# ProfTogo

Application éducative destinée aux élèves au Togo, du CP1 à la Terminale.

## Versions disponibles

- Web : https://elawscomedieclub-source.github.io/elawseducation-/
- Android : télécharger l’APK depuis la page [Releases](https://github.com/elawscomedieclub-source/elawseducation-/releases).

## Fonctionnalités présentes

- Choix du niveau scolaire : CP1, CP2, CE1, CE2, CM1, CM2, 6ème, 5ème, 4ème, 3ème, 2nde, 1ère et Terminale.
- Parcours du lycée général/littéraire (A4), scientifique (C et D), technique tertiaire (G1, G2, G3) et technique industriel (E, F1, F2, F3, F4, Ti/1).
- Matières, chapitres, cours détaillés, résumés, points essentiels et démarches d’apprentissage inspirées de l’APC.
- Exercices interactifs, corrections expliquées, reprise après erreur et points XP.
- Compositions d’entraînement par matière ou en mode mélangé, avec historique des notes.
- Missions APC avec sauvegarde de la production de l’élève sur son appareil.
- Suivi de la progression par niveau, matière et leçon, avec actualisation.
- Profil élève, choix de classe/parcours/série, photo, compte et thème clair/sombre.
- Lecture vocale des cours et recherche par texte ou microphone lorsque l’appareil prend en charge les services vocaux.

## Base pédagogique actuelle

La base contient **165 matières, 280 chapitres, 767 leçons et 2 276 exercices**, répartis sur les 13 niveaux du CP1 à la Terminale. Elle comprend les parcours et séries du lycée mentionnés ci-dessus.

Ces ressources sont une base pédagogique de travail. Elles doivent être comparées aux programmes officiels en vigueur au Togo et relues par des enseignants avant d’être considérées comme exhaustives ou homologuées. La présence d’un niveau et d’un grand nombre d’exercices ne garantit pas à elle seule la couverture complète de chaque trimestre ou de chaque épreuve nationale.

## Points de vigilance connus

- Les données de progression et les productions APC sont conservées localement. La progression, le profil et les évaluations peuvent aussi être synchronisés avec Firestore lorsqu’un élève est connecté et que le service est accessible. La synchronisation dépend de la configuration Firebase et de la connexion.
- Les leçons ne sont pas encore toutes affectées à un trimestre : le choix T1/T2/T3 dans les compositions identifie le résultat, mais ne filtre pas encore les questions par trimestre.
- Les matières du lycée et certaines séries techniques nécessitent encore un approfondissement des chapitres, des cours et des sujets d’entraînement.
- Le professeur vocal recherche des notions dans les cours disponibles par mots-clés ; il ne s’agit pas encore d’un assistant IA conversationnel.
- La reconnaissance vocale et la lecture à voix haute dépendent du téléphone, du navigateur, des autorisations et des langues installées.
- L’application ne dispose pas encore d’un espace complet de gestion des classes, des devoirs et des notes par les enseignants.

## Développement

Le projet utilise Flutter et Firebase. La publication Web et la compilation Android sont automatisées par GitHub Actions.

```bash
flutter pub get
flutter test
flutter analyze lib
flutter build web --release --base-href "/elawseducation-/"
flutter build apk --release
```
