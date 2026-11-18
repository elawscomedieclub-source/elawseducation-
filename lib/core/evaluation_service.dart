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
  static const _key = 'proftogo_evaluation_history';

  static CollectionReference<Map<String, dynamic>>? _cloudCollection() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('evaluations');
  }

  static Future<List<EvaluationRecord>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
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
        final snapshot = await collection.get();
        final cloudIds = snapshot.docs.map((doc) => doc.id).toSet();

        // Migre les anciennes évaluations locales absentes du cloud.
        // Le maximum local est de 100 enregistrements, donc un seul batch suffit.
        final batch = FirebaseFirestore.instance.batch();
        var hasLocalRecordsToUpload = false;
        for (final entry in byId.entries) {
          if (!cloudIds.contains(entry.key)) {
            batch.set(collection.doc(entry.key), entry.value.toJson());
            hasLocalRecordsToUpload = true;
          }
        }
        if (hasLocalRecordsToUpload) {
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
          _key,
          merged.map((record) => jsonEncode(record.toJson())).toList(),
        );
        return merged;
      } catch (_) {
        // L'historique local reste disponible si le cloud est inaccessible.
      }
    }

    final records = byId.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return records;
  }

  static Future<void> save(EvaluationRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
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
    await prefs.setStringList(_key, raw);

    final collection = _cloudCollection();
    if (collection != null) {
      try {
        await collection.doc(record.cloudId).set(record.toJson());
      } catch (_) {
        // L'évaluation reste enregistrée localement en cas d'échec réseau.
      }
    }
  }
}
