import '../models/models.dart';

class AnnualSecondaryMathUnit {
  final SchoolLevel level;
  final String code, title, lessonId, lessonTitle, summary, content;
  final int unitOrder;
  final List<String> keyPoints;
  final List<Exercise> exercises;
  const AnnualSecondaryMathUnit({
    required this.level, required this.code, required this.unitOrder,
    required this.title, required this.lessonId, required this.lessonTitle,
    required this.summary, required this.content, required this.keyPoints,
    required this.exercises,
  });
  String get subjectId => switch (code) {
    '6e' => 'math',
    '5e' => 'cinq_math',
    '4e' => 'quatre_math',
    '3e' => 'trois_math',
    _ => 'core_secondary_math_$code',
  };
  String get chapterId => switch (code) {
    '5e' => switch (unitOrder) {
      1 => 'cinq_m1',
      2 => 'cinq_plus_math',
      3 => 'cinq_m1',
      4 => 'cinq_plus_math',
      5 => 'ptg_year_cinq_math_6',
      6 => 'ptg_year_cinq_math_7',
      _ => 'cinq_m1',
    },
    '4e' => switch (unitOrder) {
      1 => 'ptg_year_quatre_math_6',
      2 => 'quatre_plus_math',
      3 => 'quatre_math_c2',
      4 => 'quatre_m1',
      5 => 'ptg_extension_quatre_math',
      6 => 'ptg_year_quatre_math_7',
      _ => 'ptg_year_quatre_math_6',
    },
    '3e' => switch (unitOrder) {
      1 => 'ptg_year_trois_math_5',
      2 => 'ptg_year_trois_math_7',
      3 => 'ptg_year_trois_math_6',
      4 => 'trois_m1',
      5 => 'ptg_year_trois_math_7',
      6 => 'trois_math_c2',
      _ => 'ptg_year_trois_math_5',
    },
    _ => 'core_secondary_math_${code}_unit_${unitOrder}',
  };
}

