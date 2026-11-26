import 'package:flutter_test/flutter_test.dart';
import 'package:proftogo/core/french_tts_voice_selector.dart';

void main() {
  group('French TTS voice selection', () {
    test('prefers an offline France-French voice over other locales', () {
      final voice = selectFrenchTtsVoice([
        {'name': 'French Canadian', 'locale': 'fr-CA', 'quality': 5000},
        {'name': 'French France Online', 'locale': 'fr-FR', 'quality': 5000, 'network_required': true},
        {'name': 'French France Local', 'locale': 'fr_FR', 'quality': 3000, 'network_required': false},
        {'name': 'English', 'locale': 'en-US', 'quality': 5000},
      ]);
      expect(voice, {'name': 'French France Local', 'locale': 'fr_FR'});
    });

    test('prefers higher quality when locale and offline status match', () {
      final voice = selectFrenchTtsVoice([
        {'name': 'Basic French', 'locale': 'fr-FR', 'quality': 2000},
        {'name': 'Premium French', 'locale': 'fr-FR', 'quality': 5000},
      ]);
      expect(voice?['name'], 'Premium French');
    });

    test('returns null when no French voice is available', () {
      expect(selectFrenchTtsVoice([
        {'name': 'English', 'locale': 'en-US'},
      ]), isNull);
    });
  });
}
