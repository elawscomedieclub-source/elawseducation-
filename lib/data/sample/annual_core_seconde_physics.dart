import '../models/models.dart';

class AnnualSecondePhysicsUnit {
  final int unitOrder;
  final String code;
  final String title, lessonId, lessonTitle, summary, content;
  final List<String> keyPoints;
  final List<Exercise> exercises;
  const AnnualSecondePhysicsUnit({
    this.code = 'a4',
    required this.unitOrder, required this.title, required this.lessonId,
    required this.lessonTitle, required this.summary, required this.content,
    required this.keyPoints, required this.exercises,
  });
  String get subjectId => code == 'a4' ? 'core_pc_seconde' : 'core_pc_seconde_cd';
  String get chapterId => code == 'a4' ? 'core_pc_seconde_unit_$unitOrder' : 'core_pc_seconde_cd_unit_$unitOrder';
}

const annualSecondePhysicsUnits = <AnnualSecondePhysicsUnit>[
  AnnualSecondePhysicsUnit(unitOrder:1,title:'Courant électrique continu',lessonId:'core_pc_2nde_current',lessonTitle:'Étudier un circuit en courant continu',summary:'Identifier générateur, récepteur et sens conventionnel du courant.',content:'Un circuit électrique simple comporte un générateur, des conducteurs et un récepteur. Le courant circule lorsque le circuit est fermé. Dans le circuit extérieur, le sens conventionnel du courant va de la borne positive vers la borne négative du générateur. L’intensité se mesure avec un ampèremètre placé en série et s’exprime en ampères (A). Les expériences scolaires se font avec une alimentation basse tension et sous supervision.',keyPoints:['Circuit fermé pour faire circuler le courant','Sens conventionnel : + vers − dans le circuit extérieur','Ampèremètre en série, unité A','Ne jamais manipuler le secteur'],exercises:[
    Exercise(id:'core_pc_2nde_c1',lessonId:'core_pc_2nde_current',question:'Quand le courant peut-il circuler dans un circuit simple ?',options:['Quand le circuit est fermé','Quand le fil est coupé','Quand le générateur est retiré'],correctIndex:0,explanation:'Le circuit doit être fermé pour permettre le passage du courant.'),
    Exercise(id:'core_pc_2nde_c2',lessonId:'core_pc_2nde_current',question:'Comment branche-t-on l’ampèremètre ?',options:['En série','En dérivation','En dehors du circuit'],correctIndex:0,explanation:'L’ampèremètre se place en série pour mesurer l’intensité.'),
    Exercise(id:'core_pc_2nde_c3',lessonId:'core_pc_2nde_current',question:'Dans le circuit extérieur, le sens conventionnel va…',options:['De la borne + vers la borne −','De la borne − vers la borne +','Dans aucun sens'],correctIndex:0,explanation:'Le sens conventionnel est défini de la borne positive vers la borne négative.'),
  ]),
  AnnualSecondePhysicsUnit(unitOrder:2,title:'Tension électrique',lessonId:'core_pc_2nde_voltage',lessonTitle:'Mesurer la tension d’un dipôle',summary:'Utiliser le voltmètre et comprendre la tension électrique.',content:'La tension électrique entre deux points représente une différence de potentiel électrique. Elle se mesure avec un voltmètre branché en dérivation aux bornes du dipôle et s’exprime en volts (V). Dans un circuit en série, la tension du générateur se répartit entre les récepteurs ; dans une branche en dérivation, les dipôles ont la même tension aux bornes. Vérifie toujours le calibre et la sécurité avant une mesure.',keyPoints:['Tension : volt (V)','Voltmètre en dérivation','En dérivation, la tension est identique aux bornes des branches'],exercises:[
    Exercise(id:'core_pc_2nde_v1',lessonId:'core_pc_2nde_voltage',question:'Comment branche-t-on un voltmètre ?',options:['En dérivation','En série obligatoirement','Sans connecter les bornes'],correctIndex:0,explanation:'Le voltmètre se branche en dérivation aux bornes du dipôle.'),
    Exercise(id:'core_pc_2nde_v2',lessonId:'core_pc_2nde_voltage',question:'Quelle est l’unité de la tension ?',options:['Volt','Ampère','Newton'],correctIndex:0,explanation:'La tension se mesure en volts.'),
    Exercise(id:'core_pc_2nde_v3',lessonId:'core_pc_2nde_voltage',question:'Dans un circuit en dérivation, les branches ont…',options:['La même tension','Toujours des tensions nulles','Une tension impossible à mesurer'],correctIndex:0,explanation:'Les dipôles en dérivation sont reliés aux mêmes deux points.'),
  ]),
  AnnualSecondePhysicsUnit(unitOrder:3,title:'Élément chimique et structure de l’atome',lessonId:'core_pc_2nde_atom',lessonTitle:'Décrire un atome et identifier un élément',summary:'Utiliser le numéro atomique et le nombre de masse.',content:'Un atome comprend un noyau contenant des protons et des neutrons, entouré d’électrons. Le numéro atomique Z correspond au nombre de protons. Le nombre de masse A correspond au nombre total de protons et de neutrons : A = Z + N. Un atome neutre possède autant d’électrons que de protons. Les atomes d’un même élément ont le même Z.',keyPoints:['Z = nombre de protons','A = Z + N','Atome neutre : électrons = protons','Un élément est défini par son numéro atomique Z'],exercises:[
    Exercise(id:'core_pc_2nde_at1',lessonId:'core_pc_2nde_atom',question:'Le numéro atomique Z indique…',options:['Le nombre de protons','Le nombre de neutrons seulement','Le nombre de molécules'],correctIndex:0,explanation:'Z est le nombre de protons du noyau.'),
    Exercise(id:'core_pc_2nde_at2',lessonId:'core_pc_2nde_atom',question:'Un atome neutre de Z = 8 possède…',options:['8 électrons','16 électrons','0 électron'],correctIndex:0,explanation:'Dans un atome neutre, le nombre d’électrons égale le nombre de protons.'),
    Exercise(id:'core_pc_2nde_at3',lessonId:'core_pc_2nde_atom',question:'Si A = 23 et Z = 11, le nombre de neutrons N vaut…',options:['12','11','34'],correctIndex:0,explanation:'N = A − Z = 23 − 11 = 12.'),
  ]),
  AnnualSecondePhysicsUnit(unitOrder:4,title:'Ions et molécules',lessonId:'core_pc_2nde_ions',lessonTitle:'Distinguer atome, ion et molécule',summary:'Comprendre la formation des ions et la composition des molécules.',content:'Un atome qui perd des électrons devient un ion positif appelé cation. Un atome qui gagne des électrons devient un ion négatif appelé anion. Une molécule est un assemblage d’atomes liés ; elle peut être constituée d’atomes identiques ou différents. La formule chimique indique les éléments présents et le nombre de leurs atomes. La charge d’un ion dépend du nombre d’électrons perdus ou gagnés.',keyPoints:['Perte d’électrons : cation positif','Gain d’électrons : anion négatif','Une molécule contient plusieurs atomes liés','Lire les indices dans une formule chimique'],exercises:[
    Exercise(id:'core_pc_2nde_io1',lessonId:'core_pc_2nde_ions',question:'Un atome qui perd un électron devient…',options:['Un ion positif','Un ion négatif','Un neutron'],correctIndex:0,explanation:'La perte d’une charge négative rend l’ion positif.'),
    Exercise(id:'core_pc_2nde_io2',lessonId:'core_pc_2nde_ions',question:'Quel est le nom d’un ion négatif ?',options:['Anion','Cation','Noyau'],correctIndex:0,explanation:'Un anion porte une charge négative.'),
    Exercise(id:'core_pc_2nde_io3',lessonId:'core_pc_2nde_ions',question:'Dans H₂O, combien d’atomes d’hydrogène ?',options:['2','1','3'],correctIndex:0,explanation:'L’indice 2 indique deux atomes d’hydrogène.'),
  ]),
  AnnualSecondePhysicsUnit(unitOrder:5,title:'La mole et les grandeurs molaires',lessonId:'core_pc_2nde_mole',lessonTitle:'Compter les particules avec la mole',summary:'Relier quantité de matière, nombre de particules et masse molaire.',content:'La mole est une unité de quantité de matière. Une mole contient environ 6,02 × 10²³ entités : c’est la constante d’Avogadro Nₐ. La relation entre le nombre d’entités N et la quantité de matière n est N = n × Nₐ. La masse molaire M est la masse d’une mole d’entités, exprimée en g/mol. Pour un échantillon, n = m/M.',keyPoints:['1 mol contient Nₐ ≈ 6,02 × 10²³ entités','N = n × Nₐ','n = m/M','M s’exprime en g/mol'],exercises:[
    Exercise(id:'core_pc_2nde_m1',lessonId:'core_pc_2nde_mole',question:'Combien d’entités contient 1 mole ?',options:['Environ 6,02 × 10²³','100','1 000'],correctIndex:0,explanation:'La constante d’Avogadro vaut environ 6,02 × 10²³ mol⁻¹.'),
    Exercise(id:'core_pc_2nde_m2',lessonId:'core_pc_2nde_mole',question:'Quelle relation permet de calculer n à partir de m et M ?',options:['n = m/M','n = m × M','n = M/m'],correctIndex:0,explanation:'La quantité de matière est la masse divisée par la masse molaire.'),
    Exercise(id:'core_pc_2nde_m3',lessonId:'core_pc_2nde_mole',question:'Quelle unité convient à la masse molaire ?',options:['g/mol','mol/g','m/s'],correctIndex:0,explanation:'La masse molaire s’exprime en grammes par mole.'),
  ]),
  AnnualSecondePhysicsUnit(unitOrder:6,title:'Équation-bilan d’une réaction chimique',lessonId:'core_pc_2nde_equation',lessonTitle:'Équilibrer une équation chimique',summary:'Respecter la conservation des atomes lors d’une transformation chimique.',content:'Une réaction chimique transforme des réactifs en produits. Les atomes se réorganisent mais se conservent : le nombre d’atomes de chaque élément doit être identique des deux côtés de l’équation. Pour équilibrer, on modifie les coefficients placés devant les formules, jamais les indices dans les formules. Vérifie chaque élément séparément.',keyPoints:['Les atomes se conservent','Modifier les coefficients, pas les indices','Compter chaque élément des deux côtés'],exercises:[
    Exercise(id:'core_pc_2nde_eq1',lessonId:'core_pc_2nde_equation',question:'Pour équilibrer une équation, on modifie…',options:['Les coefficients','Les indices des formules','Les symboles chimiques'],correctIndex:0,explanation:'Les coefficients changent les quantités sans modifier les espèces chimiques.'),
    Exercise(id:'core_pc_2nde_eq2',lessonId:'core_pc_2nde_equation',question:'Dans 2H₂ + O₂ → 2H₂O, combien d’atomes d’oxygène de chaque côté ?',options:['2 et 2','1 et 2','2 et 1'],correctIndex:0,explanation:'O₂ contient 2 O ; 2H₂O contient aussi 2 O.'),
    Exercise(id:'core_pc_2nde_eq3',lessonId:'core_pc_2nde_equation',question:'Pourquoi conserve-t-on les indices dans les formules ?',options:['Ils définissent l’espèce chimique','Ils sont décoratifs','Ils n’ont aucune signification'],correctIndex:0,explanation:'Changer un indice changerait la formule et l’identité de l’espèce.'),
  ]),
  AnnualSecondePhysicsUnit(unitOrder:7,title:'Chlorure de sodium et dissolution',lessonId:'core_pc_2nde_salt',lessonTitle:'Comprendre le sel et sa dissolution dans l’eau',summary:'Décrire le chlorure de sodium comme solide ionique et sa dissociation en solution.',content:'Le chlorure de sodium NaCl est un solide ionique constitué d’ions Na⁺ et Cl⁻ organisés dans un réseau. Dans l’eau, le réseau se dissocie : les ions se dispersent dans la solution. Une solution contenant des ions peut conduire le courant électrique. La dissolution ne fait pas disparaître la matière : la masse totale se conserve dans un système fermé. Ne goûte jamais une solution utilisée en expérience.',keyPoints:['NaCl est un solide ionique','En solution, les ions se dispersent','Une solution ionique peut conduire le courant','Ne jamais goûter les produits de laboratoire'],exercises:[
    Exercise(id:'core_pc_2nde_sa1',lessonId:'core_pc_2nde_salt',question:'Quels ions composent le chlorure de sodium ?',options:['Na⁺ et Cl⁻','H⁺ et O²⁻','Ca²⁺ et O²⁻'],correctIndex:0,explanation:'Le chlorure de sodium est constitué d’ions sodium et chlorure.'),
    Exercise(id:'core_pc_2nde_sa2',lessonId:'core_pc_2nde_salt',question:'Pourquoi une solution de NaCl conduit-elle le courant ?',options:['Parce qu’elle contient des ions mobiles','Parce qu’elle contient seulement des molécules neutres','Parce que le sel disparaît'],correctIndex:0,explanation:'Les ions mobiles transportent les charges électriques dans la solution.'),
    Exercise(id:'core_pc_2nde_sa3',lessonId:'core_pc_2nde_salt',question:'Lors d’une dissolution dans un système fermé, la masse totale…',options:['Se conserve','Disparaît','Double automatiquement'],correctIndex:0,explanation:'La matière se conserve dans un système fermé.'),
  ]),
  AnnualSecondePhysicsUnit(unitOrder:8,title:'Qualité de l’eau',lessonId:'core_pc_2nde_water_quality',lessonTitle:'Comprendre les critères de qualité de l’eau',summary:'Distinguer eau limpide et eau potable et connaître quelques indicateurs.',content:'La qualité de l’eau dépend de ses caractéristiques physiques, chimiques et microbiologiques. Une eau limpide n’est pas nécessairement potable. Le pH indique si une solution est acide, neutre ou basique ; à température ambiante, pH 7 est neutre. La dureté dépend notamment de certains ions dissous. La potabilité exige des contrôles et des traitements adaptés. Ne goûte jamais une eau ou un produit utilisé en laboratoire pour vérifier sa qualité.',keyPoints:['Limpidité ne garantit pas la potabilité','pH < 7 acide ; pH = 7 neutre ; pH > 7 basique','La potabilité nécessite des contrôles','Ne jamais goûter une eau de laboratoire'],exercises:[
    Exercise(id:'core_pc_2nde_wq1',lessonId:'core_pc_2nde_water_quality',question:'Une eau limpide est-elle forcément potable ?',options:['Non, elle peut contenir des microbes ou substances invisibles','Oui, toujours','Seulement si elle est froide'],correctIndex:0,explanation:'La transparence ne garantit pas la qualité chimique ou microbiologique.'),
    Exercise(id:'core_pc_2nde_wq2',lessonId:'core_pc_2nde_water_quality',question:'À température ambiante, un pH de 7 est…',options:['Neutre','Acide','Fortement basique'],correctIndex:0,explanation:'Un pH égal à 7 correspond à une solution neutre à température ambiante.'),
    Exercise(id:'core_pc_2nde_wq3',lessonId:'core_pc_2nde_water_quality',question:'Comment vérifier la potabilité ?',options:['Par des contrôles adaptés et un traitement sûr','En goûtant l’eau','En regardant seulement sa couleur'],correctIndex:0,explanation:'La potabilité nécessite des analyses et des normes, pas une simple observation.'),
  ]),
];

