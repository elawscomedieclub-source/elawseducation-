# ProfTogo — audit pédagogique et couverture annuelle

**Mise à jour : 27 novembre 2026**

## État technique vérifié — 27 novembre 2026

- La branche principale contient les changements récents de répartition annuelle par trimestre (commits #81 à #83) : les chapitres annuels sont répartis sur T1/T2/T3, les compositions filtrent les exercices par trimestre, des contrôles de qualité des exercices annuels ont été ajoutés et le calcul de répartition de la physique C/D a été corrigé.
- Le coach de progression adapte aussi ses conseils aux résultats récents et aux difficultés déclarées par l’élève (lecture, compréhension, méthode), avec tests dédiés.
- Le commit `700d6629aa` (13 cours transversaux + test de corrigés) est validé : run 1189, jobs Web, APK et publication immédiate réussis ; run 1190, build et déploiement GitHub Pages réussis. La compilation est confirmée, mais un test manuel de l’APK sur téléphone reste nécessaire.
- Le workflow Android fixe le numéro de build à partir du numéro d’exécution GitHub Actions. Utiliser l’APK téléchargée depuis l’exécution récente, pas l’ancien fichier joint (code 1090). Le test manuel sur téléphone reste nécessaire.

## État quantitatif vérifié

- Total arithmétique base principale + bonus : **1 106 leçons et 3 328 exercices/questions** (volume total, sans prétendre à l’homologation ni à l’exhaustivité).

- Base principale : **165 matières, 280 chapitres, 793 leçons et 2 328 exercices** (chiffres indiqués par la documentation actuelle du projet).
- Banque bonus : **313 leçons et 1 000 questions**, réparties sur les 13 niveaux.
- La banque bonus comprend 87 ajouts : 27 leçons initiales, 26 compléments, 13 leçons de mise à jour 2026–2027, 13 cours transversaux et 8 cours ciblés de mathématiques 6e (24 questions).
- Tests dédiés : identifiants, présence des niveaux, choix distincts, explications, réponses attendues des leçons ajoutées et seuils de volume.

## Répartition actuelle de la banque bonus

| Niveau | Leçons bonus | Questions bonus |
|---|---:|---:|
| CP1 | 39 | 118 |
| CP2 | 39 | 140 |
| CE1 | 20 | 63 |
| CE2 | 42 | 137 |
| CM1 | 19 | 59 |
| CM2 | 18 | 54 |
| 6e | 26 | 82 |
| 5e | 18 | 57 |
| 4e | 19 | 61 |
| 3e | 18 | 57 |
| 2nde | 18 | 56 |
| 1ère | 18 | 56 |
| Terminale | 19 | 60 |
| **Total** | **305** | **976**

Les nombres de questions sont calculés à partir des leçons du dépôt et peuvent différer d’une question de certains rapports historiques si ceux-ci comptaient les éléments de façon différente. Les tests Flutter restent la source de validation technique.

## Compléments récents

Les 13 dernières leçons de mise à jour 2026–2027 couvrent notamment :
- hygiène, sécurité routière, économie d’eau et lecture de tableaux au primaire ;
- découverte des métiers et projet de découverte en CM1-CM2 ;
- démarche scientifique, énergie solaire, expériences contrôlées et projets technologiques ;
- orientation, pratique active et planification des révisions.
- graphisme des lettres et comparaison de nombres au CP1 ;
- phrase simple et dizaines-unités au CP2 ;
- synonymes, saisons, eau et sécurité routière au CE1-CE2 ;
- lettre personnelle, fractions, histoire et aire au CM1-CM2 ;
- grammaire, fonctions du corps, citoyenneté et circuits électriques au collège ;
- ressources économiques, reproduction des plantes, Pythagore, argumentation ;
- atomes et molécules, analyse du récit, fonctions affines, histoire des échanges atlantiques ;
- fréquence des ondes et synthèse de documents en Terminale.
- Les 13 nouveaux cours transversaux : EPS au CP1, musique au CP2, arts plastiques au CE1, jeu collectif au CE2, rythme musical au CM1, affiche au CM2, échauffement en 6e, perspective en 5e, séquence rythmique en 4e, endurance en 3e, exposé en 2nde, prise de notes en 1ère et oral argumenté en Terminale.


### Sources officielles examinées — mise à jour du 27 novembre 2026
- Le catalogue NUSROPE publie une planification de mathématiques 6e pour le premier trimestre : droites du plan, arithmétique (nombres naturels, multiples/diviseurs, divisibilité), segments, décimaux et opérations, angles et programme de calcul. Huit cours d’entraînement ciblent ces thèmes. Cette planification publiée doit être confirmée par l’enseignant pour l’année 2026–2027. Source : https://nusrope.education.gouv.tg/opac_css/doc_num.php?explnum_id=19.

- Le ministère a rappelé que le programme allégé du collège avait été établi en tenant compte de **25 semaines effectives**, des horaires disciplinaires et des profils de sortie ; il cite aussi les thèmes transversaux (TIC, climat, citoyenneté, énergie, santé, prévention). La matrice doit donc contrôler les contenus et la durée, pas seulement le nombre de chapitres. Source : https://education.gouv.tg/programme-allege-et-actualise-du-college/ (10 avril 2018).
- La circulaire interministérielle **N°033/2025/MEPS/METFPA** rend les nouveaux programmes d’EPS applicables à partir de 2025–2026 et demande aux inspections de les mettre à disposition des établissements. La banque EPS ajoutée dans ProfTogo est un complément général ; les contenus précis devront être rapprochés du programme EPS remis par l’inspection, sans déduire la progression de la seule circulaire. Source PDF : https://education.gouv.tg/wp-content/uploads/2025/09/NOTE-N%C2%B0-033_Nouveaux-programmes-EPS.pdf.
- Le ministère rapporte qu’en novembre 2025 le CNEA a analysé les curricula du secondaire 1 pour le français, les mathématiques et la physique-chimie-technologie, dans le cadre de l’élaboration d’échelles de compétences et d’items d’évaluation. Priorité de l’audit : vérifier la cohérence verticale/horizontale de ces trois disciplines et aligner les exercices sur les compétences, pas seulement sur les intitulés de cours. Source : https://education.gouv.tg/education-nationale-le-secteur-renforce-ses-outils-strategiques-devaluation-des-apprentissages/ (2 décembre 2025).

## Vérification du programme officiel : méthode à poursuivre

La banque de cours ne suffit pas à prouver que le programme annuel officiel est complet. Il faut contrôler, pour chaque niveau et chaque matière :

1. les compétences et contenus prescrits ;
2. la progression et les prérequis ;
3. la vérification de l’affectation au trimestre réel (T1, T2, T3) — le filtre technique est en place, mais le calendrier exact doit être validé ;
4. les cours, exemples, schémas, travaux pratiques et évaluations ;
5. la correspondance avec les manuels et documents officiels en vigueur ;
6. la validation par un enseignant de la discipline.

### Points de vigilance spécifiques

- Le catalogue national des ressources éducatives distingue le primaire, le secondaire 1, le secondaire 2 et le secondaire technique/professionnel.
- Les parcours du lycée général et les séries techniques doivent être contrôlés séparément. Les bonus actuels sont des compléments communs : ils ne remplacent pas les contenus propres aux séries G1/G2/G3, E, F1/F2/F3/F4 et Ti/1.
- Le ministère a annoncé de nouveaux programmes d’EPS applicables à partir de la rentrée 2025–2026.
- À la rentrée 2026–2027, les classes-métiers sont expérimentées à partir du CM1-CM2 et dans les collèges/lycées scientifiques ; les collèges et lycées scientifiques sont renforcés. Les leçons ProfTogo sur les métiers sont des supports de découverte, pas un référentiel professionnel homologué.
- L’arrêté ministériel n°319/2025 du 8 octobre 2025 établit un cadre d’homologation des manuels et documents pédagogiques. ProfTogo ne doit pas être présenté comme homologué sans décision officielle. Les cours d’EPS de l’application doivent être rapprochés de ces documents.
- Le collège comprend des thématiques transversales (citoyenneté, compétences de vie, climat, TIC, énergie, prévention et santé) à relier explicitement aux chapitres.
- La répartition technique des chapitres annuels sur T1/T2/T3 et le filtre trimestriel des compositions sont implémentés. La répartition est calculée à partir de l’ordre des unités et reste provisoire : l’audit doit vérifier les chapitres de chaque niveau, matière et série avec les progressions officielles et l’enseignant.

## Sources de référence

- Ministère de l’Éducation nationale : [documentation officielle](https://education.gouv.tg/ministere/documentation)
- [Programme allégé et actualisé du collège](https://education.gouv.tg/programme-allege-et-actualise-du-college/)
- [Catalogue national des ressources éducatives (NUSROPE)](https://nusrope.education.gouv.tg/opac_css/index.php)
- [Cours du primaire – portail officiel](https://ecole.gouv.tg/primaire/course/index.php?categoryid=8&lang=fr)
- [Rentrée 2026–2027 : classes-métiers et établissements scientifiques](https://education.gouv.tg/rentree-scolaire-2026-2027-mama-omorou-donne-le-ton-au-lycee-scientifique-de-lome/)
- [Cadre d’homologation des manuels et documents pédagogiques (8 octobre 2025)](https://education.gouv.tg/homologation-des-manuels-et-documents-pedagogiques-un-nouveau-cadre-reglementaire-pour-leducation-au-togo/)
- [Nouveaux programmes d’EPS (rentrée 2025–2026)](https://education.gouv.tg/meps-reforme-educative-de-nouveaux-programmes-deps-entrent-en-vigueur-au-togo/)
- [Ressource officielle sur les offres de l’enseignement technique](https://education.gouv.tg/wp-content/uploads/2023/10/lien_9_1_1.pdf)

## Mise en œuvre des classes-métiers — travail préparatoire

Un guide de séance a été ajouté pour soutenir l’expérimentation annoncée en 2026–2027 : [GUIDE_CLASSES_METIERS_2026_2027.md](GUIDE_CLASSES_METIERS_2026_2027.md). Il propose une progression de travail (30 séances primaires, modules secondaires différenciés), des projets, une grille formative sur 20 et des consignes de sécurité. **Ce guide est une proposition de l’application, non un programme officiel homologué.** La publication ministérielle confirme la phase expérimentale en CM1-CM2 et dans les collèges/lycées scientifiques, mais la progression proposée doit être validée localement et rapprochée des instructions officielles.

## Conclusion

ProfTogo dispose d’une base principale substantielle et d’une banque bonus renforcée. Le filtrage technique par trimestre est en place ; la finalisation pédagogique exige encore la validation officielle du placement des chapitres, un relevé de couverture chapitre par chapitre et une relecture de chaque matière/série. Ne pas annoncer l’application comme « programme annuel intégralement homologué » avant cette vérification.
