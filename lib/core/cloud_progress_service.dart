import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'progress_service.dart';

/// Sauvegarde cloud privée de la progression de l'élève connecté.
/// Cette classe ne remplace pas le stockage local existant.
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
  static Future<ProgressSnapshot?> loadForCurrentUser() async {
    final document = _progressDocument();
    if (document == null) return null;

    final snapshot = await document.get();
    if (!snapshot.exists) return null;

    final data = snapshot.data();
    if (data == null) return null;

    final answered = data['answeredExerciseIds'];
    final correct = data['correctExerciseIds'];
    final xp = data['xp'];

    return ProgressSnapshot(
      answeredExerciseIds: answered is List
          ? answered.whereType<String>().toSet()
          : <String>{},
      correctExerciseIds: correct is List
          ? correct.whereType<String>().toSet()
          : <String>{},
      xp: xp is int && xp >= 0 ? xp : 0,
    );
  }

  /// Enregistre uniquement les données pédagogiques de progression.
  /// Aucun nom, numéro de téléphone ou email n'est copié dans Firestore.
  static Future<void> saveForCurrentUser(
    ProgressSnapshot progress,
  ) async {
    final document = _progressDocument();
    if (document == null) return;

    await document.set({
      'answeredExerciseIds': progress.answeredExerciseIds.toList()..sort(),
      'correctExerciseIds': progress.correctExerciseIds.toList()..sort(),
      'xp': progress.xp < 0 ? 0 : progress.xp,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
