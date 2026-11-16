import '../models/models.dart';

/// Données d'exemple pour le MVP ProfTogo
/// Contenu basé sur le programme togolais (approche APC)

class SampleData {
  static const List<Subject> subjects6eme = [
    Subject(
      id: 'math-6e',
      name: 'Mathématiques',
      iconName: 'calculator',
      colorHex: '#006A4E',
      level: SchoolLevel.sixieme,
      totalChapters: 12,
      completedChapters: 4,
      progress: 0.33,
    ),
    Subject(
      id: 'fr-6e',
      name: 'Français',
      iconName: 'book',
      colorHex: '#D21034',
      level: SchoolLevel.sixieme,
      totalChapters: 10,
      completedChapters: 3,
      progress: 0.30,
    ),
    Subject(
      id: 'ang-6e',
      name: 'Anglais',
      iconName: 'chat',
      colorHex: '#0288D1',
      level: SchoolLevel.sixieme,
      totalChapters: 8,
      completedChapters: 2,
      progress: 0.25,
    ),
    Subject(
      id: 'svt-6e',
      name: 'SVT',
      iconName: 'leaf',
      colorHex: '#2E7D32',
      level: SchoolLevel.sixieme,
      totalChapters: 9,
      completedChapters: 1,
      progress: 0.11,
    ),
    Subject(
      id: 'hist-6e',
      name: 'Histoire-Géo',
      iconName: 'globe',
      colorHex: '#F9A825',
      level: SchoolLevel.sixieme,
      totalChapters: 11,
      completedChapters: 2,
      progress: 0.18,
    ),
    Subject(
      id: 'phys-6e',
      name: 'Physique-Chimie',
      iconName: 'atom',
      colorHex: '#7B1FA2',
      level: SchoolLevel.sixieme,
      totalChapters: 8,
      completedChapters: 0,
      progress: 0.0,
    ),
  ];

  static const List<Chapter> mathChapters = [
    Chapter(
      id: 'math-6e-ch1',
      subjectId: 'math-6e',
      title: 'Les nombres entiers naturels',
      order: 1,
      isCompleted: true,
      totalLessons: 4,
      completedLessons: 4,
    ),
    Chapter(
      id: 'math-6e-ch2',
      subjectId: 'math-6e',
      title: 'Les opérations sur les entiers',
      order: 2,
      isCompleted: true,
      totalLessons: 5,
      completedLessons: 5,
    ),
    Chapter(
      id: 'math-6e-ch3',
      subjectId: 'math-6e',
      title: 'Les fractions',
      order: 3,
      isCompleted: true,
      totalLessons: 6,
      completedLessons: 6,
    ),
    Chapter(
      id: 'math-6e-ch4',
      subjectId: 'math-6e',
      title: 'Les nombres décimaux',
      order: 4,
      isCompleted: true,
      totalLessons: 4,
      completedLessons: 4,
    ),
    Chapter(
      id: 'math-6e-ch5',
      subjectId: 'math-6e',
      title: 'Initiation à la géométrie',
      order: 5,
      isCompleted: false,
      totalLessons: 5,
      completedLessons: 1,
    ),
    Chapter(
      id: 'math-6e-ch6',
      subjectId: 'math-6e',
      title: 'Les angles',
      order: 6,
      isCompleted: false,
      totalLessons: 4,
      completedLessons: 0,
    ),
  ];

  static const Lesson fractionLesson = Lesson(
    id: 'math-6e-ch3-l1',
    chapterId: 'math-6e-ch3',
    title: 'Qu’est-ce qu’une fraction ?',
    summary: 'Une fraction représente une ou plusieurs parts égales d’un tout.',
    durationMinutes: 12,
    content: '''
Une **fraction** est un nombre qui permet de représenter une partie d’un tout.

On l’écrit sous la forme :  
**a / b**

- **a** s’appelle le **numérateur** (le nombre de parts prises)
- **b** s’appelle le **dénominateur** (le nombre total de parts égales)

### Exemple
Si on partage un gâteau en 4 parts égales et qu’on en mange 3, on a mangé **3/4** du gâteau.

### Points importants
- Le dénominateur ne peut jamais être égal à zéro.
- Une fraction est supérieure à 1 si le numérateur est plus grand que le dénominateur.
- On peut simplifier une fraction en divisant le numérateur et le dénominateur par le même nombre.
''',
    keyPoints: [
      'Numérateur = parts prises',
      'Dénominateur = parts totales',
      'Le dénominateur ≠ 0',
      'On peut simplifier les fractions',
    ],
  );