final annualSecondeCdPhysicsUnits = annualSecondePhysicsUnits.map((unit) {
  final lessonId = unit.lessonId.replaceFirst('core_pc_2nde_', 'core_pc_2nde_cd_');
  return AnnualSecondePhysicsUnit(
    code:'cd',unitOrder:unit.unitOrder,title:unit.title,lessonId:lessonId,
    lessonTitle:unit.lessonTitle,summary:unit.summary,content:unit.content,
    keyPoints:unit.keyPoints,
    exercises:unit.exercises.map((exercise) => Exercise(
      id:exercise.id.replaceFirst('core_pc_2nde_', 'core_pc_2nde_cd_'),
      lessonId:lessonId,question:exercise.question,options:exercise.options,
      correctIndex:exercise.correctIndex,explanation:exercise.explanation,
    )).toList(),
  );
}).toList();


final annualSecondePhysicsSubject = Subject(
  id:'core_pc_seconde',name:'Physique-Chimie — cours de l’année',
  iconName:'science',colorHex:'006A4E',level:SchoolLevel.seconde,
  track:SchoolTrack.generalLiterary,series:'A4',totalChapters:8,
);

final annualSecondeCdPhysicsSubject = Subject(
  id:'core_pc_seconde_cd',name:'Physique-Chimie — Seconde C & D',
  iconName:'science',colorHex:'006A4E',level:SchoolLevel.seconde,
  track:SchoolTrack.scientific,totalChapters:8,
);

