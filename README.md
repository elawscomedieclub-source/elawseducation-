# ProfTogo

**Application éducative pour les élèves togolais (6ème → Terminale)**

Cours, exercices, mode professeur vocal, suivi de progression.

## Fonctionnalités actuelles (MVP)
- Accueil avec série (streak) et XP
- Liste des matières (exemple 6ème)
- Chapitres + leçons
- Exercices interactifs avec correction
- Mode Vocal (simulation – prêt pour brancher STT/TTS)
- Progression par matière
- Thème clair / sombre
- Design system complet (couleurs drapeau togolais)

## Lancer le projet
Flutter 3.22+ : `flutter pub get` puis `flutter run`.
Pour construire l'APK : `flutter build apk --release`.

## Structure
`lib/core/theme`, `lib/data/models`, `lib/data/sample`, `lib/features`, `lib/shared/widgets`.

## À compléter
Contenus officiels des programmes togolais, moteur vocal STT/TTS réel, authentification et mode hors-ligne complet.
