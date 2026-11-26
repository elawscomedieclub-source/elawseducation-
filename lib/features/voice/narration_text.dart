/// Prépare un texte de leçon pour une lecture vocale plus claire.
/// Le découpage conserve la ponctuation afin que le moteur TTS fasse des pauses.
class NarrationText {
  static String prepare(String raw) {
    return raw
        .replaceAll(RegExp(r'[#*_\x60~]'), '')
        .replaceAll(RegExp(r'^\s*[-•]\s*', multiLine: true), '')
        .replaceAll(RegExp(r'[\r\n]+'), '. ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'\.\s*\.'), '.')
        .trim();
  }

  /// Découpe en petits segments pour éviter la limite d'entrée de certains
  /// moteurs Android, tout en gardant les phrases ensemble autant que possible.
  static List<String> split(String raw, {int maxCharacters = 500}) {
    final text = prepare(raw);
    if (text.isEmpty) return const [];
    final limit = maxCharacters < 80 ? 80 : maxCharacters;
    final sentences = text.split(RegExp(r'(?<=[.!?;:])\s+'));
    final chunks = <String>[];
    var current = '';

    void flush() {
      if (current.trim().isNotEmpty) chunks.add(current.trim());
      current = '';
    }

    for (final sentence in sentences) {
      if (sentence.length <= limit) {
        final candidate = current.isEmpty ? sentence : '$current $sentence';
        if (candidate.length <= limit) {
          current = candidate;
        } else {
          flush();
          current = sentence;
        }
        continue;
      }

      flush();
      var part = '';
      for (final word in sentence.split(RegExp(r'\s+'))) {
        if (word.length > limit) {
          if (part.isNotEmpty) {
            chunks.add(part);
            part = '';
          }
          for (var start = 0; start < word.length; start += limit) {
            chunks.add(word.substring(start, start + limit > word.length ? word.length : start + limit));
          }
          continue;
        }
        final candidate = part.isEmpty ? word : '$part $word';
        if (candidate.length <= limit) {
          part = candidate;
        } else {
          if (part.isNotEmpty) chunks.add(part);
          part = word;
        }
      }
      if (part.isNotEmpty) chunks.add(part);
    }
    flush();
    return chunks;
  }
}
