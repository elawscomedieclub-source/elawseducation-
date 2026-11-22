import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EvaluationRecord {
  final String subjectId;
  final String subjectName;
  final String level;
  final int score;
  final int correct;
  final int total;
  final DateTime date;

  const EvaluationRecord({
    required this.subjectId,
    required this.subjectName,
    required this.level,
    required this.score,
    required this.correct,
    required this.total,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'subjectId': subjectId,
    'subjectName': subjectName,
    'level': level,
    'score': score,
    'correct': correct,
    'total': total,
    'date': date.toIso8601String(),
  };

  factory EvaluationRecord.fromJson(Map<String, dynamic> json) => EvaluationRecord(
    subjectId: json['subjectId'] as String? ?? '',
    subjectName: json['subjectName'] as String? ?? '',
    level: json['level'] as String? ?? '',
    score: json['score'] as int? ?? 0,
    correct: json['correct'] as int? ?? 0,
    total: json['total'] as int? ?? 0,
    date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
  );

  String get cloudId => base64Url
      .encode(utf8.encode('${date.toIso8601String()}|$subjectId|$score|$correct|$total'))
      .replaceAll('=', '');
}

class EvaluationService {
  static String _keyForUser(String? uid) => uid == null
      ? 'proftogo_evaluation_history_guest'
      : 'proftogo_evaluation_history_user_$uid';

  static CollectionReference<Map<String, dynamic>>? _cloudCollection() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('evaluations');
  }

  static Future<List<EvaluationRecord>> loadHistory() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser?.uid != uid) return <EvaluationRecord>[];
    await prefs.remove('proftogo_evaluation_history');
    if (FirebaseAuth.instance.currentUser?.uid != uid) return <EvaluationRecord>[];
    final localKey = _keyForUser(uid);
    final raw = prefs.getStringList(localKey) ?? [];
    final byId = <String, EvaluationRecord>{};
    for (final item in raw) {
      try {
        final record = EvaluationRecord.fromJson(
          jsonDecode(item) as Map<String, dynamic>,
        );
        byId[record.cloudId] = record;
      } catch (_) {}
    }

    final collection = _cloudCollection();
    if (collection != null) {
      try {
        if (FirebaseAuth.instance.currentUser?.uid != uid) {
          return byId.values.toList();
        }
        final snapshot = await collection.get();
        if (FirebaseAuth.instance.currentUser?.uid != uid) {
          return byId.values.toList();
        }
        final cloudIds = snapshot.docs.map((doc) => doc.id).toSet();
        final batch = FirebaseFirestore.instance.batch();
        var hasLocalRecordsToUpload = false;
        for (final entry in byId.entries) {
          if (!cloudIds.contains(entry.key)) {
            batch.set(collection.doc(entry.key), entry.value.toJson());
            hasLocalRecordsToUpload = true;
          }
        }
        if (hasLocalRecordsToUpload &&
            FirebaseAuth.instance.currentUser?.uid == uid) {
          await batch.commit();
        }

        for (final doc in snapshot.docs) {
          final record = EvaluationRecord.fromJson(doc.data());
          byId[record.cloudId] = record;
        }
        final merged = byId.values.toList()
          ..sort((a, b) => b.date.compareTo(a.date));
        if (merged.length > 100) merged.removeRange(100, merged.length);
        await prefs.setStringList(
          localKey,
          merged.map((record) => jsonEncode(record.toJson())).toList(),
        );
        return merged;
      } catch (_) {
        // L'historique de ce compte reste disponible hors connexion.
      }
    }

    final records = byId.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return records;
  }

  /// Efface l'historique local et cloud du compte courant uniquement.
  static Future<void> clearCurrentAccountHistory() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser?.uid != uid) return;
    await prefs.remove(_keyForUser(uid));
    await prefs.remove('proftogo_evaluation_history');
    if (uid == null || FirebaseAuth.instance.currentUser?.uid != uid) return;
    final collection = _cloudCollection();
    if (collection == null) return;
    final snapshot = await collection.get();
    if (FirebaseAuth.instance.currentUser?.uid != uid) return;
    final batch = FirebaseFirestore.instance.batch();
    for (final document in snapshot.docs) {
      batch.delete(document.reference);
    }
    if (snapshot.docs.isNotEmpty &&
        FirebaseAuth.instance.currentUser?.uid == uid) {
      await batch.commit();
    }
  }

  static Future<void> save(
    EvaluationRecord record, {
    String? expectedUid,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (expectedUid != null && uid != expectedUid) return;
    final prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser?.uid != uid) return;
    await prefs.remove('proftogo_evaluation_history');
    if (FirebaseAuth.instance.currentUser?.uid != uid) return;
    final localKey = _keyForUser(uid);
    final raw = prefs.getStringList(localKey) ?? [];
    raw.removeWhere((item) {
      try {
        return EvaluationRecord.fromJson(
          jsonDecode(item) as Map<String, dynamic>,
        ).cloudId == record.cloudId;
      } catch (_) {
        return false;
      }
    });
    raw.insert(0, jsonEncode(record.toJson()));
    if (raw.length > 100) raw.removeRange(100, raw.length);
    if (FirebaseAuth.instance.currentUser?.uid != uid) return;
    await prefs.setStringList(localKey, raw);

    final collection = _cloudCollection();
    if (collection != null && FirebaseAuth.instance.currentUser?.uid == uid) {
      try {
        await collection.doc(record.cloudId).set(record.toJson());
      } catch (_) {
        // L'évaluation reste enregistrée localement en cas d'échec réseau.
      }
    }
  }
}
