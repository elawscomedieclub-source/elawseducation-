# Console d'administration ProfTogo

Adresse prévue : https://elawscomedieclub-source.github.io/elawseducation-/admin/

La console est séparée de l'application élève. L'URL n'est pas un secret : les données et les actions sont protégées côté serveur par un rôle Firebase Auth admin.

## Fonctions
- Nombre de comptes, e-mails vérifiés, comptes désactivés et connexions récentes.
- Liste paginée, recherche par nom, e-mail ou classe.
- Détails du profil, progression et dernières évaluations.
- Envoi d'un e-mail sécurisé de réinitialisation du mot de passe.
- Suspension et réactivation d'un compte.
- Journal des opérations dans adminAudit.

Les mots de passe ne sont jamais lisibles. La console ne permet pas de récupérer le mot de passe actuel d'un élève.

## Première activation
1. Le propriétaire choisit une adresse e-mail personnelle et crée un compte ProfTogo avec cette adresse.
2. Il vérifie l'adresse e-mail via le message envoyé par Firebase.
3. Le projet Firebase doit être associé au plan Blaze pour déployer Cloud Functions. Ce plan est facturé à l'usage : configurer des alertes de budget avant le déploiement.
4. Depuis la racine du dépôt, installer Firebase CLI et se connecter au bon compte Google.
5. Copier functions/.env.example vers functions/.env.elawseducation, puis remplacer l'adresse d'exemple par celle du propriétaire. Aucun mot de passe ne doit être inscrit.
6. Exécuter npm --prefix functions install, puis firebase deploy --only functions --project elawseducation.
7. Une fois la page GitHub Pages et les fonctions publiées, ouvrir la console, se connecter avec le compte vérifié et choisir « Activer mon accès administrateur initial ».
8. Se déconnecter puis se reconnecter pour actualiser le jeton et obtenir le rôle.

L'activation vérifie l'adresse configurée, l'e-mail vérifié et l'absence d'un autre administrateur. Le rôle est créé uniquement côté serveur avec Firebase Admin SDK.

## Limites de mesure
Les visiteurs qui apprennent sans créer de compte ne figurent pas dans Firebase Authentication. Leur fréquentation ne peut pas être attribuée à une personne. Un compteur anonyme distinct devra être ajouté avec une politique d'information et de conservation adaptée aux élèves mineurs.

## Sécurité
- Ne jamais publier de clé de compte de service, mot de passe ou jeton privé dans GitHub.
- Ne pas rendre les collections privées lisibles depuis le navigateur.
- Les fonctions vérifient le jeton et le rôle côté serveur.
- Les consultations et suspensions sont consignées dans adminAudit.
