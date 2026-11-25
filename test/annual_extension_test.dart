import 'package:flutter_test/flutter_test.dart';
import 'package:proftogo/data/models/models.dart';
import 'package:proftogo/data/sample/supplemental_curriculum.dart';

void main() {
  test('les 26 nouveaux compléments ont leurs réponses validées', () {
    const expected = <String, List<String>>{
      "cp1_renforcement_annuel_plus_1": ["a", "Pour écrire clairement"],
      "cp1_renforcement_annuel_plus_2": ["8", "plus petit"],
      "cp2_renforcement_annuel_plus_3": ["Ama joue.", "?"],
      "cp2_renforcement_annuel_plus_4": ["2", "47"],
      "ce1_renforcement_annuel_plus_5": ["Heureux", "Lent"],
      "ce1_renforcement_annuel_plus_6": ["Les pluies et les conditions du temps", "Les cultures et les activités"],
      "ce2_renforcement_annuel_plus_7": ["Solide", "Évaporation"],
      "ce2_renforcement_annuel_plus_8": ["Regarder des deux côtés", "S’arrêter"],
      "cm1_renforcement_annuel_plus_9": ["À identifier l’auteur de la lettre", "Cher ami,"],
      "cm1_renforcement_annuel_plus_10": ["5", "Une part sur trois parts égales"],
      "cm2_renforcement_annuel_plus_11": ["Des sources et des dates", "Placer les événements dans l’ordre du temps"],
      "cm2_renforcement_annuel_plus_12": ["20 cm²", "Unités carrées"],
      "sixieme_renforcement_annuel_plus_13": ["chat", "Un adjectif"],
      "sixieme_renforcement_annuel_plus_14": ["Le cœur", "Échanger les gaz respiratoires"],
      "cinquieme_renforcement_annuel_plus_15": ["Un symbole du pays", "S’entraider et agir ensemble"],
      "cinquieme_renforcement_annuel_plus_16": ["Fermé", "La pile"],
      "quatrieme_renforcement_annuel_plus_17": ["L’agriculture", "Tertiaire"],
      "quatrieme_renforcement_annuel_plus_18": ["Les étamines", "Un fruit"],
      "troisieme_renforcement_annuel_plus_19": ["10", "Le côté opposé à l’angle droit"],
      "troisieme_renforcement_annuel_plus_20": ["L’idée que l’on défend", "Illustrer un argument"],
      "seconde_renforcement_annuel_plus_21": ["Un assemblage d’atomes", "Une charge électrique"],
      "seconde_renforcement_annuel_plus_22": ["Raconte l’histoire", "Aux pensées ou perceptions d’un personnage"],
      "premiere_renforcement_annuel_plus_23": ["4", "L’ordonnée à l’origine"],
      "premiere_renforcement_annuel_plus_24": ["La déportation forcée d’Africains réduits en esclavage", "Les causes, les acteurs et les conséquences"],
      "terminale_renforcement_annuel_plus_25": ["100 Hz", "Hertz"],
      "terminale_renforcement_annuel_plus_26": ["Croiser les idées des documents", "Repérer convergences et différences"],
    };
    for (final entry in expected.entries) {
      final lesson = supplementalLessons.firstWhere((item) => item.id == entry.key);
      expect(lesson.questions, hasLength(2), reason: lesson.title);
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
    expect(questions, hasLength(52));
    expect(questions.map((question) => question.id).toSet(), hasLength(52));
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

}
