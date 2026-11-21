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
  // Les caches locaux sont séparés par UID. Le cache invité est indépendant
  // de tous les comptes connectés.
  static String localStorageKey(String base, String? uid) =>
      uid == null ? '${base}_guest' : '${base}_user_$uid';

  static Future<ProgressSnapshot> load() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final answeredKey = localStorageKey('proftogo_answered_exercises', uid);
    final correctKey = _key('proftogo_correct_exercises', uid);
    final localCorrect = (prefs.getStringList(correctKey) ?? []).toSet();
    final local = ProgressSnapshot(
      answeredExerciseIds: (prefs.getStringList(answeredKey) ?? []).toSet(),
      correctExerciseIds: localCorrect,
      xp: localCorrect.length * 10,
    );

    if (uid == null) return local;

    try {
      final cloud = await CloudProgressService.loadForCurrentUser();
      // Ne jamais synchroniser le cache d'un compte précédent : chaque UID
      // dispose désormais de ses propres clés locales.
      if (FirebaseAuth.instance.currentUser?.uid != uid) return local;
      if (cloud == null) {
        await _saveCloud(local, uid);
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
      await _saveLocal(prefs, merged, uid);
      await _saveCloud(merged, uid);
      return merged;
    } catch (_) {
      return local;
    }
  }

  static Future<bool> recordAnswer({
    required String exerciseId,
    required bool isCorrect,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final answeredKey = _key('proftogo_answered_exercises', uid);
    final correctKey = _key('proftogo_correct_exercises', uid);
    final answered = (prefs.getStringList(answeredKey) ?? []).toSet();
    final correct = (prefs.getStringList(correctKey) ?? []).toSet();

    if (answered.contains(exerciseId) || !isCorrect) return false;

    answered.add(exerciseId);
    correct.add(exerciseId);
    final progress = ProgressSnapshot(
      answeredExerciseIds: answered,
      correctExerciseIds: correct,
      xp: correct.length * 10,
    );
    await _saveLocal(prefs, progress, uid);

    if (uid == null) return true;
    var earnedXp = true;
    try {
      final cloud = await CloudProgressService.loadForCurrentUser();
      if (FirebaseAuth.instance.currentUser?.uid != uid) return earnedXp;
      final cloudProgress = ProgressSnapshot(
        answeredExerciseIds: cloud?.answeredExerciseIds ?? <String>{},
        correctExerciseIds: cloud?.correctExerciseIds ?? <String>{},
        xp: cloud?.xp ?? 0,
      );
      earnedXp = !cloudProgress.correctExerciseIds.contains(exerciseId);
      final merged = mergeSnapshots(progress, cloudProgress);
      await _saveLocal(prefs, merged, uid);
      await _saveCloud(merged, uid);
    } catch (_) {
      // L'exercice reste utilisable si le cloud est momentanément indisponible.
    }
    return earnedXp;
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
    String? uid,
  ) async {
    await prefs.setStringList(
      _key('proftogo_answered_exercises', uid),
      progress.answeredExerciseIds.toList()..sort(),
    );
    await prefs.setStringList(
      _key('proftogo_correct_exercises', uid),
      progress.correctExerciseIds.toList()..sort(),
    );
    await prefs.setInt(_key('proftogo_total_xp', uid), progress.xp);
  }

  static Future<void> _saveCloud(ProgressSnapshot progress, String uid) async {
    if (FirebaseAuth.instance.currentUser?.uid != uid) return;
    await CloudProgressService.saveForCurrentUser(
      answeredExerciseIds: progress.answeredExerciseIds,
      correctExerciseIds: progress.correctExerciseIds,
      xp: progress.xp,
    );
  }
}
