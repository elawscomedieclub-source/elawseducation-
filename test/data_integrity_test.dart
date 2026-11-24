import 'package:flutter_test/flutter_test.dart';
import 'package:proftogo/data/sample/sample_data.dart';
import 'package:proftogo/data/sample/supplemental_curriculum.dart';
import 'package:proftogo/data/models/models.dart';
import 'package:proftogo/features/subjects/ce1_completion_screen.dart';
import 'package:proftogo/features/subjects/ce2_completion_screen.dart';
import 'package:proftogo/features/subjects/cm1_completion_screen.dart';
import 'package:proftogo/features/subjects/cm2_completion_screen.dart';
import 'package:proftogo/features/subjects/sixieme_completion_screen.dart';
import 'package:proftogo/features/subjects/cinquieme_completion_screen.dart';
import 'package:proftogo/features/subjects/quatrieme_completion_screen.dart';
import 'package:proftogo/features/subjects/troisieme_completion_screen.dart';
import 'package:proftogo/features/subjects/seconde_completion_screen.dart';
import 'package:proftogo/features/subjects/premiere_completion_screen.dart';
import 'package:proftogo/features/subjects/terminale_completion_screen.dart';

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

    test('chaque niveau scolaire possède au moins une matière', () {
      for (final level in SchoolLevel.values) {
        expect(
          demoSubjects.any((subject) => subject.level == level),
          isTrue,
          reason: 'Aucune matière disponible pour ${level.label}',
        );
      }
    });

    test('chaque série du lycée possède des matières dans les trois classes', () {
      const seriesByTrack = <SchoolTrack, List<String>>{
        SchoolTrack.generalLiterary: ['A4'],
        SchoolTrack.scientific: ['C', 'D'],
        SchoolTrack.technicalTertiary: ['G1', 'G2', 'G3'],
        SchoolTrack.technicalIndustrial: ['E', 'F1', 'F2', 'F3', 'F4', 'Ti/1'],
      };
      for (final level in [
        SchoolLevel.seconde,
        SchoolLevel.premiere,
        SchoolLevel.terminale,
      ]) {
        for (final entry in seriesByTrack.entries) {
          for (final series in entry.value) {
            expect(
              demoSubjects.any((subject) =>
                  subject.level == level &&
                  subject.track == entry.key &&
                  subject.series == series),
              isTrue,
              reason: 'Matière absente : ${level.label}, ${entry.key.label}, série $series',
            );
          }
        }
      }
    });

    test('le filtrage du parcours ne mélange pas les séries du lycée', () {
      for (final level in [
        SchoolLevel.seconde,
        SchoolLevel.premiere,
        SchoolLevel.terminale,
      ]) {
        for (final track in SchoolTrack.values) {
          final allowedSeries = switch (track) {
            SchoolTrack.generalLiterary => ['A4'],
            SchoolTrack.scientific => ['C', 'D'],
            SchoolTrack.technicalTertiary => ['G1', 'G2', 'G3'],
            SchoolTrack.technicalIndustrial => ['E', 'F1', 'F2', 'F3', 'F4', 'Ti/1'],
          };
          for (final series in allowedSeries) {
            final visible = demoSubjects.where((subject) =>
                subjectMatchesPath(subject, level, track, series));
            expect(
              visible.where((subject) => subject.track != null).every(
                  (subject) => subject.track == track &&
                      (subject.series == null || subject.series == series)),
              isTrue,
              reason: 'Mélange de parcours détecté pour ${level.label}, série $series',
            );
            expect(
              visible.any((subject) =>
                  subject.track == track && subject.series == series),
              isTrue,
              reason: 'Aucune matière spécifique pour ${level.label}, série $series',
            );
          }
        }
      }
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

    test('chaque matière couvre les trois trimestres', () {
      for (final chapter in demoChapters) {
        expect(chapter.term, inInclusiveRange(1, 3), reason: 'Trimestre invalide pour ${chapter.id}');
      }
      for (final subject in demoSubjects) {
        final terms = demoChapters.where((chapter) => chapter.subjectId == subject.id).map((chapter) => chapter.term).toSet();
        expect(terms, containsAll([1, 2, 3]), reason: 'Trimestre manquant pour ${subject.id}');
      }
    });

    test('chaque chapitre contient au moins une leçon', () {
      for (final chapter in demoChapters) {
        expect(
          demoLessons.any((lesson) => lesson.chapterId == chapter.id),
          isTrue,
          reason: 'Aucune leçon dans le chapitre ${chapter.id}',
        );
      }
    });

    test('chaque leçon propose au moins un exercice', () {
      for (final lesson in demoLessons) {
        expect(
          demoExercises.any((exercise) => exercise.lessonId == lesson.id),
          isTrue,
          reason: 'Aucun exercice pour la leçon ${lesson.id}',
        );
      }
    });

    test('chaque niveau possède une banque minimale de révision', () {
      for (final level in SchoolLevel.values) {
        final subjectIds = demoSubjects
            .where((subject) => subject.level == level)
            .map((subject) => subject.id)
            .toSet();
        final chapterIds = demoChapters
            .where((chapter) => subjectIds.contains(chapter.subjectId))
            .map((chapter) => chapter.id)
            .toSet();
        final lessonIds = demoLessons
            .where((lesson) => chapterIds.contains(lesson.chapterId))
            .map((lesson) => lesson.id)
            .toSet();
        final count = demoExercises
            .where((exercise) => lessonIds.contains(exercise.lessonId))
            .length;
        expect(count, greaterThanOrEqualTo(20),
            reason: 'Banque d’exercices trop faible pour ${level.label}');
      }
    });

    test('les choix de réponse ne sont pas dupliqués à l’identique', () {
      for (final exercise in demoExercises) {
        final options = exercise.options.map((option) => option.trim()).toList();
        expect(options.toSet().length, options.length,
            reason: 'Choix dupliqué dans ${exercise.id}');
      }
    });

    test('les choix de réponse restent distincts sans tenir compte des espaces et majuscules', () {
      for (final exercise in demoExercises) {
        final normalized = exercise.options
            .map((option) => option.trim().toLowerCase())
            .toList();
        expect(normalized.toSet().length, normalized.length,
            reason: 'Choix identiques après normalisation dans ${exercise.id}');
      }
    });
    test('les compléments CE1 à 5ème couvrent les trois trimestres', () {
      final modules = [
        (name: 'CE1', count: Ce1CompletionScreen.unitCount, lessons: Ce1CompletionScreen.lessonCount, perTerm: 5, pool: Ce1CompletionScreen.assessmentExercisesForTerm),
        (name: 'CE2', count: Ce2CompletionScreen.unitCount, lessons: Ce2CompletionScreen.lessonCount, perTerm: 5, pool: Ce2CompletionScreen.assessmentExercisesForTerm),
        (name: 'CM1', count: Cm1CompletionScreen.unitCount, lessons: Cm1CompletionScreen.lessonCount, perTerm: 5, pool: Cm1CompletionScreen.assessmentExercisesForTerm),
        (name: 'CM2', count: Cm2CompletionScreen.unitCount, lessons: Cm2CompletionScreen.lessonCount, perTerm: 5, pool: Cm2CompletionScreen.assessmentExercisesForTerm),
        (name: '6ème', count: SixiemeCompletionScreen.unitCount, lessons: SixiemeCompletionScreen.lessonCount, perTerm: 6, pool: SixiemeCompletionScreen.assessmentExercisesForTerm),
        (name: '5ème', count: CinquiemeCompletionScreen.unitCount, lessons: CinquiemeCompletionScreen.lessonCount, perTerm: 6, pool: CinquiemeCompletionScreen.assessmentExercisesForTerm),
        (name: '4ème', count: QuatriemeCompletionScreen.unitCount, lessons: QuatriemeCompletionScreen.lessonCount, perTerm: 6, pool: QuatriemeCompletionScreen.assessmentExercisesForTerm),
        (name: '3ème', count: TroisiemeCompletionScreen.unitCount, lessons: TroisiemeCompletionScreen.lessonCount, perTerm: 6, pool: TroisiemeCompletionScreen.assessmentExercisesForTerm),
        (name: 'Seconde', count: SecondeCompletionScreen.unitCount, lessons: SecondeCompletionScreen.lessonCount, perTerm: 6, pool: SecondeCompletionScreen.assessmentExercisesForTerm),
        (name: 'Première', count: PremiereCompletionScreen.unitCount, lessons: PremiereCompletionScreen.lessonCount, perTerm: 6, pool: PremiereCompletionScreen.assessmentExercisesForTerm),
        (name: 'Terminale', count: TerminaleCompletionScreen.unitCount, lessons: TerminaleCompletionScreen.lessonCount, perTerm: 6, pool: TerminaleCompletionScreen.assessmentExercisesForTerm),
      ];
      for (final module in modules) {
        expect(module.count, module.perTerm * 3, reason: '${module.name}: unités annuelles attendues');
        expect(module.lessons, module.perTerm * 3, reason: '${module.name}: leçons manquantes');
        for (var term = 1; term <= 3; term++) {
          final exercises = module.pool(term);
          expect(exercises, hasLength(module.perTerm), reason: '${module.name}: exercices attendus au trimestre $term');
          expect(exercises.every((e) => e.options.length >= 3), isTrue);
          expect(exercises.every((e) => e.question.trim().isNotEmpty), isTrue,
              reason: '${module.name}: question vide au trimestre $term');
          expect(exercises.every((e) => e.options.every((option) => option.trim().isNotEmpty)), isTrue,
              reason: '${module.name}: choix vide au trimestre $term');
          expect(exercises.every((e) {
            final normalized = e.options.map((option) => option.trim().toLowerCase()).toSet();
            return normalized.length == e.options.length;
          }), isTrue, reason: '${module.name}: choix dupliqués au trimestre $term');
          expect(exercises.every((e) => e.correctIndex >= 0 && e.correctIndex < e.options.length), isTrue);
          expect(exercises.every((e) => e.explanation.trim().isNotEmpty), isTrue);
        }
      }
    });


    test('les cours bonus couvrent chaque niveau scolaire et ne réutilisent pas les IDs des exercices principaux', () {
      for (final level in SchoolLevel.values) {
        expect(
          supplementalLessons.any((lesson) => lesson.level == level),
          isTrue,
          reason: 'Aucun cours bonus pour ${level.label}',
        );
      }
      final mainExerciseIds = demoExercises.map((exercise) => exercise.id).toSet();
      for (final lesson in supplementalLessons) {
        for (final question in lesson.questions) {
          expect(
            mainExerciseIds,
            isNot(contains(question.id)),
            reason: 'ID de question partagé avec un exercice principal : ${question.id}',
          );
        }
      }
    });

    test('les cours bonus ont des identifiants uniques et des questions complètes', () {
      expect(
        _idsAreUnique(supplementalLessons.map((lesson) => lesson.id)),
        isTrue,
        reason: 'Identifiant de cours bonus dupliqué',
      );
      final questionIds = supplementalLessons.expand((lesson) =>
          lesson.questions.map((question) => question.id));
      expect(_idsAreUnique(questionIds), isTrue,
          reason: 'Identifiant de question bonus dupliqué');

      for (final lesson in supplementalLessons) {
        expect(lesson.title.trim(), isNotEmpty,
            reason: 'Titre vide pour ${lesson.id}');
        expect(lesson.explanation.trim(), isNotEmpty,
            reason: 'Explication vide pour ${lesson.id}');
        expect(lesson.example.trim(), isNotEmpty,
            reason: 'Exemple vide pour ${lesson.id}');
        expect(lesson.questions, isNotEmpty,
            reason: 'Aucune question pour ${lesson.id}');
        for (final question in lesson.questions) {
          expect(question.prompt.trim(), isNotEmpty,
              reason: 'Question vide : ${question.id}');
          expect(question.choices.length, greaterThanOrEqualTo(2),
              reason: 'Pas assez de choix : ${question.id}');
          expect(question.choices.every((choice) => choice.trim().isNotEmpty),
              isTrue,
              reason: 'Choix vide dans la question bonus : ${question.id}');
          final normalizedChoices = question.choices
              .map((choice) => choice.trim().toLowerCase())
              .toList();
          expect(normalizedChoices.toSet().length, normalizedChoices.length,
              reason: 'Choix dupliqués dans la question bonus : ${question.id}');
          expect(question.correctIndex,
              inInclusiveRange(0, question.choices.length - 1),
              reason: 'Indice de bonne réponse invalide : ${question.id}');
          expect(question.explanation.trim(), isNotEmpty,
              reason: 'Explication vide : ${question.id}');
        }
      }
    });

    test('la Seconde propose trois cours propres à chaque série', () {
      final seriesByTrack = <SchoolTrack, List<String>>{
        SchoolTrack.generalLiterary: ['A4'],
        SchoolTrack.scientific: ['C', 'D'],
        SchoolTrack.technicalTertiary: technicalTertiarySeries,
        SchoolTrack.technicalIndustrial: technicalIndustrialSeries,
      };
      for (final entry in seriesByTrack.entries) {
        for (final series in entry.value) {
          final units = SecondeCompletionScreen.seriesUnitsFor(series);
          expect(units, hasLength(3), reason: 'Seconde série $series');
          for (var term = 1; term <= 3; term++) {
            expect(units.where((unit) => unit.title.startsWith('T$term •')), hasLength(1));
          }
          for (final unit in units) {
            expect(unit.question.trim(), isNotEmpty);
            expect(unit.options.length, greaterThanOrEqualTo(3));
            expect(unit.options.every((option) => option.trim().isNotEmpty), isTrue,
                reason: 'Choix vide dans ${unit.title}');
            final normalizedOptions = unit.options
                .map((option) => option.trim().toLowerCase())
                .toSet();
            expect(normalizedOptions.length, unit.options.length,
                reason: 'Choix dupliqués dans ${unit.title}');
            expect(unit.answer, inInclusiveRange(0, unit.options.length - 1));
            expect(unit.explanation.trim(), isNotEmpty);
          }
        }
      }
    });

    test('les parcours de Première et Terminale ajoutent des cours par série', () {
      final seriesByTrack = <SchoolTrack, List<String>>{
        SchoolTrack.generalLiterary: ['A4'],
        SchoolTrack.scientific: ['C', 'D'],
        SchoolTrack.technicalTertiary: technicalTertiarySeries,
        SchoolTrack.technicalIndustrial: technicalIndustrialSeries,
      };
      for (final entry in seriesByTrack.entries) {
        for (final series in entry.value) {
          for (var term = 1; term <= 3; term++) {
            final first = PremiereCompletionScreen.assessmentExercisesForTerm(
              term, track: entry.key, series: series);
            final finalYear = TerminaleCompletionScreen.assessmentExercisesForTerm(
              term, track: entry.key, series: series);
            expect(first, hasLength(7), reason: 'Première $series, trimestre $term');
            expect(finalYear, hasLength(7), reason: 'Terminale $series, trimestre $term');
            for (final exercise in [...first, ...finalYear]) {
              expect(exercise.options.length, greaterThanOrEqualTo(3));
              expect(exercise.question.trim(), isNotEmpty,
                  reason: 'Question vide pour ${level.label}, série $series');
              expect(exercise.options.every((option) => option.trim().isNotEmpty), isTrue,
                  reason: 'Choix vide pour ${level.label}, série $series');
              final normalizedOptions = exercise.options
                  .map((option) => option.trim().toLowerCase())
                  .toSet();
              expect(normalizedOptions.length, exercise.options.length,
                  reason: 'Choix dupliqués pour ${level.label}, série $series');
              expect(exercise.correctIndex, inInclusiveRange(0, exercise.options.length - 1));
              expect(exercise.explanation.trim().isNotEmpty, isTrue);
            }
          }
        }
      }
    });

  });
}

bool _idsAreUnique(Iterable<String> ids) {
  final values = ids.toList();
  return values.length == values.toSet().length;
}
