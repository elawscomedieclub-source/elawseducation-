import 'package:flutter_test/flutter_test.dart';
import 'package:proftogo/data/models/models.dart';
import 'package:proftogo/data/sample/supplemental_curriculum.dart';

void main() {
  test('les 26 nouveaux compléments ont leurs réponses validées', () {
    const expected = <String, List<String>>{
      "cp1_renforcement_annuel_plus_1": ["a", "Pour écrire clairement", "A"],
      "cp1_renforcement_annuel_plus_2": ["8", "plus petit", ">"],
      "cp2_renforcement_annuel_plus_3": ["Ama joue.", "?", "Par un signe de ponctuation adapté"],
      "cp2_renforcement_annuel_plus_4": ["2", "47", "35"],
      "ce1_renforcement_annuel_plus_5": ["Heureux", "Lent", "Petit"],
      "ce1_renforcement_annuel_plus_6": ["Les pluies et les conditions du temps", "Les cultures et les activités", "Préparer les cultures"],
      "ce2_renforcement_annuel_plus_7": ["Solide", "Évaporation", "Solidification"],
      "ce2_renforcement_annuel_plus_8": ["Regarder des deux côtés", "S’arrêter", "Marcher sur le trottoir"],
      "cm1_renforcement_annuel_plus_9": ["À identifier l’auteur de la lettre", "Cher ami,", "Clair et organisé"],
      "cm1_renforcement_annuel_plus_10": ["5", "Une part sur trois parts égales", "3"],
      "cm2_renforcement_annuel_plus_11": ["Des sources et des dates", "Placer les événements dans l’ordre du temps", "Comparer les sources"],
      "cm2_renforcement_annuel_plus_12": ["20 cm²", "Unités carrées", "36 cm²"],
      "sixieme_renforcement_annuel_plus_13": ["chat", "Un adjectif", "les"],
      "sixieme_renforcement_annuel_plus_14": ["Le cœur", "Échanger les gaz respiratoires", "Transporter le sang"],
      "cinquieme_renforcement_annuel_plus_15": ["Un symbole du pays", "S’entraider et agir ensemble", "L’hymne national"],
      "cinquieme_renforcement_annuel_plus_16": ["Fermé", "La pile", "S’éteint"],
      "quatrieme_renforcement_annuel_plus_17": ["L’agriculture", "Tertiaire", "Primaire"],
      "quatrieme_renforcement_annuel_plus_18": ["Les étamines", "Un fruit", "Du pollen vers le stigmate"],
      "troisieme_renforcement_annuel_plus_19": ["10", "Le côté opposé à l’angle droit", "13"],
      "troisieme_renforcement_annuel_plus_20": ["L’idée que l’on défend", "Illustrer un argument", "Soutenir la thèse"],
      "seconde_renforcement_annuel_plus_21": ["Un assemblage d’atomes", "Une charge électrique", "Électriquement neutre"],
      "seconde_renforcement_annuel_plus_22": ["Raconte l’histoire", "Aux pensées ou perceptions d’un personnage", "Je"],
      "premiere_renforcement_annuel_plus_23": ["4", "L’ordonnée à l’origine", "11"],
      "premiere_renforcement_annuel_plus_24": ["La déportation forcée d’Africains réduits en esclavage", "Les causes, les acteurs et les conséquences", "Une action contre une domination ou une injustice"],
      "terminale_renforcement_annuel_plus_25": ["100 Hz", "Hertz", "50 Hz"],
      "terminale_renforcement_annuel_plus_26": ["Croiser les idées des documents", "Repérer convergences et différences", "Reformuler et confronter les idées en mentionnant les documents"],
    };
    for (final entry in expected.entries) {
      final lesson = supplementalLessons.firstWhere((item) => item.id == entry.key);
      expect(lesson.questions, hasLength(3), reason: lesson.title);
      for (var i = 0; i < entry.value.length; i++) {
        final question = lesson.questions[i];
        expect(question.choices[question.correctIndex], entry.value[i],
            reason: 'Corrigé à vérifier : ${question.id}');
        expect(question.explanation.trim(), isNotEmpty, reason: question.id);
      }
    }
    expect(expected, hasLength(26));
  });

  test('les nouveaux compléments annuels sont répartis sur les 13 niveaux', () {
    for (final level in SchoolLevel.values) {
      expect(
        supplementalLessons.where((lesson) =>
            lesson.level == level && lesson.id.contains('renforcement_annuel_plus_')).length,
        greaterThanOrEqualTo(2),
        reason: 'Deux compléments supplémentaires attendus pour ${level.label}',
      );
    }
  });

  test('tous les identifiants des compléments supplémentaires sont uniques', () {
    final lessons = supplementalLessons
        .where((lesson) => lesson.id.contains('renforcement_annuel_plus_'))
        .toList();
    expect(lessons.map((lesson) => lesson.id).toSet(), hasLength(26));
    final questions = lessons.expand((lesson) => lesson.questions).toList();
    expect(questions, hasLength(78));
    expect(questions.map((question) => question.id).toSet(), hasLength(78));
  });
  test('les bonnes réponses des nouveaux quiz ne sont pas toujours en première position', () {
    final questions = supplementalLessons
        .where((lesson) => lesson.id.contains('renforcement_annuel_plus_'))
        .expand((lesson) => lesson.questions)
        .toList();
    final positions = questions.map((question) => question.correctIndex).toSet();
    expect(positions, contains(0));
    expect(positions, contains(1));
    expect(positions, contains(2));
    expect(questions.where((question) => question.correctIndex == 0).length,
        lessThan(questions.length));
  });


  test('les 13 compléments 2026-2027 sont présents et leurs quiz sont valides', () {
    const ids = [
      'cp1_hygiene_lavage_mains',
      'cp2_securite_route_annual',
      'ce1_economiser_eau_annual',
      'ce2_lire_tableau_annual',
      'cm1_decouvrir_metiers_annual',
      'cm2_projet_metiers_annual',
      'sixieme_demarche_scientifique_annual',
      'cinquieme_energie_solaire_annual',
      'quatrieme_experience_variables_annual',
      'troisieme_projet_scientifique_annual',
      'seconde_orientation_parcours_annual',
      'premiere_revision_active_annual',
      'terminale_plan_revision_annual',
    ];
    for (final id in ids) {
      final lesson = supplementalLessons.firstWhere((item) => item.id == id);
      expect(lesson.questions, hasLength(3), reason: lesson.title);
      for (final question in lesson.questions) {
        expect(question.choices, hasLength(3), reason: question.id);
        expect(question.choices.toSet(), hasLength(3), reason: question.id);
        expect(question.correctIndex, inInclusiveRange(0, 2), reason: question.id);
        expect(question.explanation.trim(), isNotEmpty, reason: question.id);
      }
    }
    expect(ids, hasLength(13));
  });

}
