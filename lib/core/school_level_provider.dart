import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/models.dart';

String studentPreferenceKey(String base) {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  return uid == null ? '${base}_guest' : '${base}_user_$uid';
}

final schoolLevelProvider = StateNotifierProvider<SchoolLevelNotifier, SchoolLevel>(
  (ref) => SchoolLevelNotifier(),
);

class SchoolLevelNotifier extends StateNotifier<SchoolLevel> {
  SchoolLevelNotifier() : super(SchoolLevel.sixieme) { _load(); }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(studentPreferenceKey('student_school_level'));
    final level = SchoolLevel.values.where((item) => item.name == saved);
    if (level.isNotEmpty) state = level.first;
  }

  Future<void> setLevel(SchoolLevel level) async {
    state = level;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(studentPreferenceKey('student_school_level'), level.name);
  }
}

final schoolTrackProvider = StateNotifierProvider<SchoolTrackNotifier, SchoolTrack>(
  (ref) => SchoolTrackNotifier(),
);

class SchoolTrackNotifier extends StateNotifier<SchoolTrack> {
  SchoolTrackNotifier() : super(SchoolTrack.generalLiterary) { _load(); }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(studentPreferenceKey('student_school_track'));
    for (final item in SchoolTrack.values) {
      if (item.name == saved) { state = item; break; }
    }
  }

  Future<void> setTrack(SchoolTrack value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(studentPreferenceKey('student_school_track'), value.name);
  }
}

final schoolSeriesProvider = StateNotifierProvider<SchoolSeriesNotifier, String>(
  (ref) => SchoolSeriesNotifier(),
);

class SchoolSeriesNotifier extends StateNotifier<String> {
  SchoolSeriesNotifier() : super('A4') { _load(); }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString(studentPreferenceKey('student_school_series')) ?? 'A4';
  }

  Future<void> setSeries(String value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(studentPreferenceKey('student_school_series'), value);
  }
}

List<String> seriesForTrack(SchoolTrack track) => switch (track) {
  SchoolTrack.generalLiterary => ['A4'],
  SchoolTrack.scientific => ['C', 'D'],
  SchoolTrack.technicalTertiary => technicalTertiarySeries,
  SchoolTrack.technicalIndustrial => technicalIndustrialSeries,
};
