import 'dart:convert';
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
}

class EvaluationService {
  static const _key = 'proftogo_evaluation_history';

  static Future<List<EvaluationRecord>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    final records = <EvaluationRecord>[];
    for (final item in raw) {
      try {
        records.add(EvaluationRecord.fromJson(jsonDecode(item) as Map<String, dynamic>));
      } catch (_) {}
    }
    records.sort((a, b) => b.date.compareTo(a.date));
    return records;
  }

  static Future<void> save(EvaluationRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    raw.insert(0, jsonEncode(record.toJson()));
    if (raw.length > 100) raw.removeRange(100, raw.length);
    await prefs.setStringList(_key, raw);
  }
}
