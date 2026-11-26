import 'package:flutter_test/flutter_test.dart';
import 'package:proftogo/data/models/models.dart';
import 'package:proftogo/data/sample/annual_core_catalog.dart';
import 'package:proftogo/data/sample/sample_data.dart';

void main() {
  test('6e annual lessons remain accessible in existing subject chapters', () {
    final mergedSubjects = mergeSubjectsByPath(demoSubjects, annualCoreSubjects.whereType<Subject>());
    final lessonPrefixes = <String, String>{
      'math': 'core_math_6e_',
      'fr': 'core_fr_6e_',
      'anglais': 'core_en_6e_',
      'svt': 'core_svt_6e_',
      'hist': 'core_hg_6e_',
    };
    final expectedLessons = <String, int>{
      'math': 5,
      'fr': 5,
      'anglais': 5,
      'svt': 5,
      'hist': 4,
    };
    final demoChapterIds = demoChapters.map((chapter) => chapter.id).toSet();

    for (final entry in lessonPrefixes.entries) {
      final subjectId = entry.key;
      final lessons = annualCoreLessons
          .where((lesson) => lesson.id.startsWith(entry.value))
          .toList();
      expect(lessons, hasLength(expectedLessons[subjectId]), reason: subjectId);
      expect(lessons.map((lesson) => lesson.id).toSet(), hasLength(lessons.length),
          reason: 'Les identifiants de leçons doivent être uniques pour $subjectId.');

      for (final lesson in lessons) {
        expect(demoChapterIds, contains(lesson.chapterId),
            reason: 'La leçon ${lesson.id} doit être reliée à un chapitre existant.');
        final chapter = demoChapters.firstWhere((item) => item.id == lesson.chapterId);
        expect(chapter.subjectId, subjectId,
            reason: 'La leçon ${lesson.id} doit rester dans la bonne matière.');
      }

      final lessonIds = lessons.map((lesson) => lesson.id).toSet();
      expect(
        annualCoreExercises.where((exercise) => lessonIds.contains(exercise.lessonId)),
        hasLength(lessons.length * 3),
        reason: 'Chaque leçon de $subjectId doit proposer trois exercices.',
      );

      final mergedMatches = mergedSubjects
          .where((subject) => subject.id == subjectId && subject.level == SchoolLevel.sixieme)
          .toList();
      expect(mergedMatches, hasLength(1),
          reason: 'Une seule carte de matière doit être affichée pour $subjectId.');
      final demoSubject = demoSubjects.firstWhere(
        (subject) => subject.id == subjectId && subject.level == SchoolLevel.sixieme,
      );
      final annualSubject = annualCoreSubjects.whereType<Subject>().firstWhere(
        (subject) => subject.id == subjectId && subject.level == SchoolLevel.sixieme,
      );
      final expectedTotal = demoSubject.totalChapters >= annualSubject.totalChapters
          ? demoSubject.totalChapters
          : annualSubject.totalChapters;
      expect(mergedMatches.single.totalChapters, expectedTotal,
          reason: 'Le total des chapitres ne doit pas être augmenté par des leçons ajoutées à des chapitres existants.');
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