const annualSecondaryMathUnits = <AnnualSecondaryMathUnit>[
  AnnualSecondaryMathUnit(level:SchoolLevel.cinquieme,code:'5e',unitOrder:1,title:'Fractions et calcul',lessonId:'core_math_5e_fractions',lessonTitle:'Calculer avec des fractions simples',summary:'Comparer des fractions et effectuer des additions de même dénominateur.',content:'Une fraction a un numérateur et un dénominateur. Le dénominateur indique le nombre de parts égales et ne peut pas être nul. Pour comparer des fractions de même dénominateur, compare les numérateurs. Pour additionner des fractions de même dénominateur, additionne les numérateurs et conserve le dénominateur : 2/7 + 3/7 = 5/7. Pour des dénominateurs différents, il faut les réduire au même dénominateur avant de calculer.',keyPoints:['Le dénominateur ne peut pas être nul','Même dénominateur : comparer les numérateurs','Addition de même dénominateur : (a+b)/n'],exercises:[
    Exercise(id:'core_math_5e_fr1',lessonId:'core_math_5e_fractions',question:'2/9 + 4/9 = ?',options:['6/9','6/18','2/13'],correctIndex:0,explanation:'On additionne les numérateurs : 2 + 4 = 6 et on conserve 9.'),
    Exercise(id:'core_math_5e_fr2',lessonId:'core_math_5e_fractions',question:'Quelle fraction est la plus grande ?',options:['5/8','3/8','2/8'],correctIndex:0,explanation:'Les dénominateurs sont égaux ; 5 est le plus grand numérateur.'),
    Exercise(id:'core_math_5e_fr3',lessonId:'core_math_5e_fractions',question:'Quel nombre est interdit comme dénominateur ?',options:['0','2','10'],correctIndex:0,explanation:'On ne peut pas diviser par zéro.'),
  ]),
  AnnualSecondaryMathUnit(level:SchoolLevel.cinquieme,code:'5e',unitOrder:2,title:'Proportionnalité',lessonId:'core_math_5e_proportion',lessonTitle:'Résoudre une situation de proportionnalité',summary:'Utiliser un coefficient multiplicateur et un tableau de proportionnalité.',content:'Deux grandeurs sont proportionnelles lorsque l’on multiplie chaque valeur de la première par un même nombre pour obtenir la seconde. Ce nombre est le coefficient de proportionnalité. Exemple : 3 cahiers coûtent 600 F ; un cahier coûte 600 ÷ 3 = 200 F, donc 5 cahiers coûtent 5 × 200 = 1 000 F. Vérifie les unités et la cohérence du résultat.',keyPoints:['Même coefficient pour toutes les colonnes','Prix unitaire = prix total ÷ quantité','Vérifier les unités'],exercises:[
    Exercise(id:'core_math_5e_pr1',lessonId:'core_math_5e_proportion',question:'4 stylos coûtent 800 F. Combien coûtent 6 stylos au même prix ?',options:['1 000 F','1 200 F','1 600 F'],correctIndex:1,explanation:'Un stylo coûte 200 F ; 6 × 200 = 1 200 F.'),
    Exercise(id:'core_math_5e_pr2',lessonId:'core_math_5e_proportion',question:'Le coefficient qui transforme 5 en 20 est…',options:['2','4','5'],correctIndex:1,explanation:'5 × 4 = 20.'),
    Exercise(id:'core_math_5e_pr3',lessonId:'core_math_5e_proportion',question:'Dans un tableau proportionnel, le coefficient est…',options:['Le même pour toutes les valeurs correspondantes','Toujours différent','Toujours égal à zéro'],correctIndex:0,explanation:'La proportionnalité utilise un coefficient constant.'),
  ]),
  AnnualSecondaryMathUnit(level:SchoolLevel.quatrieme,code:'4e',unitOrder:1,title:'Théorème de Pythagore',lessonId:'core_math_4e_pythagore',lessonTitle:'Calculer une longueur dans un triangle rectangle',summary:'Appliquer le théorème de Pythagore pour calculer une longueur.',content:'Dans un triangle rectangle, le carré de l’hypoténuse est égal à la somme des carrés des deux autres côtés. Si ABC est rectangle en A, alors BC² = AB² + AC². L’hypoténuse est le côté opposé à l’angle droit et c’est le plus long côté. Pour calculer une longueur, écris la relation, remplace par les valeurs, calcule puis prends la racine carrée si nécessaire.',keyPoints:['Le triangle doit être rectangle','L’hypoténuse est opposée à l’angle droit','c² = a² + b²'],exercises:[
    Exercise(id:'core_math_4e_py1',lessonId:'core_math_4e_pythagore',question:'Un triangle rectangle a des côtés de l’angle droit 3 cm et 4 cm. L’hypoténuse vaut…',options:['5 cm','7 cm','12 cm'],correctIndex:0,explanation:'c² = 3² + 4² = 9 + 16 = 25, donc c = 5 cm.'),
    Exercise(id:'core_math_4e_py2',lessonId:'core_math_4e_pythagore',question:'Dans un triangle rectangle, l’hypoténuse est…',options:['Le côté opposé à l’angle droit','Le plus petit côté toujours','Un angle'],correctIndex:0,explanation:'L’hypoténuse est le côté opposé à l’angle droit.'),
    Exercise(id:'core_math_4e_py3',lessonId:'core_math_4e_pythagore',question:'Si l’hypoténuse vaut 13 cm et un côté 5 cm, l’autre côté vaut…',options:['12 cm','8 cm','18 cm'],correctIndex:0,explanation:'x² = 13² − 5² = 169 − 25 = 144, donc x = 12 cm.'),
  ]),
  AnnualSecondaryMathUnit(level:SchoolLevel.quatrieme,code:'4e',unitOrder:2,title:'Équations du premier degré',lessonId:'core_math_4e_equations',lessonTitle:'Résoudre une équation simple',summary:'Résoudre une équation en conservant l’égalité.',content:'Une équation est une égalité contenant une inconnue. Pour isoler x, on effectue la même opération aux deux membres. Exemple : x + 7 = 19 ; on soustrait 7 des deux côtés, donc x = 12. Vérifie en remplaçant x dans l’équation initiale : 12 + 7 = 19.',keyPoints:['Faire la même opération des deux côtés','Isoler l’inconnue','Vérifier la solution dans l’équation'],exercises:[
    Exercise(id:'core_math_4e_eq1',lessonId:'core_math_4e_equations',question:'Résous x + 8 = 21.',options:['x = 13','x = 29','x = 8'],correctIndex:0,explanation:'On soustrait 8 : x = 21 − 8 = 13.'),
    Exercise(id:'core_math_4e_eq2',lessonId:'core_math_4e_equations',question:'Résous 3x = 18.',options:['x = 6','x = 15','x = 21'],correctIndex:0,explanation:'On divise les deux membres par 3 : x = 6.'),
    Exercise(id:'core_math_4e_eq3',lessonId:'core_math_4e_equations',question:'Comment vérifier une solution ?',options:['Remplacer l’inconnue dans l’équation initiale','Changer le signe au hasard','Ne pas calculer'],correctIndex:0,explanation:'La solution doit rendre l’égalité vraie.'),
  ]),
  AnnualSecondaryMathUnit(level:SchoolLevel.troisieme,code:'3e',unitOrder:1,title:'Théorème de Thalès',lessonId:'core_math_3e_thales',lessonTitle:'Calculer une longueur avec Thalès',summary:'Utiliser la proportionnalité des longueurs dans des triangles en configuration de Thalès.',content:'Dans un triangle ABC, si M appartient à [AB], N appartient à [AC] et MN est parallèle à BC, alors AM/AB = AN/AC = MN/BC. Avant d’appliquer le théorème, vérifie les points alignés et le parallélisme. Écris les rapports dans le même ordre, puis utilise un produit en croix pour calculer la longueur inconnue.',keyPoints:['Vérifier alignement et parallélisme','Écrire les rapports dans le même ordre','Calculer par produit en croix'],exercises:[
    Exercise(id:'core_math_3e_th1',lessonId:'core_math_3e_thales',question:'AM/AB = 2/5 et AB = 15 cm. AM vaut…',options:['6 cm','7,5 cm','10 cm'],correctIndex:0,explanation:'AM = (2/5) × 15 = 6 cm.'),
    Exercise(id:'core_math_3e_th2',lessonId:'core_math_3e_thales',question:'Avant d’appliquer Thalès, il faut vérifier…',options:['Les alignements et le parallélisme','La couleur du triangle','La température'],correctIndex:0,explanation:'La configuration géométrique est nécessaire.'),
    Exercise(id:'core_math_3e_th3',lessonId:'core_math_3e_thales',question:'Si 3/6 = x/10, alors x = …',options:['5','3','20'],correctIndex:0,explanation:'x = 10 × 3 ÷ 6 = 5.'),
  ]),
  AnnualSecondaryMathUnit(level:SchoolLevel.troisieme,code:'3e',unitOrder:2,title:'Fonctions linéaires et affines',lessonId:'core_math_3e_functions',lessonTitle:'Lire et utiliser une fonction affine',summary:'Calculer une image et interpréter une relation y = ax + b.',content:'Une fonction affine s’écrit f(x) = ax + b. Le nombre a est le coefficient directeur et b l’ordonnée à l’origine. Pour calculer l’image d’un nombre, remplace x par cette valeur et effectue les opérations. Une fonction linéaire est un cas particulier : f(x) = ax, donc b = 0. Un tableau de valeurs aide à représenter la fonction.',keyPoints:['Fonction affine : f(x) = ax + b','Image : remplacer x par sa valeur','Fonction linéaire : b = 0'],exercises:[
    Exercise(id:'core_math_3e_fn1',lessonId:'core_math_3e_functions',question:'Si f(x) = 2x + 3, quelle est f(4) ?',options:['11','8','14'],correctIndex:0,explanation:'f(4) = 2 × 4 + 3 = 11.'),
    Exercise(id:'core_math_3e_fn2',lessonId:'core_math_3e_functions',question:'Quelle fonction est linéaire ?',options:['f(x) = 5x','f(x) = 5x + 2','f(x) = x²'],correctIndex:0,explanation:'Une fonction linéaire est de la forme ax.'),
    Exercise(id:'core_math_3e_fn3',lessonId:'core_math_3e_functions',question:'Dans f(x) = 3x − 7, l’ordonnée à l’origine vaut…',options:['−7','3','7'],correctIndex:0,explanation:'b = −7.'),
  ]),
  AnnualSecondaryMathUnit(level:SchoolLevel.cinquieme,code:'5e',unitOrder:3,title:'Nombres décimaux et opérations',lessonId:'core_math_5e_decimals',lessonTitle:'Calculer avec les nombres décimaux',summary:'Lire, comparer, additionner et soustraire des nombres décimaux.',content:'Un nombre décimal peut s’écrire avec une virgule. Pour comparer deux nombres décimaux, compare d’abord les parties entières, puis les chiffres de même rang en ajoutant si besoin des zéros. Pour additionner ou soustraire, aligne les virgules et les rangs : 12,5 + 3,27 = 15,77. Vérifie le résultat par estimation.',keyPoints:['Aligner les virgules dans les opérations','Ajouter des zéros ne change pas la valeur','Estimer pour contrôler le résultat'],exercises:[
    Exercise(id:'core_math_5e_dec1',lessonId:'core_math_5e_decimals',question:'12,5 + 3,27 = ?',options:['15,77','15,27','16,77'],correctIndex:0,explanation:'12,50 + 3,27 = 15,77.'),
    Exercise(id:'core_math_5e_dec2',lessonId:'core_math_5e_decimals',question:'Quel nombre est le plus grand ?',options:['4,08','4,8','4,18'],correctIndex:1,explanation:'4,8 = 4,80, qui est supérieur à 4,18 et 4,08.'),
    Exercise(id:'core_math_5e_dec3',lessonId:'core_math_5e_decimals',question:'8,4 − 2,65 = ?',options:['5,75','6,25','5,85'],correctIndex:0,explanation:'8,40 − 2,65 = 5,75.'),
  ]),
  AnnualSecondaryMathUnit(level:SchoolLevel.cinquieme,code:'5e',unitOrder:4,title:'Pourcentages simples',lessonId:'core_math_5e_percent',lessonTitle:'Calculer un pourcentage d’une quantité',summary:'Comprendre 10 %, 25 %, 50 % et calculer une remise ou une proportion.',content:'Un pourcentage exprime une partie sur 100. 50 % signifie la moitié, 25 % le quart et 10 % un dixième. Pour calculer p % d’une quantité, on peut multiplier la quantité par p puis diviser par 100. Exemple : 20 % de 3 000 F = 3 000 × 20 ÷ 100 = 600 F. Une remise se soustrait au prix initial.',keyPoints:['p % = p/100','50 % = moitié ; 25 % = quart','Montant de remise = prix × taux ÷ 100'],exercises:[
    Exercise(id:'core_math_5e_pct1',lessonId:'core_math_5e_percent',question:'25 % de 800 vaut…',options:['200','250','400'],correctIndex:0,explanation:'25 % est un quart : 800 ÷ 4 = 200.'),
    Exercise(id:'core_math_5e_pct2',lessonId:'core_math_5e_percent',question:'10 % de 5 000 F vaut…',options:['50 F','500 F','1 000 F'],correctIndex:1,explanation:'5 000 ÷ 10 = 500 F.'),
    Exercise(id:'core_math_5e_pct3',lessonId:'core_math_5e_percent',question:'Un article à 2 000 F bénéficie de 50 % de remise. Nouveau prix ?',options:['1 000 F','1 500 F','500 F'],correctIndex:0,explanation:'La remise est la moitié du prix : 1 000 F ; il reste 1 000 F à payer.'),
  ]),
  AnnualSecondaryMathUnit(level:SchoolLevel.cinquieme,code:'5e',unitOrder:5,title:'Angles et triangles',lessonId:'core_math_5e_angles_triangles',lessonTitle:'Construire et reconnaître des triangles',summary:'Identifier les angles et utiliser la somme des angles d’un triangle.',content:'Un angle se mesure en degrés avec un rapporteur. Un angle aigu mesure moins de 90°, un angle droit 90° et un angle obtus plus de 90° et moins de 180°. La somme des trois angles d’un triangle est 180°. Un triangle isocèle possède deux côtés égaux ; un triangle équilatéral possède trois côtés égaux et trois angles de 60°.',keyPoints:['Angle droit : 90°','Somme des angles d’un triangle : 180°','Isocèle : deux côtés égaux ; équilatéral : trois'],exercises:[
    Exercise(id:'core_math_5e_ang1',lessonId:'core_math_5e_angles_triangles',question:'Deux angles d’un triangle mesurent 50° et 60°. Le troisième mesure…',options:['70°','90°','110°'],correctIndex:0,explanation:'180° − 50° − 60° = 70°.'),
    Exercise(id:'core_math_5e_ang2',lessonId:'core_math_5e_angles_triangles',question:'Un angle de 120° est…',options:['Aigu','Droit','Obtus'],correctIndex:2,explanation:'Un angle supérieur à 90° et inférieur à 180° est obtus.'),
    Exercise(id:'core_math_5e_ang3',lessonId:'core_math_5e_angles_triangles',question:'Chaque angle d’un triangle équilatéral mesure…',options:['60°','90°','120°'],correctIndex:0,explanation:'180° ÷ 3 = 60°.'),
  ]),
  AnnualSecondaryMathUnit(level:SchoolLevel.cinquieme,code:'5e',unitOrder:6,title:'Périmètres et aires',lessonId:'core_math_5e_perimeter_area',lessonTitle:'Calculer le périmètre et l’aire',summary:'Distinguer longueur du contour et mesure de la surface.',content:'Le périmètre mesure la longueur du contour et s’exprime en unités de longueur. Pour un rectangle, P = 2 × (longueur + largeur). L’aire mesure la surface et s’exprime en unités carrées : A = longueur × largeur pour un rectangle. Pour un carré de côté c, P = 4c et A = c × c. N’oublie pas les unités.',keyPoints:['Périmètre : unités de longueur','Aire : unités carrées','Rectangle : P = 2(L + l), A = L × l'],exercises:[
    Exercise(id:'core_math_5e_pa1',lessonId:'core_math_5e_perimeter_area',question:'Un rectangle mesure 8 cm sur 3 cm. Son périmètre est…',options:['22 cm','24 cm','11 cm'],correctIndex:0,explanation:'P = 2 × (8 + 3) = 22 cm.'),
    Exercise(id:'core_math_5e_pa2',lessonId:'core_math_5e_perimeter_area',question:'L’aire d’un rectangle de 6 m sur 4 m est…',options:['20 m²','24 m²','10 m²'],correctIndex:1,explanation:'A = 6 × 4 = 24 m².'),
    Exercise(id:'core_math_5e_pa3',lessonId:'core_math_5e_perimeter_area',question:'Quelle unité convient à une aire ?',options:['cm','cm²','cm³'],correctIndex:1,explanation:'Une aire s’exprime en unités carrées, ici cm².'),
  ]),
  AnnualSecondaryMathUnit(level:SchoolLevel.quatrieme,code:'4e',unitOrder:3,title:'Nombres relatifs et calculs',lessonId:'core_math_4e_relative_numbers',lessonTitle:'Calculer avec les nombres relatifs',summary:'Comparer et additionner des nombres positifs et négatifs.',content:'Un nombre relatif peut être positif, négatif ou nul. Sur une droite graduée, les nombres augmentent de gauche à droite. Deux nombres opposés ont la même distance à zéro et des signes contraires. Pour additionner deux nombres de même signe, additionne leurs distances à zéro et garde le signe. Pour des signes différents, soustrais les distances et garde le signe du nombre ayant la plus grande distance à zéro.',keyPoints:['Opposés : même distance à zéro, signes contraires','Même signe : additionner les distances','Signes différents : soustraire les distances'],exercises:[
    Exercise(id:'core_math_4e_rn1',lessonId:'core_math_4e_relative_numbers',question:'−7 + (−5) = ?',options:['−12','−2','12'],correctIndex:0,explanation:'Les deux nombres sont négatifs : 7 + 5 = 12 et on garde le signe −.'),
    Exercise(id:'core_math_4e_rn2',lessonId:'core_math_4e_relative_numbers',question:'L’opposé de 9 est…',options:['−9','0','9'],correctIndex:0,explanation:'L’opposé de 9 est −9.'),
    Exercise(id:'core_math_4e_rn3',lessonId:'core_math_4e_relative_numbers',question:'−8 + 3 = ?',options:['−5','5','−11'],correctIndex:0,explanation:'Les distances diffèrent : 8 − 3 = 5, signe du nombre −8.'),
  ]),
  AnnualSecondaryMathUnit(level:SchoolLevel.quatrieme,code:'4e',unitOrder:4,title:'Proportionnalité et pourcentages',lessonId:'core_math_4e_proportions',lessonTitle:'Résoudre des problèmes de proportionnalité',summary:'Utiliser le coefficient, les pourcentages et les échelles.',content:'Dans une situation de proportionnalité, les grandeurs sont liées par un coefficient constant. On peut utiliser un tableau, le passage à l’unité ou le produit en croix. Pour calculer p % d’une quantité, multiplie par p puis divise par 100. Une échelle 1:n signifie qu’une longueur sur le plan correspond à n fois cette longueur dans la réalité, avec les unités converties.',keyPoints:['Coefficient constant','Produit en croix ou passage à l’unité','Convertir les unités avant d’utiliser une échelle'],exercises:[
    Exercise(id:'core_math_4e_pr1',lessonId:'core_math_4e_proportions',question:'5 kg de riz coûtent 3 000 F. 8 kg coûtent…',options:['4 800 F','4 000 F','6 000 F'],correctIndex:0,explanation:'Prix unitaire : 3 000 ÷ 5 = 600 F ; 8 × 600 = 4 800 F.'),
    Exercise(id:'core_math_4e_pr2',lessonId:'core_math_4e_proportions',question:'15 % de 2 000 vaut…',options:['300','150','30'],correctIndex:0,explanation:'2 000 × 15 ÷ 100 = 300.'),
    Exercise(id:'core_math_4e_pr3',lessonId:'core_math_4e_proportions',question:'Sur une carte à l’échelle 1:100 000, 1 cm représente…',options:['1 km','100 km','100 m'],correctIndex:0,explanation:'100 000 cm = 1 000 m = 1 km.'),
  ]),
  AnnualSecondaryMathUnit(level:SchoolLevel.quatrieme,code:'4e',unitOrder:5,title:'Transformations géométriques',lessonId:'core_math_4e_transformations',lessonTitle:'Reconnaître translations et rotations',summary:'Décrire des transformations qui conservent longueurs et angles.',content:'Une translation déplace chaque point selon le même vecteur : même direction, même sens et même longueur. Une rotation fait tourner une figure autour d’un centre, selon un angle et un sens donnés. Ces transformations conservent les longueurs et les mesures des angles ; l’image d’une figure est donc superposable à la figure initiale.',keyPoints:['Translation : déplacement selon un vecteur','Rotation : centre, angle et sens','Longueurs et angles sont conservés'],exercises:[
    Exercise(id:'core_math_4e_tr1',lessonId:'core_math_4e_transformations',question:'Une translation conserve…',options:['Les longueurs et les angles','Seulement la couleur','La taille mais pas les angles'],correctIndex:0,explanation:'Une translation est une isométrie : elle conserve distances et angles.'),
    Exercise(id:'core_math_4e_tr2',lessonId:'core_math_4e_transformations',question:'Pour définir une rotation, il faut préciser…',options:['Un centre, un angle et un sens','Une couleur et une taille','Un seul point'],correctIndex:0,explanation:'La rotation est définie par son centre, son angle et son sens.'),
    Exercise(id:'core_math_4e_tr3',lessonId:'core_math_4e_transformations',question:'Le déplacement de tous les points selon le même vecteur est…',options:['Une translation','Une homothétie','Une symétrie axiale uniquement'],correctIndex:0,explanation:'C’est la définition d’une translation.'),
  ]),
  AnnualSecondaryMathUnit(level:SchoolLevel.quatrieme,code:'4e',unitOrder:6,title:'Statistiques : moyenne et médiane',lessonId:'core_math_4e_statistics',lessonTitle:'Résumer une série statistique',summary:'Calculer une moyenne et déterminer la médiane d’une série ordonnée.',content:'La moyenne d’une série est la somme des valeurs divisée par leur nombre. La médiane partage une série ordonnée en deux groupes de même effectif : au moins la moitié des valeurs est inférieure ou égale à la médiane et au moins la moitié lui est supérieure ou égale. Pour un effectif pair, on peut prendre la moyenne des deux valeurs centrales.',keyPoints:['Moyenne = somme ÷ effectif','Trier les valeurs avant de chercher la médiane','Effectif pair : moyenne des deux valeurs centrales'],exercises:[
    Exercise(id:'core_math_4e_st1',lessonId:'core_math_4e_statistics',question:'La moyenne de 4, 6 et 8 est…',options:['6','7','18'],correctIndex:0,explanation:'(4 + 6 + 8) ÷ 3 = 18 ÷ 3 = 6.'),
    Exercise(id:'core_math_4e_st2',lessonId:'core_math_4e_statistics',question:'La médiane de 2, 5, 7, 9, 11 est…',options:['7','5','9'],correctIndex:0,explanation:'La série est ordonnée et la valeur centrale est 7.'),
    Exercise(id:'core_math_4e_st3',lessonId:'core_math_4e_statistics',question:'Pour calculer la moyenne, on divise la somme par…',options:['L’effectif','La plus grande valeur','La médiane'],correctIndex:0,explanation:'La moyenne est la somme de toutes les valeurs divisée par leur nombre.'),
  ]),
  AnnualSecondaryMathUnit(level:SchoolLevel.troisieme,code:'3e',unitOrder:3,title:'Trigonométrie dans le triangle rectangle',lessonId:'core_math_3e_trigonometry',lessonTitle:'Calculer un angle ou une longueur avec la trigonométrie',summary:'Utiliser sinus, cosinus ou tangente dans un triangle rectangle.',content:'Dans un triangle rectangle, pour un angle aigu donné, le sinus est le rapport côté opposé / hypoténuse, le cosinus est côté adjacent / hypoténuse et la tangente est côté opposé / côté adjacent. Choisis le rapport qui relie les données connues à l’inconnue. Utilise une calculatrice réglée en degrés pour les angles.',keyPoints:['sin = opposé / hypoténuse','cos = adjacent / hypoténuse','tan = opposé / adjacent ; vérifier le mode degrés'],exercises:[
    Exercise(id:'core_math_3e_tr1',lessonId:'core_math_3e_trigonometry',question:'Dans un triangle rectangle, sin(angle) est…',options:['Opposé / hypoténuse','Adjacent / hypoténuse','Opposé / adjacent'],correctIndex:0,explanation:'Le sinus associe le côté opposé à l’hypoténuse.'),
    Exercise(id:'core_math_3e_tr2',lessonId:'core_math_3e_trigonometry',question:'Si le côté opposé vaut 3 et l’hypoténuse 5, sin(angle) = ?',options:['0,6','1,67','2'],correctIndex:0,explanation:'3 ÷ 5 = 0,6.'),
    Exercise(id:'core_math_3e_tr3',lessonId:'core_math_3e_trigonometry',question:'Pour calculer un angle avec une calculatrice, vérifier…',options:['Le mode degrés','Le mode couleur','Le niveau de batterie uniquement'],correctIndex:0,explanation:'Les angles des exercices sont généralement exprimés en degrés.'),
  ]),
  AnnualSecondaryMathUnit(level:SchoolLevel.troisieme,code:'3e',unitOrder:4,title:'Arithmétique et divisibilité',lessonId:'core_math_3e_arithmetic',lessonTitle:'Utiliser multiples, diviseurs et nombres premiers',summary:'Reconnaître les critères de divisibilité et décomposer un entier.',content:'Un entier a pour diviseurs les nombres qui le divisent sans reste. Un nombre premier possède exactement deux diviseurs positifs : 1 et lui-même. Un entier est divisible par 2 s’il est pair, par 5 s’il se termine par 0 ou 5, et par 3 si la somme de ses chiffres est divisible par 3. La décomposition en facteurs premiers permet de simplifier des fractions et de rechercher des diviseurs communs.',keyPoints:['Nombre premier : exactement deux diviseurs positifs','Divisibilité par 2, 3 et 5','Décomposer un entier en facteurs premiers'],exercises:[
    Exercise(id:'core_math_3e_ar1',lessonId:'core_math_3e_arithmetic',question:'Quel nombre est premier ?',options:['13','15','21'],correctIndex:0,explanation:'13 n’a que 1 et 13 comme diviseurs positifs.'),
    Exercise(id:'core_math_3e_ar2',lessonId:'core_math_3e_arithmetic',question:'Un nombre est divisible par 5 s’il se termine par…',options:['0 ou 5','2 ou 4','3 ou 7'],correctIndex:0,explanation:'Le critère de divisibilité par 5 est une terminaison par 0 ou 5.'),
    Exercise(id:'core_math_3e_ar3',lessonId:'core_math_3e_arithmetic',question:'La somme des chiffres de 231 est 6. 231 est divisible par…',options:['3','5','10'],correctIndex:0,explanation:'6 est divisible par 3, donc 231 l’est aussi.'),
  ]),
  AnnualSecondaryMathUnit(level:SchoolLevel.troisieme,code:'3e',unitOrder:5,title:'Probabilités',lessonId:'core_math_3e_probability',lessonTitle:'Calculer une probabilité simple',summary:'Décrire les issues d’une expérience aléatoire et calculer une probabilité.',content:'Une expérience aléatoire a plusieurs issues possibles. Lorsque toutes les issues sont équiprobables, la probabilité d’un événement est le nombre d’issues favorables divisé par le nombre total d’issues. Une probabilité est comprise entre 0 et 1. Un événement impossible a une probabilité 0 et un événement certain a une probabilité 1.',keyPoints:['P(A) = issues favorables / issues possibles si équiprobables','0 ≤ P(A) ≤ 1','Impossible : 0 ; certain : 1'],exercises:[
    Exercise(id:'core_math_3e_pb1',lessonId:'core_math_3e_probability',question:'On lance un dé équilibré. Probabilité d’obtenir 6 ?',options:['1/6','1/2','6/6'],correctIndex:0,explanation:'Une issue favorable sur six issues équiprobables.'),
    Exercise(id:'core_math_3e_pb2',lessonId:'core_math_3e_probability',question:'Une probabilité peut-elle être égale à 1,2 ?',options:['Non','Oui, toujours','Seulement pour un événement impossible'],correctIndex:0,explanation:'Une probabilité est comprise entre 0 et 1.'),
    Exercise(id:'core_math_3e_pb3',lessonId:'core_math_3e_probability',question:'La probabilité d’un événement certain est…',options:['1','0','1/2'],correctIndex:0,explanation:'Un événement certain se réalise toujours.'),
  ]),
  AnnualSecondaryMathUnit(level:SchoolLevel.troisieme,code:'3e',unitOrder:6,title:'Puissances et notation scientifique',lessonId:'core_math_3e_powers',lessonTitle:'Écrire et calculer avec des puissances',summary:'Utiliser les règles des puissances et la notation scientifique.',content:'Pour un entier n positif, aⁿ est le produit de n facteurs égaux à a. Pour a non nul, a⁰ = 1 et a⁻ⁿ = 1/aⁿ. À base identique, aᵐ × aⁿ = aᵐ⁺ⁿ et aᵐ ÷ aⁿ = aᵐ⁻ⁿ (a non nul). La notation scientifique écrit un nombre sous la forme a × 10ⁿ avec 1 ≤ |a| < 10.',keyPoints:['aᵐ × aⁿ = aᵐ⁺ⁿ','aᵐ ÷ aⁿ = aᵐ⁻ⁿ pour a non nul','Notation scientifique : a × 10ⁿ, 1 ≤ |a| < 10'],exercises:[
    Exercise(id:'core_math_3e_pw1',lessonId:'core_math_3e_powers',question:'10³ = ?',options:['1 000','100','10 000'],correctIndex:0,explanation:'10 × 10 × 10 = 1 000.'),
    Exercise(id:'core_math_3e_pw2',lessonId:'core_math_3e_powers',question:'2³ × 2² = ?',options:['2⁵','2⁶','4⁵'],correctIndex:0,explanation:'On additionne les exposants : 3 + 2 = 5.'),
    Exercise(id:'core_math_3e_pw3',lessonId:'core_math_3e_powers',question:'La notation scientifique de 45 000 est…',options:['4,5 × 10⁴','45 × 10³','0,45 × 10⁵'],correctIndex:0,explanation:'4,5 est compris entre 1 et 10 et 4,5 × 10⁴ = 45 000.'),
  ]),

  AnnualSecondaryMathUnit(level:SchoolLevel.sixieme,code:'6e',unitOrder:1,title:'Lire, comparer et encadrer les nombres',lessonId:'core_math_6e_numbers',lessonTitle:'Lire et comparer les nombres entiers et décimaux',summary:'Utiliser la valeur des chiffres, comparer, ranger et encadrer des nombres.',content:'Dans un nombre, chaque chiffre a une valeur selon sa position : unités, dizaines, centaines, puis dixièmes, centièmes et millièmes pour la partie décimale. Pour comparer deux nombres, compare d’abord les parties entières ; si elles sont égales, compare les chiffres décimaux de gauche à droite. On peut encadrer un nombre entre deux nombres proches et l’arrondir selon la précision demandée.',keyPoints:['La position d’un chiffre détermine sa valeur','Comparer de gauche à droite','Un arrondi dépend de la précision demandée'],exercises:[
    Exercise(id:'core_math_6e_num1',lessonId:'core_math_6e_numbers',question:'Dans 4 582, le chiffre 5 représente…',options:['5 dizaines','5 centaines','5 unités'],correctIndex:1,explanation:'Le 5 est à la position des centaines : il vaut 500.'),
    Exercise(id:'core_math_6e_num2',lessonId:'core_math_6e_numbers',question:'Quel nombre est le plus grand ?',options:['3,47','3,407','3,5'],correctIndex:2,explanation:'3,5 = 3,50 ; il est supérieur à 3,47 et à 3,407.'),
    Exercise(id:'core_math_6e_num3',lessonId:'core_math_6e_numbers',question:'L’arrondi de 8,36 au dixième est…',options:['8,3','8,4','8,36'],correctIndex:1,explanation:'Le chiffre des centièmes est 6 ; on augmente le chiffre des dixièmes.'),
  ]),
  AnnualSecondaryMathUnit(level:SchoolLevel.sixieme,code:'6e',unitOrder:2,title:'Comprendre les fractions',lessonId:'core_math_6e_fractions',lessonTitle:'Représenter et comparer des fractions simples',summary:'Interpréter une fraction, reconnaître des fractions équivalentes et comparer des parts.',content:'Une fraction a un numérateur et un dénominateur non nul. Le dénominateur indique en combien de parts égales l’unité est partagée ; le numérateur indique combien de parts sont prises. Des fractions équivalentes représentent la même quantité. Pour comparer des fractions de même dénominateur, compare les numérateurs ; pour des fractions simples, on peut aussi utiliser un dessin ou une droite graduée.',keyPoints:['Le dénominateur indique le nombre de parts égales','Le numérateur indique les parts prises','Des fractions équivalentes ont la même valeur'],exercises:[
    Exercise(id:'core_math_6e_fr1',lessonId:'core_math_6e_fractions',question:'Dans 3/8, le dénominateur est…',options:['3','8','11'],correctIndex:1,explanation:'Le dénominateur est le nombre placé en bas : 8.'),
    Exercise(id:'core_math_6e_fr2',lessonId:'core_math_6e_fractions',question:'Quelle fraction est équivalente à 1/2 ?',options:['2/4','1/3','3/5'],correctIndex:0,explanation:'2/4 représente deux parts sur quatre, soit la moitié.'),
    Exercise(id:'core_math_6e_fr3',lessonId:'core_math_6e_fractions',question:'Laquelle est la plus grande ?',options:['2/7','5/7','1/7'],correctIndex:1,explanation:'Les dénominateurs sont égaux ; le plus grand numérateur est 5.'),
  ]),
  AnnualSecondaryMathUnit(level:SchoolLevel.sixieme,code:'6e',unitOrder:3,title:'Résoudre des problèmes avec les quatre opérations',lessonId:'core_math_6e_operations',lessonTitle:'Choisir une opération et vérifier le résultat',summary:'Identifier les données utiles, choisir l’opération et contrôler la réponse.',content:'Pour résoudre un problème, lis l’énoncé, repère les données et la question, puis choisis l’opération adaptée. L’addition réunit des quantités, la soustraction cherche un écart ou un reste, la multiplication calcule des groupes égaux et la division partage ou forme des groupes. Vérifie le résultat par une estimation et écris une phrase réponse avec l’unité.',keyPoints:['Repérer les données et la question','Choisir l’opération selon le sens','Vérifier par estimation et rédiger la réponse'],exercises:[
    Exercise(id:'core_math_6e_op1',lessonId:'core_math_6e_operations',question:'5 cahiers coûtent 250 F chacun. Le prix total est…',options:['1 250 F','255 F','1 000 F'],correctIndex:0,explanation:'5 × 250 = 1 250 F.'),
    Exercise(id:'core_math_6e_op2',lessonId:'core_math_6e_operations',question:'On partage 36 mangues en 4 lots égaux. Chaque lot contient…',options:['8','9','12'],correctIndex:1,explanation:'36 ÷ 4 = 9 mangues par lot.'),
    Exercise(id:'core_math_6e_op3',lessonId:'core_math_6e_operations',question:'Une classe compte 28 élèves, 13 sont des filles. Le nombre de garçons est…',options:['41','15','11'],correctIndex:1,explanation:'28 − 13 = 15 garçons.'),
  ]),
  AnnualSecondaryMathUnit(level:SchoolLevel.sixieme,code:'6e',unitOrder:4,title:'Proportionnalité et tableaux',lessonId:'core_math_6e_proportionality',lessonTitle:'Reconnaître une situation de proportionnalité',summary:'Utiliser un tableau, le coefficient multiplicateur et la règle de trois simple.',content:'Deux grandeurs sont proportionnelles lorsque l’on passe de l’une à l’autre en multipliant toujours par le même nombre. Ce nombre est le coefficient de proportionnalité. Un tableau permet d’organiser les valeurs. Pour trouver une valeur manquante, on peut multiplier ou diviser par le coefficient, ou utiliser un passage par l’unité.',keyPoints:['Même coefficient pour toutes les colonnes','Organiser les données dans un tableau','Le passage par l’unité aide à calculer'],exercises:[
    Exercise(id:'core_math_6e_pr1',lessonId:'core_math_6e_proportionality',question:'2 kg de riz coûtent 1 200 F. 1 kg coûte…',options:['600 F','1 200 F','2 400 F'],correctIndex:0,explanation:'On divise le prix par 2 : 1 200 ÷ 2 = 600 F.'),
    Exercise(id:'core_math_6e_pr2',lessonId:'core_math_6e_proportionality',question:'Le coefficient qui transforme 4 en 20 est…',options:['5','16','24'],correctIndex:0,explanation:'20 ÷ 4 = 5 ; on multiplie par 5.'),
    Exercise(id:'core_math_6e_pr3',lessonId:'core_math_6e_proportionality',question:'3 bouteilles coûtent 900 F. 6 bouteilles coûtent…',options:['1 200 F','1 800 F','2 700 F'],correctIndex:1,explanation:'6 est le double de 3 ; le prix est donc doublé.'),
  ]),
  AnnualSecondaryMathUnit(level:SchoolLevel.sixieme,code:'6e',unitOrder:5,title:'Construire et mesurer des figures géométriques',lessonId:'core_math_6e_geometry',lessonTitle:'Utiliser les droites, angles et triangles',summary:'Reconnaître les éléments géométriques et construire une figure avec les instruments.',content:'Une droite se prolonge dans les deux sens ; un segment a deux extrémités. Un angle se mesure en degrés avec un rapporteur. Un triangle possède trois côtés et trois angles ; la somme de ses angles est égale à 180 degrés. Pour construire une figure, trace soigneusement les lignes, utilise la règle, l’équerre et le compas, puis vérifie les mesures.',keyPoints:['Distinguer droite, demi-droite et segment','Mesurer un angle en degrés','La somme des angles d’un triangle vaut 180°'],exercises:[
    Exercise(id:'core_math_6e_geo1',lessonId:'core_math_6e_geometry',question:'Un angle droit mesure…',options:['90°','45°','180°'],correctIndex:0,explanation:'Un angle droit mesure exactement 90 degrés.'),
    Exercise(id:'core_math_6e_geo2',lessonId:'core_math_6e_geometry',question:'La somme des angles d’un triangle est…',options:['90°','180°','360°'],correctIndex:1,explanation:'Dans tout triangle, la somme des angles est 180 degrés.'),
    Exercise(id:'core_math_6e_geo3',lessonId:'core_math_6e_geometry',question:'Quel instrument sert à mesurer un angle ?',options:['Un rapporteur','Une balance','Un thermomètre'],correctIndex:0,explanation:'On mesure un angle avec un rapporteur.'),
  ]),

];

final annualSecondaryMathChapters = annualSecondaryMathUnits.map((unit) => Chapter(
  id:unit.chapterId,subjectId:unit.subjectId,title:'Unité ${unit.unitOrder} — ${unit.title}',
  order:unit.unitOrder,term:unit.unitOrder,totalLessons:1,
)).toList();

final annualSecondaryMathLessons = annualSecondaryMathUnits.map((unit) => Lesson(
  id:unit.lessonId,chapterId:unit.chapterId,title:unit.lessonTitle,
  summary:unit.summary,content:unit.content,keyPoints:unit.keyPoints,durationMinutes:25,
)).toList();

final annualSecondaryMathExercises = annualSecondaryMathUnits.expand((unit)=>unit.exercises).toList();
