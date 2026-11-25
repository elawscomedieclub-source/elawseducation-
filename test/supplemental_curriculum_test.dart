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

    test('chaque niveau possède au moins quatre leçons bonus', () {
      for (final level in SchoolLevel.values) {
        final count = supplementalLessons
            .where((lesson) => lesson.level == level)
            .length;
        expect(
          count,
          greaterThanOrEqualTo(4),
          reason: 'Couverture bonus trop faible pour ${level.label}',
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
        'cp1_securite',
        'cp1_environnement',
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
        'cp2_monnaie_fcfa',
        'cp2_lire_heure_calendrier',
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
        'cp1_securite',
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

    test('chaque leçon bonus propose au moins trois exercices', () {
      for (final lesson in supplementalLessons) {
        expect(
          lesson.questions.length,
          greaterThanOrEqualTo(3),
          reason: 'Il manque un exercice à la leçon ${lesson.title}',
        );
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


    test('contrôle global de qualité des cours bonus pour chaque niveau', () {
      for (final lesson in supplementalLessons) {
        expect(lesson.title.trim(), isNotEmpty, reason: 'Titre vide : ${lesson.id}');
        expect(lesson.example.trim(), isNotEmpty, reason: 'Exemple vide : ${lesson.id}');
        expect(lesson.explanation.trim(), isNotEmpty, reason: 'Explication vide : ${lesson.id}');

        final normalizedPrompts = lesson.questions
            .map((question) => question.prompt.trim().toLowerCase())
            .toList();
        expect(
          normalizedPrompts.every((prompt) => prompt.isNotEmpty),
          isTrue,
          reason: 'Question vide dans ${lesson.id}',
        );
        expect(
          normalizedPrompts.toSet().length,
          normalizedPrompts.length,
          reason: 'Questions répétées dans ${lesson.id}',
        );

        for (final question in lesson.questions) {
          expect(question.choices.length, greaterThanOrEqualTo(2),
              reason: 'Pas assez de choix : ${question.id}');
          expect(question.explanation.trim(), isNotEmpty,
              reason: 'Explication de réponse vide : ${question.id}');
          expect(question.correctIndex, inInclusiveRange(0, question.choices.length - 1),
              reason: 'Réponse correcte invalide : ${question.id}');
        }
      }
    });


    test('chaque cours bonus a une matière et trois choix distincts par question', () {
      for (final lesson in supplementalLessons) {
        expect(lesson.subject.trim(), isNotEmpty,
            reason: 'Matière non renseignée : ${lesson.id}');
        for (final question in lesson.questions) {
          expect(question.choices, hasLength(3),
              reason: 'Trois choix attendus pour ${question.id}');
          final choices = question.choices
              .map((choice) => choice.trim().toLowerCase())
              .toSet();
          expect(choices.length, 3,
              reason: 'Les trois choix doivent être distincts : ${question.id}');
        }
      }
    });


    test('les réponses fondamentales de français sont exactes', () {
      const expectedAnswers = <String, String>{
        'bonus_cp1_fr_1': 'A',
        'bonus_cp1_reading_1': 'Avec sa maman',
        'bonus_cp1_sentence_1': 'Kossi joue.',
        'bonus_cp2_read_3': 'Dans le jardin',
        'bonus_ce1_text_2': 'Son père',
        'bonus_ce2_fr_2': 'sommes',
        'bonus_ce2_sujet_2': 'volent',
        'bonus_cm1_fr_1': 'jouent',
        'bonus_cm1_adj_2': 'jolie',
        'bonus_cm2_futur_1': 'irons',
        'bonus_cm2_futur_2': 'terminerai',
        'bonus_5e_fr_1': 'finissez',
        'bonus_5e_fr_2': 'chantent',
        'bonus_4e_fr_1': 'une mangue',
        'bonus_3e_fr_1': 'une idée et une raison',
        'bonus_2nde_fr_1': 'les idées essentielles',
      };

      final questions = {
        for (final lesson in supplementalLessons)
          for (final question in lesson.questions) question.id: question,
      };

      for (final entry in expectedAnswers.entries) {
        final question = questions[entry.key];
        expect(question, isNotNull, reason: 'Exercice absent : ${entry.key}');
        expect(
          question!.choices[question.correctIndex].trim(),
          entry.value,
          reason: 'Réponse de français à corriger dans ${entry.key}',
        );
      }
    });

    test('les réponses fondamentales de sciences sont exactes', () {
      const expectedAnswers = <String, String>{
        'bonus_cp1_animals_1': 'Poisson',
        'bonus_cp1_body_2': 'Les oreilles',
        'bonus_cp1_hygiene_1': 'Eau et savon',
        'bonus_ce2_regime_1': 'Carnivore',
        'bonus_cm1_eau_1': 'L’évaporation',
        'bonus_cm1_eau_2': 'Par condensation de la vapeur d’eau',
        'bonus_6e_matiere_2': 'prend la forme du récipient',
        'bonus_5e_resp_2': 'Les branchies',
        'bonus_4e_circuit_1': 'Quand le circuit est fermé',
        'bonus_4e_circuit_2': 'La pile',
        'bonus_4e_vit_1': '50 km/h',
        'bonus_4e_vit_3': '80 km',
        'bonus_3e_ohm_2': '15 V',
        'bonus_3e_ohm_3': 'Ohm',
        'bonus_3e_gene_1': 'ADN',
        'bonus_3e_gene_3': 'Une portion d’ADN',
      };

      final questions = {
        for (final lesson in supplementalLessons)
          for (final question in lesson.questions) question.id: question,
      };

      for (final entry in expectedAnswers.entries) {
        final question = questions[entry.key];
        expect(question, isNotNull, reason: 'Exercice absent : ${entry.key}');
        expect(
          question!.choices[question.correctIndex].trim(),
          entry.value,
          reason: 'Réponse de sciences à corriger dans ${entry.key}',
        );
      }
    });

    test('les résultats des calculs fondamentaux restent exacts', () {
      const expectedAnswers = <String, String>{
        'bonus_cp1_math_1': '4',
        'bonus_cp1_math_2': '3',
        'extra_review_cp1_compter': '5',
        'bonus_cp1_add_img_1': '4',
        'bonus_cp1_sub_img_1': '3',
        'bonus_cp1_sub_img_2': '3',
        'bonus_cp1_twenty_3': '17',
        'bonus_cp2_add_tens_1': '34',
        'bonus_cp2_add_tens_2': '47',
        'bonus_cp2_sub_1': '23',
        'bonus_cp2_sub_2': '26',
        'bonus_cp2_sub_3': '12',
        'bonus_ce1_table2_1': '6',
        'bonus_ce2_share_2': '3',
        'bonus_cm1_perim_1': '14 cm',
      };

      final questions = {
        for (final lesson in supplementalLessons)
          for (final question in lesson.questions) question.id: question,
      };

      for (final entry in expectedAnswers.entries) {
        final question = questions[entry.key];
        expect(question, isNotNull, reason: 'Exercice absent : ${entry.key}');
        expect(
          question!.choices[question.correctIndex].trim(),
          entry.value,
          reason: 'Résultat à corriger dans ${entry.key}',
        );
      }
    });


    test('le cours CP2 sur le franc CFA enseigne des calculs exacts', () {
      final lesson = supplementalLessons.firstWhere(
        (item) => item.id == 'cp2_monnaie_fcfa',
      );
      expect(lesson.level, SchoolLevel.cp2);
      expect(lesson.subject, 'Mathématiques');
      expect(lesson.questions, hasLength(3));
      const expectedAnswers = <String, String>{
        'bonus_cp2_fcfa_1': '350 F',
        'bonus_cp2_fcfa_2': '200 F',
        'bonus_cp2_fcfa_3': '100 F',
      };
      for (final question in lesson.questions) {
        expect(
          question.choices[question.correctIndex],
          expectedAnswers[question.id],
          reason: 'Calcul incorrect dans ${question.id}',
        );
      }
    });


    test('le cours CE1 sur les achats en franc CFA vérifie le budget et la monnaie', () {
      final lesson = supplementalLessons.firstWhere(
        (item) => item.id == 'ce1_achats_fcfa',
      );
      expect(lesson.level, SchoolLevel.ce1);
      expect(lesson.subject, 'Mathématiques');
      expect(lesson.questions, hasLength(3));
      const expectedAnswers = <String, String>{
        'bonus_ce1_fcfa_1': '450 F',
        'bonus_ce1_fcfa_2': '550 F',
        'bonus_ce1_fcfa_3': '300 F',
      };
      for (final question in lesson.questions) {
        expect(
          question.choices[question.correctIndex],
          expectedAnswers[question.id],
          reason: 'Calcul incorrect dans ${question.id}',
        );
      }
    });


    test('le cours CE2 sur le budget en franc CFA vérifie dépenses et reste', () {
      final lesson = supplementalLessons.firstWhere(
        (item) => item.id == 'ce2_budget_fcfa',
      );
      expect(lesson.level, SchoolLevel.ce2);
      expect(lesson.subject, 'Mathématiques');
      expect(lesson.questions, hasLength(3));
      const expectedAnswers = <String, String>{
        'bonus_ce2_budget_1': '1 300 F',
        'bonus_ce2_budget_2': '200 F',
        'bonus_ce2_budget_3': 'Oui, il reste 250 F',
      };
      for (final question in lesson.questions) {
        expect(
          question.choices[question.correctIndex],
          expectedAnswers[question.id],
          reason: 'Calcul incorrect dans ${question.id}',
        );
      }
    });


    test('le cours CE2 sur les longueurs vérifie les conversions', () {
      final lesson = supplementalLessons.firstWhere(
        (item) => item.id == 'ce2_mesures_longueurs',
      );
      expect(lesson.level, SchoolLevel.ce2);
      expect(lesson.subject, 'Mathématiques');
      expect(lesson.questions, hasLength(3));
      const expectedAnswers = <String, String>{
        'bonus_ce2_mesure_1': '1 000 m',
        'bonus_ce2_mesure_2': '250 cm',
        'bonus_ce2_mesure_3': '3 m et 40 cm',
      };
      for (final question in lesson.questions) {
        expect(
          question.choices[question.correctIndex],
          expectedAnswers[question.id],
          reason: 'Conversion incorrecte dans ${question.id}',
        );
      }
    });


    test('le cours CE2 sur les masses vérifie les conversions', () {
      final lesson = supplementalLessons.firstWhere(
        (item) => item.id == 'ce2_mesures_masses',
      );
      expect(lesson.level, SchoolLevel.ce2);
      expect(lesson.subject, 'Mathématiques');
      expect(lesson.questions, hasLength(3));
      const expectedAnswers = <String, String>{
        'bonus_ce2_masse_1': '1 000 g',
        'bonus_ce2_masse_2': '2 000 g',
        'bonus_ce2_masse_3': '1 kg et 500 g',
      };
      for (final question in lesson.questions) {
        expect(
          question.choices[question.correctIndex],
          expectedAnswers[question.id],
          reason: 'Conversion incorrecte dans ${question.id}',
        );
      }
    });



    test('le cours CE2 sur les capacités vérifie les conversions', () {
      final lesson = supplementalLessons.firstWhere(
        (item) => item.id == 'ce2_mesures_capacites',
      );
      expect(lesson.level, SchoolLevel.ce2);
      expect(lesson.subject, 'Mathématiques');
      expect(lesson.questions, hasLength(3));
      const expectedAnswers = <String, String>{
        'bonus_ce2_capacite_1': '1 000 mL',
        'bonus_ce2_capacite_2': '3 000 mL',
        'bonus_ce2_capacite_3': 'un demi-litre',
      };
      for (final question in lesson.questions) {
        expect(
          question.choices[question.correctIndex],
          expectedAnswers[question.id],
          reason: 'Conversion incorrecte dans ${question.id}',
        );
      }
    });



    test('le cours CE2 sur les durées vérifie les conversions horaires', () {
      final lesson = supplementalLessons.firstWhere(
        (item) => item.id == 'ce2_mesures_duree',
      );
      expect(lesson.level, SchoolLevel.ce2);
      expect(lesson.subject, 'Mathématiques');
      expect(lesson.questions, hasLength(3));
      const expectedAnswers = <String, String>{
        'bonus_ce2_duree_1': '60 minutes',
        'bonus_ce2_duree_2': '150 min',
        'bonus_ce2_duree_3': '1 h 30 min',
      };
      for (final question in lesson.questions) {
        expect(
          question.choices[question.correctIndex],
          expectedAnswers[question.id],
          reason: 'Conversion incorrecte dans ${question.id}',
        );
      }
    });



    test('le cours CE2 sur le partage vérifie les divisions exactes', () {
      final lesson = supplementalLessons.firstWhere(
        (item) => item.id == 'ce2_partage_division',
      );
      expect(lesson.level, SchoolLevel.ce2);
      expect(lesson.subject, 'Mathématiques');
      expect(lesson.questions, hasLength(3));
      const expectedAnswers = <String, String>{
        'bonus_ce2_partage_1': '4 crayons',
        'bonus_ce2_partage_2': '3 mangues',
        'bonus_ce2_partage_3': '5 biscuits',
      };
      for (final question in lesson.questions) {
        expect(
          question.choices[question.correctIndex],
          expectedAnswers[question.id],
          reason: 'Partage incorrect dans ${question.id}',
        );
      }
    });



    test('le cours CE2 sur les problèmes de multiplication vérifie les situations', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'ce2_problemes_multiplication');
      expect(lesson.level, SchoolLevel.ce2);
      expect(lesson.subject, 'Mathématiques');
      expect(lesson.questions, hasLength(3));
      const expectedAnswers = <String, String>{
        'bonus_ce2_probleme_mult_1': '12 cahiers',
        'bonus_ce2_probleme_mult_2': '30 mangues',
        'bonus_ce2_probleme_mult_3': '20 crayons',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Problème de multiplication incorrect dans ${question.id}');
      }
    });

    test('le cours CE2 sur la table de 2 vérifie les produits', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'ce2_table_multiplication_2');
      expect(lesson.level, SchoolLevel.ce2);
      expect(lesson.subject, 'Mathématiques');
      expect(lesson.questions, hasLength(3));
      const expectedAnswers = <String, String>{'bonus_ce2_table2_1': '4','bonus_ce2_table2_2': '8','bonus_ce2_table2_3': '10'};
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id], reason: 'Produit incorrect dans ${question.id}');
      }
    });

    test('le cours CE2 sur la table de 3 vérifie les produits', () {
      final lesson = supplementalLessons.firstWhere(
        (item) => item.id == 'ce2_table_multiplication_3',
      );
      expect(lesson.level, SchoolLevel.ce2);
      expect(lesson.subject, 'Mathématiques');
      expect(lesson.questions, hasLength(3));
      const expectedAnswers = <String, String>{
        'bonus_ce2_table3_1': '6',
        'bonus_ce2_table3_2': '12',
        'bonus_ce2_table3_3': '15',
      };
      for (final question in lesson.questions) {
        expect(
          question.choices[question.correctIndex],
          expectedAnswers[question.id],
          reason: 'Produit incorrect dans ${question.id}',
        );
      }
    });


    test('le cours CE2 sur la table de 4 vérifie les produits', () {
      final lesson = supplementalLessons.firstWhere(
        (item) => item.id == 'ce2_table_multiplication_4',
      );
      expect(lesson.level, SchoolLevel.ce2);
      expect(lesson.subject, 'Mathématiques');
      expect(lesson.questions, hasLength(3));
      const expectedAnswers = <String, String>{
        'bonus_ce2_table4_1': '8',
        'bonus_ce2_table4_2': '12',
        'bonus_ce2_table4_3': '20',
      };
      for (final question in lesson.questions) {
        expect(
          question.choices[question.correctIndex],
          expectedAnswers[question.id],
          reason: 'Produit incorrect dans ${question.id}',
        );
      }
    });


    test('le cours CE2 sur la table de 5 vérifie les produits', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'ce2_table_multiplication_5');
      expect(lesson.level, SchoolLevel.ce2);
      expect(lesson.subject, 'Mathématiques');
      expect(lesson.questions, hasLength(3));
      const expectedAnswers = <String, String>{'bonus_ce2_table5_1': '10','bonus_ce2_table5_2': '20','bonus_ce2_table5_3': '25'};
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id], reason: 'Produit incorrect dans ${question.id}');
      }
    });


    test('le cours CE2 sur la table de 6 vérifie les produits', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'ce2_table_multiplication_6');
      expect(lesson.level, SchoolLevel.ce2);
      expect(lesson.subject, 'Mathématiques');
      expect(lesson.questions, hasLength(3));
      const expectedAnswers = <String, String>{'bonus_ce2_table6_1': '12','bonus_ce2_table6_2': '24','bonus_ce2_table6_3': '30'};
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id], reason: 'Produit incorrect dans ${question.id}');
      }
    });


    test('le cours CE2 sur la table de 7 vérifie les produits', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'ce2_table_multiplication_7');
      expect(lesson.level, SchoolLevel.ce2);
      expect(lesson.subject, 'Mathématiques');
      expect(lesson.questions, hasLength(3));
      const expectedAnswers = <String, String>{'bonus_ce2_table7_1': '14','bonus_ce2_table7_2': '28','bonus_ce2_table7_3': '35'};
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id], reason: 'Produit incorrect dans ${question.id}');
      }
    });


    test('le cours CE2 sur la table de 8 vérifie les produits', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'ce2_table_multiplication_8');
      expect(lesson.level, SchoolLevel.ce2);
      expect(lesson.subject, 'Mathématiques');
      expect(lesson.questions, hasLength(3));
      const expectedAnswers = <String, String>{'bonus_ce2_table8_1': '16','bonus_ce2_table8_2': '32','bonus_ce2_table8_3': '40'};
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id], reason: 'Produit incorrect dans ${question.id}');
      }
    });


    test('le cours CE2 sur la table de 9 vérifie les produits', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'ce2_table_multiplication_9');
      expect(lesson.level, SchoolLevel.ce2);
      expect(lesson.subject, 'Mathématiques');
      expect(lesson.questions, hasLength(3));
      const expectedAnswers = <String, String>{'bonus_ce2_table9_1': '18','bonus_ce2_table9_2': '36','bonus_ce2_table9_3': '45'};
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id], reason: 'Produit incorrect dans ${question.id}');
      }
    });


    test('le cours CE2 sur la table de 10 vérifie les produits', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'ce2_table_multiplication_10');
      expect(lesson.level, SchoolLevel.ce2);
      expect(lesson.subject, 'Mathématiques');
      expect(lesson.questions, hasLength(3));
      const expectedAnswers = <String, String>{'bonus_ce2_table10_1': '20','bonus_ce2_table10_2': '40','bonus_ce2_table10_3': '50'};
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id], reason: 'Produit incorrect dans ${question.id}');
      }
    });


    test('le cours CE2 apprend à choisir la bonne opération', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'ce2_choisir_operation');
      expect(lesson.level, SchoolLevel.ce2);
      expect(lesson.subject, 'Mathématiques');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_ce2_operation_1': 'Addition (+)',
        'bonus_ce2_operation_2': 'Soustraction (−)',
        'bonus_ce2_operation_3': 'Multiplication (×)',
        'bonus_ce2_operation_4': 'Division (÷)',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Choix d’opération incorrect dans ${question.id}');
      }
    });


    test('le cours CE2 reconnaît les figures géométriques', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'ce2_figures_geometriques');
      expect(lesson.level, SchoolLevel.ce2);
      expect(lesson.subject, 'Mathématiques');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_ce2_geo_1': '3',
        'bonus_ce2_geo_2': 'Le carré',
        'bonus_ce2_geo_3': 'Le cercle',
        'bonus_ce2_geo_4': 'Les côtés opposés',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Réponse géométrique incorrecte dans ${question.id}');
      }
    });


    test('le cours CE2 comprend la moitié et le quart', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'ce2_moitie_quart');
      expect(lesson.level, SchoolLevel.ce2);
      expect(lesson.subject, 'Mathématiques');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_ce2_fraction_1': '5',
        'bonus_ce2_fraction_2': '3',
        'bonus_ce2_fraction_3': '4',
        'bonus_ce2_fraction_4': '5',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Calcul de partage incorrect dans ${question.id}');
      }
    });

    test('le cours CE2 lit et décompose les nombres jusqu’à 1 000', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'ce2_nombres_jusqua_1000');
      expect(lesson.level, SchoolLevel.ce2);
      expect(lesson.subject, 'Mathématiques');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_ce2_nombre_1': '4',
        'bonus_ce2_nombre_2': '300 + 60 + 5',
        'bonus_ce2_nombre_3': '709',
        'bonus_ce2_nombre_4': '520',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Décomposition incorrecte dans ${question.id}');
      }
    });

    test('le cours CE2 compare et range les nombres jusqu’à 1 000', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'ce2_comparer_nombres_1000');
      expect(lesson.level, SchoolLevel.ce2);
      expect(lesson.subject, 'Mathématiques');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_ce2_compare_1': '<',
        'bonus_ce2_compare_2': '906',
        'bonus_ce2_compare_3': '340, 403, 430',
        'bonus_ce2_compare_4': '=',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Comparaison incorrecte dans ${question.id}');
      }
    });

    test('le cours CE2 calcule des additions et soustractions jusqu’à 1 000', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'ce2_addition_soustraction_1000');
      expect(lesson.level, SchoolLevel.ce2);
      expect(lesson.subject, 'Mathématiques');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_ce2_addsub_1': '377',
        'bonus_ce2_addsub_2': '484',
        'bonus_ce2_addsub_3': '325',
        'bonus_ce2_addsub_4': '435',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Calcul incorrect dans ${question.id}');
      }
    });

    test('le cours CE2 vérifie la multiplication posée par un chiffre', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'ce2_multiplication_posee');
      expect(lesson.level, SchoolLevel.ce2);
      expect(lesson.subject, 'Mathématiques');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_ce2_multposee_1': '372',
        'bonus_ce2_multposee_2': '852',
        'bonus_ce2_multposee_3': '660',
        'bonus_ce2_multposee_4': '618',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Multiplication posée incorrecte dans ${question.id}');
      }
    });

    test('le cours CE2 vérifie les divisions exactes par un chiffre', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'ce2_division_exacte');
      expect(lesson.level, SchoolLevel.ce2);
      expect(lesson.subject, 'Mathématiques');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_ce2_division_exacte_1': '8',
        'bonus_ce2_division_exacte_2': '9',
        'bonus_ce2_division_exacte_3': '7',
        'bonus_ce2_division_exacte_4': '8',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Division incorrecte dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });


    test('le cours CE2 résout des partages égaux en francs CFA', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'ce2_problemes_partage_fcfa');
      expect(lesson.level, SchoolLevel.ce2);
      expect(lesson.subject, 'Mathématiques');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_ce2_partage_fcfa_1': '200 F',
        'bonus_ce2_partage_fcfa_2': '300 F',
        'bonus_ce2_partage_fcfa_3': '300 F',
        'bonus_ce2_partage_fcfa_4': '300 F',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Partage de monnaie incorrect dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });
    test('le cours CE2 résout des problèmes en deux étapes', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'ce2_problemes_deux_etapes');
      expect(lesson.level, SchoolLevel.ce2);
      expect(lesson.subject, 'Mathématiques');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_ce2_deux_etapes_1': '136',
        'bonus_ce2_deux_etapes_2': '225 F',
        'bonus_ce2_deux_etapes_3': '36',
        'bonus_ce2_deux_etapes_4': '42',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Résolution en deux étapes incorrecte dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });
    test('le cours CE2 résout des problèmes de multiplication puis soustraction', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'ce2_problemes_multiplication_soustraction');
      expect(lesson.level, SchoolLevel.ce2);
      expect(lesson.subject, 'Mathématiques');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_ce2_mult_soust_1': '42',
        'bonus_ce2_mult_soust_2': '43',
        'bonus_ce2_mult_soust_3': '35',
        'bonus_ce2_mult_soust_4': '52',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Problème multiplication puis soustraction incorrect dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });

    test('le cours CP2 mesure correctement les longueurs avec une règle graduée', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'cp2_regle_graduee');
      expect(lesson.level, SchoolLevel.cp2);
      expect(lesson.subject, 'Mathématiques');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_cp2_regle_1': '6 cm',
        'bonus_cp2_regle_2': '6 cm',
        'bonus_cp2_regle_3': 'Le repère 0',
        'bonus_cp2_regle_4': '6 cm',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Mesure de longueur incorrecte dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });

    test('le cours CP2 distingue les noms propres et les noms communs', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'cp2_nom_propre_commun');
      expect(lesson.level, SchoolLevel.cp2);
      expect(lesson.subject, 'Français');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_cp2_nom_1': 'Kossi',
        'bonus_cp2_nom_2': 'marché',
        'bonus_cp2_nom_3': 'Ama',
        'bonus_cp2_nom_4': 'fille, école',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Identification du nom incorrecte dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });

    test('le cours CP2 identifie le verbe dans une phrase', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'cp2_reconnaitre_verbe');
      expect(lesson.level, SchoolLevel.cp2);
      expect(lesson.subject, 'Français');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_cp2_verbe_1': 'danse',
        'bonus_cp2_verbe_2': 'dort',
        'bonus_cp2_verbe_3': 'écrivent',
        'bonus_cp2_verbe_4': 'brille',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Identification du verbe incorrecte dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });

    test('le cours CP2 distingue le singulier et le pluriel', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'cp2_singulier_pluriel');
      expect(lesson.level, SchoolLevel.cp2);
      expect(lesson.subject, 'Français');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_cp2_pluriel_1': 'singulier',
        'bonus_cp2_pluriel_2': 'pluriel',
        'bonus_cp2_pluriel_3': 'les tables',
        'bonus_cp2_pluriel_4': 'Les',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Identification du nombre incorrecte dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });

    test('le cours CP2 reconnaît les figures géométriques de base', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'cp2_reconnaitre_figures_planes');
      expect(lesson.level, SchoolLevel.cp2);
      expect(lesson.subject, 'Mathématiques');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_cp2_figures_1': '3',
        'bonus_cp2_figures_2': 'Le carré',
        'bonus_cp2_figures_3': 'Le cercle',
        'bonus_cp2_figures_4': '4',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Identification de figure incorrecte dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });

    test('le cours CP2 choisit addition ou soustraction dans un problème', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'cp2_etapes_addition_soustraction');
      expect(lesson.level, SchoolLevel.cp2);
      expect(lesson.subject, 'Mathématiques');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_cp2_probleme_op_1': '15',
        'bonus_cp2_probleme_op_2': '12',
        'bonus_cp2_probleme_op_3': '11 + 8',
        'bonus_cp2_probleme_op_4': '20 − 7',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Opération ou résultat incorrect dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });

    test('le cours CP2 identifie les états de l’eau', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'cp2_etats_eau');
      expect(lesson.level, SchoolLevel.cp2);
      expect(lesson.subject, 'Sciences');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_cp2_eau_1': 'Liquide',
        'bonus_cp2_eau_2': 'La glace',
        'bonus_cp2_eau_3': 'Gazeux',
        'bonus_cp2_eau_4': 'De la glace',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'État de l’eau incorrect dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });

    test('le cours CP2 explique le lavage correct des mains', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'cp2_hygiene_mains');
      expect(lesson.level, SchoolLevel.cp2);
      expect(lesson.subject, 'Sciences');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_cp2_hygiene_1': 'Avec de l’eau et du savon',
        'bonus_cp2_hygiene_2': 'Avant de manger',
        'bonus_cp2_hygiene_3': 'Entre les doigts',
        'bonus_cp2_hygiene_4': 'On les rince et on les sèche',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Règle d’hygiène incorrecte dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });

    test('le cours CP2 identifie les principales parties d’une plante', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'cp2_parties_plante');
      expect(lesson.level, SchoolLevel.cp2);
      expect(lesson.subject, 'Sciences');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_cp2_plante_1': 'Les racines',
        'bonus_cp2_plante_2': 'La tige',
        'bonus_cp2_plante_3': 'Les feuilles',
        'bonus_cp2_plante_4': 'Des graines',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Partie de plante incorrecte dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });
 
    test('le cours CP2 décrit les déplacements de quelques animaux', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'cp2_deplacements_animaux');
      expect(lesson.level, SchoolLevel.cp2);
      expect(lesson.subject, 'Sciences');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_cp2_animaux_move_1': 'Le poisson',
        'bonus_cp2_animaux_move_2': 'Il vole',
        'bonus_cp2_animaux_move_3': 'Le serpent',
        'bonus_cp2_animaux_move_4': 'Ses pattes',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Déplacement animal incorrect dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });

    test('le cours CP2 présente les besoins essentiels des animaux', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'cp2_besoins_animaux');
      expect(lesson.level, SchoolLevel.cp2);
      expect(lesson.subject, 'Sciences');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_cp2_besoins_animaux_1': 'D’eau et de nourriture',
        'bonus_cp2_besoins_animaux_2': 'L’eau',
        'bonus_cp2_besoins_animaux_3': 'Parce qu’il en a besoin pour vivre',
        'bonus_cp2_besoins_animaux_4': 'Répondre à ses besoins et le traiter avec soin',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Besoin animal incorrect dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });


    test('le cours CP2 représente la multiplication par des groupes égaux', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'cp2_multiplication_groupes');
      expect(lesson.level, SchoolLevel.cp2);
      expect(lesson.subject, 'Mathématiques');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_cp2_mult_groupes_1': '6',
        'bonus_cp2_mult_groupes_2': '4 groupes de 2',
        'bonus_cp2_mult_groupes_3': '15',
        'bonus_cp2_mult_groupes_4': '5 × 2',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Multiplication ou groupement incorrect dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });


    test('le cours CP2 apprend à partager une quantité en parts égales', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'cp2_partage_equitable');
      expect(lesson.level, SchoolLevel.cp2);
      expect(lesson.subject, 'Mathématiques');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_cp2_partage_1': '4',
        'bonus_cp2_partage_2': '2',
        'bonus_cp2_partage_3': '3, 3 et 3 bonbons',
        'bonus_cp2_partage_4': '3',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Partage incorrect dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });


    test('le cours CP2 repère le sujet dans une phrase simple', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'cp2_identifier_sujet');
      expect(lesson.level, SchoolLevel.cp2);
      expect(lesson.subject, 'Français');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_cp2_sujet_1': 'Kossi',
        'bonus_cp2_sujet_2': 'La fille',
        'bonus_cp2_sujet_3': 'Les élèves',
        'bonus_cp2_sujet_4': 'Le chat',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Sujet incorrect dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });

    test('le cours CP2 utilise les pronoms personnels sujets correctement', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'cp2_pronoms_personnels_sujets');
      expect(lesson.level, SchoolLevel.cp2);
      expect(lesson.subject, 'Français');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_cp2_pronoms_1': 'Elle',
        'bonus_cp2_pronoms_2': 'Nous',
        'bonus_cp2_pronoms_3': 'Ils',
        'bonus_cp2_pronoms_4': 'Vous',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Pronom sujet incorrect dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });

    test('le cours CP2 compare correctement les nombres jusqu’à 100', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'cp2_comparer_nombres_100');
      expect(lesson.level, SchoolLevel.cp2);
      expect(lesson.subject, 'Mathématiques');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_cp2_compare_1': '32',
        'bonus_cp2_compare_2': '<',
        'bonus_cp2_compare_3': '=',
        'bonus_cp2_compare_4': '67',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Comparaison incorrecte dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });

    test('le cours CP2 explique les gestes simples pour protéger les dents', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'cp2_proteger_dents');
      expect(lesson.level, SchoolLevel.cp2);
      expect(lesson.subject, 'Sciences');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_cp2_dents_1': 'À mâcher les aliments',
        'bonus_cp2_dents_2': 'Les brosser chaque jour',
        'bonus_cp2_dents_3': 'Le dire à un adulte',
        'bonus_cp2_dents_4': 'Ils peuvent favoriser les caries',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Réponse d’hygiène dentaire incorrecte dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });

    test('le cours CP2 utilise les mots de position dans l’espace correctement', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'cp2_mots_position_espace');
      expect(lesson.level, SchoolLevel.cp2);
      expect(lesson.subject, 'Français');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_cp2_position_1': 'Sur la table',
        'bonus_cp2_position_2': 'Sous la chaise',
        'bonus_cp2_position_3': 'Devant la porte',
        'bonus_cp2_position_4': 'Entre les cahiers',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Mot de position incorrect dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });


    test('le cours CP2 décrit le temps qu’il fait et les précautions simples', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'cp2_observer_temps');
      expect(lesson.level, SchoolLevel.cp2);
      expect(lesson.subject, 'Sciences');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_cp2_meteo_1': 'Nuageux',
        'bonus_cp2_meteo_2': 'Un parapluie',
        'bonus_cp2_meteo_3': 'Ensoleillé',
        'bonus_cp2_meteo_4': 'Regarder le ciel depuis un endroit sûr',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Observation météo incorrecte dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });


    test('le cours CP2 distingue les nombres pairs et impairs', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'cp2_nombres_pairs_impairs');
      expect(lesson.level, SchoolLevel.cp2);
      expect(lesson.subject, 'Mathématiques');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_cp2_pair_1': 'Pair',
        'bonus_cp2_pair_2': '15',
        'bonus_cp2_pair_3': '6',
        'bonus_cp2_pair_4': 'Un caillou seul',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Classification pair/impair incorrecte dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });


    test('le cours CP2 accorde les adjectifs simples avec le nom', () {
      final lesson = supplementalLessons.firstWhere((item) => item.id == 'cp2_accord_adjectif_simple');
      expect(lesson.level, SchoolLevel.cp2);
      expect(lesson.subject, 'Français');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_cp2_adj_1': 'petite',
        'bonus_cp2_adj_2': 'lourds',
        'bonus_cp2_adj_3': 'une robe rouge',
        'bonus_cp2_adj_4': 'grandes',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Accord de l’adjectif incorrect dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });


    test('CP2 sciences : distinguer naturel et fabriqué', () {
      final lesson = supplementalLessons.firstWhere(
          (item) => item.id == 'cp2_objets_naturels_fabriques');
      expect(lesson.level, SchoolLevel.cp2);
      expect(lesson.subject, 'Sciences');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_cp2_nature_1': 'Une pierre',
        'bonus_cp2_nature_2': 'Une cuillère',
        'bonus_cp2_nature_3': 'Le bois est une matière naturelle et la chaise est fabriquée',
        'bonus_cp2_nature_4': 'Pierre et arbre',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Réponse correcte incorrecte dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });

    test('CP2 maths : compléter des suites numériques simples', () {
      final lesson = supplementalLessons.firstWhere(
          (item) => item.id == 'cp2_suites_numeriques_pas');
      expect(lesson.level, SchoolLevel.cp2);
      expect(lesson.subject, 'Mathématiques');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_cp2_suite_1': '8',
        'bonus_cp2_suite_2': '20',
        'bonus_cp2_suite_3': '30',
        'bonus_cp2_suite_4': '3',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Réponse correcte incorrecte dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });

    test('CP1 éveil : animaux domestiques et sauvages', () {
      final lesson = supplementalLessons.firstWhere(
          (item) => item.id == 'cp1_animaux_domestiques_sauvages');
      expect(lesson.level, SchoolLevel.cp1);
      expect(lesson.subject, 'Éveil');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_cp1_domwild_1': 'La chèvre',
        'bonus_cp1_domwild_2': 'Le lion',
        'bonus_cp1_domwild_3': 'Un éleveur',
        'bonus_cp1_domwild_4': 'Rester à distance et prévenir un adulte',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Réponse correcte incorrecte dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });

    test('CE1 français : utiliser les déterminants simples', () {
      final lesson = supplementalLessons.firstWhere(
          (item) => item.id == 'ce1_determinants_articles');
      expect(lesson.level, SchoolLevel.ce1);
      expect(lesson.subject, 'Français');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_ce1_det_1': 'Le',
        'bonus_ce1_det_2': 'Une',
        'bonus_ce1_det_3': 'Les',
        'bonus_ce1_det_4': 'une orange',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Déterminant incorrect dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });


    test('CE1 sciences : découvrir les besoins des plantes', () {
      final lesson = supplementalLessons.firstWhere(
          (item) => item.id == 'ce1_besoins_plantes');
      expect(lesson.level, SchoolLevel.ce1);
      expect(lesson.subject, 'Sciences');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_ce1_plante_1': 'D’eau et de lumière',
        'bonus_ce1_plante_2': 'Les racines',
        'bonus_ce1_plante_3': 'Pour fabriquer sa nourriture',
        'bonus_ce1_plante_4': 'L’arroser raisonnablement et la placer à la lumière',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Réponse scientifique incorrecte dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });


    test('Terminale maths : étudier les variations avec la dérivée', () {
      final lesson = supplementalLessons.firstWhere(
          (item) => item.id == 'terminale_variations_derivee');
      expect(lesson.level, SchoolLevel.terminale);
      expect(lesson.subject, 'Mathématiques');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_term_var_1': 'Croissante',
        'bonus_term_var_2': '2x−4',
        'bonus_term_var_3': 'En x=2',
        'bonus_term_var_4': '−1 en x=2',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Réponse sur les variations incorrecte dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });


    test('CM1 maths : reconnaître les angles droits, aigus et obtus', () {
      final lesson = supplementalLessons.firstWhere(
          (item) => item.id == 'cm1_reconnaitre_angles');
      expect(lesson.level, SchoolLevel.cm1);
      expect(lesson.subject, 'Mathématiques');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_cm1_angle_1': '90°',
        'bonus_cm1_angle_2': 'Aigu',
        'bonus_cm1_angle_3': 'Obtus',
        'bonus_cm1_angle_4': 'Une équerre',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Classification d’angle incorrecte dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });


    test('6e géographie : s’orienter avec les points cardinaux', () {
      final lesson = supplementalLessons.firstWhere(
          (item) => item.id == 'sixieme_orienter_carte_points_cardinaux');
      expect(lesson.level, SchoolLevel.sixieme);
      expect(lesson.subject, 'Géographie');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_6e_orientation_1': 'Le nord',
        'bonus_6e_orientation_2': 'L’est',
        'bonus_6e_orientation_3': 'Le nord',
        'bonus_6e_orientation_4': 'La rose des vents',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Réponse sur l’orientation incorrecte dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });


    test('5e physique-chimie : distinguer les mélanges', () {
      final lesson = supplementalLessons.firstWhere(
          (item) => item.id == 'cinquieme_melanges_homogenes_heterogenes');
      expect(lesson.level, SchoolLevel.cinquieme);
      expect(lesson.subject, 'Physique-Chimie');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_5e_melange_1': 'Hétérogène',
        'bonus_5e_melange_2': 'Homogène',
        'bonus_5e_melange_3': 'Est toujours présent, même s’il n’est plus visible',
        'bonus_5e_melange_4': 'Ne jamais goûter les substances',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Classification du mélange incorrecte dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });


    test('4e SVT : comprendre la reproduction des plantes à fleurs', () {
      final lesson = supplementalLessons.firstWhere(
          (item) => item.id == 'quatrieme_reproduction_plantes_fleurs');
      expect(lesson.level, SchoolLevel.quatrieme);
      expect(lesson.subject, 'SVT');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_4e_plantes_1': 'Les étamines',
        'bonus_4e_plantes_2': 'Jusqu’au stigmate',
        'bonus_4e_plantes_3': 'Une graine',
        'bonus_4e_plantes_4': 'L’ovaire',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Réponse sur la reproduction des plantes incorrecte dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });


    test('6e français : reconnaître les types de phrases', () {
      final lesson = supplementalLessons.firstWhere(
          (item) => item.id == 'sixieme_types_phrases');
      expect(lesson.level, SchoolLevel.sixieme);
      expect(lesson.subject, 'Français');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_6e_types_1': 'Où vas-tu ?',
        'bonus_6e_types_2': 'Déclarative',
        'bonus_6e_types_3': 'Une consigne',
        'bonus_6e_types_4': '!',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Type de phrase incorrect dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });


    test('5e SVT : digestion et absorption des nutriments', () {
      final lesson = supplementalLessons.firstWhere(
          (item) => item.id == 'cinquieme_digestion_absorption_nutriments');
      expect(lesson.level, SchoolLevel.cinquieme);
      expect(lesson.subject, 'SVT');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_5e_digestion_1': 'La bouche',
        'bonus_5e_digestion_2': 'Transformer les aliments en nutriments',
        'bonus_5e_digestion_3': 'Dans l’intestin grêle',
        'bonus_5e_digestion_4': 'Le sang',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Réponse sur la digestion incorrecte dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });


    test('3e physique-chimie : classer les solutions selon leur pH', () {
      final lesson = supplementalLessons.firstWhere(
          (item) => item.id == 'troisieme_echelle_ph');
      expect(lesson.level, SchoolLevel.troisieme);
      expect(lesson.subject, 'Physique-Chimie');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_3e_ph_1': 'Acide',
        'bonus_3e_ph_2': '7',
        'bonus_3e_ph_3': 'Basique',
        'bonus_3e_ph_4': 'Un pH-mètre',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Réponse sur le pH incorrecte dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });


    test('2nde SVT : la cellule, unité de base du vivant', () {
      final lesson = supplementalLessons.firstWhere(
          (item) => item.id == 'seconde_cellule_unite_vivant');
      expect(lesson.level, SchoolLevel.seconde);
      expect(lesson.subject, 'SVT');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_2nde_cellule_1': 'La membrane',
        'bonus_2nde_cellule_2': 'Dans le noyau',
        'bonus_2nde_cellule_3': 'Une paroi',
        'bonus_2nde_cellule_4': 'Un microscope',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Réponse sur la cellule incorrecte dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });


    test('1ère SVT : réaction inflammatoire et immunité innée', () {
      final lesson = supplementalLessons.firstWhere(
          (item) => item.id == 'premiere_svt_reaction_inflammatoire');
      expect(lesson.level, SchoolLevel.premiere);
      expect(lesson.subject, 'SVT');
      expect(lesson.questions, hasLength(4));
      const expectedAnswers = <String, String>{
        'bonus_1ere_inflammation_1': 'L’immunité innée',
        'bonus_1ere_inflammation_2': 'L’histamine',
        'bonus_1ere_inflammation_3': 'Rougeur',
        'bonus_1ere_inflammation_4': 'Englober puis digérer un élément étranger',
      };
      for (final question in lesson.questions) {
        expect(question.choices[question.correctIndex], expectedAnswers[question.id],
            reason: 'Réponse sur la réaction inflammatoire incorrecte dans ${question.id}');
        expect(question.choices.toSet(), hasLength(question.choices.length),
            reason: 'Choix dupliqué dans ${question.id}');
      }
    });


  });
}
