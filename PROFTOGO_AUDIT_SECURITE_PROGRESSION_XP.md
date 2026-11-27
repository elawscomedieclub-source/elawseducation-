# ProfTogo — Audit de sécurité de la progression et des XP

Date : 27 novembre 2026  
Statut : audit statique du code et des règles Firestore ; aucun test d'intrusion ni déploiement de règles effectué.

## Périmètre examiné

- `lib/core/cloud_progress_service.dart`
- `firestore.rules`
- `firebase.json`

## Points positifs observés

- Les documents de progression sont rangés sous `users/{uid}`.
- Les règles exigent que l'utilisateur authentifié soit propriétaire du document.
- Les règles limitent les champs autorisés et la taille des listes.
- Le service cloud utilise une transaction pour fusionner les acquis entre appareils.
- Le service de progression conserve des identifiants d'exercices plutôt que les réponses libres de l'élève.

## Risque important : les données d'XP et les identifiants sont envoyés par le client

Dans les règles actuelles, un utilisateur authentifié peut modifier son propre document de progression en envoyant :
- une valeur `xp` non négative ;
- des listes `answeredExerciseIds` et `correctExerciseIds` contenant des identifiants choisis par le client.

La règle vérifie la structure, la propriété et la taille, mais ne prouve pas que chaque exercice a réellement été réussi. Le code client calcule aussi l'XP à partir des réponses enregistrées côté application.

Conséquence : les données conviennent à une progression personnelle indicative, mais ne doivent pas être considérées comme une preuve inviolable pour les classements, récompenses convertibles, paiements ou décisions officielles.

## Mesures recommandées avant d'activer des récompenses réelles

1. Conserver les XP actuels comme points pédagogiques non monétaires.
2. Ne pas autoriser de retrait ou conversion en argent à partir d'un score contrôlé uniquement par le client.
3. Pour des récompenses sensibles, faire valider l'exercice et le calcul par une fonction serveur ou un backend de confiance.
4. Vérifier côté serveur que l'identifiant d'exercice existe, que la réponse est correcte et que la récompense n'a pas déjà été accordée.
5. Ajouter des limites de fréquence et une journalisation des événements importants.
6. Vérifier que les règles déployées correspondent exactement au fichier `firestore.rules` du dépôt.
7. Tester les accès non connectés, l'accès au document d'un autre UID, les champs supplémentaires, les valeurs négatives et les listes excessives avec Firebase Emulator ou des tests de règles.

## À ne pas faire

- Ne pas supprimer les règles de propriété UID.
- Ne pas ouvrir la base avec `allow read, write: if true`.
- Ne pas publier les clés privées de service dans Flutter, GitHub ou les fichiers web.
- Ne pas déclarer les XP « anti-triche » tant que le calcul reste contrôlé par le client.

## Conclusion

L'accès est limité au propriétaire dans les règles examinées, ce qui est une bonne base. Toutefois, l'intégrité des XP et des acquis n'est pas garantie contre une modification volontaire du client. L'application doit donc distinguer clairement progression personnelle et récompense vérifiée côté serveur.
