import 'package:flutter_test/flutter_test.dart';
import 'package:proftogo/data/models/models.dart';
import 'package:proftogo/data/sample/supplemental_curriculum.dart';

void main() {
  test('les compléments annuels ajoutés sont présents et leurs réponses sont contrôlées', () {
    const expected = <String, List<String>>{
      "cp1_renforcement_annuel_1": ["Afi", "Il s’envole", "Dire les événements dans l’ordre"],
      "cp1_renforcement_annuel_2": ["Devant la boîte", "À côté", "Derrière"],
      "cp2_renforcement_annuel_3": ["Le centimètre", "Au début de l’objet", "Une longueur"],
      "cp2_renforcement_annuel_4": ["Dire ce qu’il faut faire", "Entoure", "Oui"],
      "ce1_renforcement_annuel_5": ["4 chacun", "La même quantité pour chacun", "3 billes"],
      "ce1_renforcement_annuel_6": ["D’eau et de lumière", "Elle se fane", "Du soleil"],
      "ce2_renforcement_annuel_7": ["Afrique de l’Ouest", "Le Ghana", "Le Bénin"],
      "ce2_renforcement_annuel_8": ["jouent", "Ama", "chantons"],
      "cm1_renforcement_annuel_9": ["3 reste 2", "Plus petit que le diviseur", "5 reste 3"],
      "cm1_renforcement_annuel_10": ["Au sud", "Au-dessus du centre sur une carte orientée au nord", "Varier selon les régions"],
      "cm1_renforcement_annuel_11": ["Pour fournir énergie et nutriments", "Variée", "Haricots"],
      "cm2_renforcement_annuel_12": ["15,75", "6,25", "Aligner les virgules"],
      "cm2_renforcement_annuel_13": ["Recevoir une éducation", "Respecter les règles", "Protégé et partagé"],
      "sixieme_renforcement_annuel_14": ["Le Nil", "Eau et terres fertiles", "De l’eau disponible"],
      "sixieme_renforcement_annuel_15": ["90°", "Aigu", "Un rapporteur"],
      "cinquieme_renforcement_annuel_16": ["Le temps à court terme", "Une longue période", "Du climat"],
      "cinquieme_renforcement_annuel_17": ["Les poumons", "L’oxygène", "Le dioxyde de carbone"],
      "quatrieme_renforcement_annuel_18": ["Les réactifs", "Les produits", "Se conserve"],
      "quatrieme_renforcement_annuel_19": ["2x + 10", "4a − 8", "Développer une expression"],
      "troisieme_renforcement_annuel_20": ["27 avril 1960", "La fête de l’indépendance", "La souveraineté d’un pays"],
      "troisieme_renforcement_annuel_21": ["Watt", "200 Wh", "Réduire la durée d’utilisation"],
      "seconde_renforcement_annuel_22": ["Population ÷ superficie", "100 habitants/km²", "Beaucoup d’habitants par unité de surface"],
      "seconde_renforcement_annuel_23": ["Distance ÷ durée", "60 km/h", "Augmente"],
      "premiere_renforcement_annuel_24": ["Justifier une idée", "Illustrer l’argument", "Donc"],
      "premiere_renforcement_annuel_25": ["Le cerveau", "Des messages nerveux", "Un changement détecté par un récepteur"],
      "terminale_renforcement_annuel_26": ["P(A∩B) ÷ P(B)", "0,4", "P(B)>0"],
      "terminale_renforcement_annuel_27": ["Formuler le problème à examiner", "Présenter et analyser le problème", "Argumenter et examiner des idées"],
    };
    for (final entry in expected.entries) {
      final lesson = supplementalLessons.firstWhere((item) => item.id == entry.key);
      expect(lesson.questions, hasLength(3), reason: lesson.title);
      for (var i = 0; i < 3; i++) {
        final question = lesson.questions[i];
        expect(question.choices[question.correctIndex], entry.value[i],
            reason: 'Réponse attendue incorrecte : ${question.id}');
        expect(question.choices.toSet(), hasLength(3), reason: question.id);
        expect(question.explanation.trim(), isNotEmpty, reason: question.id);
      }
    }
    expect(expected.length, 27);
  });

  test('les cours de renforcement annuel couvrent les 13 niveaux', () {
    for (final level in SchoolLevel.values) {
      expect(
        supplementalLessons.any((lesson) =>
            lesson.level == level && lesson.id.contains('renforcement_annuel')),
        isTrue,
        reason: 'Renforcement annuel manquant pour ${level.label}',
      );
    }
  });

  test('la banque bonus atteint au moins 292 leçons et 937 questions', () {
    expect(supplementalLessons.length, greaterThanOrEqualTo(292));
    expect(supplementalLessons.expand((lesson) => lesson.questions).length,
        greaterThanOrEqualTo(937));
  });
}
