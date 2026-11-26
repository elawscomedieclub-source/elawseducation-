import 'package:flutter_test/flutter_test.dart';
import 'package:proftogo/core/learner_adaptation_service.dart';
import 'package:elawseducation/core/progress_service.dart';

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
      final advice = LearnerAdaptationService.buildAdvice([
        attempt('new_topic', true, 1),
        attempt('new_topic', true, 2),
        attempt('new_topic', true, 3),
        attempt('old_topic', false, 4),
        attempt('old_topic', false, 5),
      ]);
      expect(advice.lessonId, isNull);
      expect(advice.title, 'Avançons à ton rythme');
    });
  });
}
