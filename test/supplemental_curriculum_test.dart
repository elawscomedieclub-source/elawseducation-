import 'package:flutter_test/flutter_test.dart';
import 'package:proftogo/data/models/models.dart';
import 'package:proftogo/data/sample/supplemental_curriculum.dart';

void main() {
  group('Cours bonus ProfTogo', () {
    test('chaque niveau scolaire possède des leçons bonus', () {
      for (final level in SchoolLevel.values) {
        expect(
          supplementalLessons.any((lesson) => lesson.level == level),
          isTrue,
          reason: 'Leçons bonus manquantes pour ${level.label}',
        );
      }
    });

    test('le CP1 contient les activités de découverte attendues', () {
      const expected = [
        'cp1_voyelles',
        'cp1_compter',
        'cp1_couleurs',
        'cp1_formes',
        'cp1_classe',
        'cp1_hygiene',
        'cp1_nombres_10',
        'cp1_saluer',
        'cp1_animaux',
        'cp1_corps',
        'cp1_syllabes',
        'cp1_mots_simples',
        'cp1_addition_images',
        'cp1_soustraction_images',
        'cp1_nombres_20',
        'cp1_ordonner_nombres',
        'cp1_majuscule_minuscule',
        'cp1_comparer_quantites',
        'cp1_petits_problemes',
        'cp1_phrases_simples',
        'cp1_comprendre_texte',
        'cp1_dictee_mots',
        'cp1_ecrire_syllabes',
        'cp1_ecrire_mots_courts',
      ];
      final cp1Ids = supplementalLessons
          .where((lesson) => lesson.level == SchoolLevel.cp1)
          .map((lesson) => lesson.id)
          .toSet();
      for (final id in expected) {
        expect(cp1Ids, contains(id), reason: 'Activité CP1 manquante : $id');
      }
    });

    test('les activités CP1 nouvellement ajoutées ont trois questions', () {
      const addedIds = [
        'cp1_couleurs',
        'cp1_formes',
        'cp1_classe',
        'cp1_hygiene',
        'cp1_nombres_10',
        'cp1_saluer',
        'cp1_animaux',
        'cp1_corps',
        'cp1_syllabes',
        'cp1_mots_simples',
        'cp1_addition_images',
        'cp1_soustraction_images',
        'cp1_nombres_20',
        'cp1_ordonner_nombres',
        'cp1_majuscule_minuscule',
        'cp1_comparer_quantites',
        'cp1_petits_problemes',
        'cp1_phrases_simples',
        'cp1_comprendre_texte',
        'cp1_dictee_mots',
        'cp1_ecrire_syllabes',
        'cp1_ecrire_mots_courts',
      ];
      for (final id in addedIds) {
        final lesson = supplementalLessons.firstWhere((item) => item.id == id);
        expect(lesson.questions.length, greaterThanOrEqualTo(3), reason: lesson.title);
      }
    });

    test('les identifiants des leçons et questions sont uniques', () {
      final lessonIds = supplementalLessons.map((lesson) => lesson.id).toList();
      final questionIds = supplementalLessons.expand((lesson) => lesson.questions).map((question) => question.id).toList();
      expect(lessonIds.toSet().length, lessonIds.length);
      expect(questionIds.toSet().length, questionIds.length);
    });

    test('chaque leçon possède au moins deux exercices valides', () {
      for (final lesson in supplementalLessons) {
        expect(lesson.questions.length, greaterThanOrEqualTo(2), reason: lesson.title);
        expect(lesson.explanation.trim(), isNotEmpty, reason: lesson.title);
        expect(lesson.example.trim(), isNotEmpty, reason: lesson.title);
        for (final question in lesson.questions) {
          expect(question.prompt.trim(), isNotEmpty);
          expect(question.choices.length, greaterThanOrEqualTo(2));
          expect(question.correctIndex, inInclusiveRange(0, question.choices.length - 1));
          expect(question.explanation.trim(), isNotEmpty);
        }
      }
    });
  });
}
