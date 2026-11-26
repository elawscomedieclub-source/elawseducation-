import '../models/models.dart';

class AnnualSecondeMathUnit {
  final int unitOrder;
  final String title, lessonId, lessonTitle, summary, content;
  final List<String> keyPoints;
  final List<Exercise> exercises;
  const AnnualSecondeMathUnit({
    required this.unitOrder, required this.title, required this.lessonId,
    required this.lessonTitle, required this.summary, required this.content,
    required this.keyPoints, required this.exercises,
  });
  String get subjectId => 'core_math_seconde';
  String get chapterId => 'core_math_seconde_unit_$unitOrder';
}

const annualSecondeMathUnits = <AnnualSecondeMathUnit>[
  AnnualSecondeMathUnit(unitOrder:1,title:'Ensembles de nombres et intervalles',lessonId:'core_math_2nde_numbers',lessonTitle:'Classer les nombres et utiliser les intervalles',summary:'Reconnaître les ensembles de nombres et représenter un intervalle.',content:'Les nombres entiers naturels N, entiers relatifs Z, décimaux D, rationnels Q et réels R sont emboîtés : N ⊂ Z ⊂ D ⊂ Q ⊂ R. Un intervalle décrit un ensemble de nombres compris entre deux bornes. [a;b] inclut les bornes, ]a;b[ les exclut. Sur une droite graduée, un point plein indique une borne incluse et un point vide une borne exclue. Vérifie toujours si les bornes sont ouvertes ou fermées.',keyPoints:['N ⊂ Z ⊂ D ⊂ Q ⊂ R','Crochet fermé : borne incluse','Crochet ouvert : borne exclue'],exercises:[
Exercise(id:'core_math_2nde_n1',lessonId:'core_math_2nde_numbers',question:'Quel ensemble contient tous les nombres rationnels ?',options:['Q','N seulement','Z seulement'],correctIndex:0,explanation:'Q désigne l’ensemble des nombres rationnels.'),
Exercise(id:'core_math_2nde_n2',lessonId:'core_math_2nde_numbers',question:'Dans [2;5], le nombre 2 est…',options:['Inclus','Exclu','Interdit'],correctIndex:0,explanation:'Les crochets fermés incluent les deux bornes.'),
Exercise(id:'core_math_2nde_n3',lessonId:'core_math_2nde_numbers',question:'Quel nombre est irrationnel ?',options:['√2','3/4','−5'],correctIndex:0,explanation:'√2 ne peut pas s’écrire comme quotient de deux entiers.'),
]),
AnnualSecondeMathUnit(unitOrder:2,title:'Calcul algébrique et identités remarquables',lessonId:'core_math_2nde_algebra',lessonTitle:'Développer et factoriser une expression',summary:'Utiliser la distributivité et les identités remarquables.',content:'La distributivité permet de développer : a(b+c)=ab+ac. La double distributivité donne (a+b)(c+d)=ac+ad+bc+bd. Les identités remarquables sont (a+b)²=a²+2ab+b², (a−b)²=a²−2ab+b² et (a−b)(a+b)=a²−b². Factoriser consiste à écrire une somme sous forme de produit. Attention aux signes et aux parenthèses ; vérifie en développant le résultat.',keyPoints:['a(b+c)=ab+ac','(a+b)²=a²+2ab+b²','a²−b²=(a−b)(a+b)'],exercises:[
Exercise(id:'core_math_2nde_a1',lessonId:'core_math_2nde_algebra',question:'Développe 3(x+4).',options:['3x+12','3x+4','x+12'],correctIndex:0,explanation:'On distribue 3 : 3×x + 3×4 = 3x+12.'),
Exercise(id:'core_math_2nde_a2',lessonId:'core_math_2nde_algebra',question:'(x+2)² vaut…',options:['x²+4x+4','x²+4','x²+2x+4'],correctIndex:0,explanation:'(a+b)²=a²+2ab+b².'),
Exercise(id:'core_math_2nde_a3',lessonId:'core_math_2nde_algebra',question:'Factorise x²−9.',options:['(x−3)(x+3)','(x−9)(x+1)','x(x−9)'],correctIndex:0,explanation:'x²−9 est une différence de deux carrés.'),
]),
AnnualSecondeMathUnit(unitOrder:3,title:'Équations et inéquations',lessonId:'core_math_2nde_equations',lessonTitle:'Résoudre une équation ou une inéquation',summary:'Isoler l’inconnue et respecter les règles de signe.',content:'Pour résoudre une équation, effectue la même opération aux deux membres afin d’isoler l’inconnue. Pour une inéquation, les mêmes opérations sont autorisées, mais lorsqu’on multiplie ou divise par un nombre négatif, on inverse le sens de l’inégalité. Exemple : −2x < 6 devient x > −3. La solution peut être représentée par un intervalle. Vérifie les solutions en les testant dans l’expression initiale.',keyPoints:['Même opération sur les deux membres','Multiplier/diviser par un négatif inverse le signe','Exprimer la solution par un intervalle'],exercises:[
Exercise(id:'core_math_2nde_e1',lessonId:'core_math_2nde_equations',question:'Résous 2x+5=13.',options:['x=4','x=9','x=−4'],correctIndex:0,explanation:'2x=8, donc x=4.'),
Exercise(id:'core_math_2nde_e2',lessonId:'core_math_2nde_equations',question:'En divisant −3x < 12 par −3, on obtient…',options:['x > −4','x < −4','x > 4'],correctIndex:0,explanation:'Le signe s’inverse lors d’une division par un nombre négatif.'),
Exercise(id:'core_math_2nde_e3',lessonId:'core_math_2nde_equations',question:'La solution de x−7≥0 est…',options:['x≥7','x≤7','x≥−7'],correctIndex:0,explanation:'On ajoute 7 aux deux membres.'),
]),
AnnualSecondeMathUnit(unitOrder:4,title:'Fonctions : images et antécédents',lessonId:'core_math_2nde_functions',lessonTitle:'Lire et calculer avec une fonction',summary:'Déterminer une image, un antécédent et lire une courbe.',content:'Une fonction f associe à chaque nombre x de son domaine une unique image f(x). Pour calculer l’image, remplace x par sa valeur dans l’expression. Un antécédent de y est un nombre x tel que f(x)=y. Sur un graphique, l’image se lit verticalement à partir de x ; les antécédents se recherchent horizontalement à partir de y. Une valeur peut avoir plusieurs antécédents ou aucun.',keyPoints:['Image de x : f(x)','Antécédent de y : résoudre f(x)=y','Lire les axes et leurs unités'],exercises:[
Exercise(id:'core_math_2nde_f1',lessonId:'core_math_2nde_functions',question:'Si f(x)=2x+1, quelle est f(3) ?',options:['7','6','5'],correctIndex:0,explanation:'f(3)=2×3+1=7.'),
Exercise(id:'core_math_2nde_f2',lessonId:'core_math_2nde_functions',question:'Pour trouver un antécédent de 9, on résout…',options:['f(x)=9','f(9)=x','x=9 toujours'],correctIndex:0,explanation:'Un antécédent de 9 est une valeur x dont l’image vaut 9.'),
Exercise(id:'core_math_2nde_f3',lessonId:'core_math_2nde_functions',question:'Une fonction associe à chaque x de son domaine…',options:['Une seule image','Toujours deux images','Aucune image'],correctIndex:0,explanation:'C’est la définition d’une fonction.'),
]),
AnnualSecondeMathUnit(unitOrder:5,title:'Fonctions affines et représentations',lessonId:'core_math_2nde_affine',lessonTitle:'Étudier une fonction affine',summary:'Identifier le coefficient directeur et l’ordonnée à l’origine.',content:'Une fonction affine s’écrit f(x)=ax+b. Le nombre a est le coefficient directeur et b l’ordonnée à l’origine. Sa représentation graphique est une droite. Si a>0, la fonction est croissante ; si a<0, elle est décroissante ; si a=0, elle est constante. Le point (0;b) appartient à la droite. Pour tracer la droite, calcule deux points puis relie-les à la règle.',keyPoints:['f(x)=ax+b','a : coefficient directeur ; b : ordonnée à l’origine','Deux points suffisent pour tracer une droite'],exercises:[
Exercise(id:'core_math_2nde_af1',lessonId:'core_math_2nde_affine',question:'Dans f(x)=−3x+2, le coefficient directeur est…',options:['−3','2','3'],correctIndex:0,explanation:'Le coefficient de x est −3.'),
Exercise(id:'core_math_2nde_af2',lessonId:'core_math_2nde_affine',question:'La droite de f(x)=4x+1 coupe l’axe des ordonnées en…',options:['(0;1)','(1;0)','(0;4)'],correctIndex:0,explanation:'L’ordonnée à l’origine est b=1.'),
Exercise(id:'core_math_2nde_af3',lessonId:'core_math_2nde_affine',question:'Si a est négatif, la fonction affine est…',options:['Décroissante','Croissante','Toujours constante'],correctIndex:0,explanation:'Un coefficient directeur négatif correspond à une droite décroissante.'),
]),
AnnualSecondeMathUnit(unitOrder:6,title:'Statistiques et probabilités',lessonId:'core_math_2nde_statistics',lessonTitle:'Résumer des données et calculer une probabilité',summary:'Calculer moyenne, médiane et probabilité dans une situation simple.',content:'La moyenne d’une série est la somme des valeurs divisée par l’effectif. La médiane partage une série ordonnée en deux groupes de même effectif ; pour un effectif pair, elle est la moyenne des deux valeurs centrales. Dans une expérience à issues équiprobables, la probabilité d’un événement est le nombre d’issues favorables divisé par le nombre total d’issues. Une probabilité est comprise entre 0 et 1.',keyPoints:['Moyenne = somme ÷ effectif','Trier les valeurs avant de chercher la médiane','P(A)=issues favorables/issues possibles'],exercises:[
Exercise(id:'core_math_2nde_s1',lessonId:'core_math_2nde_statistics',question:'La moyenne de 4, 6 et 8 est…',options:['6','18','8'],correctIndex:0,explanation:'(4+6+8)÷3=6.'),
Exercise(id:'core_math_2nde_s2',lessonId:'core_math_2nde_statistics',question:'On lance un dé équilibré. P(obtenir 6)=…',options:['1/6','1/2','6/6'],correctIndex:0,explanation:'Une issue favorable sur six issues équiprobables.'),
Exercise(id:'core_math_2nde_s3',lessonId:'core_math_2nde_statistics',question:'Une probabilité est toujours…',options:['Entre 0 et 1','Supérieure à 1','Négative'],correctIndex:0,explanation:'Une probabilité appartient à l’intervalle [0;1].'),
]),
];

final annualSecondeMathSubject = Subject(
  id:'core_math_seconde',name:'Mathématiques — Seconde : cours de l’année',
  iconName:'calculate',colorHex:'1565C0',level:SchoolLevel.seconde,
  totalChapters:annualSecondeMathUnits.length,
);
final annualSecondeMathChapters = annualSecondeMathUnits.map((unit)=>Chapter(
  id:unit.chapterId,subjectId:unit.subjectId,title:'Unité ${unit.unitOrder} — ${unit.title}',
  order:unit.unitOrder,term:unit.unitOrder,totalLessons:1,
)).toList();
final annualSecondeMathLessons = annualSecondeMathUnits.map((unit)=>Lesson(
  id:unit.lessonId,chapterId:unit.chapterId,title:unit.lessonTitle,
  summary:unit.summary,content:unit.content,keyPoints:unit.keyPoints,durationMinutes:30,
)).toList();
final annualSecondeMathExercises = annualSecondeMathUnits.expand((unit)=>unit.exercises).toList();
