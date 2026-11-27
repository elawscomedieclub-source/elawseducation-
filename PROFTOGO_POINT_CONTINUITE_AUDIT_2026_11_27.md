# ProfTogo — point de continuité et audit de couverture
Mise à jour : 27 novembre 2026

## Validation technique du dernier état

- Commit vérifié : `6851c6a9845a1a9f5dc757f6ff4e37980fdd1242`.
- Workflow Android/Web : run `46057624928`, conclusion **success**.
- GitHub Pages : run `46057624143`, conclusion **success**.
- Les tests de références du catalogue annuel acceptent les chapitres historiques référencés par les leçons et préservent la casse des symboles scientifiques.
- APK Android produite par le run : artefact `PROFTOGO-APK-Android`, 33 964 502 octets, non expiré au moment du contrôle. L'artefact se télécharge depuis l'onglet **Artifacts** du workflow Android/Web.

## Volumes à préserver — état documenté

| Banque | Matières | Chapitres | Leçons | Exercices / questions |
|---|---:|---:|---:|---:|
| Programme principal | 165 | 280 | 793 | 2 328 |
| Banque bonus | — | — | 313 | 1 000 |
| **Total leçons/questions** | | | **1 106** | **3 328** |

Ces chiffres sont les volumes inscrits dans la documentation du dépôt. Ils ne constituent pas une preuve que chaque ligne du programme officiel est couverte. Toute modification de volume doit être calculée depuis les données et expliquée; ne pas supprimer ou réduire un contenu pour faire réussir un test.

## Audit de couverture à poursuivre

Pour chaque niveau, matière, série et trimestre, vérifier séparément :

1. le référentiel officiel et sa version/année ;
2. les compétences et notions prescrites ;
3. les chapitres et leçons existants, avec identifiants ;
4. les exercices, corrigés et explications ;
5. la répartition réelle T1/T2/T3 ;
6. les contenus spécifiques aux séries et filières techniques ;
7. la validation pédagogique par un enseignant.

## État honnête

- **Technique :** les deux workflows cités sont réussis.
- **Volume :** les valeurs ci-dessus sont conservées comme référence documentaire.
- **Couverture officielle :** audit détaillé encore nécessaire, notamment pour les programmes du primaire, les séries du lycée, les filières techniques/professionnelles et les progressions trimestrielles.
- **Publication :** un build réussi ne remplace pas l'installation et l'essai de l'APK sur un téléphone Android.

## Sources de travail

- `CURRICULUM_COVERAGE_MATRIX.md`
- `CURRICULUM_REVIEW.md`
- `PROFTOGO_CONTINUITE_VOLUMES_COUVERTURE.md`
- Catalogue national NUSROPE : https://nusrope.education.gouv.tg/opac_css/index.php
- Portail documentaire du ministère : https://education.gouv.tg/ministere/documentation
