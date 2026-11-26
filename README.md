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
- Suivi de la progression par niveau, matière et leçon, avec actualisation. Les cours bonus sont inclus dans le total de progression de l’accueil et de l’espace de suivi.
- Profil élève, choix de classe/parcours/série, photo, compte et thème clair/sombre.
- Lecture vocale des cours et recherche par texte ou microphone lorsque l’appareil prend en charge les services vocaux.

## Base pédagogique actuelle

La base contient **165 matières, 280 chapitres, 793 leçons et 2 328 exercices**, répartis sur les 13 niveaux du CP1 à la Terminale. Elle comprend les parcours et séries du lycée mentionnés ci-dessus.

Ces ressources sont une base pédagogique de travail. Elles doivent être comparées aux programmes officiels en vigueur au Togo et relues par des enseignants avant d’être considérées comme exhaustives ou homologuées. La présence d’un niveau et d’un grand nombre d’exercices ne garantit pas à elle seule la couverture complète de chaque trimestre ou de chaque épreuve nationale.

## Compléments pédagogiques ajoutés

La banque de cours bonus contient maintenant **292 leçons et 937 questions** sur les 13 niveaux. La banque a été enrichie par 27 leçons de renforcement, 26 leçons complémentaires et 13 nouvelles leçons de mise à jour 2026–2027, soit 66 nouvelles leçons réparties sur les 13 niveaux. Les ajouts renforcent les fondamentaux en français et mathématiques au primaire, les sciences, l’histoire-géographie, la citoyenneté, la grammaire, la physique-chimie, l’argumentation, la philosophie, la découverte des métiers, l’orientation, la démarche scientifique et les méthodes de révision. Les tests vérifient les identifiants, la présence des 13 niveaux, les choix, les explications et les réponses attendues des leçons nouvellement ajoutées. Les erreurs aux exercices bonus sont enregistrées dans les révisions et l’historique de l’élève, puis affichées dans « Ma progression » avec la bonne réponse, l’explication et un accès direct à la leçon.

Ces compléments sont des exercices de consolidation. Ils ne remplacent pas encore la vérification complète des programmes officiels, l’affectation de chaque cours au trimestre, ni la validation par des enseignants togolais.

## Audit de couverture et limites

- [Matrice détaillée de contrôle annuel, par niveau et série](CURRICULUM_COVERAGE_MATRIX.md)
- [Calendrier scolaire et examens 2026–2027](ANNEE_SCOLAIRE_2026_2027.md)
- [Rapport de révision et sources officielles](CURRICULUM_REVIEW.md)

- La dernière extension a ajouté 13 leçons de mise à jour (39 questions) aux 53 compléments précédents. La banque bonus totalise 292 leçons et 937 questions, avec tests des corrigés et des schémas pédagogiques.
- Le programme officiel du collège comporte des thèmes transversaux et des compétences de vie : citoyenneté, climat, TIC, énergies renouvelables, prévention des violences et santé. Les compléments intègrent plusieurs de ces axes, mais l’affectation complète à chaque chapitre et trimestre reste à faire.
- Les séries du lycée général et technique sont présentes dans la structure de l’application. Leur couverture doit toutefois être contrôlée séparément, matière par matière et série par série, notamment G1/G2/G3, E, F1/F2/F3/F4 et Ti/1. Les compléments bonus communs ne remplacent pas les cours professionnels spécifiques.
- Le référentiel des programmes du collège et le catalogue officiel des ressources éducatives doivent servir à une vérification chapitre par chapitre. Une relecture par des enseignants togolais reste nécessaire avant toute affirmation d’exhaustivité ou d’homologation.

## Priorités de finalisation

1. **Organiser le programme par trimestre** (T1, T2, T3) et filtrer les compositions sur le trimestre réellement étudié.
2. **Vérifier les progressions et contenus officiels** pour chaque niveau, matière et série, avec relecture pédagogique.
3. **Compléter les séries techniques et les sujets d’examen**, en particulier les matières professionnelles et les exercices avec barème.
4. **Finaliser l’espace enseignant** : classes, devoirs, correction et suivi des résultats.
5. **Tester les parcours réels sur téléphone Android**, y compris l’accès hors connexion, la sauvegarde et la publication de la version Web/APK.

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
