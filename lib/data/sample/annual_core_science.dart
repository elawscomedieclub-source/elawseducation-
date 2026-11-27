import '../models/models.dart';

class AnnualScienceUnit {
  final SchoolLevel level;
  final String code, title, lessonId, lessonTitle, summary, content;
  final int unitOrder;
  final List<String> keyPoints;
  final List<Exercise> exercises;
  const AnnualScienceUnit({
    required this.level, required this.code, required this.unitOrder,
    required this.title, required this.lessonId, required this.lessonTitle,
    required this.summary, required this.content, required this.keyPoints,
    required this.exercises,
  });
  String get subjectId => 'core_science_$code';
  String get chapterId => 'core_science_${code}_unit_${unitOrder}';
}

const annualScienceUnits = <AnnualScienceUnit>[
  AnnualScienceUnit(level: SchoolLevel.cp1, code: 'cp1', unitOrder: 1, title: 'Living and non-living things',
    lessonId: 'core_sc_cp1_living', lessonTitle: 'Living things around us',
    summary: 'Reconnaître quelques êtres vivants et objets non vivants.',
    content: 'A living thing needs food, water and air and can grow. People, animals and plants are living things. A stone, a chair and a pencil are non-living objects. Observe carefully and never harm living things.',
    keyPoints: ['People, animals and plants are living', 'A stone and a chair are non-living', 'Living things grow and need care'],
    exercises: [
      Exercise(id:'core_sc_cp1_l1',lessonId:'core_sc_cp1_living',question:'Which one is a living thing?',options:['A plant','A stone','A chair'],correctIndex:0,explanation:'Une plante est un être vivant.'),
      Exercise(id:'core_sc_cp1_l2',lessonId:'core_sc_cp1_living',question:'Which one is non-living?',options:['A goat','A tree','A pencil'],correctIndex:2,explanation:'Un crayon est un objet non vivant.'),
      Exercise(id:'core_sc_cp1_l3',lessonId:'core_sc_cp1_living',question:'What can a living thing do?',options:['Grow','Become a chair','Never need water'],correctIndex:0,explanation:'Les êtres vivants grandissent et ont des besoins.'),
    ]),
  AnnualScienceUnit(level: SchoolLevel.cp1, code: 'cp1', unitOrder: 2, title: 'Personal hygiene',
    lessonId: 'core_sc_cp1_hygiene', lessonTitle: 'Keeping my body clean',
    summary: 'Adopter des gestes simples d’hygiène au quotidien.',
    content: 'Wash your hands with clean water and soap before eating and after using the toilet. Brush your teeth every day. Keep your nails clean and wear clean clothes. If you feel sick, tell a trusted adult.',
    keyPoints: ['Wash hands with soap', 'Brush teeth daily', 'Tell an adult when you feel sick'],
    exercises: [
      Exercise(id:'core_sc_cp1_h1',lessonId:'core_sc_cp1_hygiene',question:'What should you use to wash your hands?',options:['Water and soap','Dust','Oil'],correctIndex:0,explanation:'L’eau et le savon aident à nettoyer les mains.'),
      Exercise(id:'core_sc_cp1_h2',lessonId:'core_sc_cp1_hygiene',question:'When should you wash your hands?',options:['Before eating','Never','Only once a month'],correctIndex:0,explanation:'Il faut se laver les mains avant de manger.'),
      Exercise(id:'core_sc_cp1_h3',lessonId:'core_sc_cp1_hygiene',question:'What helps keep teeth clean?',options:['Brushing','Eating sand','Never washing'],correctIndex:0,explanation:'Le brossage régulier aide à garder les dents propres.'),
    ]),
  AnnualScienceUnit(level: SchoolLevel.cp2, code: 'cp2', unitOrder: 1, title: 'Needs of plants and animals',
    lessonId: 'core_sc_cp2_needs', lessonTitle: 'What living things need',
    summary: 'Comparer les besoins essentiels des plantes et des animaux.',
    content: 'Plants need water, air, light and suitable soil to grow. Animals need water, food, air and shelter. Different living things have different needs. We must protect plants and animals in our environment.',
    keyPoints: ['Plants need water and light', 'Animals need food and water', 'Living things need a suitable environment'],
    exercises: [
      Exercise(id:'core_sc_cp2_n1',lessonId:'core_sc_cp2_needs',question:'What helps a green plant grow?',options:['Water and light','Plastic only','No air'],correctIndex:0,explanation:'L’eau et la lumière sont nécessaires à la croissance des plantes.'),
      Exercise(id:'core_sc_cp2_n2',lessonId:'core_sc_cp2_needs',question:'What does an animal need?',options:['Food and water','Only a stone','No air'],correctIndex:0,explanation:'Les animaux ont besoin de nourriture et d’eau.'),
      Exercise(id:'core_sc_cp2_n3',lessonId:'core_sc_cp2_needs',question:'How should we treat living things?',options:['Protect them','Destroy them','Waste their water'],correctIndex:0,explanation:'Il faut protéger les êtres vivants.'),
    ]),
  AnnualScienceUnit(level: SchoolLevel.cp2, code: 'cp2', unitOrder: 2, title: 'Clean water',
    lessonId: 'core_sc_cp2_water', lessonTitle: 'Water and cleanliness',
    summary: 'Comprendre l’importance de l’eau propre et éviter de la polluer.',
    content: 'We use water for drinking, cooking, washing and watering plants. Drinking water must be safe. Keep wells and water containers clean, cover stored water and never throw rubbish into rivers or wells. If water is unsafe, ask an adult how to treat it.',
    keyPoints: ['Water is needed every day', 'Keep drinking water covered and clean', 'Do not pollute rivers or wells'],
    exercises: [
      Exercise(id:'core_sc_cp2_w1',lessonId:'core_sc_cp2_water',question:'Why do we need water?',options:['To drink and wash','To make rubbish','To pollute wells'],correctIndex:0,explanation:'L’eau sert notamment à boire et à se laver.'),
      Exercise(id:'core_sc_cp2_w2',lessonId:'core_sc_cp2_water',question:'How should stored drinking water be kept?',options:['In a clean covered container','Open beside rubbish','In a dirty bucket'],correctIndex:0,explanation:'Un récipient propre et couvert protège l’eau.'),
      Exercise(id:'core_sc_cp2_w3',lessonId:'core_sc_cp2_water',question:'What should we never throw into a well?',options:['Rubbish','Clean water','A clean cover'],correctIndex:0,explanation:'Les déchets peuvent contaminer l’eau.'),
    ]),
  AnnualScienceUnit(level: SchoolLevel.ce1, code: 'ce1', unitOrder: 1, title: 'Parts of a plant',
    lessonId: 'core_sc_ce1_plant', lessonTitle: 'Discovering a plant',
    summary: 'Identifier les principales parties d’une plante.',
    content: 'A common flowering plant has roots, a stem, leaves and sometimes flowers, fruits and seeds. Roots hold the plant and take up water. The stem supports the plant. Leaves help the plant make its food using sunlight.',
    keyPoints: ['Roots take up water and hold the plant', 'The stem supports the plant', 'Leaves use sunlight to make food'],
    exercises: [
      Exercise(id:'core_sc_ce1_p1',lessonId:'core_sc_ce1_plant',question:'Which part takes up water from the soil?',options:['Roots','Flower','Fruit'],correctIndex:0,explanation:'Les racines absorbent l’eau du sol.'),
      Exercise(id:'core_sc_ce1_p2',lessonId:'core_sc_ce1_plant',question:'Which part supports the plant?',options:['Stem','Seed','Petal only'],correctIndex:0,explanation:'La tige soutient la plante.'),
      Exercise(id:'core_sc_ce1_p3',lessonId:'core_sc_ce1_plant',question:'Which part uses sunlight to make food?',options:['Leaves','Roots only','Fruit only'],correctIndex:0,explanation:'Les feuilles participent à la fabrication de la nourriture de la plante.'),
    ]),
  AnnualScienceUnit(level: SchoolLevel.ce1, code: 'ce1', unitOrder: 2, title: 'The five senses',
    lessonId: 'core_sc_ce1_senses', lessonTitle: 'My senses',
    summary: 'Relier les cinq sens aux organes correspondants.',
    content: 'We use our eyes to see, ears to hear, nose to smell, tongue to taste and skin to feel touch. The senses help us learn about our surroundings. Protect your senses: avoid loud sounds and never put dangerous objects in your eyes or ears.',
    keyPoints: ['Eyes: sight', 'Ears: hearing', 'Nose: smell', 'Tongue: taste', 'Skin: touch'],
    exercises: [
      Exercise(id:'core_sc_ce1_s1',lessonId:'core_sc_ce1_senses',question:'Which organ helps you hear?',options:['Ears','Eyes','Nose'],correctIndex:0,explanation:'Les oreilles permettent d’entendre.'),
      Exercise(id:'core_sc_ce1_s2',lessonId:'core_sc_ce1_senses',question:'Which sense uses the nose?',options:['Smell','Sight','Hearing'],correctIndex:0,explanation:'Le nez sert à sentir les odeurs.'),
      Exercise(id:'core_sc_ce1_s3',lessonId:'core_sc_ce1_senses',question:'Which organ feels touch?',options:['Skin','Tongue','Ears'],correctIndex:0,explanation:'La peau permet de sentir le toucher.'),
    ]),
  AnnualScienceUnit(level: SchoolLevel.ce2, code: 'ce2', unitOrder: 1, title: 'States of water',
    lessonId: 'core_sc_ce2_states', lessonTitle: 'Water can change state',
    summary: 'Observer l’eau liquide, la glace et la vapeur.',
    content: 'Water can be liquid, solid or gas. Ice is solid water. Liquid water flows. When water is heated, some of it changes into water vapour. When vapour cools, it can form tiny drops. Handle hot water only with an adult.',
    keyPoints: ['Ice is solid water', 'Liquid water flows', 'Heating can produce water vapour', 'Hot water needs adult supervision'],
    exercises: [
      Exercise(id:'core_sc_ce2_st1',lessonId:'core_sc_ce2_states',question:'What state is ice?',options:['Solid','Liquid','Gas'],correctIndex:0,explanation:'La glace est de l’eau à l’état solide.'),
      Exercise(id:'core_sc_ce2_st2',lessonId:'core_sc_ce2_states',question:'What can happen when water is heated?',options:['It can become vapour','It becomes wood','It disappears forever'],correctIndex:0,explanation:'Le chauffage peut transformer l’eau liquide en vapeur.'),
      Exercise(id:'core_sc_ce2_st3',lessonId:'core_sc_ce2_states',question:'Who should help with hot water?',options:['An adult','A small child alone','Nobody'],correctIndex:0,explanation:'L’eau chaude peut brûler : un adulte doit aider.'),
    ]),
  AnnualScienceUnit(level: SchoolLevel.ce2, code: 'ce2', unitOrder: 2, title: 'Materials and objects',
    lessonId: 'core_sc_ce2_materials', lessonTitle: 'What are objects made of?',
    summary: 'Reconnaître quelques matériaux et leurs propriétés.',
    content: 'Objects are made from materials such as wood, metal, plastic, glass, paper and fabric. Materials have properties: some are hard, soft, flexible, transparent or waterproof. Choose and reuse materials carefully and safely.',
    keyPoints: ['Wood, metal, plastic, glass, paper and fabric are materials', 'Materials have different properties', 'Reuse materials when possible'],
    exercises: [
      Exercise(id:'core_sc_ce2_m1',lessonId:'core_sc_ce2_materials',question:'Which material can be transparent?',options:['Glass','Cotton cloth only','Soil'],correctIndex:0,explanation:'Le verre peut être transparent.'),
      Exercise(id:'core_sc_ce2_m2',lessonId:'core_sc_ce2_materials',question:'Which material is often flexible?',options:['Fabric','A stone block','A thick metal bar'],correctIndex:0,explanation:'Le tissu est souvent souple.'),
      Exercise(id:'core_sc_ce2_m3',lessonId:'core_sc_ce2_materials',question:'What is a good way to use materials?',options:['Reuse when suitable','Throw everything in water','Burn plastic anywhere'],correctIndex:0,explanation:'Réutiliser les matériaux adaptés réduit les déchets.'),
    ]),
  AnnualScienceUnit(level: SchoolLevel.cm1, code: 'cm1', unitOrder: 1, title: 'The water cycle',
    lessonId: 'core_sc_cm1_cycle', lessonTitle: 'The water cycle',
    summary: 'Comprendre les principales étapes du cycle de l’eau.',
    content: 'The Sun heats water in rivers, lakes and the sea. Some water evaporates and rises as vapour. Vapour cools and forms clouds by condensation. Water returns to Earth as rain. It flows into rivers and can collect again in lakes and the sea.',
    keyPoints: ['Evaporation: liquid water becomes vapour', 'Condensation: vapour forms tiny drops', 'Precipitation: water falls as rain'],
    exercises: [
      Exercise(id:'core_sc_cm1_c1',lessonId:'core_sc_cm1_cycle',question:'What provides energy for evaporation?',options:['The Sun','A stone','A book'],correctIndex:0,explanation:'Le Soleil chauffe l’eau et favorise l’évaporation.'),
      Exercise(id:'core_sc_cm1_c2',lessonId:'core_sc_cm1_cycle',question:'What is condensation?',options:['Vapour forms tiny drops','Rain enters the soil only','Ice becomes wood'],correctIndex:0,explanation:'La condensation forme de petites gouttes à partir de la vapeur refroidie.'),
      Exercise(id:'core_sc_cm1_c3',lessonId:'core_sc_cm1_cycle',question:'What is precipitation?',options:['Rain or other water falling','Water being written','A plant growing'],correctIndex:0,explanation:'La précipitation est la chute de l’eau depuis les nuages.'),
    ]),
  AnnualScienceUnit(level: SchoolLevel.cm1, code: 'cm1', unitOrder: 2, title: 'Food chains',
    lessonId: 'core_sc_cm1_foodchain', lessonTitle: 'Who eats whom?',
    summary: 'Construire une chaîne alimentaire simple.',
    content: 'A food chain shows how living things get food. Green plants make their own food and are producers. A grasshopper may eat grass; a bird may eat the grasshopper. Arrows show the direction from food to the animal that eats it.',
    keyPoints: ['Plants are producers', 'Animals get energy by eating plants or other animals', 'Arrows point from food to eater'],
    exercises: [
      Exercise(id:'core_sc_cm1_fc1',lessonId:'core_sc_cm1_foodchain',question:'Which living thing is a producer?',options:['Green plant','Grasshopper','Bird'],correctIndex:0,explanation:'Les plantes vertes produisent leur propre nourriture.'),
      Exercise(id:'core_sc_cm1_fc2',lessonId:'core_sc_cm1_foodchain',question:'In grass → grasshopper → bird, what eats grass?',options:['Grasshopper','Bird','Grass'],correctIndex:0,explanation:'La sauterelle mange l’herbe.'),
      Exercise(id:'core_sc_cm1_fc3',lessonId:'core_sc_cm1_foodchain',question:'What do arrows in a food chain show?',options:['Direction from food to eater','The colour of animals','The size of a plant'],correctIndex:0,explanation:'Les flèches indiquent le transfert de nourriture et d’énergie.'),
    ]),
  AnnualScienceUnit(level: SchoolLevel.cm2, code: 'cm2', unitOrder: 1, title: 'Simple electric circuits',
    lessonId: 'core_sc_cm2_circuit', lessonTitle: 'A simple electric circuit',
    summary: 'Identifier les éléments d’un circuit simple et distinguer circuit ouvert et fermé.',
    content: 'A simple circuit can contain a cell, wires and a lamp. The lamp lights when the circuit is closed and the connections are correct. If a wire is disconnected, the circuit is open and the lamp does not light. Use only safe classroom batteries; never experiment with mains electricity.',
    keyPoints: ['A cell supplies electrical energy', 'A closed circuit can light the lamp', 'An open circuit stops the current', 'Never touch mains electricity'],
    exercises: [
      Exercise(id:'core_sc_cm2_el1',lessonId:'core_sc_cm2_circuit',question:'When can a lamp light in a simple circuit?',options:['When the circuit is closed','When a wire is disconnected','Without a cell or source'],correctIndex:0,explanation:'Un circuit fermé et correctement connecté permet à la lampe de s’allumer.'),
      Exercise(id:'core_sc_cm2_el2',lessonId:'core_sc_cm2_circuit',question:'What happens when a wire is disconnected?',options:['The circuit is open','The circuit becomes a plant','The lamp must always light'],correctIndex:0,explanation:'Une connexion interrompue ouvre le circuit.'),
      Exercise(id:'core_sc_cm2_el3',lessonId:'core_sc_cm2_circuit',question:'Which electricity source must pupils never touch?',options:['Mains electricity','A classroom drawing','A paper diagram'],correctIndex:0,explanation:'Il ne faut jamais manipuler le courant du secteur.'),
    ]),
  AnnualScienceUnit(level: SchoolLevel.cm2, code: 'cm2', unitOrder: 2, title: 'Energy and renewable sources',
    lessonId: 'core_sc_cm2_energy', lessonTitle: 'Energy around us',
    summary: 'Identifier quelques sources d’énergie et des usages responsables.',
    content: 'Energy helps us move, cook, light rooms and operate machines. Sources include the Sun, wind, flowing water, fuels and batteries. Solar and wind energy are renewable. Save energy by switching off lights when they are not needed and using equipment safely.',
    keyPoints: ['Energy is used for light, heat and movement', 'Sun and wind are renewable sources', 'Save energy and use equipment safely'],
    exercises: [
      Exercise(id:'core_sc_cm2_en1',lessonId:'core_sc_cm2_energy',question:'Which source is renewable?',options:['Sunlight','A single-use battery after it is empty','A limited fuel deposit'],correctIndex:0,explanation:'L’énergie solaire est une source renouvelable.'),
      Exercise(id:'core_sc_cm2_en2',lessonId:'core_sc_cm2_energy',question:'What is a responsible energy habit?',options:['Switch off unused lights','Leave every lamp on','Damage electrical devices'],correctIndex:0,explanation:'Éteindre les lumières inutilisées permet d’économiser l’énergie.'),
      Exercise(id:'core_sc_cm2_en3',lessonId:'core_sc_cm2_energy',question:'What can energy help produce?',options:['Light and movement','Only paper','Nothing useful'],correctIndex:0,explanation:'L’énergie permet notamment l’éclairage et le mouvement.'),
    ]),
];

