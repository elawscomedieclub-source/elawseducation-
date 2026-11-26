import 'progress_service.dart';

/// Conseils pédagogiques fondés uniquement sur des réponses récentes observées.
/// Ne déduit jamais la personnalité, l'intelligence ou un diagnostic de l'élève.
class LearnerCoachAdvice {
  final String title;
  final String message;
  final String? lessonId;

  const LearnerCoachAdvice({
    required this.title,
    required this.message,
    this.lessonId,
  });
}

class LearnerAdaptationService {
  static const learningWindow = Duration(days: 30);
  static const maxRecentAttempts = 20;

  static LearnerCoachAdvice buildAdvice(
    List<ExerciseAttemptRecord> attempts, {
    Map<String, String> lessonTitles = const {},
    DateTime? now,
    Map<String, int> learningBarrierCounts = const {},
  }) {
    final barrier = _dominantBarrier(learningBarrierCounts);
    if (attempts.isEmpty) {
      final barrierAdvice = _barrierAdvice(barrier);
      if (barrierAdvice != null) return barrierAdvice;
      return const LearnerCoachAdvice(
        title: 'On commence doucement',
        message: 'Choisis une courte leçon, puis réponds à quelques questions. Tes réponses aideront ProfTogo à te proposer la prochaine étape.',
      );
    }

    // Les données peuvent arriver dans un ordre différent selon leur source.
    // Une difficulté ancienne ne doit pas déterminer le conseil d'aujourd'hui.
    final referenceTime = (now ?? DateTime.now()).toUtc();
    final cutoff = referenceTime.subtract(learningWindow);
    final recent = attempts.where((attempt) {
      final timestamp = attempt.timestamp.toUtc();
      return !timestamp.isBefore(cutoff) && !timestamp.isAfter(referenceTime);
    }).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    if (recent.isEmpty) {
      final barrierAdvice = _barrierAdvice(barrier);
      if (barrierAdvice != null) return barrierAdvice;
      return const LearnerCoachAdvice(
        title: 'Reprenons progressivement',
        message: 'Cela fait un moment que tu n’as pas fait d’exercice ici. Reprends avec une courte leçon et quelques questions faciles ; nous ajusterons la suite à tes réponses récentes.',
      );
    }

    final boundedRecent = recent.take(maxRecentAttempts).toList();
    final recentByLesson = <String, List<ExerciseAttemptRecord>>{};
    for (final attempt in boundedRecent) {
      final list = recentByLesson.putIfAbsent(attempt.lessonId, () => []);
      if (list.length < 5) list.add(attempt);
    }

    String? priorityLesson;
    var priorityWrong = 0;
    for (final entry in recentByLesson.entries) {
      final wrong = entry.value.where((attempt) => !attempt.isCorrect).length;
      if (entry.value.length >= 2 && wrong >= 2 && wrong > priorityWrong) {
        priorityLesson = entry.key;
        priorityWrong = wrong;
      }
    }
    if (priorityLesson != null) {
      final title = lessonTitles[priorityLesson];
      final lessonName = title == null || title.trim().isEmpty
          ? 'cette leçon'
          : '« ${title.trim()} »';
      return LearnerCoachAdvice(
        title: 'Une notion à retravailler',
        message: 'Tes dernières réponses montrent que $lessonName mérite un nouvel entraînement. Relis l’explication, fais un exemple guidé, puis essaie trois questions. Une erreur est une étape normale pour apprendre.' + (_barrierHint(barrier) ?? ''),
        lessonId: priorityLesson,
      );
    }

    var streak = 0;
    for (final attempt in boundedRecent) {
      if (!attempt.isCorrect) break;
      streak++;
    }
    if (streak >= 4) {
      return LearnerCoachAdvice(
        title: 'Tu prends confiance',
        message: 'Tu viens de réussir plusieurs exercices de suite. Essaie maintenant une question un peu plus difficile, tout en gardant le temps de réfléchir.' + (_barrierHint(barrier) ?? ''),
      );
    }

    final correct = boundedRecent.where((attempt) => attempt.isCorrect).length;
    final accuracy = correct / boundedRecent.length;
    if (boundedRecent.length >= 5 && accuracy >= 0.8) {
      return LearnerCoachAdvice(
        title: 'Tes acquis se consolident',
        message: 'Tes réponses récentes sont solides. Pour retenir durablement, reviens sur cette notion demain et explique la méthode avec tes propres mots.' + (_barrierHint(barrier) ?? ''),
      );
    }

    final barrierAdvice = _barrierAdvice(barrier);
    if (barrierAdvice != null) return barrierAdvice;
    return const LearnerCoachAdvice(
      title: 'Avançons à ton rythme',
      message: 'Prends le temps de lire chaque consigne. Si une réponse est incorrecte, relis l’explication et essaie un exercice similaire avant de passer à la suite.',
    );
  }

  static String? _dominantBarrier(Map<String, int> counts) {
    const allowed = {'lecture', 'comprehension', 'methode'};
    final entries = counts.entries.where((entry) => allowed.contains(entry.key) && entry.value > 0).toList()
      ..sort((a, b) {
        final byCount = b.value.compareTo(a.value);
        return byCount != 0 ? byCount : a.key.compareTo(b.key);
      });
    return entries.isEmpty ? null : entries.first.key;
  }

  static String? _barrierHint(String? category) => switch (category) {
        'lecture' => ' Tu as aussi signalé que la lecture peut demander un appui : écoute la consigne si la lecture vocale est disponible, puis avance phrase par phrase.',
        'comprehension' => ' Tu as signalé un besoin d’aide pour comprendre : reformule la consigne avec tes mots et repère ce qu’on te demande avant de répondre.',
        'methode' => ' Tu as signalé un besoin d’aide pour la méthode : suis les étapes une par une, regarde un exemple guidé, puis refais-le sans regarder.',
        _ => null,
      };

  static LearnerCoachAdvice? _barrierAdvice(String? category) {
    switch (category) {
      case 'lecture':
        return const LearnerCoachAdvice(title: 'Un appui pour lire', message: 'Tu as indiqué que la lecture peut parfois demander plus d’effort. Si la lecture vocale est disponible, écoute une phrase, puis relis-la et repère les mots importants. Ensuite, essaie une seule question.');
      case 'comprehension':
        return const LearnerCoachAdvice(title: 'Comprendre avant de répondre', message: 'Tu as indiqué que comprendre certaines consignes peut être difficile. Lis la consigne lentement, reformule-la avec tes mots et repère ce qu’on te demande. Puis fais un exemple guidé.');
      case 'methode':
        return const LearnerCoachAdvice(title: 'Une méthode pas à pas', message: 'Tu as indiqué que la méthode peut parfois te bloquer. Regarde un exemple résolu, repère chaque étape, puis refais un exercice similaire sans regarder la solution.');
      default:
        return null;
    }
  }
}
