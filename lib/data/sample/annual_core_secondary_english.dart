import '../models/models.dart';

class AnnualSecondaryEnglishUnit {
  final SchoolLevel level;
  final String code, title, lessonId, lessonTitle, summary, content;
  final int unitOrder;
  final List<String> keyPoints;
  final List<Exercise> exercises;
  const AnnualSecondaryEnglishUnit({
    required this.level, required this.code, required this.unitOrder,
    required this.title, required this.lessonId, required this.lessonTitle,
    required this.summary, required this.content, required this.keyPoints,
    required this.exercises,
  });
  String get subjectId => switch (code) {
    '5e' => 'cinq_ang',
    '4e' => 'quatre_ang',
    '3e' => 'trois_ang',
    _ => 'core_secondary_english_$code',
  };
  String get chapterId => 'core_secondary_english_${code}_unit_${unitOrder}';
}

const annualSecondaryEnglishUnits = <AnnualSecondaryEnglishUnit>[
  AnnualSecondaryEnglishUnit(level:SchoolLevel.cinquieme,code:'5e',unitOrder:1,title:'Present simple and daily routines',lessonId:'core_en_5e_present_simple',lessonTitle:'Talk about daily routines',summary:'Use the present simple to describe habits and routines.',content:'We use the present simple for habits, routines and facts. With I/you/we/they, use the base verb: I walk to school. With he/she/it, add -s or -es: She walks; he watches. Questions use do or does: Do you play? Does he play? In negative sentences, use do not (don’t) or does not (doesn’t) + base verb.',keyPoints:['I/you/we/they + base verb','He/she/it + verb-s/-es','Questions: Do/Does + subject + base verb?','Negatives: don’t/doesn’t + base verb'],exercises:[
    Exercise(id:'core_en_5e_ps1',lessonId:'core_en_5e_present_simple',question:'Choose the correct sentence.',options:['She walks to school.','She walk to school.','She walking to school.'],correctIndex:0,explanation:'Avec she, le verbe au présent simple prend généralement -s.'),
    Exercise(id:'core_en_5e_ps2',lessonId:'core_en_5e_present_simple',question:'___ you play football every day?',options:['Do','Does','Are'],correctIndex:0,explanation:'On utilise Do avec you pour former une question au présent simple.'),
    Exercise(id:'core_en_5e_ps3',lessonId:'core_en_5e_present_simple',question:'He ___ like tea.',options:['doesn’t','don’t','isn’t'],correctIndex:0,explanation:'Avec he, la négation au présent simple est doesn’t + base verbale.'),
  ]),
  AnnualSecondaryEnglishUnit(level:SchoolLevel.cinquieme,code:'5e',unitOrder:2,title:'Adverbs of frequency and time',lessonId:'core_en_5e_frequency',lessonTitle:'Describe how often you do things',summary:'Use always, usually, often, sometimes and never with routines.',content:'Adverbs of frequency describe how often an action happens. Always means 100% of the time; usually means most of the time; often means many times; sometimes means on some occasions; never means 0%. They usually come before the main verb: I often read. With the verb be, they usually come after it: She is always punctual. Time expressions include every day, on Mondays, in the morning and at night.',keyPoints:['always, usually, often, sometimes, never','Before a main verb: I often study','After be: He is always ready','Use time expressions to give details'],exercises:[
    Exercise(id:'core_en_5e_fr1',lessonId:'core_en_5e_frequency',question:'Which adverb means 0% of the time?',options:['Never','Always','Usually'],correctIndex:0,explanation:'Never signifie jamais.'),
    Exercise(id:'core_en_5e_fr2',lessonId:'core_en_5e_frequency',question:'Choose the correct sentence.',options:['She is always kind.','She always is kind.','She is kind always never.'],correctIndex:0,explanation:'Avec be, l’adverbe de fréquence se place généralement après le verbe.'),
    Exercise(id:'core_en_5e_fr3',lessonId:'core_en_5e_frequency',question:'Which is a time expression?',options:['Every morning','Neverly','Alwaysing'],correctIndex:0,explanation:'Every morning indique le moment ou la fréquence.'),
  ]),
  AnnualSecondaryEnglishUnit(level:SchoolLevel.quatrieme,code:'4e',unitOrder:1,title:'Past simple',lessonId:'core_en_4e_past_simple',lessonTitle:'Talk about past events',summary:'Use the past simple for completed actions in the past.',content:'The past simple describes completed actions in the past. Regular verbs usually take -ed: play → played, watch → watched. Some verbs are irregular: go → went, see → saw, have → had. Use did + base verb in questions and didn’t + base verb in negatives: Did you go? I didn’t go. Common time markers are yesterday, last week, two days ago and in 2020.',keyPoints:['Regular verbs: base + -ed','Learn common irregular verbs','Questions: Did + subject + base verb?','Negatives: didn’t + base verb'],exercises:[
    Exercise(id:'core_en_4e_ps1',lessonId:'core_en_4e_past_simple',question:'Yesterday, we ___ to the market.',options:['went','go','goes'],correctIndex:0,explanation:'Go est irrégulier : son prétérit est went.'),
    Exercise(id:'core_en_4e_ps2',lessonId:'core_en_4e_past_simple',question:'Did she ___ the lesson?',options:['understand','understood','understands'],correctIndex:0,explanation:'Après Did, on utilise la base verbale.'),
    Exercise(id:'core_en_4e_ps3',lessonId:'core_en_4e_past_simple',question:'Choose the correct negative.',options:['They didn’t play.','They didn’t played.','They don’t played.'],correctIndex:0,explanation:'Après didn’t, le verbe reste à la base.'),
  ]),
  AnnualSecondaryEnglishUnit(level:SchoolLevel.quatrieme,code:'4e',unitOrder:2,title:'Comparatives and superlatives',lessonId:'core_en_4e_comparatives',lessonTitle:'Compare people, places and things',summary:'Form comparatives and superlatives with short and long adjectives.',content:'Use a comparative to compare two things: tall → taller than; interesting → more interesting than. Use a superlative to compare one thing with a whole group: the tallest, the most interesting. Short adjectives usually take -er/-est; long adjectives usually use more/most. Some forms are irregular: good → better → best; bad → worse → worst. Use than after a comparative.',keyPoints:['Comparative: adjective-er than / more + adjective + than','Superlative: the adjective-est / the most + adjective','good → better → best; bad → worse → worst'],exercises:[
    Exercise(id:'core_en_4e_cm1',lessonId:'core_en_4e_comparatives',question:'Afi is ___ than Kossi.',options:['taller','tallest','more tall'],correctIndex:0,explanation:'Taller than est le comparatif de tall.'),
    Exercise(id:'core_en_4e_cm2',lessonId:'core_en_4e_comparatives',question:'This is ___ book in the class.',options:['the most interesting','more interesting','interestinger'],correctIndex:0,explanation:'Avec un adjectif long, on utilise the most au superlatif.'),
    Exercise(id:'core_en_4e_cm3',lessonId:'core_en_4e_comparatives',question:'The comparative of good is…',options:['better','gooder','best'],correctIndex:0,explanation:'Good est irrégulier : better au comparatif.'),
  ]),
  AnnualSecondaryEnglishUnit(level:SchoolLevel.troisieme,code:'3e',unitOrder:1,title:'Future forms: will and going to',lessonId:'core_en_3e_future',lessonTitle:'Talk about plans and predictions',summary:'Distinguish plans and intentions from predictions and spontaneous decisions.',content:'Use be going to for plans or intentions already decided: I am going to study tonight. It can also describe a prediction based on evidence: Look at the clouds; it is going to rain. Use will for predictions, promises and decisions made at the moment of speaking: I think she will win. After will, use the base verb. Remember the forms: I am, you are, he/she is going to…',keyPoints:['Be going to: plan, intention or evidence-based prediction','Will: prediction, promise or spontaneous decision','Will + base verb'],exercises:[
    Exercise(id:'core_en_3e_fu1',lessonId:'core_en_3e_future',question:'I have a plan. I ___ visit my grandmother tomorrow.',options:['am going to','went to','going'],correctIndex:0,explanation:'Be going to exprime un projet déjà décidé.'),
    Exercise(id:'core_en_3e_fu2',lessonId:'core_en_3e_future',question:'I think Togo ___ win the match.',options:['will','is','did'],correctIndex:0,explanation:'Will peut exprimer une prédiction.'),
    Exercise(id:'core_en_3e_fu3',lessonId:'core_en_3e_future',question:'After will, use…',options:['the base verb','the verb + -ed','the verb + -s'],correctIndex:0,explanation:'Will est suivi de la base verbale.'),
  ]),
  AnnualSecondaryEnglishUnit(level:SchoolLevel.troisieme,code:'3e',unitOrder:2,title:'Modal verbs: advice, obligation and permission',lessonId:'core_en_3e_modals',lessonTitle:'Give advice and express rules',summary:'Use should, must, have to and can in everyday communication.',content:'Modal verbs express advice, obligation, prohibition, ability or permission. Should/shouldn’t give advice: You should revise. Must and have to express strong obligation: We must respect the rules. Mustn’t expresses prohibition: You mustn’t cheat. Can/can’t express ability or permission: Can I come in? Modal verbs are followed by the base verb without to (except have to).',keyPoints:['Should/shouldn’t: advice','Must/have to: obligation','Mustn’t: prohibition','Can: ability or permission','Modal + base verb'],exercises:[
    Exercise(id:'core_en_3e_md1',lessonId:'core_en_3e_modals',question:'You look tired. You ___ rest.',options:['should','mustn’t','can’t'],correctIndex:0,explanation:'Should exprime un conseil.'),
    Exercise(id:'core_en_3e_md2',lessonId:'core_en_3e_modals',question:'You ___ cheat during an exam.',options:['mustn’t','should','can'],correctIndex:0,explanation:'Mustn’t exprime une interdiction.'),
    Exercise(id:'core_en_3e_md3',lessonId:'core_en_3e_modals',question:'After should, use…',options:['the base verb','to + verb','verb + -s'],correctIndex:0,explanation:'Should est suivi de la base verbale sans to.'),
  ]),
];

final annualSecondaryEnglishChapters = annualSecondaryEnglishUnits.map((unit) => Chapter(
  id:unit.chapterId,subjectId:unit.subjectId,title:'Unit ${unit.unitOrder} — ${unit.title}',
  order:unit.unitOrder,term:unit.unitOrder,totalLessons:1,
)).toList();

final annualSecondaryEnglishLessons = annualSecondaryEnglishUnits.map((unit) => Lesson(
  id:unit.lessonId,chapterId:unit.chapterId,title:unit.lessonTitle,
  summary:unit.summary,content:unit.content,keyPoints:unit.keyPoints,durationMinutes:25,
)).toList();

final annualSecondaryEnglishExercises = annualSecondaryEnglishUnits.expand((unit)=>unit.exercises).toList();
