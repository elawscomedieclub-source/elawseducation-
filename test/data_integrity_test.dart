import 'package:flutter_test/flutter_test.dart';
import 'package:proftogo/data/sample/sample_data.dart';

void main() {
  group('Intégrité de la base pédagogique ProfTogo', () {
    test('les identifiants des matières, chapitres, leçons et exercices sont uniques', () {
      expect(_idsAreUnique(demoSubjects.map((item) => item.id)), isTrue);
      expect(_idsAreUnique(demoChapters.map((item) => item.id)), isTrue);
      expect(_idsAreUnique(demoLessons.map((item) => item.id)), isTrue);
      expect(_idsAreUnique(demoExercises.map((item) => item.id)), isTrue);
    });

    test('chaque chapitre appartient à une matière existante', () {
      final subjectIds = demoSubjects.map((item) => item.id).toSet();
      for (final chapter in demoChapters) {
        expect(subjectIds, contains(chapter.subjectId),
            reason: 'Chapitre ${chapter.id}: matière ${chapter.subjectId} introuvable');
      }
    });

    test('chaque leçon appartient à un chapitre existant', () {
      final chapterIds = demoChapters.map((item) => item.id).toSet();
      for (final lesson in demoLessons) {
        expect(chapterIds, contains(lesson.chapterId),
            reason: 'Leçon ${lesson.id}: chapitre ${lesson.chapterId} introuvable');
      }
    });

    test('chaque exercice appartient à une leçon existante', () {
      final lessonIds = demoLessons.map((item) => item.id).toSet();
      for (final exercise in demoExercises) {
        expect(lessonIds, contains(exercise.lessonId),
            reason: 'Exercice ${exercise.id}: leçon ${exercise.lessonId} introuvable');
      }
    });

    test('chaque exercice possède des choix et une bonne réponse valide', () {
      for (final exercise in demoExercises) {
        expect(exercise.options, isNotEmpty,
            reason: 'Exercice ${exercise.id} sans proposition');
        expect(exercise.correctIndex, inInclusiveRange(0, exercise.options.length - 1),
            reason: 'Indice de réponse incorrect pour ${exercise.id}');
        expect(exercise.question.trim(), isNotEmpty,
            reason: 'Question vide pour ${exercise.id}');
        expect(exercise.explanation.trim(), isNotEmpty,
            reason: 'Explication vide pour ${exercise.id}');
      }
    });

    test('chaque leçon contient un cours et un résumé', () {
      for (final lesson in demoLessons) {
        expect(lesson.content.trim(), isNotEmpty,
            reason: 'Cours vide pour ${lesson.id}');
        expect(lesson.summary.trim(), isNotEmpty,
            reason: 'Résumé vide pour ${lesson.id}');
      }
    });

    test('la base contient bien les quatre familles de parcours du lycée', () {
      final tracks = demoSubjects
          .where((subject) => subject.track != null)
          .map((subject) => subject.track)
          .toSet();
      expect(tracks.length, 4);
    });

    test('les compteurs des matières correspondent aux chapitres réels', () {
      for (final subject in demoSubjects) {
        final actual = demoChapters.where((item) => item.subjectId == subject.id).length;
        expect(subject.totalChapters, actual,
            reason: 'Compteur incorrect pour ${subject.id}');
        expect(actual, greaterThan(0),
            reason: 'La matière ${subject.id} ne possède aucun chapitre');
      }
    });

    test('les compteurs des chapitres correspondent aux leçons réelles', () {
      for (final chapter in demoChapters) {
        final actual = demoLessons.where((item) => item.chapterId == chapter.id).length;
        expect(chapter.totalLessons, actual,
            reason: 'Compteur incorrect pour ${chapter.id}');
      }
    });
  });
}

bool _idsAreUnique(Iterable<String> ids) {
  final values = ids.toList();
  return values.length == values.toSet().length;
}
