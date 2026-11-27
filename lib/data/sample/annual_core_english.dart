import '../models/models.dart';

/// Cours d'anglais intégrés au programme principal du primaire.
/// Progression originale de ProfTogo, à rapprocher des manuels en vigueur.
class AnnualEnglishQuestion {
  final String id, question, explanation;
  final List<String> options;
  final int correctIndex;
  const AnnualEnglishQuestion(this.id, this.question, this.options, this.correctIndex, this.explanation);
}

class AnnualEnglishUnit {
  final SchoolLevel level;
  final String code, unitTitle, lessonId, lessonTitle, summary, content;
  final int unitOrder;
  final List<String> keyPoints;
  final List<AnnualEnglishQuestion> questions;
  const AnnualEnglishUnit({
    required this.level, required this.code, required this.unitOrder,
    required this.unitTitle, required this.lessonId, required this.lessonTitle,
    required this.summary, required this.content, required this.keyPoints,
    required this.questions,
  });
  String get subjectId => 'core_english_$code';
  String get chapterId => 'core_english_${code}_unit_${unitOrder}';
  List<Exercise> get exercises => questions.map((q) => Exercise(
    id: q.id, lessonId: lessonId, question: q.question, options: q.options,
    correctIndex: q.correctIndex, explanation: q.explanation,
  )).toList();
}

