# ProfTogo — contrôle de couverture pédagogique

## Révision du 25 novembre 2026

La banque de cours bonus contient **253 leçons et 820 questions**. La révision actuelle a ajouté 27 leçons de renforcement (81 questions), chacune avec trois exercices corrigés et un test de réponse attendu.

### Répartition des leçons bonus par niveau

| Niveau | Leçons bonus |
|---|---:|
| CP1 | 35 |
| CP2 | 35 |
| CE1 | 16 |
| CE2 | 38 |
| CM1 | 15 |
| CM2 | 14 |
| 6e | 14 |
| 5e | 14 |
| 4e | 15 |
| 3e | 14 |
| 2nde | 14 |
| 1ère | 14 |
| Terminale | 15 |

Les compléments bonus sont accessibles dans l’espace de cours. Ils sont distincts du parcours principal et ne remplacent pas une progression annuelle officielle.

## Compléments ajoutés pendant cette révision

- **CP1 :** raconter une histoire, repérer les positions.
- **CP2 :** mesurer une longueur, lire et exécuter une consigne.
- **CE1 :** partager en parts égales, besoins d’une plante.
- **CE2 :** situer le Togo et ses voisins, accord sujet-verbe.
- **CM1 :** division avec reste, régions du Togo, alimentation équilibrée.
- **CM2 :** opérations décimales, droits et devoirs de l’élève.
- **6e :** civilisations anciennes et fleuves, angles et rapporteur.
- **5e :** météo et climat, système respiratoire.
- **4e :** transformation chimique, distributivité.
- **3e :** indépendance du Togo, puissance et énergie électrique.
- **2nde :** densité de population, vitesse moyenne.
- **1ère :** paragraphe argumentatif, système nerveux.
- **Terminale :** probabilité conditionnelle, introduction de dissertation philosophique.

## Contrôles automatiques

Le test `test/annual_reinforcement_test.dart` vérifie :
1. la présence de chacune des 27 nouvelles leçons ;
2. les trois réponses correctes attendues par leçon ;
3. les choix distincts et les explications ;
4. la présence de renforcement dans chacun des 13 niveaux ;
5. le seuil global d’au moins 253 leçons et 820 questions bonus.

## Ce qui reste à vérifier avant de déclarer le programme annuel exhaustif

- Comparer chaque chapitre de la base principale aux programmes et progressions officiels en vigueur.
- Affecter chaque chapitre et chaque leçon au trimestre réel (T1, T2, T3) et contrôler les prérequis.
- Contrôler séparément chaque série et filière : A4, C, D, G1, G2, G3, E, F1, F2, F3, F4 et Ti/1.
- Ajouter les chapitres professionnels propres aux séries techniques, sans les remplacer par des cours généraux.
- Faire relire les cours, schémas, barèmes et sujets d’examen par des enseignants togolais.

## Références de travail

- Ministère de l’Éducation nationale du Togo, **Programme allégé et actualisé du collège** : https://education.gouv.tg/programme-allege-et-actualise-du-college/
- Portail officiel des cours du collège : https://ecole.gouv.tg/college/course/index.php?lang=fr
- Catalogue officiel des ressources éducatives du Togo : https://nusrope.education.gouv.tg/opac_css/index.php

Le ministère précise que les programmes du collège intègrent notamment des compétences de vie, des valeurs citoyennes, la climatologie, les TIC, les énergies renouvelables, la prévention des violences et des questions de santé. Les compléments de ProfTogo renforcent certains de ces thèmes, mais la validation de l’exhaustivité et de l’homologation exige encore une comparaison chapitre par chapitre et une relecture pédagogique.
