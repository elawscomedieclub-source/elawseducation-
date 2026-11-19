import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cloud_progress_service.dart';

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
    final localCorrect = (prefs.getStringList(_correctKey) ?? []).toSet();
    final local = ProgressSnapshot(
      answeredExerciseIds: (prefs.getStringList(_answeredKey) ?? []).toSet(),
      correctExerciseIds: localCorrect,
      xp: localCorrect.length * 10,
    );

    if (FirebaseAuth.instance.currentUser == null) return local;

    try {
      final cloud = await CloudProgressService.loadForCurrentUser();
      if (cloud == null) {
        await _saveCloud(local);
        return local;
      }

      final merged = mergeSnapshots(
        local,
        ProgressSnapshot(
          answeredExerciseIds: cloud.answeredExerciseIds,
          correctExerciseIds: cloud.correctExerciseIds,
          xp: cloud.xp,
        ),
      );
      await _saveLocal(prefs, merged);
      await _saveCloud(merged);
      return merged;
    } catch (_) {
      // La progression locale reste disponible même si Internet ou Firestore échoue.
      return local;
    }
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
    if (!isCorrect) return false;

    answered.add(exerciseId);
    correct.add(exerciseId);
    final progress = ProgressSnapshot(
      answeredExerciseIds: answered,
      correctExerciseIds: correct,
      xp: correct.length * 10,
    );
    await _saveLocal(prefs, progress);

    if (FirebaseAuth.instance.currentUser != null) {
      try {
        final cloud = await CloudProgressService.loadForCurrentUser();
        final cloudProgress = ProgressSnapshot(
          answeredExerciseIds: cloud?.answeredExerciseIds ?? <String>{},
          correctExerciseIds: cloud?.correctExerciseIds ?? <String>{},
          xp: cloud?.xp ?? 0,
        );
        final alreadyEarnedInCloud =
            cloudProgress.correctExerciseIds.contains(exerciseId);
        final merged = mergeSnapshots(progress, cloudProgress);
        await _saveLocal(prefs, merged);
        await _saveCloud(merged);
      } catch (_) {
        // Ne bloque jamais les exercices si la sauvegarde cloud échoue.
      }
    }
    return FirebaseAuth.instance.currentUser == null
        ? true
        : !((await _cloudAlreadyHadExercise(exerciseId)) ?? false);
  }

  static Future<bool?> _cloudAlreadyHadExercise(String exerciseId) async {
    try {
      final cloud = await CloudProgressService.loadForCurrentUser();
      return cloud?.correctExerciseIds.contains(exerciseId) ?? false;
    } catch (_) {
      return null;
    }
  }

  static ProgressSnapshot mergeSnapshots(
    ProgressSnapshot local,
    ProgressSnapshot cloud,
  ) {
    final correct = {...local.correctExerciseIds, ...cloud.correctExerciseIds};
    final answered = {
      ...local.answeredExerciseIds,
      ...cloud.answeredExerciseIds,
      ...correct,
    };
    return ProgressSnapshot(
      answeredExerciseIds: answered,
      correctExerciseIds: correct,
      xp: correct.length * 10,
    );
  }

  static Future<void> _saveLocal(
    SharedPreferences prefs,
    ProgressSnapshot progress,
  ) async {
    await prefs.setStringList(_answeredKey, progress.answeredExerciseIds.toList());
    await prefs.setStringList(_correctKey, progress.correctExerciseIds.toList());
    await prefs.setInt(_xpKey, progress.xp);
  }

  static Future<void> _saveCloud(ProgressSnapshot progress) async {
    await CloudProgressService.saveForCurrentUser(
      answeredExerciseIds: progress.answeredExerciseIds,
      correctExerciseIds: progress.correctExerciseIds,
      xp: progress.xp,
    );
  }
}
