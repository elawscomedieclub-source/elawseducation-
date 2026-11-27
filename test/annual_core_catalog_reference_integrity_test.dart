import 'package:flutter_test/flutter_test.dart';
import 'package:proftogo/data/sample/annual_core_catalog.dart';

void main() {
  group('Références croisées du catalogue annuel principal', () {
    test('les identifiants des matières, chapitres, leçons et exercices sont uniques', () {
      expect(annualCoreSubjects.map((item) => item.id).toSet(),
          hasLength(annualCoreSubjects.length));
      expect(annualCoreChapters.map((item) => item.id).toSet(),
          hasLength(annualCoreChapters.length));
      expect(annualCoreLessons.map((item) => item.id).toSet(),
          hasLength(annualCoreLessons.length));
      expect(annualCoreExercises.map((item) => item.id).toSet(),
          hasLength(annualCoreExercises.length));
    });

    test('chaque chapitre référence une matière existante et contient des leçons', () {
      final subjectIds = annualCoreSubjects.map((item) => item.id).toSet();
      final lessonChapterIds =
          annualCoreLessons.map((item) => item.chapterId).toSet();

      for (final chapter in annualCoreChapters) {
        expect(subjectIds, contains(chapter.subjectId),
            reason: 'Matière absente pour le chapitre ${chapter.id}');
        expect(lessonChapterIds, contains(chapter.id),
            reason: 'Aucune leçon liée au chapitre ${chapter.id}');
        expect(chapter.term, inInclusiveRange(1, 3),
            reason: 'Trimestre invalide pour ${chapter.id}');
        expect(chapter.title.trim(), isNotEmpty,
            reason: 'Titre vide pour ${chapter.id}');
      }
    });

    test('chaque leçon référence un chapitre existant et possède un exercice', () {
      final chapterIds = annualCoreChapters.map((item) => item.id).toSet();
      final exerciseLessonIds =
          annualCoreExercises.map((item) => item.lessonId).toSet();

      for (final lesson in annualCoreLessons) {
        expect(chapterIds, contains(lesson.chapterId),
            reason: 'Chapitre absent pour la leçon ${lesson.id}');
        expect(exerciseLessonIds, contains(lesson.id),
            reason: 'Aucun exercice lié à la leçon ${lesson.id}');
        expect(lesson.title.trim(), isNotEmpty,
            reason: 'Titre vide pour ${lesson.id}');
        expect(lesson.content.trim(), isNotEmpty,
            reason: 'Cours vide pour ${lesson.id}');
        expect(lesson.summary.trim(), isNotEmpty,
            reason: 'Résumé vide pour ${lesson.id}');
      }
    });

    test('chaque exercice référence une leçon et possède une correction exploitable', () {
      final lessonIds = annualCoreLessons.map((item) => item.id).toSet();

      for (final exercise in annualCoreExercises) {
        expect(lessonIds, contains(exercise.lessonId),
            reason: 'Leçon absente pour l’exercice ${exercise.id}');
        expect(exercise.question.trim(), isNotEmpty,
            reason: 'Énoncé vide pour ${exercise.id}');
        expect(exercise.options.length, greaterThanOrEqualTo(2),
            reason: 'Moins de deux choix pour ${exercise.id}');
        final options = exercise.options
            .map((option) => option.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase())
            .toList();
        expect(options.every((option) => option.isNotEmpty), isTrue,
            reason: 'Choix vide pour ${exercise.id}');
        expect(options.toSet(), hasLength(options.length),
            reason: 'Choix dupliqués pour ${exercise.id}');
        expect(exercise.correctIndex, inInclusiveRange(0, options.length - 1),
            reason: 'Réponse attendue invalide pour ${exercise.id}');
        expect(exercise.explanation.trim(), isNotEmpty,
            reason: 'Explication absente pour ${exercise.id}');
      }
    });
  });
}