final annualSecondePhysicsChapters = annualSecondePhysicsUnits.map((unit) => Chapter(
  id:unit.chapterId,subjectId:unit.subjectId,title:'Unité ${unit.unitOrder} — ${unit.title}',
  order:unit.unitOrder,term:unit.unitOrder,totalLessons:1,
)).toList();

final annualSecondePhysicsLessons = annualSecondePhysicsUnits.map((unit) => Lesson(
  id:unit.lessonId,chapterId:unit.chapterId,title:unit.lessonTitle,
  summary:unit.summary,content:unit.content,keyPoints:unit.keyPoints,durationMinutes:25,
)).toList();

final annualSecondePhysicsExercises = annualSecondePhysicsUnits.expand((unit)=>unit.exercises).toList();

final annualSecondeCdPhysicsChapters = annualSecondeCdPhysicsUnits.map((unit) => Chapter(
  id:unit.chapterId,subjectId:unit.subjectId,title:'Unité ${unit.unitOrder} — ${unit.title}',
  order:unit.unitOrder,term:unit.unitOrder,totalLessons:1,
)).toList();

final annualSecondeCdPhysicsLessons = annualSecondeCdPhysicsUnits.map((unit) => Lesson(
  id:unit.lessonId,chapterId:unit.chapterId,title:unit.lessonTitle,
  summary:unit.summary,content:unit.content,keyPoints:unit.keyPoints,durationMinutes:25,
)).toList();

final annualSecondeCdPhysicsExercises = annualSecondeCdPhysicsUnits.expand((unit)=>unit.exercises).toList();
