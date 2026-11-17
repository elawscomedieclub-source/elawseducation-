import '../../data/models/models.dart';
import '../../data/sample/sample_data.dart';

class ApcLessonGuide {
  final String competence;
  final String situation;
  final String mission;
  final List<String> steps;
  final String production;
  final List<String> criteria;

  const ApcLessonGuide({
    required this.competence,
    required this.situation,
    required this.mission,
    required this.steps,
    required this.production,
    required this.criteria,
  });

  factory ApcLessonGuide.forLesson(Lesson lesson, Chapter chapter) {
    final subject = demoSubjects.firstWhere(
      (item) => item.id == chapter.subjectId,
      orElse: () => demoSubjects.first,
    );
    final name = subject.name.toLowerCase();
    final primary = subject.level.index <= SchoolLevel.cm2.index;
    final context = primary
        ? 'dans ton école ou ton quartier'
        : 'dans ta communauté au Togo';

    if (name.contains('math')) {
      return ApcLessonGuide(
        competence: 'Résoudre une situation concrète en mobilisant les notions de mathématiques étudiées : ${lesson.title.toLowerCase()}.',
        situation: 'Au marché de $context, une famille doit organiser ses achats et vérifier ses calculs. Elle te demande de l’aider en utilisant les connaissances de cette leçon.',
        mission: 'Repère les données utiles, choisis une méthode de calcul, résous le problème et explique pourquoi ta réponse est correcte.',
        steps: [
          'Observer la situation et relever les informations importantes.',
          'Dire ce que l’on cherche et choisir une opération ou une propriété adaptée.',
          'Effectuer les calculs et vérifier le résultat.',
          'Présenter la démarche avec des phrases et, si nécessaire, un schéma.',
        ],
        production: 'Une solution rédigée, avec les calculs, les unités et une justification.',
        criteria: ['Les données utiles sont correctement repérées.', 'La méthode choisie convient au problème.', 'Le résultat est exact et expliqué.'],
      );
    }
    if (name.contains('français')) {
      return ApcLessonGuide(
        competence: 'Comprendre et produire un message oral ou écrit en réinvestissant les acquis de la leçon : ${lesson.title.toLowerCase()}.',
        situation: 'Ton établissement prépare une activité pour les élèves et les familles. Il faut lire, comprendre ou rédiger un message clair adapté aux destinataires.',
        mission: 'Étudie le document ou le sujet proposé, identifie les informations essentielles puis produis un message organisé en respectant les règles étudiées.',
        steps: [
          'Lire ou écouter attentivement la consigne.',
          'Relever les idées et les indices importants.',
          'Organiser les idées dans un ordre logique.',
          'Rédiger, relire et corriger la production.',
        ],
        production: 'Un texte ou une prise de parole compréhensible, cohérente et adaptée à la situation.',
        criteria: ['Le message répond à la consigne.', 'Les idées sont organisées.', 'La langue et la ponctuation sont correctement utilisées.'],
      );
    }
    if (name.contains('anglais')) {
      return ApcLessonGuide(
        competence: 'Utiliser les expressions et structures anglaises de la leçon dans une communication simple et réelle.',
        situation: 'Un nouvel élève arrive dans ton école et ne parle qu’anglais. Tu dois échanger avec lui en utilisant les mots et expressions appris.',
        mission: 'Prépare un court dialogue à deux. Pose des questions, réponds clairement et réutilise les expressions de la leçon.',
        steps: [
          'Repérer les mots et expressions utiles.',
          'Préparer deux ou trois répliques.',
          'Jouer le dialogue à deux voix.',
          'Corriger la prononciation et améliorer les réponses.',
        ],
        production: 'Un dialogue oral ou écrit en anglais, adapté à la situation.',
        criteria: ['Les expressions sont adaptées.', 'Les phrases sont compréhensibles.', 'L’échange respecte la situation proposée.'],
      );
    }
    if (name.contains('svt') || name.contains('sciences') || name.contains('éveil') || name.contains('technologie')) {
      return ApcLessonGuide(
        competence: 'Observer un phénomène de l’environnement, l’expliquer avec les connaissances scientifiques de la leçon et proposer une action adaptée.',
        situation: 'Dans ton quartier ou ton village, les habitants constatent un problème lié à la santé, à l’eau, aux plantes, aux animaux ou à l’environnement. Ils cherchent une explication et des solutions.',
        mission: 'Observe le phénomène, formule une explication à partir de la leçon et propose des gestes réalisables pour améliorer la situation.',
        steps: [
          'Décrire ce que l’on observe sans inventer de faits.',
          'Poser une question et proposer une explication.',
          'Utiliser les connaissances de la leçon pour vérifier l’explication.',
          'Présenter une solution et expliquer ses avantages.',
        ],
        production: 'Une courte explication scientifique accompagnée d’une proposition d’action.',
        criteria: ['Les observations sont pertinentes.', 'L’explication utilise les notions étudiées.', 'La solution proposée est réaliste et justifiée.'],
      );
    }
    if (name.contains('histoire') || name.contains('géographie')) {
      return ApcLessonGuide(
        competence: 'Exploiter des repères, des documents ou des cartes pour comprendre une situation historique ou géographique.',
        situation: 'Une association de jeunes prépare une présentation sur l’histoire ou l’organisation de son milieu de vie. Elle a besoin d’informations fiables et bien situées.',
        mission: 'Utilise les repères et documents étudiés pour expliquer la situation, la localiser ou la replacer dans le temps.',
        steps: [
          'Identifier la nature et le sujet du document.',
          'Relever les informations utiles et les repères.',
          'Organiser les informations dans le temps ou dans l’espace.',
          'Présenter une conclusion appuyée sur les éléments relevés.',
        ],
        production: 'Une courte présentation avec des repères précis et des informations justifiées.',
        criteria: ['Les repères sont exacts.', 'Les informations sont bien organisées.', 'La conclusion est appuyée sur des éléments du document.'],
      );
    }
    return ApcLessonGuide(
      competence: 'Réinvestir les connaissances de la leçon pour traiter une situation concrète : ${lesson.title.toLowerCase()}.',
      situation: 'Une situation de la vie quotidienne nécessite d’utiliser les connaissances travaillées dans cette leçon.',
      mission: 'Analyse la situation, mobilise les notions apprises et propose une réponse argumentée.',
      steps: ['Comprendre la consigne.', 'Identifier les connaissances utiles.', 'Réaliser la tâche.', 'Vérifier et expliquer le résultat.'],
      production: 'Une réponse claire, organisée et justifiée.',
      criteria: ['La consigne est comprise.', 'Les connaissances sont bien utilisées.', 'La réponse est expliquée.'],
    );
  }
}
