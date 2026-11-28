# ProfTogo — audit structurel du catalogue annuel
Date : 27 novembre 2026

## Ce qui est vérifié par les tests actuels

Le test `annual_core_catalog_reference_integrity_test.dart` contrôle :
- l'unicité des identifiants des matières, chapitres, leçons et exercices ;
- les références chapitre → matière et chapitre → leçon ;
- les références leçon → chapitre et leçon → exercice ;
- la présence d'un titre, d'un contenu, d'un résumé, d'une question, de choix et d'une explication ;
- la validité de l'index de réponse correcte ;
- le trimestre des chapitres du catalogue annuel (1 à 3).

La banque bonus a aussi des contrôles de volume et de cohérence séparés.

## Constats de structure à ne pas confondre avec une certification pédagogique

1. Le catalogue annuel principal est assemblé à partir de fichiers distincts : anglais, sciences, mathématiques, physique, histoire/civisme, matières du secondaire et matières de Seconde.
2. Les sujets de 6e affichent des volumes de chapitres déclarés (Mathématiques 14, Français 12, Anglais 12, SVT 12, Histoire-Géographie 10). Ces valeurs doivent être rapprochées des chapitres effectivement liés, puis du référentiel officiel. Un nombre affiché ne prouve pas que toutes les notions sont présentes.
3. Le modèle de leçon contient titre, contenu, résumé et points clés, mais n'attache pas directement à chaque leçon une référence officielle de compétence, une année/version du programme ou un identifiant de progression. Cette traçabilité doit être ajoutée à la couche de catalogue ou dans une table de correspondance, sans casser les anciens IDs.
4. La fonction `termForAnnualUnit` distribue les unités entre T1 et T3. Pour une matière à deux unités, elle attribue T1 et T3, donc T2 n'est pas représenté par cette seule répartition. Il faut vérifier la composition réelle des chapitres et compléter les séquences trimestrielles là où le programme le demande.
5. Les tests de qualité des questions sont des contrôles de structure et de quelques réponses attendues. Ils ne remplacent pas une relecture des calculs, des formulations, des distracteurs, du niveau de difficulté et de la conformité au programme par des enseignants.

## Prochaine feuille de route — sans réduire le contenu

- Ajouter une matrice de correspondance officielle : niveau → série → matière → compétence/notion → trimestre → leçon → exercices.
- Calculer automatiquement le nombre réel de chapitres par matière et le comparer aux `totalChapters` déclarés.
- Signaler les sujets avec un trimestre vide ou une compétence sans leçon liée.
- Ajouter des sources/versions pour les références officielles (document, année, page/section), en évitant de marquer « officiel » sans source consultable.
- Vérifier progressivement les corrigés et les unités/notations scientifiques, puis faire valider les contenus sensibles par un enseignant.

## État

La validation CI confirme que les références et les données contrôlées sont cohérentes selon les tests existants. La couverture complète du programme togolais reste à prouver par une matrice de compétences et une revue pédagogique.


## Vérification de publication — 27 novembre 2026 (mise à jour)

Après l'audit structurel, les deux workflows du commit `5b3c2daf735e409337b52ac425d39ce043d65b72` ont terminé avec succès :

- Publication Android/Web : [workflow 46081231436](https://github.com/elawscomedieclub-source/elawseducation-/actions/runs/46081231436) — `success`.
- GitHub Pages : [workflow 46081230663](https://github.com/elawscomedieclub-source/elawseducation-/actions/runs/46081230663) — `success`.
- L'artefact Android `PROFTOGO-APK-Android` est présent dans le workflow Android, taille 33 964 515 octets (environ 34 MB). Il est disponible dans la section **Artifacts** du workflow ; ce contrôle confirme la présence de l'artefact, pas une installation testée sur téléphone.

Cette réussite valide la compilation et la publication par les workflows, pas encore l'exhaustivité officielle des cours. La prochaine étape de contenu reste le rapprochement des chapitres réellement liés avec les volumes déclarés et les compétences officielles, sans suppression ni réduction de la banque existante.


## Contrôle ciblé des unités déclarées de 6e — 28 novembre 2026

J'ai relu les déclarations d'unités dans les fichiers Dart qui alimentent le catalogue annuel et leur transformation en chapitres. Ce comptage porte sur les unités explicitement déclarées avec le code `6e` dans ces modules, pas sur une validation du programme officiel.

| Matière de 6e | Chapitres annoncés dans le catalogue | Unités explicitement déclarées dans le module examiné |
|---|---:|---:|
| Mathématiques | 14 | 5 |
| Français | 12 | 5 |
| Anglais | 12 | 5 |
| SVT | 12 | 5 |
| Histoire-Géographie | 10 | 4 |

Les chapitres de ces modules sont générés à partir des unités déclarées ; les filtres de `annualCoreChapters` incluent les unités de 6e des modules secondaire mathématiques, français, SVT et anglais. Le rapprochement révèle donc un écart structurel important entre les volumes affichés et les unités explicites de ces sources. Il ne faut pas interpréter les nombres annoncés (14/12/12/12/10) comme déjà remplis.

### Action de correction

- Ne pas modifier à la baisse les nombres déclarés et ne pas supprimer les contenus existants.
- Ajouter les unités manquantes dans les modules concernés, après vérification du programme de 6e et de la répartition par trimestre.
- Chaque nouvelle unité devra contenir une leçon réelle et des exercices corrigés, avec des identifiants stables et des références officielles à renseigner.
- Ajouter un test qui compare le nombre de chapitres réellement liés à chaque matière avec `totalChapters`, et qui échoue si un volume annoncé n'est pas atteint.

**État de ce contrôle : écart identifié, contenu à compléter.** Aucun chapitre manquant n'est déclaré « ajouté » tant que le code et les tests ne l'ont pas confirmé.
