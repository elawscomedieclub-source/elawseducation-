import 'package:shared_preferences/shared_preferences.dart';

class ProgressSnapshot {
  final Set<String> answeredExerciseIds;
  final Set<String> correctExerciseIds;
  final int xp;

  const ProgressSnapshot({
    required this.answeredExerciseIds,
    required this.correctExerciseIds,
    required this.xp,
  });
}

class ProgressService {
  static const _answeredKey = 'proftogo_answered_exercises';
  static const _correctKey = 'proftogo_correct_exercises';
  static const _xpKey = 'proftogo_total_xp';

  static Future<ProgressSnapshot> load() async {
    final prefs = await SharedPreferences.getInstance();
    return ProgressSnapshot(
      answeredExerciseIds: (prefs.getStringList(_answeredKey) ?? []).toSet(),
      correctExerciseIds: (prefs.getStringList(_correctKey) ?? []).toSet(),
      xp: prefs.getInt(_xpKey) ?? 0,
    );
  }

  // Retourne true uniquement si une bonne réponse vient de rapporter des XP.
  static Future<bool> recordAnswer({
    required String exerciseId,
    required bool isCorrect,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final answered = (prefs.getStringList(_answeredKey) ?? []).toSet();
    final correct = (prefs.getStringList(_correctKey) ?? []).toSet();

    if (answered.contains(exerciseId)) return false;

    answered.add(exerciseId);
    await prefs.setStringList(_answeredKey, answered.toList());

    if (!isCorrect) return false;
    correct.add(exerciseId);
    await prefs.setStringList(_correctKey, correct.toList());
    await prefs.setInt(_xpKey, (prefs.getInt(_xpKey) ?? 0) + 10);
    return true;
  }
}
