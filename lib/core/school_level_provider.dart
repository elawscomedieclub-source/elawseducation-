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
