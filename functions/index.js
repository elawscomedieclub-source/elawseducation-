const { initializeApp } = require("firebase-admin/app");
const { getAuth } = require("firebase-admin/auth");
const { getFirestore, FieldValue } = require("firebase-admin/firestore");
const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { defineString } = require("firebase-functions/params");

initializeApp();
const db = getFirestore();
const auth = getAuth();
const bootstrapEmail = defineString("ADMIN_BOOTSTRAP_EMAIL");

function requireAdmin(request) {
  if (!request.auth) throw new HttpsError("unauthenticated", "Connexion requise.");
  if (request.auth.token.admin !== true) {
    throw new HttpsError("permission-denied", "Accès réservé à l'administrateur.");
  }
  return request.auth.uid;
}

async function audit(actorUid, action, targetUid, details = {}) {
  await db.collection("adminAudit").add({
    actorUid, action, targetUid: targetUid || null,
    details, createdAt: FieldValue.serverTimestamp(),
  });
}

// Activation initiale strictement limitée à l'adresse configurée au déploiement.
// Une fois un premier administrateur créé, cette fonction ne peut plus en créer un autre.
exports.bootstrapFirstAdmin = onCall({ maxInstances: 2 }, async (request) => {
  if (!request.auth) throw new HttpsError("unauthenticated", "Connecte-toi d'abord.");
  const email = String(request.auth.token.email || "").trim().toLowerCase();
  if (!email || email !== bootstrapEmail.value().trim().toLowerCase()) {
    throw new HttpsError("permission-denied", "Cette adresse n'est pas autorisée pour l'activation.");
  }
  if (request.auth.token.email_verified !== true) {
    throw new HttpsError("failed-precondition", "Vérifie d'abord ton adresse e-mail.");
  }

  let pageToken;
  do {
    const page = await auth.listUsers(1000, pageToken);
    const anotherAdmin = page.users.find(
      (user) => user.uid !== request.auth.uid && user.customClaims?.admin === true
    );
    if (anotherAdmin) {
      throw new HttpsError("already-exists", "Un administrateur est déjà configuré.");
    }
    pageToken = page.pageToken;
  } while (pageToken);

  const user = await auth.getUser(request.auth.uid);
  await auth.setCustomUserClaims(user.uid, {
    ...(user.customClaims || {}),
    admin: true,
  });
  await audit(user.uid, "bootstrap_admin", user.uid);
  return { ok: true, message: "Compte administrateur activé. Reconnecte-toi." };
});

exports.adminDashboard = onCall({ maxInstances: 3 }, async (request) => {
  const actorUid = requireAdmin(request);
  let pageToken;
  let total = 0, verified = 0, disabled = 0, active7d = 0, active30d = 0;
  const now = Date.now();
  do {
    const page = await auth.listUsers(1000, pageToken);
    for (const user of page.users) {
      total++;
      if (user.emailVerified) verified++;
      if (user.disabled) disabled++;
      const last = user.metadata.lastSignInTime ? Date.parse(user.metadata.lastSignInTime) : 0;
      if (last && now - last <= 7 * 86400000) active7d++;
      if (last && now - last <= 30 * 86400000) active30d++;
    }
    pageToken = page.pageToken;
  } while (pageToken);
  await audit(actorUid, "view_dashboard", null);
  return { total, verified, unverified: total - verified, disabled, active7d, active30d };
});

exports.adminListUsers = onCall({ maxInstances: 3 }, async (request) => {
  const actorUid = requireAdmin(request);
  const pageSize = Math.min(Math.max(Number(request.data?.pageSize) || 40, 1), 100);
  const pageToken = typeof request.data?.pageToken === "string" ? request.data.pageToken : undefined;
  const page = await auth.listUsers(pageSize, pageToken);
  const users = await Promise.all(page.users.map(async (user) => {
    let profile = {};
    try {
      const snap = await db.collection("users").doc(user.uid)
        .collection("profile").doc("main").get();
      if (snap.exists) profile = snap.data() || {};
    } catch (_) {}
    return {
      uid: user.uid,
      email: user.email || "",
      displayName: user.displayName || profile.name || "",
      emailVerified: user.emailVerified,
      disabled: user.disabled,
      createdAt: user.metadata.creationTime || "",
      lastSignInAt: user.metadata.lastSignInTime || "",
      level: profile.level || "",
      track: profile.track || "",
      series: profile.series || "",
    };
  }));
  await audit(actorUid, "list_users", null, { count: users.length });
  return { users, nextPageToken: page.pageToken || null };
});

exports.adminUserDetails = onCall({ maxInstances: 3 }, async (request) => {
  const actorUid = requireAdmin(request);
  const uid = String(request.data?.uid || "");
  if (!uid || uid.length > 128) throw new HttpsError("invalid-argument", "Identifiant invalide.");
  const user = await auth.getUser(uid);
  const root = db.collection("users").doc(uid);
  const [profile, progress, evaluations] = await Promise.all([
    root.collection("profile").doc("main").get(),
    root.collection("progress").doc("main").get(),
    root.collection("evaluations").orderBy("date", "desc").limit(20).get(),
  ]);
  await audit(actorUid, "view_user_details", uid);
  const p = profile.exists ? profile.data() : {};
  const g = progress.exists ? progress.data() : {};
  return {
    uid, email: user.email || "", emailVerified: user.emailVerified,
    disabled: user.disabled, createdAt: user.metadata.creationTime || "",
    lastSignInAt: user.metadata.lastSignInTime || "",
    profile: p || {},
    progress: {
      xp: Number(g?.xp || 0),
      answered: Array.isArray(g?.answeredExerciseIds) ? g.answeredExerciseIds.length : 0,
      correct: Array.isArray(g?.correctExerciseIds) ? g.correctExerciseIds.length : 0,
    },
    evaluations: evaluations.docs.map((doc) => doc.data()),
  };
});

exports.adminSetUserDisabled = onCall({ maxInstances: 2 }, async (request) => {
  const actorUid = requireAdmin(request);
  const uid = String(request.data?.uid || "");
  const disabled = request.data?.disabled;
  if (!uid || typeof disabled !== "boolean") {
    throw new HttpsError("invalid-argument", "Paramètres invalides.");
  }
  if (uid === actorUid) throw new HttpsError("failed-precondition", "Tu ne peux pas désactiver ta propre session.");
  await auth.updateUser(uid, { disabled });
  if (disabled) await auth.revokeRefreshTokens(uid);
  await audit(actorUid, disabled ? "disable_user" : "enable_user", uid);
  return { ok: true };
});

exports.adminRevokeSessions = onCall({ maxInstances: 2 }, async (request) => {
  const actorUid = requireAdmin(request);
  const uid = String(request.data?.uid || "");
  if (!uid || uid === actorUid) {
    throw new HttpsError("invalid-argument", "Compte cible invalide.");
  }
  await auth.revokeRefreshTokens(uid);
  await audit(actorUid, "revoke_sessions", uid);
  return { ok: true };
});