  static const List<Exercise> fractionExercises = [
    Exercise(
      id: 'ex1',
      lessonId: 'math-6e-ch3-l1',
      question: 'Dans la fraction 5/8, quel est le numérateur ?',
      options: ['5', '8', '13', '3'],
      correctIndex: 0,
      explanation: 'Le numérateur est le nombre du haut. Ici c’est 5.',
    ),
    Exercise(
      id: 'ex2',
      lessonId: 'math-6e-ch3-l1',
      question: 'Que représente le dénominateur d’une fraction ?',
      options: [
        'Le nombre de parts prises',
        'Le nombre total de parts égales',
        'La somme des parts',
        'Le produit des parts',
      ],
      correctIndex: 1,
      explanation: 'Le dénominateur indique en combien de parts égales le tout a été divisé.',
    ),
    Exercise(
      id: 'ex3',
      lessonId: 'math-6e-ch3-l1',
      question: 'Quelle fraction représente 3 parts sur 5 ?',
      options: ['5/3', '3/5', '3/8', '5/8'],
      correctIndex: 1,
      explanation: '3 parts prises sur 5 parts au total → 3/5.',
    ),
  ];

  static const UserProgress demoProgress = UserProgress(
    userId: 'eleve-demo',
    level: SchoolLevel.sixieme,
    totalXp: 1250,
    currentStreak: 5,
    longestStreak: 12,
    subjectProgress: {
      'math-6e': 0.33,
      'fr-6e': 0.30,
      'ang-6e': 0.25,
      'svt-6e': 0.11,
      'hist-6e': 0.18,
      'phys-6e': 0.0,
    },
  );

  static List<Chapter> chaptersForSubject(Subject subject) {
    if (subject.name == 'Mathématiques' && subject.level == SchoolLevel.sixieme) {
      return mathChapters;
    }
    final n = subject.name.toLowerCase();
    List<String> topics;
    if (n.contains('math')) {
      topics = ['Nombres et opérations', 'Fractions et nombres décimaux', 'Proportionnalité et problèmes', 'Géométrie et mesures'];
    } else if (n.contains('français') || n.contains('langue')) {
      topics = ['Lecture et compréhension', 'Grammaire', 'Conjugaison', 'Orthographe et expression écrite'];
    } else if (n.contains('anglais')) {
      topics = ['Greetings and introductions', 'Vocabulary and everyday expressions', 'Grammar basics', 'Reading and writing'];
    } else if (n.contains('svt') || n.contains('sciences')) {
      topics = ['Le vivant et son environnement', 'Le corps humain et la santé', 'La matière et les ressources naturelles', 'Protection de l’environnement'];
    } else if (n.contains('histoire')) {
      topics = ['Repères historiques', 'Les sociétés et les civilisations', 'Géographie du Togo et de l’Afrique', 'Population et activités humaines'];
    } else if (n.contains('physique')) {
      topics = ['Mesures et grandeurs physiques', 'Matière et transformations', 'Électricité et énergie', 'Forces et mouvements'];
    } else if (n.contains('philosophie')) {
      topics = ['Introduction à la réflexion philosophique', 'La conscience et la personne', 'La connaissance et la vérité', 'La société et la liberté'];
    } else if (n.contains('civique') || n.contains('sociale')) {
      topics = ['La personne et la vie en société', 'Droits et devoirs', 'Citoyenneté et institutions', 'Paix et protection de l’environnement'];
    } else if (n.contains('artistique') || n.contains('musicale')) {
      topics = ['Découverte des formes artistiques', 'Pratiques et techniques', 'Création et expression', 'Patrimoine culturel'];
    } else if (n.contains('eps')) {
      topics = ['Santé et activité physique', 'Jeux et règles', 'Coordination et endurance', 'Sécurité dans la pratique'];
    } else {
      topics = ['Notions fondamentales', 'Vocabulaire et méthodes', 'Applications pratiques', 'Révisions et évaluation'];
    }
    return List.generate(topics.length, (i) => Chapter(
      id: '${subject.id}-ch${i + 1}',
      subjectId: subject.id,
      title: topics[i],
      order: i + 1,
      totalLessons: 2,
    ));
  }

