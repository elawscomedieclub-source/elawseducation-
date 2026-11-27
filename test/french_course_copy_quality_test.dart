import 'package:flutter_test/flutter_test.dart';
import 'package:proftogo/data/sample/sample_data.dart';
import 'package:proftogo/data/sample/annual_core_catalog.dart';
import 'package:proftogo/data/sample/supplemental_curriculum.dart';

void main() {
  group('Qualité rédactionnelle des cours ProfTogo', () {
    test('les leçons et exercices ont des textes pédagogiques renseignés', () {
      final lessons = [...demoLessons, ...annualCoreLessons];
      final exercises = [...demoExercises, ...annualCoreExercises];
      for (final lesson in lessons) {
        expect(lesson.title.trim(), isNotEmpty, reason: 'Titre vide : ${lesson.id}');
        expect(lesson.summary.trim(), isNotEmpty, reason: 'Résumé vide : ${lesson.id}');
        expect(lesson.content.trim(), isNotEmpty, reason: 'Cours vide : ${lesson.id}');
        expect(lesson.title, lesson.title.trim(), reason: 'Espaces en bordure du titre : ${lesson.id}');
      }
      for (final exercise in exercises) {
        expect(exercise.question.trim(), isNotEmpty, reason: 'Question vide : ${exercise.id}');
        expect(exercise.explanation.trim(), isNotEmpty, reason: 'Correction expliquée manquante : ${exercise.id}');
        expect(exercise.options.length, greaterThanOrEqualTo(2), reason: 'Choix insuffisants : ${exercise.id}');
        expect(exercise.correctIndex, inInclusiveRange(0, exercise.options.length - 1),
            reason: 'Réponse attendue hors des choix : ${exercise.id}');
      }
    });

    test('les choix de chaque exercice sont distincts', () {
      final exercises = [...demoExercises, ...annualCoreExercises];
      for (final exercise in exercises) {
        final normalizedOptions = exercise.options
            .map((option) => option.trim().replaceAll(RegExp(r'\s+'), ' '))
            .toSet();
        expect(
          normalizedOptions.length,
          exercise.options.length,
          reason: 'Choix répété dans l’exercice ${exercise.id}',
        );
      }
    });

    test('les choix des quiz bonus sont distincts et la bonne réponse existe', () {
      for (final lesson in supplementalLessons) {
        for (final question in lesson.questions) {
          final normalizedChoices = question.choices
              .map((choice) => choice.trim().replaceAll(RegExp(r'\s+'), ' '))
              .toSet();
          expect(
            normalizedChoices.length,
            question.choices.length,
            reason: 'Choix répété dans le quiz bonus ${question.id}',
          );
          expect(
            question.correctIndex,
            inInclusiveRange(0, question.choices.length - 1),
            reason: 'Bonne réponse hors des choix dans ${question.id}',
          );
        }
      }
    });

    test('la banque ne contient pas les coquilles françaises fréquentes repérées', () {
      final texts = <String>[
        for (final lesson in [...demoLessons, ...annualCoreLessons])
          lesson.title + ' ' + lesson.summary + ' ' + lesson.content + ' ' + lesson.keyPoints.join(' '),
        for (final exercise in [...demoExercises, ...annualCoreExercises])
          exercise.question + ' ' + exercise.options.join(' ') + ' ' + exercise.explanation,
        for (final lesson in supplementalLessons)
          lesson.title + ' ' + lesson.explanation + ' ' + lesson.example,
        for (final lesson in supplementalLessons)
          for (final question in lesson.questions)
            question.prompt + ' ' + question.choices.join(' ') + ' ' + question.explanation,
      ];
      final commonFrenchTypos = RegExp(
        r'\b(apparament|souvant|parmis|malgrès|acceuill\w*|dévelopement|environement|connaissence|est arriveront)\b',
        caseSensitive: false,
      );
      for (final text in texts) {
        expect(commonFrenchTypos.hasMatch(text), isFalse,
            reason: 'Coquille fréquente détectée : ${commonFrenchTypos.firstMatch(text)?.group(0)}');
      }
    });
  });
}
