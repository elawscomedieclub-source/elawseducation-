import 'package:flutter_test/flutter_test.dart';
import 'package:proftogo/core/learner_adaptation_service.dart';
import 'package:proftogo/core/progress_service.dart';

ExerciseAttemptRecord attempt(String lesson, bool correct, int minutesAgo) =>
    ExerciseAttemptRecord(
      exerciseId: 'ex_${lesson}_${minutesAgo}_${correct}',
      lessonId: lesson,
      isCorrect: correct,
      timestamp: DateTime.now().toUtc().subtract(Duration(minutes: minutesAgo)),
    );

void main() {
  group('LearnerAdaptationService', () {
    test('welcomes a learner without history without judging them', () {
      final advice = LearnerAdaptationService.buildAdvice([]);
      expect(advice.title, 'On commence doucement');
      expect(advice.lessonId, isNull);
    });

    test('suggests revisiting a lesson after repeated recent errors', () {
      final advice = LearnerAdaptationService.buildAdvice(
        [attempt('fractions', false, 1), attempt('fractions', false, 2), attempt('fractions', true, 3)],
        lessonTitles: {'fractions': 'Les fractions'},
      );
      expect(advice.lessonId, 'fractions');
      expect(advice.message, contains('Les fractions'));
      expect(advice.message, contains('Une erreur est une étape normale'));
    });

    test('encourages a learner after a recent success streak', () {
      final advice = LearnerAdaptationService.buildAdvice([
        attempt('geometry', true, 1),
        attempt('geometry', true, 2),
        attempt('geometry', true, 3),
        attempt('geometry', true, 4),
      ]);
      expect(advice.title, 'Tu prends confiance');
    });

    test('recognizes consolidated recent mastery', () {
      final advice = LearnerAdaptationService.buildAdvice([
        attempt('reading', true, 1),
        attempt('reading', false, 2),
        attempt('reading', true, 3),
        attempt('reading', true, 4),
        attempt('reading', true, 5),
        attempt('reading', true, 6),
      ]);
      expect(advice.title, 'Tes acquis se consolident');
    });

    test('uses only recent attempts when recommending a lesson', () {
      final recentSuccesses = List<ExerciseAttemptRecord>.generate(
        20,
        (index) => attempt('new_topic', true, index + 1),
      );
      final advice = LearnerAdaptationService.buildAdvice([
        ...recentSuccesses,
        attempt('old_topic', false, 21),
        attempt('old_topic', false, 22),
      ]);
      expect(advice.lessonId, isNull);
      expect(advice.title, 'Tu prends confiance');
    });

    test('sorts attempts by timestamp before identifying a recent success streak', () {
      final advice = LearnerAdaptationService.buildAdvice([
        attempt('fractions', false, 30),
        attempt('fractions', true, 4),
        attempt('fractions', true, 3),
        attempt('fractions', true, 2),
        attempt('fractions', true, 1),
      ]);
      expect(advice.title, 'Tu prends confiance');
    });
    test('ignores repeated mistakes older than the 30-day learning window', () {
      final now = DateTime.now().toUtc();
      final old = now.subtract(const Duration(days: 45));
      final advice = LearnerAdaptationService.buildAdvice([
        ExerciseAttemptRecord(
          exerciseId: 'old_1',
          lessonId: 'old_topic',
          isCorrect: false,
          timestamp: old,
        ),
        ExerciseAttemptRecord(
          exerciseId: 'old_2',
          lessonId: 'old_topic',
          isCorrect: false,
          timestamp: old.subtract(const Duration(minutes: 1)),
        ),
        attempt('current_topic', true, 1),
        attempt('current_topic', true, 2),
        attempt('current_topic', true, 3),
      ], now: now);
      expect(advice.lessonId, isNull);
      expect(advice.title, isNot('Une notion à retravailler'));
    });

    test('offers a gentle restart when all recorded practice is stale', () {
      final now = DateTime.now().toUtc();
      final old = now.subtract(const Duration(days: 40));
      final advice = LearnerAdaptationService.buildAdvice([
        ExerciseAttemptRecord(
          exerciseId: 'old_1',
          lessonId: 'old_topic',
          isCorrect: false,
          timestamp: old,
        ),
        ExerciseAttemptRecord(
          exerciseId: 'old_2',
          lessonId: 'old_topic',
          isCorrect: false,
          timestamp: old.subtract(const Duration(minutes: 1)),
        ),
      ], now: now);
      expect(advice.title, 'Reprenons progressivement');
      expect(advice.lessonId, isNull);
    });

    test('sorts attempts by timestamp before detecting a success streak', () {
      final now = DateTime.now().toUtc();
      final advice = LearnerAdaptationService.buildAdvice([
        attempt('topic', false, 5),
        attempt('topic', true, 1),
        attempt('topic', true, 2),
        attempt('topic', true, 3),
        attempt('topic', true, 4),
      ], now: now);
      expect(advice.title, 'Tu prends confiance');
    });

    test('adapts advice to a learner-reported reading barrier', () {
      final advice = LearnerAdaptationService.buildAdvice(
        [],
        learningBarrierCounts: {'lecture': 2},
      );
      expect(advice.title, 'Un appui pour lire');
      expect(advice.message, contains('lecture vocale'));
    });

    test('adapts advice to a learner-reported comprehension barrier', () {
      final advice = LearnerAdaptationService.buildAdvice(
        [attempt('topic', false, 1)],
        learningBarrierCounts: {'comprehension': 1},
      );
      expect(advice.title, 'Comprendre avant de répondre');
      expect(advice.message, contains('reformule-la'));
    });

    test('adapts advice to a learner-reported method barrier', () {
      final advice = LearnerAdaptationService.buildAdvice(
        [attempt('topic', true, 1)],
        learningBarrierCounts: {'methode': 3},
      );
      expect(advice.message, contains('exemple résolu'));
      expect(advice.title, 'Une méthode pas à pas');
    });

    test('chooses the most frequently reported valid barrier', () {
      final advice = LearnerAdaptationService.buildAdvice(
        [],
        learningBarrierCounts: {'lecture': 2, 'methode': 4, 'unknown': 99},
      );
      expect(advice.title, 'Une méthode pas à pas');
    });

    test('repeated errors remain priority and receive barrier-aware guidance', () {
      final advice = LearnerAdaptationService.buildAdvice(
        [attempt('fractions', false, 1), attempt('fractions', false, 2)],
        lessonTitles: {'fractions': 'Les fractions'},
        learningBarrierCounts: {'comprehension': 1},
      );
      expect(advice.lessonId, 'fractions');
      expect(advice.message, contains('reformule la consigne'));
    });

  });
}