final annualScienceSubjects = SchoolLevel.values.take(6).map((level) {
  final code = switch (level) {
    SchoolLevel.cp1 => 'cp1',
    SchoolLevel.cp2 => 'cp2',
    SchoolLevel.ce1 => 'ce1',
    SchoolLevel.ce2 => 'ce2',
    SchoolLevel.cm1 => 'cm1',
    SchoolLevel.cm2 => 'cm2',
    _ => 'primary',
  };
  return Subject(
    id: 'core_science_$code', name: 'Sciences et Technologie',
    iconName: 'science', colorHex: '006A4E', level: level, totalChapters: 2,
  );
}).toList();

final annualScienceChapters = annualScienceUnits.map((unit) => Chapter(
  id: unit.chapterId, subjectId: unit.subjectId,
  title: 'Unité ${unit.unitOrder} — ${unit.title}',
  order: unit.unitOrder, term: termForAnnualUnit(unit.unitOrder, annualScienceUnits.where((item) => item.code == unit.code).length), totalLessons: 1,
)).toList();

final annualScienceLessons = annualScienceUnits.map((unit) => Lesson(
  id: unit.lessonId, chapterId: unit.chapterId, title: unit.lessonTitle,
  summary: unit.summary, content: unit.content, keyPoints: unit.keyPoints,
  durationMinutes: 18,
)).toList();

final annualScienceExercises = annualScienceUnits.expand((unit) => unit.exercises).toList();
