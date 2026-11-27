import 'package:flutter_test/flutter_test.dart';
import 'package:proftogo/data/models/models.dart';
import 'package:proftogo/data/sample/annual_core_catalog.dart';

void main() {
  test('annual unit order is mapped into the three school terms', () {
    expect(termForAnnualUnit(1, 5), 1);
    expect(termForAnnualUnit(2, 5), 1);
    expect(termForAnnualUnit(3, 5), 2);
    expect(termForAnnualUnit(4, 5), 3);
    expect(termForAnnualUnit(5, 5), 3);
    expect(termForAnnualUnit(1, 2), 1);
    expect(termForAnnualUnit(2, 2), 3);
    expect(termForAnnualUnit(1, 1), 1);
  });

  test('annual core chapters use only valid terms and distribute across T1-T3', () {
    final grouped = <String, List<Chapter>>{};
    for (final chapter in annualCoreChapters) {
      expect(chapter.term, inInclusiveRange(1, 3), reason: chapter.id);
      grouped.putIfAbsent(chapter.subjectId, () => <Chapter>[]).add(chapter);
    }
    for (final entry in grouped.entries) {
      final ordered = [...entry.value]
        ..sort((a, b) => a.order.compareTo(b.order));
      final expectedTerms = ordered
          .map((chapter) => termForAnnualUnit(chapter.order, ordered.length))
          .toList();
      expect(ordered.map((chapter) => chapter.term).toList(), expectedTerms,
          reason: 'Le trimestre doit correspondre à l’ordre des unités : ${entry.key}');
      for (var i = 1; i < ordered.length; i++) {
        expect(ordered[i].term, greaterThanOrEqualTo(ordered[i - 1].term),
            reason: 'Les trimestres doivent suivre l’ordre pédagogique : ${entry.key}');
      }
      if (entry.value.length >= 3) {
        final terms = entry.value.map((chapter) => chapter.term).toSet();
        expect(terms, containsAll(<int>{1, 2, 3}), reason: entry.key);
      }
    }
  });
}
