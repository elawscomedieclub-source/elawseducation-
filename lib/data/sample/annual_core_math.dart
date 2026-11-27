import '../models/models.dart';

class AnnualMathUnit {
  final SchoolLevel level;
  final String code, title, lessonId, lessonTitle, summary, content;
  final int unitOrder;
  final List<String> keyPoints;
  final List<Exercise> exercises;
  const AnnualMathUnit({
    required this.level, required this.code, required this.unitOrder,
    required this.title, required this.lessonId, required this.lessonTitle,
    required this.summary, required this.content, required this.keyPoints,
    required this.exercises,
  });
  String get subjectId => 'core_math_$code';
  String get chapterId => 'core_math_${code}_unit_${unitOrder}';
}

const annualMathUnits = <AnnualMathUnit>[
  AnnualMathUnit(level: SchoolLevel.cp1,code:'cp1',unitOrder:1,title:'Numbers from 1 to 20',lessonId:'core_math_cp1_numbers',lessonTitle:'Count and compare to 20',summary:'Compter, lire, écrire et comparer les nombres jusqu’à 20.',content:'Count objects one by one and match each object with one number. Numbers from 1 to 20 have an order. The number that comes after 9 is 10. Use more than, less than and equal to when comparing two groups.',keyPoints:['Count one object at a time','10 comes after 9','Compare groups by counting'],exercises:[
    Exercise(id:'core_math_cp1_n1',lessonId:'core_math_cp1_numbers',question:'Which number comes after 9?',options:['8','10','7'],correctIndex:1,explanation:'Après 9 vient 10.'),
    Exercise(id:'core_math_cp1_n2',lessonId:'core_math_cp1_numbers',question:'Which number is greater?',options:['14','12','11'],correctIndex:0,explanation:'14 est plus grand que 12 et 11.'),
    Exercise(id:'core_math_cp1_n3',lessonId:'core_math_cp1_numbers',question:'How many objects are 5 and 3 more?',options:['7','8','9'],correctIndex:1,explanation:'5 + 3 = 8 objets.'),
  ]),
  AnnualMathUnit(level:SchoolLevel.cp1,code:'cp1',unitOrder:2,title:'Addition and subtraction',lessonId:'core_math_cp1_operations',lessonTitle:'Add and take away',summary:'Résoudre des additions et soustractions simples.',content:'Addition joins two quantities. Example: 3 mangoes and 2 mangoes make 5 mangoes, so 3 + 2 = 5. Subtraction removes a quantity. Example: 6 pencils take away 1 pencil leaves 5, so 6 − 1 = 5. Use objects or drawings to check.',keyPoints:['Addition joins quantities','Subtraction removes a quantity','Use objects or drawings to check'],exercises:[
    Exercise(id:'core_math_cp1_o1',lessonId:'core_math_cp1_operations',question:'What is 4 + 3?',options:['6','7','8'],correctIndex:1,explanation:'4 + 3 = 7.'),
    Exercise(id:'core_math_cp1_o2',lessonId:'core_math_cp1_operations',question:'What is 8 − 2?',options:['5','6','7'],correctIndex:1,explanation:'8 − 2 = 6.'),
    Exercise(id:'core_math_cp1_o3',lessonId:'core_math_cp1_operations',question:'Afi has 5 oranges and gets 2 more. How many?',options:['7','3','10'],correctIndex:0,explanation:'5 + 2 = 7 oranges.'),
  ]),
  AnnualMathUnit(level:SchoolLevel.cp2,code:'cp2',unitOrder:1,title:'Tens and units',lessonId:'core_math_cp2_placevalue',lessonTitle:'Tens and units to 100',summary:'Décomposer un nombre en dizaines et unités.',content:'A group of ten units makes one ten. In 34, the digit 3 represents three tens (30) and the digit 4 represents four units. So 34 = 30 + 4. Use bundles of ten sticks to understand place value.',keyPoints:['10 units = 1 ten','34 = 3 tens + 4 units','The position of a digit gives its value'],exercises:[
    Exercise(id:'core_math_cp2_p1',lessonId:'core_math_cp2_placevalue',question:'How many tens are in 52?',options:['5','2','7'],correctIndex:0,explanation:'52 contient 5 dizaines et 2 unités.'),
    Exercise(id:'core_math_cp2_p2',lessonId:'core_math_cp2_placevalue',question:'Write 36 as tens and units.',options:['3 tens and 6 units','6 tens and 3 units','36 tens'],correctIndex:0,explanation:'36 = 30 + 6.'),
    Exercise(id:'core_math_cp2_p3',lessonId:'core_math_cp2_placevalue',question:'What is 4 tens?',options:['4','14','40'],correctIndex:2,explanation:'4 dizaines = 40 unités.'),
  ]),
  AnnualMathUnit(level:SchoolLevel.cp2,code:'cp2',unitOrder:2,title:'Addition and subtraction to 100',lessonId:'core_math_cp2_addsub',lessonTitle:'Calculate to 100',summary:'Additionner et soustraire en utilisant les dizaines et unités.',content:'To calculate 27 + 15, add tens and units carefully: 27 + 10 = 37, then 37 + 5 = 42. For subtraction, 54 − 20 = 34 because two tens are removed. Check an answer using the opposite operation when possible.',keyPoints:['Add tens first when helpful','Break numbers into tens and units','Check with the opposite operation'],exercises:[
    Exercise(id:'core_math_cp2_a1',lessonId:'core_math_cp2_addsub',question:'What is 27 + 15?',options:['32','42','52'],correctIndex:1,explanation:'27 + 10 = 37, puis +5 = 42.'),
    Exercise(id:'core_math_cp2_a2',lessonId:'core_math_cp2_addsub',question:'What is 64 − 20?',options:['44','46','54'],correctIndex:0,explanation:'64 − 2 dizaines = 44.'),
    Exercise(id:'core_math_cp2_a3',lessonId:'core_math_cp2_addsub',question:'Which operation checks 35 + 8 = 43?',options:['43 − 8 = 35','43 + 8 = 35','35 − 8 = 43'],correctIndex:0,explanation:'La soustraction 43 − 8 permet de vérifier l’addition.'),
  ]),
  AnnualMathUnit(level:SchoolLevel.ce1,code:'ce1',unitOrder:1,title:'Numbers to 1,000',lessonId:'core_math_ce1_thousands',lessonTitle:'Hundreds, tens and units',summary:'Lire, écrire et décomposer les nombres jusqu’à 1 000.',content:'One hundred is ten tens. In 482, 4 means four hundreds, 8 means eight tens and 2 means two units. We write 482 = 400 + 80 + 2. Compare numbers by looking first at hundreds, then tens, then units.',keyPoints:['10 tens = 100','482 = 400 + 80 + 2','Compare hundreds before tens and units'],exercises:[
    Exercise(id:'core_math_ce1_h1',lessonId:'core_math_ce1_thousands',question:'What is the value of 6 in 653?',options:['6','60','600'],correctIndex:2,explanation:'Le 6 est au rang des centaines : 600.'),
    Exercise(id:'core_math_ce1_h2',lessonId:'core_math_ce1_thousands',question:'Which number is greatest?',options:['482','428','248'],correctIndex:0,explanation:'482 a 4 centaines, 428 aussi, mais 8 dizaines est supérieur à 2.'),
    Exercise(id:'core_math_ce1_h3',lessonId:'core_math_ce1_thousands',question:'Decompose 371.',options:['300 + 70 + 1','30 + 7 + 1','300 + 7 + 10'],correctIndex:0,explanation:'371 = 300 + 70 + 1.'),
  ]),
  AnnualMathUnit(level:SchoolLevel.ce1,code:'ce1',unitOrder:2,title:'Multiplication as groups',lessonId:'core_math_ce1_multiplication',lessonTitle:'Equal groups and multiplication',summary:'Comprendre la multiplication comme addition répétée.',content:'Multiplication can count equal groups. Three bags with four oranges each contain 4 + 4 + 4 = 12 oranges. We write 3 × 4 = 12. The order of equal groups can be changed: 3 × 4 and 4 × 3 have the same product.',keyPoints:['Multiplication counts equal groups','3 × 4 = 4 + 4 + 4 = 12','Learn multiplication tables gradually'],exercises:[
    Exercise(id:'core_math_ce1_m1',lessonId:'core_math_ce1_multiplication',question:'What is 3 × 4?',options:['7','12','16'],correctIndex:1,explanation:'3 groupes de 4 font 12.'),
    Exercise(id:'core_math_ce1_m2',lessonId:'core_math_ce1_multiplication',question:'5 groups of 2 make…',options:['7','10','12'],correctIndex:1,explanation:'5 × 2 = 10.'),
    Exercise(id:'core_math_ce1_m3',lessonId:'core_math_ce1_multiplication',question:'Which addition equals 4 × 3?',options:['3 + 3 + 3 + 3','4 + 3','4 + 4 + 4 + 4'],correctIndex:0,explanation:'4 × 3 correspond à quatre groupes de trois.'),
  ]),
  AnnualMathUnit(level:SchoolLevel.ce2,code:'ce2',unitOrder:1,title:'Division and equal sharing',lessonId:'core_math_ce2_division',lessonTitle:'Share equally',summary:'Partager une quantité en groupes égaux.',content:'Division shares a quantity equally. If 12 pencils are shared among 3 pupils, each pupil receives 4 pencils: 12 ÷ 3 = 4. Multiplication checks division: 3 × 4 = 12. If objects remain, we call them a remainder.',keyPoints:['Division shares equally','12 ÷ 3 = 4','Check division with multiplication'],exercises:[
    Exercise(id:'core_math_ce2_d1',lessonId:'core_math_ce2_division',question:'Share 15 mangoes among 5 children. Each gets…',options:['2','3','5'],correctIndex:1,explanation:'15 ÷ 5 = 3 mangues par enfant.'),
    Exercise(id:'core_math_ce2_d2',lessonId:'core_math_ce2_division',question:'What is 20 ÷ 4?',options:['4','5','6'],correctIndex:1,explanation:'20 partagé en 4 groupes égaux donne 5.'),
    Exercise(id:'core_math_ce2_d3',lessonId:'core_math_ce2_division',question:'Which multiplication checks 18 ÷ 3 = 6?',options:['3 × 6 = 18','18 × 3 = 6','6 + 3 = 18'],correctIndex:0,explanation:'3 × 6 = 18 vérifie le quotient.'),
  ]),
  AnnualMathUnit(level:SchoolLevel.ce2,code:'ce2',unitOrder:2,title:'Length and measurement',lessonId:'core_math_ce2_length',lessonTitle:'Measure length',summary:'Choisir une unité et convertir mètre et centimètre.',content:'Use a ruler or tape measure to measure length. One metre equals 100 centimetres. A pencil may be measured in centimetres; a classroom may be measured in metres. Start at zero and read the mark carefully.',keyPoints:['1 m = 100 cm','Use cm for small objects','Start measuring at zero'],exercises:[
    Exercise(id:'core_math_ce2_l1',lessonId:'core_math_ce2_length',question:'How many centimetres are in 1 metre?',options:['10','100','1,000'],correctIndex:1,explanation:'1 m = 100 cm.'),
    Exercise(id:'core_math_ce2_l2',lessonId:'core_math_ce2_length',question:'Which unit is suitable for a pencil?',options:['Centimetre','Kilometre','Hectare'],correctIndex:0,explanation:'Le centimètre convient à un petit objet.'),
    Exercise(id:'core_math_ce2_l3',lessonId:'core_math_ce2_length',question:'A ribbon is 50 cm long. How much more to make 1 m?',options:['25 cm','50 cm','100 cm'],correctIndex:1,explanation:'100 − 50 = 50 cm.'),
  ]),
  AnnualMathUnit(level:SchoolLevel.cm1,code:'cm1',unitOrder:1,title:'Fractions',lessonId:'core_math_cm1_fractions',lessonTitle:'Understand fractions',summary:'Représenter une fraction d’un tout partagé en parts égales.',content:'A fraction describes equal parts of a whole. In 3/4, the denominator 4 tells us there are four equal parts; the numerator 3 tells us three parts are selected. Fractions can be shown with a folded paper, a rectangle or a number line.',keyPoints:['Parts must be equal','Denominator = total equal parts','Numerator = selected parts'],exercises:[
    Exercise(id:'core_math_cm1_f1',lessonId:'core_math_cm1_fractions',question:'In 2/5, what does 5 show?',options:['Total equal parts','Selected parts','The whole number 5 only'],correctIndex:0,explanation:'Le dénominateur 5 indique cinq parts égales.'),
    Exercise(id:'core_math_cm1_f2',lessonId:'core_math_cm1_fractions',question:'What fraction is 3 parts out of 4 equal parts?',options:['3/4','4/3','1/4'],correctIndex:0,explanation:'Trois parts choisies sur quatre donnent 3/4.'),
    Exercise(id:'core_math_cm1_f3',lessonId:'core_math_cm1_fractions',question:'Which model can show a fraction?',options:['A rectangle divided into equal parts','A rectangle with random unequal parts','A list of names'],correctIndex:0,explanation:'Un rectangle partagé en parts égales représente une fraction.'),
  ]),
  AnnualMathUnit(level:SchoolLevel.cm1,code:'cm1',unitOrder:2,title:'Perimeter and area',lessonId:'core_math_cm1_measure',lessonTitle:'Perimeter and area of a rectangle',summary:'Calculer le périmètre et l’aire d’un rectangle.',content:'Perimeter is the total length around a shape. For a rectangle, P = 2 × (length + width). Area measures the surface inside. For a rectangle, A = length × width. Use the correct units: cm or m for perimeter, cm² or m² for area.',keyPoints:['Perimeter = distance around','P = 2 × (L + l)','Area = L × l','Area uses square units'],exercises:[
    Exercise(id:'core_math_cm1_m1',lessonId:'core_math_cm1_measure',question:'A rectangle is 5 cm by 3 cm. What is its perimeter?',options:['8 cm','15 cm','16 cm'],correctIndex:2,explanation:'P = 2 × (5 + 3) = 16 cm.'),
    Exercise(id:'core_math_cm1_m2',lessonId:'core_math_cm1_measure',question:'What is the area of a 5 cm × 3 cm rectangle?',options:['8 cm²','15 cm²','16 cm²'],correctIndex:1,explanation:'A = 5 × 3 = 15 cm².'),
    Exercise(id:'core_math_cm1_m3',lessonId:'core_math_cm1_measure',question:'Which unit is suitable for area?',options:['cm²','cm only','litre'],correctIndex:0,explanation:'L’aire s’exprime en unités carrées.'),
  ]),
  AnnualMathUnit(level:SchoolLevel.cm2,code:'cm2',unitOrder:1,title:'Decimal numbers',lessonId:'core_math_cm2_decimals',lessonTitle:'Tenths and hundredths',summary:'Lire et comparer des nombres décimaux simples.',content:'A decimal number has a decimal point. In 3.4, 3 is the whole part and 4 represents four tenths. In 3.45, 4 is the tenths digit and 5 is the hundredths digit. Align decimal points when adding or comparing decimal numbers.',keyPoints:['3.4 = 3 + 4/10','The first digit after the point is tenths','Align decimal points'],exercises:[
    Exercise(id:'core_math_cm2_dec1',lessonId:'core_math_cm2_decimals',question:'In 2.7, what does 7 represent?',options:['7 tenths','7 hundreds','7 units'],correctIndex:0,explanation:'Le 7 est au rang des dixièmes.'),
    Exercise(id:'core_math_cm2_dec2',lessonId:'core_math_cm2_decimals',question:'Which number is greater?',options:['4.8','4.5','4.2'],correctIndex:0,explanation:'4.8 est supérieur à 4.5 et 4.2.'),
    Exercise(id:'core_math_cm2_dec3',lessonId:'core_math_cm2_decimals',question:'What is 1.2 + 0.3?',options:['1.5','1.23','2.5'],correctIndex:0,explanation:'1.2 + 0.3 = 1.5.'),
  ]),
  AnnualMathUnit(level:SchoolLevel.cm2,code:'cm2',unitOrder:2,title:'Proportional situations',lessonId:'core_math_cm2_proportion',lessonTitle:'Double and half',summary:'Résoudre des situations simples de double et moitié.',content:'If one item costs 100 CFA, two identical items cost 200 CFA. This is double. Half of 12 is 6 because 6 + 6 = 12. Use a table to organize quantities and prices when the relationship is proportional.',keyPoints:['Double = multiply by 2','Half = divide by 2','A simple table helps compare quantities'],exercises:[
    Exercise(id:'core_math_cm2_prop1',lessonId:'core_math_cm2_proportion',question:'What is double 35?',options:['60','70','75'],correctIndex:1,explanation:'Le double de 35 est 35 × 2 = 70.'),
    Exercise(id:'core_math_cm2_prop2',lessonId:'core_math_cm2_proportion',question:'What is half of 48?',options:['12','24','36'],correctIndex:1,explanation:'48 ÷ 2 = 24.'),
    Exercise(id:'core_math_cm2_prop3',lessonId:'core_math_cm2_proportion',question:'One notebook costs 150 CFA. Two cost…',options:['200 CFA','250 CFA','300 CFA'],correctIndex:2,explanation:'150 × 2 = 300 CFA.'),
  ]),

  AnnualMathUnit(level:SchoolLevel.cp1,code:'cp1',unitOrder:3,title:'Formes et positions',lessonId:'core_math_cp1_shapes',lessonTitle:'Reconnaître les formes et se repérer',summary:'Reconnaître les formes simples et décrire leur position.',content:'Observe les objets autour de toi. Un cercle est rond, un triangle possède trois côtés et un rectangle possède quatre côtés avec des angles droits. Pour se repérer, on utilise devant, derrière, à côté, au-dessus et en dessous. Dessine les formes puis nomme-les.',keyPoints:['Le triangle a 3 côtés','Le rectangle a 4 côtés et 4 angles droits','Utiliser des mots de position'],exercises:[
    Exercise(id:'core_math_cp1_sh1',lessonId:'core_math_cp1_shapes',question:'Combien de côtés a un triangle ?',options:['2','3','4'],correctIndex:1,explanation:'Un triangle possède trois côtés.'),
    Exercise(id:'core_math_cp1_sh2',lessonId:'core_math_cp1_shapes',question:'Quelle forme est ronde ?',options:['Le cercle','Le rectangle','Le triangle'],correctIndex:0,explanation:'Le cercle est une forme ronde.'),
    Exercise(id:'core_math_cp1_sh3',lessonId:'core_math_cp1_shapes',question:'Le livre est sur la table. Où est le livre ?',options:['Sous la table','Sur la table','Derrière la table'],correctIndex:1,explanation:'La phrase indique que le livre est sur la table.'),
  ]),
  AnnualMathUnit(level:SchoolLevel.cp2,code:'cp2',unitOrder:3,title:'Calendrier et monnaie',lessonId:'core_math_cp2_time_money',lessonTitle:'Lire le calendrier et compter l’argent',summary:'Lire les jours de la semaine et résoudre de petits achats.',content:'Une semaine compte sept jours. Le calendrier indique les jours, les dates et les mois. Pour compter de l’argent, additionne les valeurs des pièces ou billets. Si un article coûte 200 F et tu donnes 500 F, la monnaie rendue est 500 − 200 = 300 F.',keyPoints:['Une semaine compte 7 jours','Lire la date sur le calendrier','Monnaie rendue = somme donnée − prix'],exercises:[
    Exercise(id:'core_math_cp2_tm1',lessonId:'core_math_cp2_time_money',question:'Combien de jours compte une semaine ?',options:['5','7','10'],correctIndex:1,explanation:'Une semaine compte sept jours.'),
    Exercise(id:'core_math_cp2_tm2',lessonId:'core_math_cp2_time_money',question:'Un cahier coûte 200 F. Tu donnes 500 F. Quelle monnaie ?',options:['200 F','300 F','700 F'],correctIndex:1,explanation:'500 − 200 = 300 F.'),
    Exercise(id:'core_math_cp2_tm3',lessonId:'core_math_cp2_time_money',question:'Quel jour vient après mardi ?',options:['Lundi','Mercredi','Vendredi'],correctIndex:1,explanation:'Après mardi vient mercredi.'),
  ]),
  AnnualMathUnit(level:SchoolLevel.ce1,code:'ce1',unitOrder:3,title:'Tables et problèmes de multiplication',lessonId:'core_math_ce1_tables',lessonTitle:'Utiliser les tables pour résoudre un problème',summary:'Mobiliser les tables de multiplication dans des situations concrètes.',content:'Les tables de multiplication permettent de calculer rapidement des groupes égaux. Pour résoudre un problème, repère le nombre de groupes et le nombre d’objets par groupe. Écris l’opération, calcule puis vérifie si la réponse est raisonnable.',keyPoints:['Repérer les groupes égaux','Choisir la multiplication','Écrire une phrase réponse'],exercises:[
    Exercise(id:'core_math_ce1_t1',lessonId:'core_math_ce1_tables',question:'4 sachets contiennent 5 bonbons chacun. Combien de bonbons ?',options:['9','20','25'],correctIndex:1,explanation:'4 × 5 = 20 bonbons.'),
    Exercise(id:'core_math_ce1_t2',lessonId:'core_math_ce1_tables',question:'Quelle opération convient pour 6 rangées de 3 chaises ?',options:['6 × 3','6 − 3','6 ÷ 3'],correctIndex:0,explanation:'Six groupes de trois se calculent par 6 × 3.'),
    Exercise(id:'core_math_ce1_t3',lessonId:'core_math_ce1_tables',question:'8 × 4 = ?',options:['24','32','36'],correctIndex:1,explanation:'8 fois 4 donne 32.'),
  ]),
  AnnualMathUnit(level:SchoolLevel.ce2,code:'ce2',unitOrder:3,title:'Masse et capacité',lessonId:'core_math_ce2_mass_capacity',lessonTitle:'Mesurer la masse et la capacité',summary:'Choisir kilogramme, gramme, litre et millilitre.',content:'La masse indique la quantité de matière d’un objet. On utilise le kilogramme (kg) ou le gramme (g). La capacité indique la quantité de liquide qu’un récipient peut contenir : litre (L) et millilitre (mL). 1 kg = 1 000 g et 1 L = 1 000 mL.',keyPoints:['1 kg = 1 000 g','1 L = 1 000 mL','Choisir l’unité adaptée à l’objet'],exercises:[
    Exercise(id:'core_math_ce2_mc1',lessonId:'core_math_ce2_mass_capacity',question:'Quelle unité convient à la masse d’un sac de riz ?',options:['Kilogramme','Litre','Centimètre'],correctIndex:0,explanation:'Le kilogramme mesure la masse.'),
    Exercise(id:'core_math_ce2_mc2',lessonId:'core_math_ce2_mass_capacity',question:'1 litre correspond à…',options:['100 mL','1 000 mL','10 000 mL'],correctIndex:1,explanation:'1 L = 1 000 mL.'),
    Exercise(id:'core_math_ce2_mc3',lessonId:'core_math_ce2_mass_capacity',question:'2 kg correspondent à combien de grammes ?',options:['200 g','2 000 g','20 000 g'],correctIndex:1,explanation:'2 × 1 000 = 2 000 g.'),
  ]),
  AnnualMathUnit(level:SchoolLevel.cm1,code:'cm1',unitOrder:3,title:'Division et partage avec reste',lessonId:'core_math_cm1_division',lessonTitle:'Effectuer une division avec reste',summary:'Comprendre le quotient et le reste dans un partage.',content:'Lorsqu’on partage une quantité en groupes égaux, le quotient indique le nombre d’objets dans chaque groupe. Parfois, il reste des objets. Exemple : 17 ÷ 5 = 3 reste 2, car 5 × 3 = 15 et 17 − 15 = 2. Le reste doit être inférieur au diviseur.',keyPoints:['Dividende = diviseur × quotient + reste','Le reste est inférieur au diviseur','Vérifier la division par multiplication'],exercises:[
    Exercise(id:'core_math_cm1_dv1',lessonId:'core_math_cm1_division',question:'17 ÷ 5 = ?',options:['3 reste 2','2 reste 3','4 reste 1'],correctIndex:0,explanation:'5 × 3 = 15 et 17 − 15 = 2.'),
    Exercise(id:'core_math_cm1_dv2',lessonId:'core_math_cm1_division',question:'Quel est le reste de 23 ÷ 4 ?',options:['1','2','3'],correctIndex:2,explanation:'4 × 5 = 20 ; il reste 3.'),
    Exercise(id:'core_math_cm1_dv3',lessonId:'core_math_cm1_division',question:'Dans 29 ÷ 6 = 4 reste 5, quel nombre est le diviseur ?',options:['29','6','4'],correctIndex:1,explanation:'Le diviseur est le nombre par lequel on partage : 6.'),
  ]),
  AnnualMathUnit(level:SchoolLevel.cm2,code:'cm2',unitOrder:3,title:'Pourcentages simples et conversions',lessonId:'core_math_cm2_percent_units',lessonTitle:'Calculer un pourcentage simple et convertir',summary:'Comprendre 10 %, 25 %, 50 % et quelques conversions usuelles.',content:'Un pourcentage exprime une part sur 100. 50 % signifie la moitié, 25 % le quart et 10 % un dixième. Pour trouver 50 % de 80, calcule 80 ÷ 2 = 40. Pour convertir une longueur, rappelle-toi que 1 km = 1 000 m et 1 m = 100 cm.',keyPoints:['50 % = la moitié','25 % = le quart','10 % = un dixième','1 km = 1 000 m'],exercises:[
    Exercise(id:'core_math_cm2_pc1',lessonId:'core_math_cm2_percent_units',question:'50 % de 60 vaut…',options:['15','30','50'],correctIndex:1,explanation:'50 % représente la moitié : 60 ÷ 2 = 30.'),
    Exercise(id:'core_math_cm2_pc2',lessonId:'core_math_cm2_percent_units',question:'25 % de 40 vaut…',options:['10','20','25'],correctIndex:0,explanation:'25 % représente le quart : 40 ÷ 4 = 10.'),
    Exercise(id:'core_math_cm2_pc3',lessonId:'core_math_cm2_percent_units',question:'3 km correspondent à…',options:['300 m','3 000 m','30 000 m'],correctIndex:1,explanation:'3 × 1 000 = 3 000 m.'),
  ]),
]; 

