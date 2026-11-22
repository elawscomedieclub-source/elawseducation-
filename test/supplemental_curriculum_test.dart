import 'package:flutter_test/flutter_test.dart';
import 'package:proftogo/data/models/models.dart';
import 'package:proftogo/data/sample/supplemental_curriculum.dart';

void main() {
  group('Cours bonus ProfTogo', () {
    test('chaque niveau scolaire possède des leçons bonus', () {
      for (final level in SchoolLevel.values) {
        expect(
          supplementalLessons.any((lesson) => lesson.level == level),
          isTrue,
          reason: 'Leçons bonus manquantes pour ${level.label}',
        );
      }
    });

    test('les identifiants des leçons et questions sont uniques', () {
      final lessonIds = supplementalLessons.map((lesson) => lesson.id).toList();
      final questionIds = supplementalLessons.expand((lesson) => lesson.questions).map((question) => question.id).toList();
      expect(lessonIds.toSet().length, lessonIds.length);
      expect(questionIds.toSet().length, questionIds.length);
    });

    test('chaque leçon possède au moins deux exercices valides', () {
      for (final lesson in supplementalLessons) {
        expect(lesson.questions.length, greaterThanOrEqualTo(2), reason: lesson.title);
        expect(lesson.explanation.trim(), isNotEmpty, reason: lesson.title);
        expect(lesson.example.trim(), isNotEmpty, reason: lesson.title);
        for (final question in lesson.questions) {
          expect(question.prompt.trim(), isNotEmpty);
          expect(question.choices.length, greaterThanOrEqualTo(2));
          expect(question.correctIndex, inInclusiveRange(0, question.choices.length - 1));
          expect(question.explanation.trim(), isNotEmpty);
        }
      }
    });
  });
}
