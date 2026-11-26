import 'package:flutter_test/flutter_test.dart';
import 'package:proftogo/features/voice/narration_text.dart';

void main() {
  group('NarrationText', () {
    test('removes markdown and turns line breaks into natural pauses', () {
      expect(
        NarrationText.prepare('## Les fractions\n- Une moitié.\n- Un quart.'),
        'Les fractions. Une moitié. Un quart.',
      );
    });

    test('keeps sentences together while splitting long narration', () {
      final text = List<String>.filled(100, 'Cette phrase explique une notion importante.')
          .join(' ');
      final chunks = NarrationText.split(text, maxCharacters: 300);
      expect(chunks.length, greaterThan(1));
      expect(chunks.every((chunk) => chunk.length <= 300), isTrue);
      expect(chunks.join(' '), text);
    });

    test('splits a single long word safely and handles empty input', () {
      final chunks = NarrationText.split('x' * 180, maxCharacters: 80);
      expect(chunks.length, 3);
      expect(chunks.every((chunk) => chunk.length <= 80), isTrue);
      expect(NarrationText.split('   '), isEmpty);
    });
  });
}
