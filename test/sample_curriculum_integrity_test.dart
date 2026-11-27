import 'package:flutter_test/flutter_test.dart';
import 'package:proftogo/data/sample/sample_data.dart';
import 'package:proftogo/data/models/models.dart';
import 'package:proftogo/data/sample/annual_core_catalog.dart';

void main() {
  test('the current demo chapters do not exceed each subject annual plan', () {
    for (final subject in demoSubjects) {
      final count = demoChapters.where((chapter) => chapter.subjectId == subject.id).length;
      expect(
        count,
        greaterThan(0),
        reason: 'La matière ${subject.name} (${subject.level.name}) doit avoir au moins un chapitre accessible.',
      );
      expect(
        count,
        lessThanOrEqualTo(subject.totalChapters),
        reason: 'La matière ${subject.name} (${subject.level.name}) ne doit pas dépasser son total annuel planifié de ${subject.totalChapters} chapitres.',
      );
    }
  });

  test('every demo chapter is unique and has at least one lesson', () {
    final chapterIds = demoChapters.map((chapter) => chapter.id).toSet();
    expect(chapterIds.length, demoChapters.length, reason: 'Les identifiants de chapitres doivent être uniques.');

    final lessonIds = demoLessons.map((lesson) => lesson.id).toSet();
    expect(lessonIds.length, demoLessons.length, reason: 'Les identifiants de leçons doivent être uniques.');

    for (final chapter in demoChapters) {
      expect(
        demoLessons.any((lesson) => lesson.chapterId == chapter.id),
        isTrue,
        reason: 'Le chapitre ${chapter.id} doit contenir au moins une leçon.',
      );
    }
    for (final lesson in demoLessons) {
      expect(
        chapterIds.contains(lesson.chapterId),
        isTrue,
        reason: 'La leçon ${lesson.id} doit pointer vers un chapitre existant.',
      );
    }
  });

  test('every demo lesson has exercises and all exercise links are valid', () {
    final lessonIds = demoLessons.map((lesson) => lesson.id).toSet();
    final exerciseIds = demoExercises.map((exercise) => exercise.id).toSet();
    expect(exerciseIds.length, demoExercises.length, reason: 'Les identifiants d’exercices doivent être uniques.');

    for (final lesson in demoLessons) {
      expect(
        demoExercises.any((exercise) => exercise.lessonId == lesson.id),
        isTrue,
        reason: 'La leçon ${lesson.id} doit proposer au moins un exercice.',
      );
    }
    for (final exercise in demoExercises) {
      expect(
        lessonIds.contains(exercise.lessonId),
        isTrue,
        reason: 'L’exercice ${exercise.id} doit pointer vers une leçon existante.',
      );
    }
  });

  test('annual core lessons and exercises link to existing curriculum records', () {
    final chapterIds = {
      ...demoChapters.map((chapter) => chapter.id),
      ...annualCoreChapters.map((chapter) => chapter.id),
    };
    final lessonIds = annualCoreLessons.map((lesson) => lesson.id).toSet();
    final chapterCoreIds = annualCoreChapters.map((chapter) => chapter.id).toSet();
    final exerciseIds = annualCoreExercises.map((exercise) => exercise.id).toSet();

    expect(chapterCoreIds.length, annualCoreChapters.length, reason: 'Les chapitres annuels doivent avoir des identifiants uniques.');
    expect(lessonIds.length, annualCoreLessons.length, reason: 'Les leçons annuelles doivent avoir des identifiants uniques.');
    expect(exerciseIds.length, annualCoreExercises.length, reason: 'Les exercices annuels doivent avoir des identifiants uniques.');

    for (final lesson in annualCoreLessons) {
      expect(
        chapterIds.contains(lesson.chapterId),
        isTrue,
        reason: 'La leçon annuelle ${lesson.id} doit pointer vers un chapitre existant.',
      );
    }
    for (final exercise in annualCoreExercises) {
      expect(
        lessonIds.contains(exercise.lessonId),
        isTrue,
        reason: 'L’exercice annuel ${exercise.id} doit pointer vers une leçon annuelle existante.',
      );
    }
  });

  test('every annual-core chapter is attached to a declared subject within its yearly chapter plan', () {
    final declaredSubjects = <Subject>[
      ...demoSubjects,
      ...annualCoreSubjects,
    ];
    final chaptersBySubject = <String, List<Chapter>>{};
    for (final chapter in annualCoreChapters) {
      chaptersBySubject.putIfAbsent(chapter.subjectId, () => <Chapter>[]).add(chapter);
    }

    for (final entry in chaptersBySubject.entries) {
      final matches = declaredSubjects
          .where((subject) => subject.id == entry.key)
          .toList();
      expect(matches, isNotEmpty,
          reason: 'Matière non déclarée pour les chapitres annuels : ${entry.key}');
      final planned = matches.fold<int>(
          0, (maximum, subject) =>
              subject.totalChapters > maximum ? subject.totalChapters : maximum);
      expect(entry.value.length, lessThanOrEqualTo(planned),
          reason: 'Les chapitres annuels dépassent le plan déclaré pour ${entry.key}');
    }
  });

}
