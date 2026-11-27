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
    '6e' => 'anglais',
    '5e' => 'cinq_ang',
    '4e' => 'quatre_ang',
    '3e' => 'trois_ang',
    _ => 'core_secondary_english_$code',
  };
  String get chapterId => switch (code) {
    '5e' => switch (unitOrder) {
      1 => 'cinq_a1',
      2 => 'cinq_anglais_c2',
      3 => 'ptg_extension_cinq_ang',
      4 => 'ptg_year_cinq_ang_5',
      5 => 'cinq_plus_ang',
      6 => 'ptg_extension_cinq_ang',
      _ => 'cinq_a1',
    },
    '4e' => switch (unitOrder) {
      1 => 'quatre_a1',
      2 => 'quatre_anglais_c2',
      3 => 'quatre_plus_ang',
      4 => 'ptg_extension_quatre_ang',
      5 => 'ptg_year_quatre_ang_7',
      6 => 'quatre_anglais_c2',
      _ => 'quatre_a1',
    },
    '3e' => switch (unitOrder) {
      1 => 'trois_a1',
      2 => 'ptg_extension_trois_ang',
      3 => 'ptg_year_trois_ang_5',
      4 => 'trois_ang_c3',
      5 => 'trois_ang_c3',
      6 => 'ptg_year_trois_ang_7',
      _ => 'trois_a1',
    },
    _ => 'core_secondary_english_${code}_unit_${unitOrder}',
  };
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
  AnnualSecondaryEnglishUnit(level:SchoolLevel.cinquieme,code:'5e',unitOrder:3,title:'Present continuous',lessonId:'core_en_5e_present_continuous',lessonTitle:'Describe actions happening now',summary:'Form the present continuous with be + verb-ing.',content:'Use the present continuous for an action happening now or around now. Form it with am/is/are + verb-ing: I am reading; she is writing; they are playing. For a negative, add not after be. For a question, put am/is/are before the subject: Are you listening? Do not omit the verb be.',keyPoints:['am/is/are + verb-ing','Negative: be + not + verb-ing','Question: Am/Is/Are + subject + verb-ing?'],exercises:[
    Exercise(id:'core_en_5e_pc1',lessonId:'core_en_5e_present_continuous',question:'She ___ a book now.',options:['is reading','reads nowing','read'],correctIndex:0,explanation:'Present continuous: she is + reading.'),
    Exercise(id:'core_en_5e_pc2',lessonId:'core_en_5e_present_continuous',question:'Choose the correct question.',options:['Are they playing?','Do they playing?','They are play?'],correctIndex:0,explanation:'Place are before the subject and use the -ing form.'),
    Exercise(id:'core_en_5e_pc3',lessonId:'core_en_5e_present_continuous',question:'I ___ not sleeping.',options:['am','is','are'],correctIndex:0,explanation:'I takes am: I am not sleeping.'),
  ]),
  AnnualSecondaryEnglishUnit(level:SchoolLevel.cinquieme,code:'5e',unitOrder:4,title:'Past simple: regular and irregular verbs',lessonId:'core_en_5e_past_simple',lessonTitle:'Describe completed past actions',summary:'Use the past simple with regular and common irregular verbs.',content:'The past simple describes completed actions in the past. Regular verbs usually add -ed: clean → cleaned. Some verbs are irregular: go → went, eat → ate, see → saw. Use did + base verb in questions and did not/didn’t + base verb in negatives. Time expressions include yesterday, last week and two days ago.',keyPoints:['Regular verbs: base + -ed','Learn common irregular forms','Did/didn’t + base verb'],exercises:[
    Exercise(id:'core_en_5e_past1',lessonId:'core_en_5e_past_simple',question:'Yesterday, we ___ to the market.',options:['went','go','going'],correctIndex:0,explanation:'Go is irregular; its past simple form is went.'),
    Exercise(id:'core_en_5e_past2',lessonId:'core_en_5e_past_simple',question:'Choose the correct negative.',options:['She didn’t visit.','She didn’t visited.','She not visit.'],correctIndex:0,explanation:'After didn’t, use the base verb visit.'),
    Exercise(id:'core_en_5e_past3',lessonId:'core_en_5e_past_simple',question:'The past form of “watch” is…',options:['watched','watching','watchs'],correctIndex:0,explanation:'Watch is regular: add -ed.'),
  ]),
  AnnualSecondaryEnglishUnit(level:SchoolLevel.cinquieme,code:'5e',unitOrder:5,title:'There is, there are and prepositions',lessonId:'core_en_5e_there_prepositions',lessonTitle:'Describe places and locations',summary:'Use there is/are and prepositions of place to describe a room or neighbourhood.',content:'Use there is with a singular noun and there are with plural nouns. Examples: There is a school near my house. There are two shops on the street. Prepositions of place include in, on, under, next to, between, behind and in front of. Choose the preposition that describes the position accurately.',keyPoints:['There is + singular','There are + plural','Prepositions: next to, between, behind, under'],exercises:[
    Exercise(id:'core_en_5e_tp1',lessonId:'core_en_5e_there_prepositions',question:'___ two books on the table.',options:['There are','There is','It are'],correctIndex:0,explanation:'Two books is plural, so use there are.'),
    Exercise(id:'core_en_5e_tp2',lessonId:'core_en_5e_there_prepositions',question:'The bag is ___ the chair (below it).',options:['under','between','behind of'],correctIndex:0,explanation:'Under means below something.'),
    Exercise(id:'core_en_5e_tp3',lessonId:'core_en_5e_there_prepositions',question:'There ___ a hospital near here.',options:['is','are','be'],correctIndex:0,explanation:'A hospital is singular, so use there is.'),
  ]),
  AnnualSecondaryEnglishUnit(level:SchoolLevel.cinquieme,code:'5e',unitOrder:6,title:'Can, must and mustn’t',lessonId:'core_en_5e_modals',lessonTitle:'Express ability and rules',summary:'Use can for ability or permission and must/mustn’t for rules.',content:'Can expresses ability or permission: I can swim; Can I come in? Must expresses a strong obligation: You must wear a helmet. Mustn’t expresses prohibition: You mustn’t touch the wires. Modal verbs are followed by the base verb without to, and do not take -s with he or she.',keyPoints:['Can + base verb: ability or permission','Must + base verb: obligation','Mustn’t + base verb: prohibition'],exercises:[
    Exercise(id:'core_en_5e_mm1',lessonId:'core_en_5e_modals',question:'You ___ wear a seat belt in a car.',options:['must','can’t to','musts'],correctIndex:0,explanation:'Must expresses an important obligation.'),
    Exercise(id:'core_en_5e_mm2',lessonId:'core_en_5e_modals',question:'You ___ run across a busy road.',options:['mustn’t','must','can'],correctIndex:0,explanation:'Mustn’t expresses a prohibition.'),
    Exercise(id:'core_en_5e_mm3',lessonId:'core_en_5e_modals',question:'After can, use…',options:['the base verb','verb + -s','to + verb'],correctIndex:0,explanation:'Can is followed by the base form without to.'),
  ]),
  AnnualSecondaryEnglishUnit(level:SchoolLevel.quatrieme,code:'4e',unitOrder:3,title:'Future plans with going to',lessonId:'core_en_4e_future_plans',lessonTitle:'Talk about plans and intentions',summary:'Use be going to + base verb for intentions and planned actions.',content:'Use be going to to talk about plans and intentions. Form: subject + am/is/are + going to + base verb. Example: I am going to visit my aunt. For a question, put be before the subject: Are you going to study? For a negative, add not after be: He is not going to travel.',keyPoints:['am/is/are + going to + base verb','Question: Are you going to…?','Negative: be + not + going to'],exercises:[
    Exercise(id:'core_en_4e_fp1',lessonId:'core_en_4e_future_plans',question:'We ___ going to study tonight.',options:['are','is','am'],correctIndex:0,explanation:'We takes are.'),
    Exercise(id:'core_en_4e_fp2',lessonId:'core_en_4e_future_plans',question:'Choose the correct sentence.',options:['She is going to travel.','She going to travels.','She are going to travel.'],correctIndex:0,explanation:'She + is going to + base verb.'),
    Exercise(id:'core_en_4e_fp3',lessonId:'core_en_4e_future_plans',question:'Make a question: ___ they going to play?',options:['Are','Do','Is'],correctIndex:0,explanation:'Use are before the plural subject they.'),
  ]),
  AnnualSecondaryEnglishUnit(level:SchoolLevel.quatrieme,code:'4e',unitOrder:4,title:'Giving directions',lessonId:'core_en_4e_directions',lessonTitle:'Ask for and give directions',summary:'Use imperative phrases and location vocabulary to guide someone.',content:'To ask for directions, say “Excuse me, how can I get to…?” or “Where is…?”. Give instructions with the imperative: go straight, turn left, turn right, cross the street, take the first road. Use landmarks and prepositions such as opposite, next to and between. Be polite with please and thank you.',keyPoints:['Excuse me, how can I get to…?','Go straight; turn left/right','Use landmarks and polite expressions'],exercises:[
    Exercise(id:'core_en_4e_dr1',lessonId:'core_en_4e_directions',question:'To move to the left, say…',options:['Turn left','Turn right','Go back up'],correctIndex:0,explanation:'Turn left means tourner à gauche.'),
    Exercise(id:'core_en_4e_dr2',lessonId:'core_en_4e_directions',question:'The bank is ___ the school (across from it).',options:['opposite','under','inside'],correctIndex:0,explanation:'Opposite means en face de.'),
    Exercise(id:'core_en_4e_dr3',lessonId:'core_en_4e_directions',question:'Which phrase is polite?',options:['Excuse me, where is the station?','Give me station now!','Station!'],correctIndex:0,explanation:'Excuse me is a polite way to begin asking for help.'),
  ]),
  AnnualSecondaryEnglishUnit(level:SchoolLevel.quatrieme,code:'4e',unitOrder:5,title:'Present perfect: life experiences',lessonId:'core_en_4e_present_perfect',lessonTitle:'Talk about experiences',summary:'Form the present perfect with have/has + past participle.',content:'The present perfect can describe life experiences without specifying an exact past time. Form it with have/has + past participle: I have visited Lomé; she has eaten akoumé. Use ever in questions and never for an experience not had. When a precise finished time is given, the past simple is normally used: I visited yesterday.',keyPoints:['have/has + past participle','Ever often appears in experience questions','Use past simple with a finished time such as yesterday'],exercises:[
    Exercise(id:'core_en_4e_pp1',lessonId:'core_en_4e_present_perfect',question:'She ___ visited Kara.',options:['has','have','is'],correctIndex:0,explanation:'She takes has in the present perfect.'),
    Exercise(id:'core_en_4e_pp2',lessonId:'core_en_4e_present_perfect',question:'Have you ever ___ a horse?',options:['ridden','ride','riding'],correctIndex:0,explanation:'After have, use the past participle ridden.'),
    Exercise(id:'core_en_4e_pp3',lessonId:'core_en_4e_present_perfect',question:'Which sentence uses a finished past time?',options:['I went yesterday.','I have ever went.','I has gone.'],correctIndex:0,explanation:'Yesterday is a finished past time, so past simple is used.'),
  ]),
  AnnualSecondaryEnglishUnit(level:SchoolLevel.quatrieme,code:'4e',unitOrder:6,title:'Countable and uncountable nouns',lessonId:'core_en_4e_quantities',lessonTitle:'Talk about quantities',summary:'Use some, any, much, many and a few/a little with nouns.',content:'Countable nouns can be counted: one mango, three mangos. Uncountable nouns are not normally counted individually: water, rice, sugar. Use many and a few with countable plural nouns; much and a little with uncountable nouns. Some is common in affirmative sentences, while any is common in questions and negatives.',keyPoints:['many / a few + countable plural nouns','much / a little + uncountable nouns','some in affirmatives; any in questions and negatives'],exercises:[
    Exercise(id:'core_en_4e_q1',lessonId:'core_en_4e_quantities',question:'How ___ mangoes do you need?',options:['many','much','little'],correctIndex:0,explanation:'Mangoes are countable plural nouns.'),
    Exercise(id:'core_en_4e_q2',lessonId:'core_en_4e_quantities',question:'There isn’t ___ water in the bottle.',options:['much','many','few'],correctIndex:0,explanation:'Water is uncountable, so much is used.'),
    Exercise(id:'core_en_4e_q3',lessonId:'core_en_4e_quantities',question:'Would you like ___ rice?',options:['some','many','few'],correctIndex:0,explanation:'Some is natural in an offer or request.'),
  ]),
  AnnualSecondaryEnglishUnit(level:SchoolLevel.troisieme,code:'3e',unitOrder:3,title:'First conditional',lessonId:'core_en_3e_first_conditional',lessonTitle:'Talk about possible future results',summary:'Use if + present simple and will + base verb for likely future situations.',content:'The first conditional describes a real or possible future situation. Form: If + present simple, will + base verb. Example: If it rains, we will stay at home. The if-clause can come first or second. Do not normally use will directly after if in this pattern.',keyPoints:['If + present simple, will + base verb','Describe a possible future result','No will directly after if in the standard pattern'],exercises:[
    Exercise(id:'core_en_3e_fc1',lessonId:'core_en_3e_first_conditional',question:'If she studies, she ___ pass.',options:['will','would','is'],correctIndex:0,explanation:'First conditional uses will + base verb in the result clause.'),
    Exercise(id:'core_en_3e_fc2',lessonId:'core_en_3e_first_conditional',question:'Choose the correct if-clause.',options:['If it rains…','If it will rain…','If it raining…'],correctIndex:0,explanation:'Use present simple after if in the first conditional.'),
    Exercise(id:'core_en_3e_fc3',lessonId:'core_en_3e_first_conditional',question:'The first conditional is used for…',options:['Possible future situations','Only completed past actions','Facts that are always impossible'],correctIndex:0,explanation:'It describes a possible condition and its future result.'),
  ]),
  AnnualSecondaryEnglishUnit(level:SchoolLevel.troisieme,code:'3e',unitOrder:4,title:'Reported speech',lessonId:'core_en_3e_reported_speech',lessonTitle:'Report what someone said',summary:'Use reported speech and adjust pronouns and verb forms when needed.',content:'Direct speech gives the exact words: “I am tired,” she said. Reported speech tells what was said: She said that she was tired. In many past reporting contexts, pronouns and verb tenses change to match the speaker and time. Questions are reported with if/whether or a question word and use statement word order.',keyPoints:['She said that…','Adjust pronouns and tenses to the context','Reported questions use statement word order'],exercises:[
    Exercise(id:'core_en_3e_rs1',lessonId:'core_en_3e_reported_speech',question:'“I am happy,” he said. → He said that he ___ happy.',options:['was','is always','be'],correctIndex:0,explanation:'In a past reporting context, am commonly changes to was.'),
    Exercise(id:'core_en_3e_rs2',lessonId:'core_en_3e_reported_speech',question:'Reported yes/no questions often use…',options:['if or whether','only do','quotation marks always'],correctIndex:0,explanation:'If or whether introduces a reported yes/no question.'),
    Exercise(id:'core_en_3e_rs3',lessonId:'core_en_3e_reported_speech',question:'Reported questions usually use…',options:['Statement word order','Question inversion in every case','No subject'],correctIndex:0,explanation:'Reported questions use statement word order.'),
  ]),
  AnnualSecondaryEnglishUnit(level:SchoolLevel.troisieme,code:'3e',unitOrder:5,title:'Passive voice',lessonId:'core_en_3e_passive_voice',lessonTitle:'Describe actions in the passive',summary:'Form the passive with be + past participle.',content:'The passive focuses on the action or the receiver rather than the person doing it. Form: be + past participle. Active: People speak French. Passive: French is spoken. The tense is shown by the form of be: is made, was made, will be made. The agent can be added with by when important.',keyPoints:['be + past participle','Keep the tense in the form of be','Use by + agent when relevant'],exercises:[
    Exercise(id:'core_en_3e_pv1',lessonId:'core_en_3e_passive_voice',question:'English ___ in many countries.',options:['is spoken','speaks','is speak'],correctIndex:0,explanation:'The passive is is + past participle spoken.'),
    Exercise(id:'core_en_3e_pv2',lessonId:'core_en_3e_passive_voice',question:'The passive form uses…',options:['be + past participle','have + -ing only','do + base verb'],correctIndex:0,explanation:'The passive is formed with be and the past participle.'),
    Exercise(id:'core_en_3e_pv3',lessonId:'core_en_3e_passive_voice',question:'The agent in a passive sentence is often introduced by…',options:['by','at only','because'],correctIndex:0,explanation:'By introduces the person or thing that performs the action.'),
  ]),
  AnnualSecondaryEnglishUnit(level:SchoolLevel.troisieme,code:'3e',unitOrder:6,title:'Reading and writing for exams',lessonId:'core_en_3e_exam_writing',lessonTitle:'Understand a text and write a short response',summary:'Identify main ideas, use evidence and organize a short English paragraph.',content:'Read the instruction first and identify the topic. Read the text once for the general meaning, then again to locate names, dates, reasons and details. Answer in a complete sentence when asked. For a short paragraph, use a topic sentence, two supporting details and a closing sentence. Check verb forms, spelling and punctuation.',keyPoints:['Read the task before the text','Find evidence and answer clearly','Paragraph: topic sentence, details, closing'],exercises:[
    Exercise(id:'core_en_3e_ew1',lessonId:'core_en_3e_exam_writing',question:'Before answering comprehension questions, you should…',options:['Read the instruction and text carefully','Guess every answer','Ignore the question words'],correctIndex:0,explanation:'The instruction tells you what information to find.'),
    Exercise(id:'core_en_3e_ew2',lessonId:'core_en_3e_exam_writing',question:'A short paragraph should have…',options:['A main idea and supporting details','Only unrelated sentences','No punctuation'],correctIndex:0,explanation:'A clear paragraph develops one main idea with details.'),
    Exercise(id:'core_en_3e_ew3',lessonId:'core_en_3e_exam_writing',question:'At the end of writing, check…',options:['Grammar, spelling and punctuation','Only the page colour','Nothing'],correctIndex:0,explanation:'A final check helps correct language errors.'),
  ]),

  AnnualSecondaryEnglishUnit(level:SchoolLevel.sixieme,code:'6e',unitOrder:1,title:'Greetings and introducing yourself',lessonId:'core_en_6e_greetings',lessonTitle:'Greet people and give personal information',summary:'Use common greetings, names, age and simple personal details.',content:'English greetings include “Hello”, “Good morning” and “Goodbye”. To introduce yourself, say “My name is…” or “I am…”. Ask “What is your name?” and “How old are you?”. Use “I am” with a name or age and “I live in…” to give a place. Speak politely and listen to the other person’s answer.',keyPoints:['Hello / Good morning / Goodbye','My name is… / I am…','What is your name? / How old are you?'],exercises:[
    Exercise(id:'core_en_6e_gr1',lessonId:'core_en_6e_greetings',question:'Choose the correct greeting for the morning.',options:['Good morning','Good night','Goodbye'],correctIndex:0,explanation:'“Good morning” is used to greet someone in the morning.'),
    Exercise(id:'core_en_6e_gr2',lessonId:'core_en_6e_greetings',question:'Complete: “My … is Kossi.”',options:['name','age','school'],correctIndex:0,explanation:'We say “My name is…” to introduce ourselves.'),
    Exercise(id:'core_en_6e_gr3',lessonId:'core_en_6e_greetings',question:'“How old are you?” asks about…',options:['Age','Name','Country only'],correctIndex:0,explanation:'“How old are you?” asks a person’s age.'),
  ]),
  AnnualSecondaryEnglishUnit(level:SchoolLevel.sixieme,code:'6e',unitOrder:2,title:'Classroom language and school objects',lessonId:'core_en_6e_classroom',lessonTitle:'Understand classroom instructions and name objects',summary:'Use simple classroom commands and vocabulary for school materials.',content:'In class, the teacher may say “Stand up”, “Sit down”, “Open your book”, “Listen” or “Repeat”. School objects include a book, a pen, a pencil, a ruler, a bag and a desk. Use “This is a…” to name one object and “These are…” to name several. Follow instructions carefully and ask politely when you do not understand.',keyPoints:['Stand up / Sit down / Open your book','A pen, a pencil, a ruler, a bag','This is… / These are…'],exercises:[
    Exercise(id:'core_en_6e_cl1',lessonId:'core_en_6e_classroom',question:'What does “Open your book” mean?',options:['Ouvre ton livre','Ferme la porte','Écris ton nom'],correctIndex:0,explanation:'“Open your book” means “Ouvre ton livre”.'),
    Exercise(id:'core_en_6e_cl2',lessonId:'core_en_6e_classroom',question:'Which object do you use to draw a straight line?',options:['A ruler','A bag','A chair'],correctIndex:0,explanation:'A ruler is used to draw or measure straight lines.'),
    Exercise(id:'core_en_6e_cl3',lessonId:'core_en_6e_classroom',question:'Choose the correct sentence for one object.',options:['This is a pen.','These is a pen.','This are pens.'],correctIndex:0,explanation:'“This is…” is used to introduce one object.'),
  ]),
  AnnualSecondaryEnglishUnit(level:SchoolLevel.sixieme,code:'6e',unitOrder:3,title:'Personal pronouns and the verb to be',lessonId:'core_en_6e_be',lessonTitle:'Use I am, you are and he or she is',summary:'Build simple affirmative and negative sentences with the verb to be.',content:'The verb “to be” is used to identify or describe people and things. Its present forms are I am, you are, he is, she is, it is, we are and they are. The negative forms use “not”: I am not, he is not, they are not. Questions place the verb before the subject: “Are you a pupil?” “Is she happy?”.',keyPoints:['I am; you/we/they are; he/she/it is','Add not to make a negative sentence','Questions: Are you…? Is he…?'],exercises:[
    Exercise(id:'core_en_6e_be1',lessonId:'core_en_6e_be',question:'Choose the correct sentence.',options:['She is a pupil.','She are a pupil.','She am a pupil.'],correctIndex:0,explanation:'With “she”, the present form of “to be” is “is”.'),
    Exercise(id:'core_en_6e_be2',lessonId:'core_en_6e_be',question:'Complete: “They … at school.”',options:['are','is','am'],correctIndex:0,explanation:'“They” takes the form “are”.'),
    Exercise(id:'core_en_6e_be3',lessonId:'core_en_6e_be',question:'Which is a correct question?',options:['Are you ready?','You are ready?','Is you ready?'],correctIndex:0,explanation:'In a “to be” question, put the verb before the subject.'),
  ]),
  AnnualSecondaryEnglishUnit(level:SchoolLevel.sixieme,code:'6e',unitOrder:4,title:'Daily routines and the present simple',lessonId:'core_en_6e_routines',lessonTitle:'Talk about everyday activities',summary:'Describe daily habits with the present simple and time expressions.',content:'The present simple describes habits and routines. Use the base verb with I, you, we and they: “I go to school”. With he, she and it, add -s or -es: “She goes to school”. Common time expressions are “every day”, “in the morning” and “at night”. To make a negative, use do not or does not; questions use Do or Does.',keyPoints:['I play / She plays','Do not and does not form negatives','Every day / in the morning / at night'],exercises:[
    Exercise(id:'core_en_6e_rt1',lessonId:'core_en_6e_routines',question:'Complete: “He … to school every day.”',options:['goes','go','going'],correctIndex:0,explanation:'With “he” in the present simple, add -s or -es: goes.'),
    Exercise(id:'core_en_6e_rt2',lessonId:'core_en_6e_routines',question:'Choose the correct negative.',options:['I do not play.','I does not play.','I not plays.'],correctIndex:0,explanation:'Use “do not” with I, you, we and they.'),
    Exercise(id:'core_en_6e_rt3',lessonId:'core_en_6e_routines',question:'“Every day” expresses…',options:['A routine','A place','A person’s name'],correctIndex:0,explanation:'“Every day” tells how often an activity happens.'),
  ]),
  AnnualSecondaryEnglishUnit(level:SchoolLevel.sixieme,code:'6e',unitOrder:5,title:'Numbers, dates and telling the time',lessonId:'core_en_6e_time',lessonTitle:'Say numbers, days and simple times',summary:'Use numbers, days of the week and basic time expressions.',content:'Learn numbers for age, quantities and classroom tasks. The days of the week are Monday, Tuesday, Wednesday, Thursday, Friday, Saturday and Sunday. Ask “What time is it?” and answer “It is seven o’clock” or “It is half past seven”. Use “on” with days, for example “on Monday”, and “at” with clock times, for example “at seven o’clock”.',keyPoints:['Days: Monday to Sunday','What time is it? It is…','On Monday; at seven o’clock'],exercises:[
    Exercise(id:'core_en_6e_tm1',lessonId:'core_en_6e_time',question:'Which day comes after Tuesday?',options:['Wednesday','Monday','Friday'],correctIndex:0,explanation:'Wednesday comes after Tuesday.'),
    Exercise(id:'core_en_6e_tm2',lessonId:'core_en_6e_time',question:'“It is seven o’clock” means…',options:['Il est sept heures','Il est midi','Il est six heures'],correctIndex:0,explanation:'“Seven o’clock” means seven hours exactly.'),
    Exercise(id:'core_en_6e_tm3',lessonId:'core_en_6e_time',question:'Choose the correct preposition: “... Monday”.',options:['on','at','in'],correctIndex:0,explanation:'Use “on” before a day of the week.'),
  ]),

];

final annualSecondaryEnglishChapters = annualSecondaryEnglishUnits.map((unit) => Chapter(
  id:unit.chapterId,subjectId:unit.subjectId,title:'Unit ${unit.unitOrder} — ${unit.title}',
  order:unit.unitOrder,term: termForAnnualUnit(unit.unitOrder, annualSecondaryEnglishUnits.where((item) => item.code == unit.code).length),totalLessons:1,
)).toList();

final annualSecondaryEnglishLessons = annualSecondaryEnglishUnits.map((unit) => Lesson(
  id:unit.lessonId,chapterId:unit.chapterId,title:unit.lessonTitle,
  summary:unit.summary,content:unit.content,keyPoints:unit.keyPoints,durationMinutes:25,
)).toList();

final annualSecondaryEnglishExercises = annualSecondaryEnglishUnits.expand((unit)=>unit.exercises).toList();
