/// Selects the best available French voice without hard-coding a device voice.
/// Prefer France French, offline availability, then the engine's quality score.
Map<String, String>? selectFrenchTtsVoice(Iterable<Map> voices) {
  final candidates = <_FrenchVoiceCandidate>[];
  for (final voice in voices) {
    final name = voice['name']?.toString().trim() ?? '';
    final locale = voice['locale']?.toString().trim() ?? '';
    if (name.isEmpty || locale.isEmpty) continue;
    final normalized = locale.replaceAll('_', '-').toLowerCase();
    if (normalized != 'fr' && !normalized.startsWith('fr-')) continue;
    final exactFrance = normalized == 'fr-fr' || normalized.startsWith('fr-fr-');
    final networkRequired = voice['network_required'] == true ||
        voice['network_required']?.toString().toLowerCase() == 'true';
    final qualityValue = voice['quality'];
    final quality = qualityValue is num
        ? qualityValue.toInt()
        : int.tryParse(qualityValue?.toString() ?? '') ?? 0;
    candidates.add(_FrenchVoiceCandidate(
      name: name,
      locale: locale,
      exactFrance: exactFrance,
      networkRequired: networkRequired,
      quality: quality,
    ));
  }
  if (candidates.isEmpty) return null;
  candidates.sort((a, b) {
    final locale = (a.exactFrance ? 0 : 1).compareTo(b.exactFrance ? 0 : 1);
    if (locale != 0) return locale;
    final offline = (a.networkRequired ? 1 : 0).compareTo(b.networkRequired ? 1 : 0);
    if (offline != 0) return offline;
    return b.quality.compareTo(a.quality);
  });
  final selected = candidates.first;
  return {'name': selected.name, 'locale': selected.locale};
}

class _FrenchVoiceCandidate {
  final String name;
  final String locale;
  final bool exactFrance;
  final bool networkRequired;
  final int quality;

  const _FrenchVoiceCandidate({
    required this.name,
    required this.locale,
    required this.exactFrance,
    required this.networkRequired,
    required this.quality,
  });
}
