const PROJECT = "elawseducation";
const ISSUER = "https://securetoken.google.com/" + PROJECT;
const JWKS_URL = "https://www.googleapis.com/service_accounts/v1/jwk/securetoken@system.gserviceaccount.com";
const cors = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET,POST,OPTIONS",
  "Access-Control-Allow-Headers": "Authorization,Content-Type",
  "Cache-Control": "no-store"
};

function reply(data, status=200) {
  return new Response(JSON.stringify(data), {status, headers:{...cors,"Content-Type":"application/json; charset=utf-8"}});
}
function b64url(s) {
  const t=s.replace(/-/g,"+").replace(/_/g,"/");
  return atob(t + "=".repeat((4-t.length%4)%4));
}
async function verifyToken(request, env) {
  const h=request.headers.get("Authorization")||"";
  if(!h.startsWith("Bearer ")) throw new Error("Connexion requise.");
  const token=h.slice(7), parts=token.split(".");
  if(parts.length!==3) throw new Error("Jeton invalide.");
  const header=JSON.parse(b64url(parts[0]));
  const payload=JSON.parse(b64url(parts[1]));
  if(header.alg!=="RS256" || !header.kid) throw new Error("Signature invalide.");
  const now=Math.floor(Date.now()/1000);
  if(payload.aud!==PROJECT || payload.iss!==ISSUER || !payload.sub ||
     payload.sub.length>128 || !payload.exp || payload.exp<=now ||
     !payload.iat || payload.iat>now+60) throw new Error("Jeton expiré ou non valide.");
  const keySet=await fetch(JWKS_URL,{cf:{cacheTtl:3600,cacheEverything:true}});
  if(!keySet.ok) throw new Error("Vérification de sécurité indisponible.");
  const keys=await keySet.json();
  const jwk=keys.keys.find(k=>k.kid===header.kid);
  if(!jwk) throw new Error("Clé de signature inconnue.");
  const key=await crypto.subtle.importKey("jwk",jwk,{name:"RSASSA-PKCS1-v1_5",hash:"SHA-256"},false,["verify"]);
  const signed=new TextEncoder().encode(parts[0]+"."+parts[1]);
  const signature=Uint8Array.from(b64url(parts[2]),c=>c.charCodeAt(0));
  if(!await crypto.subtle.verify("RSASSA-PKCS1-v1_5",key,signature,signed)) throw new Error("Signature du jeton incorrecte.");
  return payload;
}
function dayKey(){return new Date().toISOString().slice(0,10);}
async function requireUser(request,env){
  const claims=await verifyToken(request,env);
  if(!claims.sub) throw new Error("Compte invalide.");
  return claims;
}
async function requireAdmin(request,env){
  const claims=await requireUser(request,env);
  if(!env.ADMIN_UID || claims.sub!==env.ADMIN_UID) throw new Error("Accès administrateur refusé.");
  return claims;
}
export default {
 async fetch(request,env){
  if(request.method==="OPTIONS") return new Response(null,{status:204,headers:cors});
  const url=new URL(request.url);
  try{
   if(url.pathname==="/api/health" && request.method==="GET") return reply({ok:true,service:"ProfTogo API"});
   if(url.pathname==="/api/heartbeat" && request.method==="POST"){
    const claims=await requireUser(request,env);
    const body=await request.json();
    const sid=String(body.sessionId||"");
    if(!/^[A-Za-z0-9_-]{16,80}$/.test(sid)) return reply({error:"Session invalide."},400);
    const uid=claims.sub, day=dayKey(), now=Date.now();
    const prior=await env.DB.prepare("SELECT uid,last_ms FROM sessions WHERE id=?").bind(sid).first();
    if(!prior){
      await env.DB.batch([
       env.DB.prepare("INSERT OR IGNORE INTO sessions(id,uid,day_key,started_ms,last_ms,seconds) VALUES(?,?,?,?,?,0)").bind(sid,uid,day,now,now),
       env.DB.prepare("INSERT OR IGNORE INTO daily_users(day_key,uid) VALUES(?,?)").bind(day,uid),
       env.DB.prepare("INSERT INTO usage_daily(day_key,logins,sessions,unique_users,total_seconds) VALUES(?,1,1,changes(),0) ON CONFLICT(day_key) DO UPDATE SET logins=logins+1,sessions=sessions+1,unique_users=unique_users+excluded.unique_users").bind(day)
      ]);
      return reply({ok:true,newSession:true});
    }
    if(prior.uid!==uid) return reply({error:"Session non autorisée."},403);
    const elapsed=Math.floor((now-prior.last_ms)/1000);
    const added=elapsed>0 && elapsed<=120 ? Math.min(elapsed,90):0;
    await env.DB.batch([
      env.DB.prepare("UPDATE sessions SET last_ms=?,seconds=seconds+? WHERE id=?").bind(now,added,sid),
      env.DB.prepare("INSERT INTO usage_daily(day_key,total_seconds) VALUES(?,?) ON CONFLICT(day_key) DO UPDATE SET total_seconds=total_seconds+excluded.total_seconds").bind(day,added)
    ]);
    return reply({ok:true,addedSeconds:added});
   }
   if(url.pathname==="/api/admin/usage" && request.method==="GET"){
    await requireAdmin(request,env);
    const rows=await env.DB.prepare("SELECT d.day_key, d.logins,d.sessions,d.unique_users,d.total_seconds FROM usage_daily d ORDER BY day_key DESC LIMIT 7").all();
    const today=dayKey();
    const t=rows.results.find(r=>r.day_key===today)||{day_key:today,logins:0,sessions:0,unique_users:0,total_seconds:0};
    return reply({today:{date:today,loginCount:t.logins, sessions:t.sessions,uniqueUsers:t.unique_users,totalSeconds:t.total_seconds},days:rows.results.map(r=>({date:r.day_key,loginCount:r.logins,sessions:r.sessions,uniqueUsers:r.unique_users,totalSeconds:r.total_seconds}))});
   }
   return reply({error:"Route introuvable."},404);
  }catch(e){return reply({error:e.message||"Erreur serveur."},401);}
 }
};