import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/models.dart';

final schoolLevelProvider = StateNotifierProvider<SchoolLevelNotifier, SchoolLevel>(
  (ref) => SchoolLevelNotifier(),
);

class SchoolLevelNotifier extends StateNotifier<SchoolLevel> {
  SchoolLevelNotifier() : super(SchoolLevel.sixieme) {
    _load();
  }

  static const _key = 'student_school_level';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    final level = SchoolLevel.values.where((item) => item.name == saved);
    if (level.isNotEmpty) state = level.first;
  }

  Future<void> setLevel(SchoolLevel level) async {
    state = level;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, level.name);
  }
}

final schoolTrackProvider = StateNotifierProvider<SchoolTrackNotifier, SchoolTrack>(
  (ref) => SchoolTrackNotifier(),
);

class SchoolTrackNotifier extends StateNotifier<SchoolTrack> {
  SchoolTrackNotifier() : super(SchoolTrack.generalLiterary) { _load(); }
  static const _key = 'student_school_track';
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    for (final item in SchoolTrack.values) {
      if (item.name == saved) { state = item; break; }
    }
  }
  Future<void> setTrack(SchoolTrack value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, value.name);
  }
}

final schoolSeriesProvider = StateNotifierProvider<SchoolSeriesNotifier, String>(
  (ref) => SchoolSeriesNotifier(),
);

class SchoolSeriesNotifier extends StateNotifier<String> {
  SchoolSeriesNotifier() : super('A4') { _load(); }
  static const _key = 'student_school_series';
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString(_key) ?? 'A4';
  }
  Future<void> setSeries(String value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, value);
  }
}

List<String> seriesForTrack(SchoolTrack track) => switch (track) {
  SchoolTrack.generalLiterary => ['A4'],
  SchoolTrack.scientific => ['C', 'D'],
  SchoolTrack.technicalTertiary => technicalTertiarySeries,
  SchoolTrack.technicalIndustrial => technicalIndustrialSeries,
};

bool subjectMatchesPath(Subject subject, SchoolLevel level, SchoolTrack track, String series) {
  if (subject.level != level) return false;
  if (subject.track == null) return true;
  if (subject.track != track) return false;
  return subject.series == null || subject.series == series;
}
