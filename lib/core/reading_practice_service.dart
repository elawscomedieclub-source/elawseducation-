import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Progression de l'atelier de lecture, isolée pour chaque compte.
class ReadingPracticeService {
  static String _key(String base, String? uid) =>
      uid == null ? '${base}_guest' : '${base}_user_$uid';

  static Future<Set<int>> loadCompletedStages() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser?.uid != uid) return <int>{};
    final values = prefs.getStringList(_key('proftogo_reading_stages', uid)) ?? [];
    return values.map(int.tryParse).whereType<int>().toSet();
  }

  static Future<int> loadAttemptCount() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser?.uid != uid) return 0;
    return prefs.getInt(_key('proftogo_reading_attempts', uid)) ?? 0;
  }

  /// Nombre de réponses fausses par étape (clés "0" à "3").
  static Future<Map<int, int>> loadStageWrongCounts() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser?.uid != uid) return <int, int>{};
    final result = <int, int>{};
    for (var stage = 0; stage < 4; stage++) {
      final count = prefs.getInt(_key('proftogo_reading_stage_${stage}_wrong', uid)) ?? 0;
      if (count > 0) result[stage] = count;
    }
    return result;
  }

  /// Enregistre les réponses par compte et par niveau scolaire.
  static Future<void> recordComprehensionAttempt({
    required bool isCorrect,
    required String levelKey,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser?.uid != uid) return;
    final totalKey = _key('proftogo_reading_comprehension_${levelKey}_total', uid);
    final correctKey = _key('proftogo_reading_comprehension_${levelKey}_correct', uid);
    await prefs.setInt(totalKey, (prefs.getInt(totalKey) ?? 0) + 1);
    if (isCorrect && FirebaseAuth.instance.currentUser?.uid == uid) {
      await prefs.setInt(correctKey, (prefs.getInt(correctKey) ?? 0) + 1);
    }
  }

  static Future<Map<String, int>> loadComprehensionStats({
    required String levelKey,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser?.uid != uid) {
      return {'total': 0, 'correct': 0};
    }
    return {
      'total': prefs.getInt(_key('proftogo_reading_comprehension_${levelKey}_total', uid)) ?? 0,
      'correct': prefs.getInt(_key('proftogo_reading_comprehension_${levelKey}_correct', uid)) ?? 0,
    };
  }

  static Future<void> recordAttempt({
    required int stageIndex,
    required bool isCorrect,
  }) async {
    if (stageIndex < 0 || stageIndex > 3) return;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser?.uid != uid) return;
    final attemptKey = _key('proftogo_reading_attempts', uid);
    await prefs.setInt(attemptKey, (prefs.getInt(attemptKey) ?? 0) + 1);
    if (!isCorrect) {
      final wrongKey = _key('proftogo_reading_stage_${stageIndex}_wrong', uid);
      await prefs.setInt(wrongKey, (prefs.getInt(wrongKey) ?? 0) + 1);
      return;
    }
    if (FirebaseAuth.instance.currentUser?.uid != uid) return;
    final stageKey = _key('proftogo_reading_stages', uid);
    final completed = (prefs.getStringList(stageKey) ?? []).toSet()
      ..add(stageIndex.toString());
    await prefs.setStringList(stageKey, completed.toList()..sort());
  }
}
