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

  static Future<void> recordAttempt({
    required int stageIndex,
    required bool isCorrect,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser?.uid != uid) return;
    final attemptKey = _key('proftogo_reading_attempts', uid);
    await prefs.setInt(attemptKey, (prefs.getInt(attemptKey) ?? 0) + 1);
    if (!isCorrect || FirebaseAuth.instance.currentUser?.uid != uid) return;
    final stageKey = _key('proftogo_reading_stages', uid);
    final completed = (prefs.getStringList(stageKey) ?? []).toSet()
      ..add(stageIndex.toString());
    await prefs.setStringList(stageKey, completed.toList()..sort());
  }
}
