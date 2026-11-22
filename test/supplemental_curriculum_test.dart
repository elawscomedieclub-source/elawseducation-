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
        'cp1_copier_phrase',
        'cp1_completer_phrase',
        'cp1_point_interrogation',
      ];
      final cp1Ids = supplementalLessons
          .where((lesson) => lesson.level == SchoolLevel.cp1)
          .map((lesson) => lesson.id)
          .toSet();
      for (final id in expected) {
        expect(cp1Ids, contains(id), reason: 'Activité CP1 manquante : $id');
      }
    });

    test('les nouvelles leçons CP2 et CE1 sont présentes', () {
      const expected = [
        'cp2_lire_phrases',
        'cp2_addition_dizaines',
        'cp2_soustraction',
        'ce1_multiplication_groupes',
        'ce1_problemes_addition',
      ];
      final ids = supplementalLessons.map((lesson) => lesson.id).toSet();
      for (final id in expected) {
        expect(ids, contains(id), reason: 'Leçon manquante : $id');
      }
    });

    test('les nouvelles leçons CE1 et CE2 sont présentes et complètes', () {
      const expected = [
        'ce1_comprendre_texte',
        'ce1_multiplication_table_2',
        'ce2_division_partage',
        'ce2_phrase_types',
      ];
      for (final id in expected) {
        final lesson = supplementalLessons.firstWhere((item) => item.id == id);
        expect(lesson.questions.length, greaterThanOrEqualTo(3), reason: lesson.title);
      }
    });

    test('les nouvelles leçons CM1 et CM2 sont complètes', () {
      const expected = [
        'cm1_fraction_equivalentes',
        'cm1_perimetre_rectangle',
        'cm2_nombres_decimaux',
        'cm2_proportionnalite_tableau',
      ];
      for (final id in expected) {
        final lesson = supplementalLessons.firstWhere((item) => item.id == id);
        expect(lesson.questions.length, greaterThanOrEqualTo(3), reason: lesson.title);
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
        'cp1_copier_phrase',
        'cp1_completer_phrase',
        'cp1_point_interrogation',
        'cp2_lire_phrases',
        'cp2_addition_dizaines',
        'cp2_soustraction',
        'ce1_multiplication_groupes',
        'ce1_problemes_addition',
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

    test('les choix sont non vides et uniques même après normalisation', () {
      for (final lesson in supplementalLessons) {
        for (final question in lesson.questions) {
          final normalized = question.choices
              .map((choice) => choice.trim().toLowerCase())
              .toList();
          expect(normalized.every((choice) => choice.isNotEmpty), isTrue,
              reason: 'Choix vide dans ${question.id}');
          expect(normalized.toSet().length, normalized.length,
              reason: 'Choix identiques après normalisation dans ${question.id}');
          expect(question.correctIndex, inInclusiveRange(0, normalized.length - 1),
              reason: 'Bonne réponse invalide dans ${question.id}');
        }
      }
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

    test('les nouvelles leçons du collège ont trois exercices expliqués', () {
      const expected = [
        'sixieme_operations_decimales',
        'cinquieme_fractions_addition',
        'quatrieme_thales',
        'troisieme_equation_second_degre',
      ];
      for (final id in expected) {
        final lesson = supplementalLessons.firstWhere((item) => item.id == id);
        expect(lesson.questions, hasLength(3), reason: lesson.title);
        for (final question in lesson.questions) {
          expect(question.choices.toSet().length, question.choices.length,
              reason: 'Choix répétés dans ${question.id}');
        }
      }
    });


    test('les nouvelles leçons de français et de sciences sont complètes', () {
      const expected = [
        'ce2_sujet_verbe',
        'cm1_cycle_eau',
        'quatrieme_circuit_electrique',
      ];
      for (final id in expected) {
        final lesson = supplementalLessons.firstWhere((item) => item.id == id);
        expect(lesson.questions, hasLength(3), reason: lesson.title);
        expect(lesson.example.trim(), isNotEmpty);
        expect(lesson.explanation.trim(), isNotEmpty);
      }
    });

    test('les nouvelles leçons du lycée ont trois exercices sans choix répétés', () {
      const expected = [
        'seconde_equation_lineaire',
        'premiere_suite_arithmetique',
        'terminale_probabilite_conditionnelle',
        'seconde_systeme_equations',
        'premiere_trinome_signe',
        'terminale_limite_simple',
      ];
      for (final id in expected) {
        final lesson = supplementalLessons.firstWhere((item) => item.id == id);
        expect(lesson.questions, hasLength(3), reason: lesson.title);
        for (final question in lesson.questions) {
          expect(question.choices.toSet().length, question.choices.length,
              reason: 'Choix répétés dans ${question.id}');
          expect(question.correctIndex, inInclusiveRange(0, question.choices.length - 1));
        }
      }
    });

    test('les nouvelles leçons de calcul et de sciences sont complètes', () {
      const expected = [
        'ce1_soustraction_emprunt',
        'cm2_aire_triangle',
        'cinquieme_respiration',
      ];
      for (final id in expected) {
        final lesson = supplementalLessons.firstWhere((item) => item.id == id);
        expect(lesson.questions, hasLength(3), reason: lesson.title);
        expect(lesson.example.trim(), isNotEmpty);
        expect(lesson.explanation.trim(), isNotEmpty);
        for (final question in lesson.questions) {
          expect(question.explanation.trim(), isNotEmpty);
          expect(question.correctIndex, inInclusiveRange(0, question.choices.length - 1));
        }
      }
    });

    test('les nouvelles leçons CE2, CM1 et 3e sont complètes', () {
      const expected = [
        'ce2_multiplication_dizaines',
        'cm1_adjectif_qualificatif',
        'troisieme_loi_ohm',
      ];
      for (final id in expected) {
        final lesson = supplementalLessons.firstWhere((item) => item.id == id);
        expect(lesson.questions, hasLength(3), reason: lesson.title);
        expect(lesson.example.trim(), isNotEmpty);
        expect(lesson.explanation.trim(), isNotEmpty);
        for (final question in lesson.questions) {
          final normalized = question.choices.map((choice) => choice.trim().toLowerCase()).toSet();
          expect(normalized.length, question.choices.length, reason: question.id);
          expect(question.correctIndex, inInclusiveRange(0, question.choices.length - 1));
        }
      }
    });

    test('les leçons CM2, 6e et Seconde sont complètes', () {
      const expected = [
        'cm2_fraction_nombre_decimal',
        'sixieme_etats_matiere',
        'seconde_pourcentage_evolution',
      ];
      for (final id in expected) {
        final lesson = supplementalLessons.firstWhere((item) => item.id == id);
        expect(lesson.questions, hasLength(3), reason: lesson.title);
        expect(lesson.example.trim(), isNotEmpty);
        expect(lesson.explanation.trim(), isNotEmpty);
        for (final question in lesson.questions) {
          final choices = question.choices.map((choice) => choice.trim().toLowerCase()).toSet();
          expect(choices.length, question.choices.length, reason: question.id);
          expect(question.correctIndex, inInclusiveRange(0, question.choices.length - 1));
          expect(question.explanation.trim(), isNotEmpty);
        }
      }
    });

    test('les leçons CE1, CM2 et 4e sur mesures et sciences sont complètes', () {
      const expected = [
        'ce1_mesurer_longueurs',
        'cm2_volume_pave',
        'quatrieme_vitesse_moyenne',
      ];
      for (final id in expected) {
        final lesson = supplementalLessons.firstWhere((item) => item.id == id);
        expect(lesson.questions, hasLength(3), reason: lesson.title);
        expect(lesson.example.trim(), isNotEmpty);
        expect(lesson.explanation.trim(), isNotEmpty);
        for (final question in lesson.questions) {
          final choices = question.choices.map((choice) => choice.trim().toLowerCase()).toSet();
          expect(choices.length, question.choices.length, reason: question.id);
          expect(question.correctIndex, inInclusiveRange(0, question.choices.length - 1));
          expect(question.explanation.trim(), isNotEmpty);
        }
      }
    });


    test('les nouvelles leçons CP2, CE2 et 5e sont complètes', () {
      const expected = ['cp2_addition_retenue_dizaines','ce2_animaux_regimes_alimentaires','cinquieme_proportionnalite_tableau'];
      for (final id in expected) {
        final lesson = supplementalLessons.firstWhere((item) => item.id == id);
        expect(lesson.questions, hasLength(3), reason: lesson.title);
        expect(lesson.example.trim(), isNotEmpty);
        expect(lesson.explanation.trim(), isNotEmpty);
        for (final question in lesson.questions) {
          final choices = question.choices.map((choice) => choice.trim().toLowerCase()).toSet();
          expect(choices.length, question.choices.length, reason: question.id);
          expect(question.correctIndex, inInclusiveRange(0, question.choices.length - 1));
          expect(question.explanation.trim(), isNotEmpty);
        }
      }
    });



    test('les nouvelles leçons CP1, CM2 et 3e sont complètes', () {
      const expected = ['cp1_nombres_ordonner','cm2_conjugaison_futur','troisieme_gene_expression'];
      for (final id in expected) {
        final lesson = supplementalLessons.firstWhere((item) => item.id == id);
        expect(lesson.questions, hasLength(3), reason: lesson.title);
        expect(lesson.example.trim(), isNotEmpty);
        expect(lesson.explanation.trim(), isNotEmpty);
        for (final question in lesson.questions) {
          final choices = question.choices.map((choice) => choice.trim().toLowerCase()).toSet();
          expect(choices.length, question.choices.length, reason: question.id);
          expect(question.correctIndex, inInclusiveRange(0, question.choices.length - 1));
          expect(question.explanation.trim(), isNotEmpty);
        }
      }
    });


  });
}
