import '../models/models.dart';

const demoSubjects = <Subject>[
 Subject(id:'math',name:'Mathématiques',iconName:'calculator',colorHex:'#006A4E',level:SchoolLevel.sixieme,totalChapters:8,progress:.35),
 Subject(id:'fr',name:'Français',iconName:'book',colorHex:'#D21034',level:SchoolLevel.sixieme,totalChapters:7,progress:.25),
 Subject(id:'svt',name:'Sciences de la vie et de la Terre',iconName:'leaf',colorHex:'#2E7D32',level:SchoolLevel.sixieme,totalChapters:6,progress:.15),
 Subject(id:'hist',name:'Histoire-Géographie',iconName:'globe',colorHex:'#0288D1',level:SchoolLevel.sixieme,totalChapters:5,progress:.1),
 Subject(id:'anglais',name:'Anglais',iconName:'translate',colorHex:'#F9A825',level:SchoolLevel.sixieme,totalChapters:6,progress:.2),
];
const demoChapters = <Chapter>[
 Chapter(id:'m1',subjectId:'math',title:'Nombres entiers et décimaux',order:1,totalLessons:3),
 Chapter(id:'m2',subjectId:'math',title:'Opérations et calcul',order:2,totalLessons:4),
 Chapter(id:'f1',subjectId:'fr',title:'Lire et comprendre un texte',order:1,totalLessons:2),
];
const demoLessons = <Lesson>[
 Lesson(id:'l1',chapterId:'m1',title:'Les nombres entiers',summary:'Comprendre les nombres entiers.',content:'Un nombre entier est un nombre sans partie décimale. Exemples : 0, 1, 25, 100 et 2026. On peut les comparer et les ranger dans l’ordre croissant ou décroissant.',keyPoints:['Un entier n’a pas de partie décimale.','La droite graduée aide à comparer les nombres.']),
 Lesson(id:'l2',chapterId:'m1',title:'Les nombres décimaux',summary:'Lire et écrire les nombres décimaux.',content:'Un nombre décimal possède une partie entière et une partie décimale séparées par une virgule. Exemple : 12,45.',keyPoints:['La virgule sépare les deux parties.','Les dixièmes sont juste après la virgule.']),
];
const demoExercises = <Exercise>[
 Exercise(id:'e1',lessonId:'l1',question:'Lequel de ces nombres est un entier ?',options:['3,5','18','2,75'],correctIndex:1,explanation:'18 est un nombre entier car il n’a pas de partie décimale.'),
];
