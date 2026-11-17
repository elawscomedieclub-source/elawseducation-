# ProfTogo

Application éducative destinée aux élèves au Togo, du CP1 à la Terminale.

## Versions disponibles

- Web : https://elawscomedieclub-source.github.io/elawseducation-/
- Android : télécharger l'APK depuis la page [Releases](https://github.com/elawscomedieclub-source/elawseducation-/releases).

## Fonctionnalités présentes

- Sélection du niveau scolaire : CP1, CP2, CE1, CE2, CM1, CM2, 6ème, 5ème, 4ème, 3ème, 2nde, 1ère et Terminale.
- Consultation des matières, chapitres, leçons et points essentiels.
- Démarche pédagogique inspirée de l'APC : compétence, situation-problème, mission, étapes et critères de réussite.
- Exercices interactifs avec correction et explication.
- Compositions d'entraînement par matière ou en mode mélangé.
- Historique des évaluations et suivi local de la progression.
- Lecture vocale des leçons et recherche de notions par texte ou microphone lorsque le navigateur ou l'appareil prend en charge ces services.
- Thème clair et sombre.

## Base pédagogique actuelle

La base d'exemple contient 61 matières, 73 chapitres, 188 leçons et 552 exercices. Les contenus sont des ressources pédagogiques de travail, à vérifier et enrichir avec les documents officiels homologués et les enseignants. Ils ne constituent pas une publication homologuée par le ministère.

## Limites connues

- Les progrès, XP et résultats sont conservés localement sur l'appareil. Il n'y a pas encore de comptes élèves/enseignants ni de synchronisation entre appareils.
- Les compositions utilisent les exercices disponibles ; le choix du trimestre est affiché mais ne filtre pas encore les questions selon une progression trimestrielle.
- Le professeur vocal effectue une recherche par mots-clés dans les leçons disponibles. Il ne s'agit pas encore d'un assistant IA qui connaît toutes les réponses.
- La disponibilité de la reconnaissance et de la synthèse vocales dépend du navigateur, du système et des langues installées.
- Les contenus couvrent des notions de plusieurs niveaux, mais la présence d'un niveau dans le sélecteur ne signifie pas que tout son programme officiel est déjà complet.

## Développement

Prérequis : Flutter stable et Dart compatibles avec les contraintes de `pubspec.yaml`.

```bash
flutter pub get
flutter analyze lib
flutter run -d chrome
flutter build web --release --base-href "/elawseducation-/"
flutter build apk --release
```

La publication Web et la construction Android sont automatisées par GitHub Actions dans `.github/workflows/build.yml`.
