# ProfTogo — démarrage Cloudflare gratuit

Cette première version remplace les Cloud Functions Firebase payantes pour les statistiques d'usage. Elle vérifie les jetons Firebase côté serveur et réserve l'API administrateur à un UID précis. Aucun mot de passe ni clé privée ne doit être placé dans GitHub.

## 1. Créer la base D1
Dans Cloudflare Dashboard : **Workers & Pages → D1 SQL Database → Create database**.
Nom conseillé : `proftogo-metrics`.
Ouvrir la base, onglet **Console**, coller le contenu de `cloudflare/schema.sql`, puis exécuter.

## 2. Créer le Worker
Dans **Workers & Pages → Create → Worker**, nom conseillé : `proftogo-api`.
Ouvrir **Edit code**, remplacer le contenu par `cloudflare/worker.js`, puis **Deploy**.
Dans **Settings → Bindings**, ajouter une liaison **D1 database** :
- Variable name : `DB`
- Database : `proftogo-metrics`

## 3. Définir les variables privées
Dans **Settings → Variables and Secrets** :
- Secret `ADMIN_UID` : UID Firebase du compte propriétaire (jamais l'e-mail, jamais le mot de passe).
- Variable `FIREBASE_PROJECT_ID` n'est pas nécessaire dans cette version : l'identifiant du projet est fixé dans le code et vérifié dans le jeton.

Le compte propriétaire doit d'abord être créé dans ProfTogo et son e-mail vérifié. Pour trouver l'UID : Firebase Console → Authentication → Users → ouvrir le compte → copier l'UID. Ne pas envoyer cet UID ou un secret dans une conversation publique; le saisir directement dans Cloudflare.

## 4. Vérifier le Worker
Après déploiement, ouvrir `https://NOM-DU-WORKER.NOM-COMPTE.workers.dev/api/health`.
La réponse attendue est `{"ok":true,"service":"ProfTogo API"}`.
Garder l'adresse exacte du Worker pour la connexion de l'application et de la console.

## Important — étape suivante
Cette première livraison met en place le socle sécurisé et les statistiques de fréquentation. La page admin actuelle utilise encore les anciennes Cloud Functions Firebase; elle ne doit pas être considérée comme opérationnelle avec ce Worker avant sa mise à jour. Le suivi Flutter sera relié à l'adresse du Worker après sa création. La liste des comptes, suspension et réinitialisation assistée seront ajoutées dans une seconde étape sécurisée avec les autorisations Google nécessaires. Ne déploie pas les fichiers du dossier `functions` : ils correspondent à l'ancienne solution payante.

## Limites et confidentialité
Le suivi ne concerne que les comptes Firebase connectés; les élèves utilisant le mode sans compte ne sont pas comptés individuellement. Les durées sont estimées par signaux périodiques et ignorent les longues périodes hors ligne. Les statistiques D1 restent soumises aux quotas gratuits Cloudflare.
