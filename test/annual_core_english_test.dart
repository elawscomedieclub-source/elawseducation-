import 'package:flutter_test/flutter_test.dart';
import 'package:elawseducation/data/models/models.dart';
import 'package:elawseducation/data/sample/annual_core_english.dart';

void main() {
  test('primary English course covers CP1 through CM2 as core lessons', () {
    expect(annualEnglishSubjects.map((s) => s.level).toSet(), {
      SchoolLevel.cp1, SchoolLevel.cp2, SchoolLevel.ce1,
      SchoolLevel.ce2, SchoolLevel.cm1, SchoolLevel.cm2,
    });
    expect(annualEnglishUnits, hasLength(18));
    expect(annualEnglishLessons, hasLength(18));
    expect(annualEnglishChapters, hasLength(18));
    expect(annualEnglishExercises, hasLength(54));
  });

  test('core English units have unique IDs and complete questions', () {
    expect(annualEnglishLessons.map((l) => l.id).toSet(), hasLength(18));
    expect(annualEnglishExercises.map((e) => e.id).toSet(), hasLength(54));
    for (final lesson in annualEnglishLessons) {
      expect(lesson.title.trim(), isNotEmpty);
      expect(lesson.content.trim(), isNotEmpty);
      expect(lesson.summary.trim(), isNotEmpty);
      final questions = annualEnglishExercises.where((e) => e.lessonId == lesson.id);
      expect(questions, hasLength(3));
      for (final question in questions) {
        expect(question.options.length, greaterThanOrEqualTo(3));
        expect(question.correctIndex, inInclusiveRange(0, question.options.length - 1));
        expect(question.explanation.trim(), isNotEmpty);
      }
    }
  });
}
