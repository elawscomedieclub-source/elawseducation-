import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CloudProgressData {
  final Set<String> answeredExerciseIds;
  final Set<String> correctExerciseIds;
  final int xp;

  const CloudProgressData({
    required this.answeredExerciseIds,
    required this.correctExerciseIds,
    required this.xp,
  });
}

/// Sauvegarde cloud privée de la progression de l'élève connecté.
class CloudProgressService {
  static DocumentReference<Map<String, dynamic>>? _progressDocument() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('progress')
        .doc('main');
  }

  /// Renvoie null si l'élève n'est pas connecté ou si aucune sauvegarde n'existe.
  static Future<CloudProgressData?> loadForCurrentUser() async {
    final document = _progressDocument();
    if (document == null) return null;

    final snapshot = await document.get();
    if (!snapshot.exists) return null;

    final data = snapshot.data();
    if (data == null) return null;

    final answered = data['answeredExerciseIds'];
    final correct = data['correctExerciseIds'];
    final xp = data['xp'];

    return CloudProgressData(
      answeredExerciseIds: answered is List
          ? answered.whereType<String>().toSet()
          : <String>{},
      correctExerciseIds: correct is List
          ? correct.whereType<String>().toSet()
          : <String>{},
      xp: xp is int && xp >= 0 ? xp : 0,
    );
  }

  /// Efface uniquement la progression cloud de l'élève actuellement connecté.
  static Future<void> clearForCurrentUser() async {
    final document = _progressDocument();
    if (document == null) return;
    await document.delete();
  }

  /// Enregistre uniquement les données pédagogiques de progression.
  static Future<void> saveForCurrentUser({
    required Set<String> answeredExerciseIds,
    required Set<String> correctExerciseIds,
    required int xp,
  }) async {
    final document = _progressDocument();
    if (document == null) return;

    await document.set({
      'answeredExerciseIds': answeredExerciseIds.toList()..sort(),
      'correctExerciseIds': correctExerciseIds.toList()..sort(),
      'xp': xp < 0 ? 0 : xp,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
