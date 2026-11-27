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
