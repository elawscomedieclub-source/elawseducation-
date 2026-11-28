import 'package:flutter_test/flutter_test.dart';
import 'package:proftogo/data/models/models.dart';
import 'package:proftogo/data/sample/annual_core_catalog.dart';
import 'package:proftogo/data/sample/sample_data.dart';

void main() {
  test('6e core lessons are connected to existing subject pages and chapter totals', () {
    final mergedSubjects = mergeSubjectsByPath(demoSubjects, annualCoreSubjects.whereType<Subject>());
    final prefixes = <String, String>{
      'math': 'core_math_6e_', 'fr': 'core_fr_6e_',
      'anglais': 'core_en_6e_', 'svt': 'core_svt_6e_', 'hist': 'core_hg_6e_',
    };
    final expected = <String, int>{'math': 14, 'fr': 12, 'anglais': 12, 'svt': 13, 'hist': 4};
    final allChapterIds = <String>{
      ...demoChapters.map((chapter) => chapter.id),
      ...annualCoreChapters.map((chapter) => chapter.id),
    };
    for (final entry in prefixes.entries) {
      final subjectId = entry.key;
      final count = expected[subjectId]!;
      final lessons = annualCoreLessons.where((lesson) => lesson.id.startsWith(entry.value)).toList();
      expect(lessons, hasLength(count), reason: subjectId);
      expect(lessons.map((lesson) => lesson.id).toSet(), hasLength(count));
      final chapters = annualCoreChapters.where((chapter) =>
          chapter.subjectId == subjectId && chapter.id.contains('_6e_unit_')).toList();
      expect(chapters, hasLength(count), reason: subjectId);
      expect(chapters.map((chapter) => chapter.id).toSet(), hasLength(count));
      final chapterIds = chapters.map((chapter) => chapter.id).toSet();
      for (final lesson in lessons) {
        expect(allChapterIds, contains(lesson.chapterId), reason: lesson.id);
        expect(chapterIds, contains(lesson.chapterId), reason: lesson.id);
      }
      final lessonIds = lessons.map((lesson) => lesson.id).toSet();
      expect(annualCoreExercises.where((exercise) => lessonIds.contains(exercise.lessonId)),
          hasLength(count * 3), reason: subjectId);
      final demoSubject = demoSubjects.firstWhere((subject) =>
          subject.id == subjectId && subject.level == SchoolLevel.sixieme);
      final annualSubject = annualCoreSubjects.whereType<Subject>().firstWhere((subject) =>
          subject.id == subjectId && subject.level == SchoolLevel.sixieme);
      final expectedTotal = demoSubject.totalChapters + count;
      expect(annualSubject.totalChapters, expectedTotal, reason: subjectId);
      final merged = mergedSubjects.where((subject) =>
          subject.id == subjectId && subject.level == SchoolLevel.sixieme).toList();
      expect(merged, hasLength(1), reason: subjectId);
      expect(merged.single.totalChapters, expectedTotal, reason: subjectId);
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
