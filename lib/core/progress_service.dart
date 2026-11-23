import 'dart:convert';

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

class ExerciseAttemptRecord {
  final String exerciseId;
  final String lessonId;
  final bool isCorrect;
  final DateTime timestamp;

  const ExerciseAttemptRecord({
    required this.exerciseId,
    required this.lessonId,
    required this.isCorrect,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'exerciseId': exerciseId,
    'lessonId': lessonId,
    'isCorrect': isCorrect,
    'timestamp': timestamp.toUtc().toIso8601String(),
  };

  factory ExerciseAttemptRecord.fromJson(Map<String, dynamic> json) {
    return ExerciseAttemptRecord(
      exerciseId: json['exerciseId'] as String? ?? '',
      lessonId: json['lessonId'] as String? ?? '',
      isCorrect: json['isCorrect'] as bool? ?? false,
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '')?.toUtc()
          ?? DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
    );
  }
}

class ProgressService {
  // Les caches locaux sont séparés par UID. Le cache invité est indépendant
  // de tous les comptes connectés.
  static String localStorageKey(String base, String? uid) =>
      uid == null ? '${base}_guest' : '${base}_user_$uid';

  // Dernière leçon consultée : clé locale isolée par compte et par invité.
  static Future<void> saveLastLesson(String lessonId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser?.uid != uid) return;
    await prefs.setString(localStorageKey('proftogo_last_lesson', uid), lessonId);
  }

  static Future<String?> loadLastLesson() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser?.uid != uid) return null;
    return prefs.getString(localStorageKey('proftogo_last_lesson', uid));
  }

  static Future<List<ExerciseAttemptRecord>> loadAttemptHistory() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser?.uid != uid) return <ExerciseAttemptRecord>[];
    final raw = prefs.getStringList(localStorageKey('proftogo_attempt_history', uid)) ?? <String>[];
    final records = <ExerciseAttemptRecord>[];
    for (final item in raw) {
      try {
        final decoded = jsonDecode(item);
        if (decoded is Map<String, dynamic>) {
          final record = ExerciseAttemptRecord.fromJson(decoded);
          if (record.exerciseId.isNotEmpty && record.lessonId.isNotEmpty && record.timestamp.millisecondsSinceEpoch > 0) records.add(record);
        }
      } catch (_) {}
    }
    records.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return records;
  }

  static Future<void> recordAttempt({required String exerciseId, required String lessonId, required bool isCorrect}) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser?.uid != uid) return;
    final key = localStorageKey('proftogo_attempt_history', uid);
    final raw = prefs.getStringList(key) ?? <String>[];
    raw.add(jsonEncode(ExerciseAttemptRecord(exerciseId: exerciseId, lessonId: lessonId, isCorrect: isCorrect, timestamp: DateTime.now().toUtc()).toJson()));
    if (raw.length > 200) raw.removeRange(0, raw.length - 200);
    if (FirebaseAuth.instance.currentUser?.uid != uid) return;
    await prefs.setStringList(key, raw);
  }

  // Les erreurs à revoir sont conservées séparément pour chaque compte.
  static Future<Set<String>> loadReviewExerciseIds() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser?.uid != uid) return <String>{};
    return (prefs.getStringList(localStorageKey('proftogo_review_exercises', uid)) ?? []).toSet();
  }

  // Compte les erreurs successives pour repérer les notions qui résistent.
  // Ces données restent isolées par compte, comme le reste de la progression.
  static Future<Map<String, int>> loadWrongAttemptCounts() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser?.uid != uid) return <String, int>{};
    final raw = prefs.getStringList(
          localStorageKey('proftogo_wrong_attempt_counts', uid),
        ) ??
        <String>[];
    final counts = <String, int>{};
    for (final entry in raw) {
      final separator = entry.lastIndexOf('|');
      if (separator <= 0) continue;
      final id = entry.substring(0, separator);
      final count = int.tryParse(entry.substring(separator + 1));
      if (count != null && count > 0) counts[id] = count;
    }
    return counts;
  }

  static Future<Map<String, int>> loadSkillDifficultyCounts() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser?.uid != uid) return <String, int>{};
    final raw = prefs.getStringList(
          localStorageKey('proftogo_skill_difficulty_counts', uid),
        ) ??
        <String>[];
    final counts = <String, int>{};
    for (final entry in raw) {
      final separator = entry.lastIndexOf('|');
      if (separator <= 0) continue;
      final skillId = entry.substring(0, separator);
      final count = int.tryParse(entry.substring(separator + 1));
      if (count != null && count > 0) counts[skillId] = count;
    }
    return counts;
  }

  static Future<void> recordWrongAnswer(
    String exerciseId, {
    String? skillId,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser?.uid != uid) return;
    final reviewKey = localStorageKey('proftogo_review_exercises', uid);
    final ids = (prefs.getStringList(reviewKey) ?? []).toSet()..add(exerciseId);
    final countsKey = localStorageKey('proftogo_wrong_attempt_counts', uid);
    final counts = await loadWrongAttemptCounts();
    if (FirebaseAuth.instance.currentUser?.uid != uid) return;
    counts[exerciseId] = (counts[exerciseId] ?? 0) + 1;
    await prefs.setStringList(reviewKey, ids.toList()..sort());
    if (FirebaseAuth.instance.currentUser?.uid != uid) return;
    final encoded = counts.entries
        .map((entry) => '${entry.key}|${entry.value}')
        .toList()
      ..sort();
    await prefs.setStringList(countsKey, encoded);

    // Tant que les questions ne sont pas toutes étiquetées par compétence,
    // la leçon sert de regroupement pédagogique provisoire.
    if (skillId != null && skillId.trim().isNotEmpty) {
      final skillCounts = await loadSkillDifficultyCounts();
      if (FirebaseAuth.instance.currentUser?.uid != uid) return;
      skillCounts[skillId] = (skillCounts[skillId] ?? 0) + 1;
      final skillKey = localStorageKey('proftogo_skill_difficulty_counts', uid);
      final skillEncoded = skillCounts.entries
          .map((entry) => '${entry.key}|${entry.value}')
          .toList()
        ..sort();
      await prefs.setStringList(skillKey, skillEncoded);
    }
  }

  static Future<void> clearReviewExercise(String exerciseId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser?.uid != uid) return;
    final key = localStorageKey('proftogo_review_exercises', uid);
    final ids = (prefs.getStringList(key) ?? []).toSet()..remove(exerciseId);
    if (FirebaseAuth.instance.currentUser?.uid != uid) return;
    await prefs.setStringList(key, ids.toList()..sort());
  }


  // Difficultés déclarées volontairement par l'élève, distinctes des erreurs observées.
  static Future<void> recordLearningBarrier(String category) async {
    if (!{'lecture', 'comprehension', 'methode'}.contains(category)) return;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser?.uid != uid) return;
    final key = localStorageKey('proftogo_declared_learning_barriers', uid);
    final counts = await loadLearningBarrierCounts();
    if (FirebaseAuth.instance.currentUser?.uid != uid) return;
    counts[category] = (counts[category] ?? 0) + 1;
    final encoded = counts.entries.map((entry) => '${entry.key}|${entry.value}').toList()..sort();
    await prefs.setStringList(key, encoded);
  }

  static Future<Map<String, int>> loadLearningBarrierCounts() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser?.uid != uid) return <String, int>{};
    final raw = prefs.getStringList(localStorageKey('proftogo_declared_learning_barriers', uid)) ?? <String>[];
    final counts = <String, int>{};
    for (final entry in raw) {
      final separator = entry.lastIndexOf('|');
      if (separator <= 0) continue;
      final count = int.tryParse(entry.substring(separator + 1));
      if (count != null && count > 0) counts[entry.substring(0, separator)] = count;
    }
    return counts;
  }

  static Future<ProgressSnapshot> load() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser?.uid != uid) {
      return const ProgressSnapshot(
        answeredExerciseIds: <String>{},
        correctExerciseIds: <String>{},
        xp: 0,
      );
    }
    // Anciennes clés globales non liées à un compte : elles ne sont plus sûres.
    await prefs.remove('proftogo_answered_exercises');
    await prefs.remove('proftogo_correct_exercises');
    await prefs.remove('proftogo_total_xp');
    if (FirebaseAuth.instance.currentUser?.uid != uid) {
      return const ProgressSnapshot(
        answeredExerciseIds: <String>{},
        correctExerciseIds: <String>{},
        xp: 0,
      );
    }
    final answeredKey = localStorageKey('proftogo_answered_exercises', uid);
    final correctKey = localStorageKey('proftogo_correct_exercises', uid);
    final localCorrect = (prefs.getStringList(correctKey) ?? []).toSet();
    final local = ProgressSnapshot(
      answeredExerciseIds: (prefs.getStringList(answeredKey) ?? []).toSet(),
      correctExerciseIds: localCorrect,
      xp: localCorrect.length * 10,
    );

    if (uid == null) return local;

    try {
      // La transaction conserve les acquis déjà présents sur les autres appareils.
      final cloudMerge = await CloudProgressService.mergeForCurrentUser(
        answeredExerciseIds: local.answeredExerciseIds,
        correctExerciseIds: local.correctExerciseIds,
      );
      if (FirebaseAuth.instance.currentUser?.uid != uid) return local;
      if (cloudMerge == null) return local;
      final merged = ProgressSnapshot(
        answeredExerciseIds: cloudMerge.progress.answeredExerciseIds,
        correctExerciseIds: cloudMerge.progress.correctExerciseIds,
        xp: cloudMerge.progress.xp,
      );
      await _saveLocal(prefs, merged, uid);
      return merged;
    } catch (_) {
      return local;
    }
  }

  static Future<bool> recordAnswer({
    required String exerciseId,
    required bool isCorrect,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser?.uid != uid) return false;
    final answeredKey = localStorageKey('proftogo_answered_exercises', uid);
    final correctKey = localStorageKey('proftogo_correct_exercises', uid);
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
      final cloudMerge = await CloudProgressService.mergeForCurrentUser(
        answeredExerciseIds: progress.answeredExerciseIds,
        correctExerciseIds: progress.correctExerciseIds,
        newlyCorrectExerciseId: exerciseId,
      );
      if (FirebaseAuth.instance.currentUser?.uid != uid) return earnedXp;
      if (cloudMerge != null) {
        earnedXp = cloudMerge.newlyEarnedExercise;
        final merged = ProgressSnapshot(
          answeredExerciseIds: cloudMerge.progress.answeredExerciseIds,
          correctExerciseIds: cloudMerge.progress.correctExerciseIds,
          xp: cloudMerge.progress.xp,
        );
        await _saveLocal(prefs, merged, uid);
      }
    } catch (_) {
      // L'exercice reste utilisable si le cloud est momentanément indisponible.
    }
    return earnedXp;
  }

  /// Réinitialise la progression locale et cloud du compte courant uniquement.
  static Future<void> clearCurrentAccount() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser?.uid != uid) return;
    await prefs.remove(localStorageKey('proftogo_answered_exercises', uid));
    await prefs.remove(localStorageKey('proftogo_correct_exercises', uid));
    await prefs.remove(localStorageKey('proftogo_total_xp', uid));
    await prefs.remove(localStorageKey('proftogo_review_exercises', uid));
    await prefs.remove(localStorageKey('proftogo_wrong_attempt_counts', uid));
    await prefs.remove(localStorageKey('proftogo_skill_difficulty_counts', uid));
    await prefs.remove(localStorageKey('proftogo_attempt_history', uid));
    await prefs.remove(localStorageKey('proftogo_last_lesson', uid));
    await prefs.remove('proftogo_answered_exercises');
    await prefs.remove('proftogo_correct_exercises');
    await prefs.remove('proftogo_total_xp');
    if (uid != null && FirebaseAuth.instance.currentUser?.uid == uid) {
      await CloudProgressService.clearForCurrentUser();
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
    String? uid,
  ) async {
    await prefs.setStringList(
      localStorageKey('proftogo_answered_exercises', uid),
      progress.answeredExerciseIds.toList()..sort(),
    );
    await prefs.setStringList(
      localStorageKey('proftogo_correct_exercises', uid),
      progress.correctExerciseIds.toList()..sort(),
    );
    await prefs.setInt(localStorageKey('proftogo_total_xp', uid), progress.xp);
  }

}