final annualMathSubjects = SchoolLevel.values.take(6).map((level) {
  final code = switch (level) {
    SchoolLevel.cp1 => 'cp1',
    SchoolLevel.cp2 => 'cp2',
    SchoolLevel.ce1 => 'ce1',
    SchoolLevel.ce2 => 'ce2',
    SchoolLevel.cm1 => 'cm1',
    SchoolLevel.cm2 => 'cm2',
    _ => 'primary',
  };
  return Subject(id:'core_math_$code',name:'Mathématiques — cours de l’année',iconName:'calculator',colorHex:'006A4E',level:level,totalChapters:3);
}).toList();

final annualMathChapters = annualMathUnits.map((unit) => Chapter(
  id:unit.chapterId,subjectId:unit.subjectId,title:'Unité ${unit.unitOrder} — ${unit.title}',
  order:unit.unitOrder,term: termForAnnualUnit(unit.unitOrder, annualMathUnits.where((item) => item.code == unit.code).length),totalLessons:1,
)).toList();

final annualMathLessons = annualMathUnits.map((unit) => Lesson(
  id:unit.lessonId,chapterId:unit.chapterId,title:unit.lessonTitle,
  summary:unit.summary,content:unit.content,keyPoints:unit.keyPoints,durationMinutes:18,
)).toList();

final annualMathExercises = annualMathUnits.expand((unit)=>unit.exercises).toList();
