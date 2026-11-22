import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cloud_progress_service.dart';

class ProgressSnapshot {
  final Set<String> answeredExerciseIds;
  final Set<String> correctExerciseIds;
  final int xp;

  const ProgressSnapshot({
    required this.answeredExerciseIds,
    required this.correctExerciseIds,
    required this.xp,
  });
}

class ProgressService {
  // Les caches locaux sont séparés par UID. Le cache invité est indépendant
  // de tous les comptes connectés.
  static String localStorageKey(String base, String? uid) =>
      uid == null ? '${base}_guest' : '${base}_user_$uid';

  // Dernière leçon consultée : clé locale isolée par compte et par invité.
  static Future<void> saveLastLesson(String lessonId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser?.uid != uid) return;
    await prefs.setString(localStorageKey('proftogo_last_lesson', uid), lessonId);
  }

  static Future<String?> loadLastLesson() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser?.uid != uid) return null;
    return prefs.getString(localStorageKey('proftogo_last_lesson', uid));
  }

  // Les erreurs à revoir sont conservées séparément pour chaque compte.
  static Future<Set<String>> loadReviewExerciseIds() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser?.uid != uid) return <String>{};
    return (prefs.getStringList(localStorageKey('proftogo_review_exercises', uid)) ?? []).toSet();
  }

  // Compte les erreurs successives pour repérer les notions qui résistent.
  // Ces données restent isolées par compte, comme le reste de la progression.
  static Future<Map<String, int>> loadWrongAttemptCounts() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser?.uid != uid) return <String, int>{};
    final raw = prefs.getStringList(
          localStorageKey('proftogo_wrong_attempt_counts', uid),
        ) ??
        <String>[];
    final counts = <String, int>{};
    for (final entry in raw) {
      final separator = entry.lastIndexOf('|');
      if (separator <= 0) continue;
      final id = entry.substring(0, separator);
      final count = int.tryParse(entry.substring(separator + 1));
      if (count != null && count > 0) counts[id] = count;
    }
    return counts;
  }

  static Future<void> recordWrongAnswer(String exerciseId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser?.uid != uid) return;
    final reviewKey = localStorageKey('proftogo_review_exercises', uid);
    final ids = (prefs.getStringList(reviewKey) ?? []).toSet()..add(exerciseId);
    final countsKey = localStorageKey('proftogo_wrong_attempt_counts', uid);
    final counts = await loadWrongAttemptCounts();
    if (FirebaseAuth.instance.currentUser?.uid != uid) return;
    counts[exerciseId] = (counts[exerciseId] ?? 0) + 1;
    await prefs.setStringList(reviewKey, ids.toList()..sort());
    if (FirebaseAuth.instance.currentUser?.uid != uid) return;
    final encoded = counts.entries
        .map((entry) => '${entry.key}|${entry.value}')
        .toList()
      ..sort();
    await prefs.setStringList(countsKey, encoded);
  }

  static Future<void> clearReviewExercise(String exerciseId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser?.uid != uid) return;
    final key = localStorageKey('proftogo_review_exercises', uid);
    final ids = (prefs.getStringList(key) ?? []).toSet()..remove(exerciseId);
    if (FirebaseAuth.instance.currentUser?.uid != uid) return;
    await prefs.setStringList(key, ids.toList()..sort());
  }

  static Future<ProgressSnapshot> load() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser?.uid != uid) {
      return const ProgressSnapshot(
        answeredExerciseIds: <String>{},
        correctExerciseIds: <String>{},
        xp: 0,
      );
    }
    // Anciennes clés globales non liées à un compte : elles ne sont plus sûres.
    await prefs.remove('proftogo_answered_exercises');
    await prefs.remove('proftogo_correct_exercises');
    await prefs.remove('proftogo_total_xp');
    if (FirebaseAuth.instance.currentUser?.uid != uid) {
      return const ProgressSnapshot(
        answeredExerciseIds: <String>{},
        correctExerciseIds: <String>{},
        xp: 0,
      );
    }
    final answeredKey = localStorageKey('proftogo_answered_exercises', uid);
    final correctKey = localStorageKey('proftogo_correct_exercises', uid);
    final localCorrect = (prefs.getStringList(correctKey) ?? []).toSet();
    final local = ProgressSnapshot(
      answeredExerciseIds: (prefs.getStringList(answeredKey) ?? []).toSet(),
      correctExerciseIds: localCorrect,
      xp: localCorrect.length * 10,
    );

    if (uid == null) return local;

    try {
      final cloud = await CloudProgressService.loadForCurrentUser();
      // Ne jamais synchroniser le cache d'un compte précédent : chaque UID
      // dispose désormais de ses propres clés locales.
      if (FirebaseAuth.instance.currentUser?.uid != uid) return local;
      if (cloud == null) {
        await _saveCloud(local, uid);
        return local;
      }

      final merged = mergeSnapshots(
        local,
        ProgressSnapshot(
          answeredExerciseIds: cloud.answeredExerciseIds,
          correctExerciseIds: cloud.correctExerciseIds,
          xp: cloud.xp,
        ),
      );
      await _saveLocal(prefs, merged, uid);
      await _saveCloud(merged, uid);
      return merged;
    } catch (_) {
      return local;
    }
  }

  static Future<bool> recordAnswer({
    required String exerciseId,
    required bool isCorrect,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser?.uid != uid) return false;
    final answeredKey = localStorageKey('proftogo_answered_exercises', uid);
    final correctKey = localStorageKey('proftogo_correct_exercises', uid);
    final answered = (prefs.getStringList(answeredKey) ?? []).toSet();
    final correct = (prefs.getStringList(correctKey) ?? []).toSet();

    if (answered.contains(exerciseId) || !isCorrect) return false;

    answered.add(exerciseId);
    correct.add(exerciseId);
    final progress = ProgressSnapshot(
      answeredExerciseIds: answered,
      correctExerciseIds: correct,
      xp: correct.length * 10,
    );
    await _saveLocal(prefs, progress, uid);

    if (uid == null) return true;
    var earnedXp = true;
    try {
      final cloud = await CloudProgressService.loadForCurrentUser();
      if (FirebaseAuth.instance.currentUser?.uid != uid) return earnedXp;
      final cloudProgress = ProgressSnapshot(
        answeredExerciseIds: cloud?.answeredExerciseIds ?? <String>{},
        correctExerciseIds: cloud?.correctExerciseIds ?? <String>{},
        xp: cloud?.xp ?? 0,
      );
      earnedXp = !cloudProgress.correctExerciseIds.contains(exerciseId);
      final merged = mergeSnapshots(progress, cloudProgress);
      await _saveLocal(prefs, merged, uid);
      await _saveCloud(merged, uid);
    } catch (_) {
      // L'exercice reste utilisable si le cloud est momentanément indisponible.
    }
    return earnedXp;
  }

  /// Réinitialise la progression locale et cloud du compte courant uniquement.
  static Future<void> clearCurrentAccount() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser?.uid != uid) return;
    await prefs.remove(localStorageKey('proftogo_answered_exercises', uid));
    await prefs.remove(localStorageKey('proftogo_correct_exercises', uid));
    await prefs.remove(localStorageKey('proftogo_total_xp', uid));
    await prefs.remove(localStorageKey('proftogo_review_exercises', uid));
    await prefs.remove(localStorageKey('proftogo_wrong_attempt_counts', uid));
    await prefs.remove(localStorageKey('proftogo_last_lesson', uid));
    await prefs.remove('proftogo_answered_exercises');
    await prefs.remove('proftogo_correct_exercises');
    await prefs.remove('proftogo_total_xp');
    if (uid != null && FirebaseAuth.instance.currentUser?.uid == uid) {
      await CloudProgressService.clearForCurrentUser();
    }
  }

  static ProgressSnapshot mergeSnapshots(
    ProgressSnapshot local,
    ProgressSnapshot cloud,
  ) {
    final correct = {...local.correctExerciseIds, ...cloud.correctExerciseIds};
    final answered = {
      ...local.answeredExerciseIds,
      ...cloud.answeredExerciseIds,
      ...correct,
    };
    return ProgressSnapshot(
      answeredExerciseIds: answered,
      correctExerciseIds: correct,
      xp: correct.length * 10,
    );
  }

  static Future<void> _saveLocal(
    SharedPreferences prefs,
    ProgressSnapshot progress,
    String? uid,
  ) async {
    await prefs.setStringList(
      localStorageKey('proftogo_answered_exercises', uid),
      progress.answeredExerciseIds.toList()..sort(),
    );
    await prefs.setStringList(
      localStorageKey('proftogo_correct_exercises', uid),
      progress.correctExerciseIds.toList()..sort(),
    );
    await prefs.setInt(localStorageKey('proftogo_total_xp', uid), progress.xp);
  }

  static Future<void> _saveCloud(ProgressSnapshot progress, String uid) async {
    if (FirebaseAuth.instance.currentUser?.uid != uid) return;
    await CloudProgressService.saveForCurrentUser(
      answeredExerciseIds: progress.answeredExerciseIds,
      correctExerciseIds: progress.correctExerciseIds,
      xp: progress.xp,
    );
  }
}
