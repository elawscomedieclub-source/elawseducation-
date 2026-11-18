import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentProfileCloudService {
  static DocumentReference<Map<String, dynamic>>? _document() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('profile')
        .doc('main');
  }

  static Future<Map<String, dynamic>?> load() async {
    final document = _document();
    if (document == null) return null;
    final snapshot = await document.get();
    return snapshot.exists ? snapshot.data() : null;
  }

  static Future<void> savePhoto(String photoBase64) async {
    final document = _document();
    if (document == null) return;
    await document.set({
      'photoBase64': photoBase64,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<void> deletePhoto() async {
    final document = _document();
    if (document == null) return;
    await document.set({
      'photoBase64': FieldValue.delete(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<void> saveName(String name) async {
    final document = _document();
    if (document == null) return;
    await document.set({
      'name': name.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<void> save({
    required String level,
    required String track,
    required String series,
  }) async {
    final document = _document();
    if (document == null) return;
    await document.set({
      'level': level,
      'track': track,
      'series': series,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