const annualEnglishUnits = <AnnualEnglishUnit>[
  // CP1
  AnnualEnglishUnit(level: SchoolLevel.cp1, code: 'cp1', unitOrder: 1, unitTitle: 'Greetings',
    lessonId: 'core_en_cp1_greetings', lessonTitle: 'Hello! Good morning!',
    summary: 'Apprendre à saluer selon le moment de la journée.',
    content: 'We say Hello! or Hi! to greet someone. In the morning, we can say Good morning! When we leave, we say Goodbye! or Bye! Speak clearly and smile politely.',
    keyPoints: ['Hello / Hi = Bonjour', 'Good morning = Bonjour le matin', 'Goodbye / Bye = Au revoir'],
    questions: [
      AnnualEnglishQuestion('core_en_cp1_g1','What do we say in the morning?',['Good morning','Goodbye','Good night'],0,'Good morning signifie bonjour le matin.'),
      AnnualEnglishQuestion('core_en_cp1_g2','Which word means au revoir?',['Hello','Goodbye','Please'],1,'Goodbye signifie au revoir.'),
      AnnualEnglishQuestion('core_en_cp1_g3','Choose a greeting.',['Hello!','Pencil!','Seven!'],0,'Hello est une formule de salutation.'),
    ]),
  AnnualEnglishUnit(level: SchoolLevel.cp1, code: 'cp1', unitOrder: 2, unitTitle: 'My name',
    lessonId: 'core_en_cp1_my_name', lessonTitle: 'My name is…',
    summary: 'Se présenter et demander le prénom de quelqu’un.',
    content: 'To introduce yourself, say: My name is Afi. You can also say: I am Afi or I’m Afi. To ask someone’s name, say: What is your name? Answer: My name is…',
    keyPoints: ['My name is… = Je m’appelle…', 'I am… / I’m… = Je suis…', 'What is your name? = Comment t’appelles-tu ?'],
    questions: [
      AnnualEnglishQuestion('core_en_cp1_n1','Complete: My ___ is Kossi.',['name','book','school'],0,'My name is Kossi.'),
      AnnualEnglishQuestion('core_en_cp1_n2','How do you ask a name?',['What is your name?','Goodbye!','Sit down!'],0,'What is your name? demande le prénom.'),
      AnnualEnglishQuestion('core_en_cp1_n3','Choose the correct introduction.',['I am Ama.','You is Ama.','Name Ama am.'],0,'I am Ama est une phrase correcte.'),
    ]),
  AnnualEnglishUnit(level: SchoolLevel.cp1, code: 'cp1', unitOrder: 3, unitTitle: 'Classroom objects',
    lessonId: 'core_en_cp1_classroom', lessonTitle: 'My classroom',
    summary: 'Nommer quelques objets de la classe et les montrer.',
    content: 'Look around your classroom. A book, a pen, a pencil, a bag and a chair are classroom objects. Say: This is a book. This is my pencil. Listen and repeat each word.',
    keyPoints: ['book = livre', 'pen = stylo', 'pencil = crayon', 'bag = sac', 'chair = chaise'],
    questions: [
      AnnualEnglishQuestion('core_en_cp1_c1','Which object is used to write?',['Pencil','Chair','Bag'],0,'A pencil est un crayon.'),
      AnnualEnglishQuestion('core_en_cp1_c2','What is “book” in French?',['Livre','Sac','Chaise'],0,'Book signifie livre.'),
      AnnualEnglishQuestion('core_en_cp1_c3','Complete: This is a ___.',['chair','hello','morning'],0,'Chair est un objet de classe.'),
    ]),
  // CP2
  AnnualEnglishUnit(level: SchoolLevel.cp2, code: 'cp2', unitOrder: 1, unitTitle: 'Numbers and age',
    lessonId: 'core_en_cp2_numbers', lessonTitle: 'Numbers 1–10',
    summary: 'Dire les nombres et indiquer son âge.',
    content: 'Count from one to ten: one, two, three, four, five, six, seven, eight, nine, ten. To say your age, use: I am seven years old. Ask: How old are you? Answer: I am … years old.',
    keyPoints: ['one to ten = 1 à 10', 'How old are you? = Quel âge as-tu ?', 'I am … years old. = J’ai … ans.'],
    questions: [
      AnnualEnglishQuestion('core_en_cp2_num1','What comes after six?',['Five','Seven','Ten'],1,'Seven vient après six.'),
      AnnualEnglishQuestion('core_en_cp2_num2','How do you say 3?',['Three','Eight','Four'],0,'Three signifie trois.'),
      AnnualEnglishQuestion('core_en_cp2_num3','Complete: I am eight ___ old.',['years','books','days'],0,'On dit eight years old.'),
    ]),
  AnnualEnglishUnit(level: SchoolLevel.cp2, code: 'cp2', unitOrder: 2, unitTitle: 'Colours',
    lessonId: 'core_en_cp2_colours', lessonTitle: 'Colours around me',
    summary: 'Reconnaître les couleurs et décrire un objet.',
    content: 'The basic colours are red, blue, yellow, green, black and white. Ask: What colour is it? Answer: It is red. You can say: My bag is blue.',
    keyPoints: ['red = rouge', 'blue = bleu', 'yellow = jaune', 'green = vert', 'What colour is it?'],
    questions: [
      AnnualEnglishQuestion('core_en_cp2_col1','Which word means vert?',['Green','Red','White'],0,'Green signifie vert.'),
      AnnualEnglishQuestion('core_en_cp2_col2','What colour is the sun in a drawing?',['Yellow','Black','Blue'],0,'Yellow signifie jaune.'),
      AnnualEnglishQuestion('core_en_cp2_col3','Complete: It is ___.',['blue','chair','seven'],0,'Blue est une couleur.'),
    ]),
  AnnualEnglishUnit(level: SchoolLevel.cp2, code: 'cp2', unitOrder: 3, unitTitle: 'Classroom instructions',
    lessonId: 'core_en_cp2_instructions', lessonTitle: 'Listen and do',
    summary: 'Comprendre et exécuter des consignes simples.',
    content: 'The teacher can say: Stand up! Sit down! Listen! Look! Open your book! Close your book! These are classroom instructions. Listen first, then do the action safely.',
    keyPoints: ['Stand up = Lève-toi', 'Sit down = Assieds-toi', 'Listen = Écoute', 'Open your book = Ouvre ton livre'],
    questions: [
      AnnualEnglishQuestion('core_en_cp2_i1','What does “Sit down” mean?',['Assieds-toi','Lève-toi','Écoute'],0,'Sit down signifie assieds-toi.'),
      AnnualEnglishQuestion('core_en_cp2_i2','Which instruction asks you to listen?',['Listen!','Close!','Stand!'],0,'Listen signifie écoute.'),
      AnnualEnglishQuestion('core_en_cp2_i3','What do you open to read?',['Your book','Your chair','Your shoe'],0,'Open your book : ouvre ton livre.'),
    ]),
  // CE1
  AnnualEnglishUnit(level: SchoolLevel.ce1, code: 'ce1', unitOrder: 1, unitTitle: 'My family',
    lessonId: 'core_en_ce1_family', lessonTitle: 'This is my family',
    summary: 'Présenter les membres de la famille.',
    content: 'My family: mother, father, sister, brother and baby. Use: This is my mother. This is my father. You can say: I have one brother. Listen to the words and repeat them.',
    keyPoints: ['mother = mère', 'father = père', 'sister = sœur', 'brother = frère', 'This is my…'],
    questions: [
      AnnualEnglishQuestion('core_en_ce1_f1','Who is your mother?',['Your mother','Your teacher','Your friend'],0,'Mother signifie mère.'),
      AnnualEnglishQuestion('core_en_ce1_f2','What does “brother” mean?',['Frère','Sœur','Père'],0,'Brother signifie frère.'),
      AnnualEnglishQuestion('core_en_ce1_f3','Complete: This is my ___.',['father','blue','Monday'],0,'Father est un membre de la famille.'),
    ]),
  AnnualEnglishUnit(level: SchoolLevel.ce1, code: 'ce1', unitOrder: 2, unitTitle: 'At school',
    lessonId: 'core_en_ce1_school', lessonTitle: 'My school',
    summary: 'Parler de l’école et de quelques matières.',
    content: 'At school, I meet my teacher and my friends. I use a book, a notebook and a pencil. School subjects include English, mathematics, French and science. Say: I like English.',
    keyPoints: ['teacher = enseignant', 'notebook = cahier', 'I like… = J’aime…', 'English = anglais'],
    questions: [
      AnnualEnglishQuestion('core_en_ce1_s1','Who teaches the class?',['The teacher','The pencil','The bag'],0,'The teacher est l’enseignant.'),
      AnnualEnglishQuestion('core_en_ce1_s2','What does “notebook” mean?',['Cahier','Chaise','Livre de cuisine'],0,'Notebook signifie cahier.'),
      AnnualEnglishQuestion('core_en_ce1_s3','Complete: I ___ English.',['like','likes','liking'],0,'Avec I, on utilise like.'),
    ]),
  AnnualEnglishUnit(level: SchoolLevel.ce1, code: 'ce1', unitOrder: 3, unitTitle: 'Days of the week',
    lessonId: 'core_en_ce1_days', lessonTitle: 'Days and school',
    summary: 'Nommer les jours et parler de la semaine.',
    content: 'The days are Monday, Tuesday, Wednesday, Thursday, Friday, Saturday and Sunday. School days are usually Monday to Friday. Say: Today is Monday. Tomorrow is Tuesday.',
    keyPoints: ['Monday = lundi', 'Tuesday = mardi', 'Friday = vendredi', 'Today = aujourd’hui', 'Tomorrow = demain'],
    questions: [
      AnnualEnglishQuestion('core_en_ce1_d1','What day comes after Monday?',['Tuesday','Sunday','Friday'],0,'Tuesday vient après Monday.'),
      AnnualEnglishQuestion('core_en_ce1_d2','Which day is usually a school day?',['Wednesday','Sunday','Saturday'],0,'Wednesday est un jour de semaine scolaire.'),
      AnnualEnglishQuestion('core_en_ce1_d3','What does “tomorrow” mean?',['Demain','Hier','Aujourd’hui'],0,'Tomorrow signifie demain.'),
    ]),
  // CE2
  AnnualEnglishUnit(level: SchoolLevel.ce2, code: 'ce2', unitOrder: 1, unitTitle: 'Food and drinks',
    lessonId: 'core_en_ce2_food', lessonTitle: 'Food I like',
    summary: 'Nommer des aliments et exprimer ses goûts.',
    content: 'Food words: rice, bread, fish, beans, banana and orange. Drinks: water and milk. Say: I like rice. I don’t like milk. Ask: What do you like?',
    keyPoints: ['rice = riz', 'fish = poisson', 'water = eau', 'I like… / I don’t like…'],
    questions: [
      AnnualEnglishQuestion('core_en_ce2_food1','What does “rice” mean?',['Riz','Poisson','Pain'],0,'Rice signifie riz.'),
      AnnualEnglishQuestion('core_en_ce2_food2','Which one is a drink?',['Water','Banana','Beans'],0,'Water signifie eau.'),
      AnnualEnglishQuestion('core_en_ce2_food3','Complete: I ___ bananas.',['like','am','are'],0,'I like exprime un goût.'),
    ]),
  AnnualEnglishUnit(level: SchoolLevel.ce2, code: 'ce2', unitOrder: 2, unitTitle: 'Daily routine',
    lessonId: 'core_en_ce2_routine', lessonTitle: 'My daily routine',
    summary: 'Décrire quelques actions de la journée.',
    content: 'In the morning, I get up, wash my face and eat breakfast. Then I go to school. In the evening, I do my homework. Use: I get up. I go to school. I do my homework.',
    keyPoints: ['get up = se lever', 'wash = se laver', 'go to school = aller à l’école', 'homework = devoirs'],
    questions: [
      AnnualEnglishQuestion('core_en_ce2_r1','What does “get up” mean?',['Se lever','Se coucher','Courir'],0,'Get up signifie se lever.'),
      AnnualEnglishQuestion('core_en_ce2_r2','When do you usually go to school?',['In the morning','At midnight','Never'],0,'On va généralement à l’école le matin.'),
      AnnualEnglishQuestion('core_en_ce2_r3','Complete: I do my ___.',['homework','water','chair'],0,'Homework signifie devoirs.'),
    ]),
  AnnualEnglishUnit(level: SchoolLevel.ce2, code: 'ce2', unitOrder: 3, unitTitle: 'Telling the time',
    lessonId: 'core_en_ce2_time', lessonTitle: 'What time is it?',
    summary: 'Lire les heures simples et demander l’heure.',
    content: 'Ask: What time is it? For an exact hour, say: It is seven o’clock. It is eight o’clock. The word o’clock is used for a full hour. Practise with a clock drawing.',
    keyPoints: ['What time is it? = Quelle heure est-il ?', 'seven o’clock = 7 heures', 'o’clock = heure exacte'],
    questions: [
      AnnualEnglishQuestion('core_en_ce2_t1','How do you say 7:00?',['Seven o’clock','Seven days','Seven books'],0,'Seven o’clock signifie sept heures.'),
      AnnualEnglishQuestion('core_en_ce2_t2','Which question asks the time?',['What time is it?','What is your name?','How old are you?'],0,'What time is it? demande l’heure.'),
      AnnualEnglishQuestion('core_en_ce2_t3','Complete: It is eight ___.',['o’clock','family','school'],0,'On dit eight o’clock pour 8 heures.'),
    ]),
  // CM1
  AnnualEnglishUnit(level: SchoolLevel.cm1, code: 'cm1', unitOrder: 1, unitTitle: 'Describing people',
    lessonId: 'core_en_cm1_describe', lessonTitle: 'Describe a person',
    summary: 'Décrire une personne avec des adjectifs simples.',
    content: 'Use adjectives to describe people: tall, short, young, kind and happy. Say: He is tall. She is kind. My friend is happy. Remember: he refers to a boy or man; she refers to a girl or woman.',
    keyPoints: ['tall = grand', 'short = petit', 'kind = gentil', 'He is… / She is…'],
    questions: [
      AnnualEnglishQuestion('core_en_cm1_p1','Which word means gentil?',['Kind','Tall','Young'],0,'Kind signifie gentil.'),
      AnnualEnglishQuestion('core_en_cm1_p2','Complete: She ___ happy.',['is','am','are'],0,'Avec she, on utilise is.'),
      AnnualEnglishQuestion('core_en_cm1_p3','Which pronoun refers to a boy?',['He','She','They'],0,'He peut désigner un garçon ou un homme.'),
    ]),
  AnnualEnglishUnit(level: SchoolLevel.cm1, code: 'cm1', unitOrder: 2, unitTitle: 'Places and directions',
    lessonId: 'core_en_cm1_directions', lessonTitle: 'Where is the school?',
    summary: 'Indiquer un lieu et donner une direction simple.',
    content: 'Places: school, market, hospital and house. Directions: left, right and straight ahead. Ask: Where is the market? Answer: Go straight, then turn left. Use directions politely and safely.',
    keyPoints: ['market = marché', 'hospital = hôpital', 'left = gauche', 'right = droite', 'straight ahead = tout droit'],
    questions: [
      AnnualEnglishQuestion('core_en_cm1_dir1','What does “left” mean?',['Gauche','Droite','Tout droit'],0,'Left signifie gauche.'),
      AnnualEnglishQuestion('core_en_cm1_dir2','Where can you buy food?',['At the market','At the hospital','In the sky'],0,'On achète souvent des aliments au marché.'),
      AnnualEnglishQuestion('core_en_cm1_dir3','Complete: Go ___ ahead.',['straight','blue','seven'],0,'Straight ahead signifie tout droit.'),
    ]),
  AnnualEnglishUnit(level: SchoolLevel.cm1, code: 'cm1', unitOrder: 3, unitTitle: 'Simple present',
    lessonId: 'core_en_cm1_present', lessonTitle: 'What do you do?',
    summary: 'Parler des habitudes avec le présent simple.',
    content: 'Use the simple present for habits: I play football. We read books. With he, she or it, add -s to most verbs: She plays football. He reads a book. Do not add -s after I, you, we or they.',
    keyPoints: ['I play', 'We read', 'She plays', 'He reads'],
    questions: [
      AnnualEnglishQuestion('core_en_cm1_pr1','Choose: I ___ football.',['play','plays','playing'],0,'Avec I, on écrit play.'),
      AnnualEnglishQuestion('core_en_cm1_pr2','Choose: She ___ books.',['reads','read','reading'],0,'Avec she, le verbe read devient reads.'),
      AnnualEnglishQuestion('core_en_cm1_pr3','Which sentence is correct?',['He plays.','He play.','He playing.'],0,'Au présent simple, on ajoute souvent -s avec he.'),
    ]),
  // CM2
  AnnualEnglishUnit(level: SchoolLevel.cm2, code: 'cm2', unitOrder: 1, unitTitle: 'Weather and seasons',
    lessonId: 'core_en_cm2_weather', lessonTitle: 'What is the weather like?',
    summary: 'Décrire le temps qu’il fait et les saisons.',
    content: 'Weather words: sunny, rainy, cloudy, windy and hot. Ask: What is the weather like? Answer: It is sunny. In Togo, we often talk about the rainy season and the dry season. Weather can change during the day.',
    keyPoints: ['sunny = ensoleillé', 'rainy = pluvieux', 'cloudy = nuageux', 'rainy season = saison des pluies', 'dry season = saison sèche'],
    questions: [
      AnnualEnglishQuestion('core_en_cm2_w1','What does “rainy” mean?',['Pluvieux','Ensoleillé','Froid'],0,'Rainy signifie pluvieux.'),
      AnnualEnglishQuestion('core_en_cm2_w2','Which season is dry?',['Dry season','Rainy season','Night'],0,'Dry season signifie saison sèche.'),
      AnnualEnglishQuestion('core_en_cm2_w3','Complete: It is ___ today.',['sunny','chair','family'],0,'Sunny décrit un temps ensoleillé.'),
    ]),
  AnnualEnglishUnit(level: SchoolLevel.cm2, code: 'cm2', unitOrder: 2, unitTitle: 'Reading a short text',
    lessonId: 'core_en_cm2_reading', lessonTitle: 'Read and understand',
    summary: 'Lire un court paragraphe et retrouver les informations.',
    content: 'Read: “My name is Sena. I am eleven years old. I live in Lomé. I go to school from Monday to Friday. I like science and football.” To understand a text, find the name, age, place, days and activities. Answer with words from the text.',
    keyPoints: ['Read the text twice', 'Find names and numbers', 'Answer with information from the text'],
    questions: [
      AnnualEnglishQuestion('core_en_cm2_read1','What is the child’s name?',['Sena','Afi','Kossi'],0,'Le texte dit : My name is Sena.'),
      AnnualEnglishQuestion('core_en_cm2_read2','Where does Sena live?',['Lomé','Paris','Accra'],0,'Le texte précise I live in Lomé.'),
      AnnualEnglishQuestion('core_en_cm2_read3','What does Sena like?',['Science and football','Only music','Cooking'],0,'Le texte dit I like science and football.'),
    ]),
  AnnualEnglishUnit(level: SchoolLevel.cm2, code: 'cm2', unitOrder: 3, unitTitle: 'Future plans',
    lessonId: 'core_en_cm2_future', lessonTitle: 'My plans',
    summary: 'Exprimer une intention simple pour l’avenir.',
    content: 'Use “I am going to…” to talk about a plan. Example: I am going to study. I am going to visit my grandmother. Ask: What are you going to do? Answer: I am going to…',
    keyPoints: ['I am going to… = Je vais…', 'What are you going to do? = Que vas-tu faire ?', 'Use the phrase for a plan'],
    questions: [
      AnnualEnglishQuestion('core_en_cm2_fu1','Complete: I am going to ___.',['study','studies','studying'],0,'Après going to, on utilise le verbe à sa forme de base.'),
      AnnualEnglishQuestion('core_en_cm2_fu2','Which question asks about a plan?',['What are you going to do?','How old are you?','What colour is it?'],0,'Cette question demande ce que la personne prévoit de faire.'),
      AnnualEnglishQuestion('core_en_cm2_fu3','Choose the correct sentence.',['I am going to read.','I going read.','I am go to read.'],0,'I am going to read est la forme correcte.'),
    ]),
];

final annualEnglishSubjects = SchoolLevel.values.take(6).map((level) {
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
    id: 'core_english_$code', name: 'Anglais', iconName: 'translate',
    colorHex: '006A4E', level: level, totalChapters: 3,
  );
}).toList();

final annualEnglishChapters = annualEnglishUnits.map((unit) => Chapter(
  id: unit.chapterId, subjectId: unit.subjectId,
  title: 'Unité ${unit.unitOrder} — ${unit.unitTitle}',
  order: unit.unitOrder, term: termForAnnualUnit(unit.unitOrder, annualEnglishUnits.where((item) => item.code == unit.code).length),
  totalLessons: 1,
)).toList();

final annualEnglishLessons = annualEnglishUnits.map((unit) => Lesson(
  id: unit.lessonId, chapterId: unit.chapterId, title: unit.lessonTitle,
  summary: unit.summary, content: unit.content, keyPoints: unit.keyPoints,
  durationMinutes: 15,
)).toList();

final annualEnglishExercises = annualEnglishUnits.expand((unit) => unit.exercises).toList();
