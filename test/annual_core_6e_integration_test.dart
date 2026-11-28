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
    final expected = <String, int>{'math': 14, 'fr': 12, 'anglais': 12, 'svt': 13, 'hist': 10};
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
  test('5e annual math extension keeps units 7-10 and correct trimester placement', () {
    final extensionIds = <String>{
      'ptg_year_cinq_math_8', 'ptg_year_cinq_math_9',
      'ptg_year_cinq_math_10', 'ptg_year_cinq_math_11',
    };
    final chapters = annualCoreChapters
        .where((chapter) => extensionIds.contains(chapter.id))
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));
    expect(chapters, hasLength(4));
    expect(chapters.map((chapter) => chapter.order), [7, 8, 9, 10]);
    for (final chapter in chapters) {
      expect(chapter.term, termForAnnualUnit(chapter.order, 10));
    }
  });
  test('5e French, English and SVT annual lessons and exercises stay linked', () {
    final chapterIds = <String>{
      ...demoChapters.map((chapter) => chapter.id),
      ...annualCoreChapters.map((chapter) => chapter.id),
    };
    final expectedByPrefix = <String, int>{
      'core_fr_5e_': 6,
      'core_en_5e_': 6,
      'core_svt_5e_': 6,
    };
    for (final entry in expectedByPrefix.entries) {
      final lessons = annualCoreLessons
          .where((lesson) => lesson.id.startsWith(entry.key))
          .toList();
      expect(lessons, hasLength(entry.value), reason: entry.key);
      expect(lessons.map((lesson) => lesson.id).toSet(),
          hasLength(entry.value), reason: entry.key);
      final lessonIds = lessons.map((lesson) => lesson.id).toSet();
      for (final lesson in lessons) {
        expect(chapterIds, contains(lesson.chapterId), reason: lesson.id);
      }
      expect(
        annualCoreExercises.where((exercise) => lessonIds.contains(exercise.lessonId)),
        hasLength(entry.value *  3),
        reason: entry.key,
      );
    }
  });
}
