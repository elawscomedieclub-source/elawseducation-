import '../models/models.dart';

class AnnualSecondaryFrenchUnit {
  final SchoolLevel level;
  final String code, title, lessonId, lessonTitle, summary, content;
  final int unitOrder;
  final List<String> keyPoints;
  final List<Exercise> exercises;
  const AnnualSecondaryFrenchUnit({
    required this.level, required this.code, required this.unitOrder,
    required this.title, required this.lessonId, required this.lessonTitle,
    required this.summary, required this.content, required this.keyPoints,
    required this.exercises,
  });
  String get subjectId => switch (code) {
    '5e' => 'cinq_fr',
    '4e' => 'quatre_fr',
    '3e' => 'trois_fr',
    _ => 'core_secondary_french_$code',
  };
  String get chapterId => 'core_secondary_french_${code}_unit_${unitOrder}';
}

const annualSecondaryFrenchUnits = <AnnualSecondaryFrenchUnit>[
  AnnualSecondaryFrenchUnit(level:SchoolLevel.cinquieme,code:'5e',unitOrder:1,title:'Les types et formes de phrases',lessonId:'core_fr_5e_sentence_types',lessonTitle:'Reconnaître les types et formes de phrases',summary:'Distinguer phrase déclarative, interrogative, impérative et exclamative.',content:'Une phrase commence par une majuscule et se termine par une ponctuation adaptée. La phrase déclarative donne une information et se termine souvent par un point. La phrase interrogative pose une question et se termine par un point d’interrogation. La phrase impérative exprime un ordre, un conseil ou une consigne. La phrase exclamative exprime une émotion. Une phrase peut être affirmative ou négative : « Il vient » / « Il ne vient pas ».',keyPoints:['Déclarative : information','Interrogative : question ?','Impérative : ordre ou conseil','Exclamative : émotion !','Négation : ne…pas'],exercises:[
    Exercise(id:'core_fr_5e_st1',lessonId:'core_fr_5e_sentence_types',question:'« Où vas-tu ? » est une phrase…',options:['Interrogative','Déclarative','Impérative'],correctIndex:0,explanation:'Elle pose une question et se termine par un point d’interrogation.'),
    Exercise(id:'core_fr_5e_st2',lessonId:'core_fr_5e_sentence_types',question:'Quelle phrase est à la forme négative ?',options:['Il ne parle pas.','Il parle.','Parle !'],correctIndex:0,explanation:'La négation est construite avec ne… pas.'),
    Exercise(id:'core_fr_5e_st3',lessonId:'core_fr_5e_sentence_types',question:'« Fermez vos cahiers. » est une phrase…',options:['Impérative','Interrogative','Exclamative'],correctIndex:0,explanation:'Elle donne une consigne.'),
  ]),
  AnnualSecondaryFrenchUnit(level:SchoolLevel.cinquieme,code:'5e',unitOrder:2,title:'Comprendre et résumer un récit',lessonId:'core_fr_5e_narrative',lessonTitle:'Identifier les étapes d’un récit',summary:'Repérer situation initiale, événement perturbateur, actions et dénouement.',content:'Un récit raconte des événements. On peut repérer la situation initiale (présentation des personnages et du cadre), l’événement perturbateur, les actions ou péripéties, le dénouement et la situation finale. Pour résumer, conserve les idées principales dans l’ordre, utilise tes propres mots et évite les détails secondaires ou les dialogues inutiles.',keyPoints:['Repérer les étapes du récit','Respecter l’ordre chronologique','Résumer avec les idées essentielles'],exercises:[
    Exercise(id:'core_fr_5e_na1',lessonId:'core_fr_5e_narrative',question:'Quelle partie présente les personnages et le cadre ?',options:['Situation initiale','Dénouement','Péripétie finale'],correctIndex:0,explanation:'La situation initiale présente le cadre et les personnages.'),
    Exercise(id:'core_fr_5e_na2',lessonId:'core_fr_5e_narrative',question:'Un bon résumé doit…',options:['Garder les idées principales','Copier tous les dialogues','Ajouter des événements inventés'],correctIndex:0,explanation:'Le résumé reprend l’essentiel sans inventer.'),
    Exercise(id:'core_fr_5e_na3',lessonId:'core_fr_5e_narrative',question:'L’événement qui lance l’action est…',options:['L’événement perturbateur','La situation finale','La description du titre'],correctIndex:0,explanation:'L’événement perturbateur déclenche les actions du récit.'),
  ]),
  AnnualSecondaryFrenchUnit(level:SchoolLevel.quatrieme,code:'4e',unitOrder:1,title:'La phrase complexe',lessonId:'core_fr_4e_complex_sentence',lessonTitle:'Construire une phrase complexe',summary:'Distinguer propositions et utiliser coordination ou subordination.',content:'Une phrase simple contient un seul verbe conjugué. Une phrase complexe contient plusieurs propositions, généralement repérées par plusieurs verbes conjugués. Les propositions peuvent être juxtaposées (ponctuation), coordonnées (mais, ou, et, donc, or, ni, car) ou subordonnées (introduites par un mot subordonnant). Choisis le lien logique qui exprime la relation entre les idées : cause, conséquence, opposition, condition ou temps.',keyPoints:['Compter les verbes conjugués','Juxtaposition : ponctuation','Coordination : conjonction','Subordination : proposition dépendante'],exercises:[
    Exercise(id:'core_fr_4e_cs1',lessonId:'core_fr_4e_complex_sentence',question:'Dans « Il pleut, nous restons à la maison », les propositions sont…',options:['Juxtaposées','Subordonnées','Sans lien'],correctIndex:0,explanation:'Elles sont séparées par une virgule sans conjonction.'),
    Exercise(id:'core_fr_4e_cs2',lessonId:'core_fr_4e_complex_sentence',question:'Quel mot exprime généralement la cause ?',options:['Parce que','Pourtant','Puis'],correctIndex:0,explanation:'« Parce que » introduit une cause.'),
    Exercise(id:'core_fr_4e_cs3',lessonId:'core_fr_4e_complex_sentence',question:'Combien de propositions dans « Afi lit et Kossi écrit » ?',options:['Deux','Une','Trois'],correctIndex:0,explanation:'Il y a deux verbes conjugués : lit et écrit.'),
  ]),
  AnnualSecondaryFrenchUnit(level:SchoolLevel.quatrieme,code:'4e',unitOrder:2,title:'Le texte argumentatif',lessonId:'core_fr_4e_argument',lessonTitle:'Défendre une opinion avec des arguments',summary:'Formuler une thèse, donner des arguments et les illustrer par des exemples.',content:'Un texte argumentatif cherche à convaincre ou persuader. La thèse est l’opinion défendue. Les arguments expliquent pourquoi cette opinion est soutenue ; les exemples rendent les arguments concrets. Organise le texte avec une introduction, des paragraphes reliés par des connecteurs logiques et une conclusion. Distingue un fait vérifiable d’une opinion personnelle.',keyPoints:['Thèse : opinion défendue','Argument : raison qui soutient la thèse','Exemple : illustration concrète','Connecteurs : d’abord, ensuite, enfin, cependant'],exercises:[
    Exercise(id:'core_fr_4e_ar1',lessonId:'core_fr_4e_argument',question:'Dans un texte argumentatif, la thèse est…',options:['L’opinion défendue','Un exemple seulement','Le titre obligatoire'],correctIndex:0,explanation:'La thèse exprime l’opinion que l’auteur cherche à défendre.'),
    Exercise(id:'core_fr_4e_ar2',lessonId:'core_fr_4e_argument',question:'À quoi sert un exemple ?',options:['À illustrer un argument','À remplacer tous les arguments','À supprimer la conclusion'],correctIndex:0,explanation:'Un exemple rend l’argument plus concret.'),
    Exercise(id:'core_fr_4e_ar3',lessonId:'core_fr_4e_argument',question:'Quel connecteur marque l’opposition ?',options:['Cependant','Donc','D’abord'],correctIndex:0,explanation:'« Cependant » introduit une opposition ou une nuance.'),
  ]),
  AnnualSecondaryFrenchUnit(level:SchoolLevel.troisieme,code:'3e',unitOrder:1,title:'Analyser un texte littéraire',lessonId:'core_fr_3e_literary_analysis',lessonTitle:'Lire, interpréter et justifier une réponse',summary:'Identifier le genre, le thème, le point de vue et appuyer une interprétation par le texte.',content:'Pour analyser un texte, commence par identifier son genre (récit, poésie, théâtre, argumentation), son thème et la situation d’énonciation. Repère les procédés d’écriture : comparaison, métaphore, répétition, champ lexical, rythme ou dialogue. Une interprétation doit être justifiée par une citation courte ou un élément précis du texte. Explique ensuite l’effet produit sur le lecteur.',keyPoints:['Identifier genre et thème','Repérer les procédés d’écriture','Justifier avec un indice du texte','Expliquer l’effet produit'],exercises:[
    Exercise(id:'core_fr_3e_la1',lessonId:'core_fr_3e_literary_analysis',question:'Pour justifier une interprétation, il faut…',options:['Citer un indice précis du texte','Inventer une citation','Donner seulement son avis'],correctIndex:0,explanation:'Une interprétation s’appuie sur des éléments observables du texte.'),
    Exercise(id:'core_fr_3e_la2',lessonId:'core_fr_3e_literary_analysis',question:'« Il est fort comme un lion » contient…',options:['Une comparaison','Une métaphore sans outil','Une hyperbole numérique'],correctIndex:0,explanation:'Le mot « comme » introduit une comparaison.'),
    Exercise(id:'core_fr_3e_la3',lessonId:'core_fr_3e_literary_analysis',question:'Le champ lexical regroupe…',options:['Des mots liés à un même thème','Tous les verbes du texte','Uniquement les noms propres'],correctIndex:0,explanation:'Un champ lexical rassemble des mots associés à une idée ou un thème.'),
  ]),
  AnnualSecondaryFrenchUnit(level:SchoolLevel.troisieme,code:'3e',unitOrder:2,title:'Rédiger un paragraphe argumenté',lessonId:'core_fr_3e_writing',lessonTitle:'Organiser une argumentation claire',summary:'Rédiger un paragraphe avec une idée, un argument, un exemple et une conclusion.',content:'Un paragraphe argumenté répond clairement à une question. Commence par une idée directrice, développe un argument, donne un exemple précis et termine par une phrase qui relie l’exemple à l’idée. Utilise des connecteurs logiques et relis la grammaire, les accords, la ponctuation et l’orthographe. Évite les répétitions en utilisant des synonymes ou des pronoms adaptés.',keyPoints:['Une idée directrice claire','Argument + exemple','Connecteurs logiques','Relire accords et ponctuation'],exercises:[
    Exercise(id:'core_fr_3e_wr1',lessonId:'core_fr_3e_writing',question:'Quel ordre convient à un paragraphe argumenté ?',options:['Idée, argument, exemple, conclusion','Exemple, titre, mots au hasard','Conclusion uniquement'],correctIndex:0,explanation:'L’organisation logique aide le lecteur à suivre le raisonnement.'),
    Exercise(id:'core_fr_3e_wr2',lessonId:'core_fr_3e_writing',question:'Quel connecteur introduit un exemple ?',options:['Par exemple','En revanche','Donc'],correctIndex:0,explanation:'« Par exemple » annonce une illustration.'),
    Exercise(id:'core_fr_3e_wr3',lessonId:'core_fr_3e_writing',question:'Que faut-il vérifier à la relecture ?',options:['Accords, ponctuation et orthographe','Seulement la longueur','La couleur du papier'],correctIndex:0,explanation:'La relecture vérifie la correction et la clarté du texte.'),
  ]),
];

final annualSecondaryFrenchChapters = annualSecondaryFrenchUnits.map((unit) => Chapter(
  id:unit.chapterId,subjectId:unit.subjectId,title:'Unité ${unit.unitOrder} — ${unit.title}',
  order:unit.unitOrder,term:unit.unitOrder,totalLessons:1,
)).toList();

final annualSecondaryFrenchLessons = annualSecondaryFrenchUnits.map((unit) => Lesson(
  id:unit.lessonId,chapterId:unit.chapterId,title:unit.lessonTitle,
  summary:unit.summary,content:unit.content,keyPoints:unit.keyPoints,durationMinutes:25,
)).toList();

final annualSecondaryFrenchExercises = annualSecondaryFrenchUnits.expand((unit)=>unit.exercises).toList();