  static Lesson lessonForSubject(Subject subject, Chapter chapter) {
    if (subject.name == 'Mathématiques' && chapter.title.toLowerCase().contains('fractions')) {
      return fractionLesson;
    }
    return Lesson(
      id: '${chapter.id}-lesson1',
      chapterId: chapter.id,
      title: chapter.title,
      summary: 'Découvre les notions essentielles de ${chapter.title.toLowerCase()} en ${subject.name}.',
      durationMinutes: 15,
      content: '''
OBJECTIF DE LA LEÇON

Comprendre les notions principales de « ${chapter.title} » en ${subject.name}, puis savoir les utiliser dans des situations simples.

MÉTHODE DE TRAVAIL

1. Lis attentivement le titre et les objectifs.
2. Repère les mots importants et note leur définition dans ton cahier.
3. Étudie les exemples donnés par ton enseignant et ton manuel.
4. Essaie de reformuler la notion avec tes propres mots.
5. Termine par les exercices et vérifie tes réponses.

À RETENIR

Cette fiche est une trame pédagogique de révision. Le contenu détaillé, les exemples et les évaluations doivent être complétés et vérifiés avec le programme et les manuels homologués correspondant à la classe.
''',
      keyPoints: [
        'Identifier les notions importantes du chapitre.',
        'Connaître le vocabulaire de la matière.',
        'Savoir expliquer la leçon avec ses propres mots.',
        'S’entraîner avant de passer à la suite.',
      ],
    );
  }

  static List<Exercise> exercisesForSubject(Subject subject, Chapter chapter) {
    if (subject.name == 'Mathématiques' && chapter.title.toLowerCase().contains('fractions')) {
      return fractionExercises;
    }
    final question = subject.name == 'Anglais'
        ? 'Que signifie « Good morning » en français ?'
        : subject.name == 'Français' || subject.name == 'Langue et communication'
            ? 'Dans une phrase, à quoi sert le verbe ?'
            : subject.name == 'Histoire-Géographie'
                ? 'Quel est le pays dans lequel se trouve Lomé ?'
                : subject.name == 'SVT' || subject.name.contains('Sciences')
                    ? 'Quel élément est indispensable à la plupart des êtres vivants ?'
                    : subject.name == 'Physique-Chimie'
                        ? 'Quelle est l’unité de mesure de la masse dans le système international ?'
                        : 'Quelle est la meilleure première étape pour réussir ce chapitre ?';
    final options = subject.name == 'Anglais'
        ? ['Bonjour', 'Bonsoir', 'Au revoir', 'Merci']
        : subject.name == 'Français' || subject.name == 'Langue et communication'
            ? ['Exprimer une action ou un état', 'Nommer une personne', 'Remplacer un nom', 'Décrire un lieu']
            : subject.name == 'Histoire-Géographie'
                ? ['Togo', 'Ghana', 'Bénin', 'Nigeria']
                : subject.name == 'SVT' || subject.name.contains('Sciences')
                    ? ['Eau', 'Plastique', 'Métal', 'Sable sec']
                    : subject.name == 'Physique-Chimie'
                        ? ['Kilogramme', 'Mètre', 'Seconde', 'Litre']
                        : ['Lire et comprendre les objectifs', 'Sauter la leçon', 'Répondre au hasard', 'Ignorer les consignes'];
    final correct = 0;
    return [
      Exercise(
        id: '${chapter.id}-ex1',
        lessonId: '${chapter.id}-lesson1',
        question: question,
        options: options,
        correctIndex: correct,
        explanation: 'La bonne réponse est « ${options[correct]} ». Revois la leçon et les exemples de ton cours.',
      ),
      Exercise(
        id: '${chapter.id}-ex2',
        lessonId: '${chapter.id}-lesson1',
        question: 'Avant de faire un exercice sur « ${chapter.title} », que faut-il faire ?',
        options: ['Lire et comprendre la consigne', 'Copier sans lire', 'Choisir au hasard', 'Ne pas vérifier'],
        correctIndex: 0,
        explanation: 'Il faut lire attentivement la consigne pour savoir ce qui est demandé.',
      ),
    ];
  }

}
