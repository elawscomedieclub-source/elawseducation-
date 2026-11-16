# ProfTogo

Application éducative destinée aux élèves du Togo.

## Navigation ajoutée dans cette version

- Menu latéral (burger) : Accueil, Classes et matières, Cours et leçons, Exercices, Professeur vocal, Progression et Profil.
- Sélecteur de classe couvrant CP1, CP2, CE1, CE2, CM1, CM2, 6e, 5e, 4e, 3e, Seconde A4, Seconde C/D, Première A4/C/D et Terminale A4/C/D.
- Matières filtrées selon la classe choisie.
- Ouverture des matières vers des chapitres, puis une fiche de leçon et des exercices.
- Le parcours existant de leçon, questionnaire et correction est conservé.

## Important : état du contenu pédagogique

Cette version complète la structure de navigation et ajoute des fiches d'orientation ainsi que des exemples d'exercices. Elle ne contient PAS encore l'intégralité des cours officiels de toutes les classes. Les chapitres génériques sont des trames de travail, pas des cours homologués. Le contenu détaillé doit être saisi et relu classe par classe, matière par matière, à partir des programmes et manuels autorisés.

Les sources de référence à utiliser :
- Portail officiel des cours du primaire : https://ecole.gouv.tg/primaire/
- Catalogue des ressources éducatives du Togo : https://nusrope.education.gouv.tg/opac_css/index.php
- Cadre d'homologation des manuels et documents pédagogiques (ministère, 8 octobre 2025) : https://education.gouv.tg/homologation-des-manuels-et-documents-pedagogiques-un-nouveau-cadre-reglementaire-pour-leducation-au-togo/

Le catalogue ministériel référence les classes CP1 à CM2, 6e à 3e, Seconde A4/CD, Première A4/C/D et Terminale A4/C/D. La disponibilité des documents varie selon la classe : certaines catégories sont vides ou ne proposent que quelques ressources. Il ne faut donc pas prétendre que tous les cours officiels ont déjà été récupérés.

## Lancer et compiler

Prérequis : Flutter 3.22+ et Dart compatibles avec `pubspec.yaml`.

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

Pour générer un APK Android :

```bash
flutter build apk --release
```

Pour générer le site web :

```bash
flutter build web --release
```

Le dossier de sortie web est `build/web`. Pour le publier sur GitHub Pages, il faut configurer le dépôt et le workflow de déploiement.

## Limites restantes avant publication

- Remplacer les fiches génériques par les vrais cours, exemples, devoirs et corrigés vérifiés.
- Compléter les exercices par chapitre et par classe.
- Vérifier le contenu avec les programmes et manuels homologués.
- Ajouter une vraie sauvegarde de progression et un compte élève/parent/professeur.
- Brancher le mode vocal réel (la version actuelle est encore une simulation).
- Tester sur Android et corriger les éventuelles erreurs de compilation.

## Dépendances

Voir `pubspec.yaml`. Les fonctionnalités existantes (thème clair/sombre, progression de démonstration, mode vocal simulé et questionnaire interactif) restent dans le projet.
