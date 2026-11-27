import 'package:flutter_test/flutter_test.dart';
import 'package:proftogo/data/sample/annual_core_catalog.dart';

void main() {
  test('every annual core exercise has a valid question, options, answer and explanation', () {
    final ids = annualCoreExercises.map((exercise) => exercise.id).toSet();
    expect(ids, hasLength(annualCoreExercises.length));
    for (final exercise in annualCoreExercises) {
      expect(exercise.question.trim(), isNotEmpty, reason: exercise.id);
      expect(exercise.options.length, greaterThanOrEqualTo(2), reason: exercise.id);
      final normalized = exercise.options
          .map((option) => option.trim().replaceAll(RegExp(r'\s+'), ' '))
          .toList();
      expect(normalized.every((option) => option.isNotEmpty), isTrue,
          reason: 'Option vide : ${exercise.id}');
      expect(normalized.toSet(), hasLength(normalized.length),
          reason: 'Options identiques : ${exercise.id}');
      expect(exercise.correctIndex, inInclusiveRange(0, normalized.length - 1),
          reason: 'Index de réponse incorrect : ${exercise.id}');
      expect(exercise.explanation.trim(), isNotEmpty,
          reason: 'Explication manquante : ${exercise.id}');
    }
  });

  test('every annual core lesson has at least one linked exercise', () {
    final exerciseLessonIds =
        annualCoreExercises.map((exercise) => exercise.lessonId).toSet();
    for (final lesson in annualCoreLessons) {
      expect(exerciseLessonIds, contains(lesson.id), reason: lesson.id);
    }
  });
}
