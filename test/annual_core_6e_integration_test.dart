import 'package:flutter_test/flutter_test.dart';
import 'package:proftogo/data/models/models.dart';
import 'package:proftogo/data/sample/annual_core_catalog.dart';
import 'package:proftogo/data/sample/sample_data.dart';

void main() {
  test('6e core lessons are connected to existing subject pages and chapter totals', () {
    final mergedSubjects = mergeSubjectsByPath(demoSubjects, annualCoreSubjects);
    final expectedChapterCounts = <String, int>{
      'math': 5,
      'fr': 5,
      'anglais': 5,
      'svt': 5,
      'hist': 4,
    };

    for (final entry in expectedChapterCounts.entries) {
      final subjectId = entry.key;
      final coreChapters = annualCoreChapters
          .where((chapter) =>
              chapter.subjectId == subjectId &&
              chapter.id.contains('_6e_unit_'))
          .toList();
      expect(coreChapters, hasLength(entry.value), reason: subjectId);
      expect(coreChapters.map((chapter) => chapter.id).toSet(),
          hasLength(entry.value), reason: 'Les identifiants de chapitres doivent être uniques.');

      final chapterIds = coreChapters.map((chapter) => chapter.id).toSet();
      final lessons = annualCoreLessons
          .where((lesson) => chapterIds.contains(lesson.chapterId))
          .toList();
      expect(lessons, hasLength(entry.value), reason: subjectId);
      expect(lessons.map((lesson) => lesson.id).toSet(), hasLength(entry.value));

      final lessonIds = lessons.map((lesson) => lesson.id).toSet();
      expect(
        annualCoreExercises.where((exercise) => lessonIds.contains(exercise.lessonId)),
        hasLength(entry.value * 3),
        reason: 'Chaque leçon de $subjectId doit proposer trois exercices.',
      );

      final demoChapterCount =
          demoChapters.where((chapter) => chapter.subjectId == subjectId).length;
      final mergedSubject = mergedSubjects.firstWhere(
        (subject) => subject.id == subjectId && subject.level == SchoolLevel.sixieme,
      );
      expect(
        mergedSubject.totalChapters,
        demoChapterCount + entry.value,
        reason: 'Le total affiché doit correspondre aux chapitres réellement accessibles de $subjectId.',
      );
    }
  });

  test('every annual core lesson points to an available chapter', () {
    final chapterIds = <String>{
      ...demoChapters.map((chapter) => chapter.id),
      ...annualCoreChapters.map((chapter) => chapter.id),
    };
    for (final lesson in annualCoreLessons) {
      expect(chapterIds, contains(lesson.chapterId), reason: lesson.id);
    }
  });
}
