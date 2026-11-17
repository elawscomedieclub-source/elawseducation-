import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/evaluation_service.dart';
import '../../data/models/models.dart';
import '../../data/sample/sample_data.dart';

class CompositionScreen extends StatefulWidget {
  final SchoolLevel level;
  const CompositionScreen({super.key, required this.level});

  @override
  State<CompositionScreen> createState() => _CompositionScreenState();
}

class _CompositionScreenState extends State<CompositionScreen> {
  int _term = 1;
  String? _selectedSubjectId;
  List<Exercise> _questions = [];
  final Map<String, int> _answers = {};
  bool _started = false;
  bool _submitted = false;
  bool _saving = false;
  int _correct = 0;

  List<Exercise> _buildQuestions() {
    final subjects = demoSubjects.where((s) => s.level == widget.level && (_selectedSubjectId == null || s.id == _selectedSubjectId)).toList();
    final selected = <Exercise>[];
    for (final subject in subjects) {
      final chapterIds = demoChapters.where((c) => c.subjectId == subject.id).map((c) => c.id).toSet();
      final lessonIds = demoLessons.where((l) => chapterIds.contains(l.chapterId)).map((l) => l.id).toSet();
      final pool = demoExercises.where((e) => lessonIds.contains(e.lessonId)).toList()..shuffle(Random());
      selected.addAll(pool.take(2));
    }
    selected.shuffle(Random());
    return selected.take(10).toList();
  }

  void _start() {
    final questions = _buildQuestions();
    setState(() {
      _questions = questions;
      _answers.clear();
      _submitted = false;
      _started = true;
      _correct = 0;
    });
  }

  Future<void> _finish() async {
    if (_answers.length != _questions.length || _submitted || _saving) return;
    setState(() => _saving = true);
    final correct = _questions.where((q) => _answers[q.id] == q.correctIndex).length;
    final score = _questions.isEmpty ? 0 : (correct * 20 / _questions.length).round();
    await EvaluationService.save(EvaluationRecord(
      subjectId: 'composition_${widget.level.name}_T$_term',
      subjectName: 'Composition du trimestre $_term',
      level: widget.level.label,
      score: score,
      correct: correct,
      total: _questions.length,
      date: DateTime.now(),
    ));
    if (!mounted) return;
    setState(() {
      _correct = correct;
      _submitted = true;
      _saving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Compositions • ${widget.level.label}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Composition d’entraînement', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Choisis un trimestre et une matière. Tu peux préparer un sujet mélangé ou t’entraîner dans une seule matière. Les questions disponibles sont tirées au hasard.'),
                const SizedBox(height: 12),
                DropdownButtonFormField<String?>(
                  value: _selectedSubjectId,
                  decoration: const InputDecoration(labelText: 'Matière', border: OutlineInputBorder()),
                  items: [
                    const DropdownMenuItem<String?>(value: null, child: Text('Toutes les matières')),
                    ...demoSubjects.where((s) => s.level == widget.level).map((s) => DropdownMenuItem<String?>(value: s.id, child: Text(s.name))),
                  ],
                  onChanged: _started ? null : (value) => setState(() => _selectedSubjectId = value),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  value: _term,
                  decoration: const InputDecoration(labelText: 'Trimestre', border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('Premier trimestre')),
                    DropdownMenuItem(value: 2, child: Text('Deuxième trimestre')),
                    DropdownMenuItem(value: 3, child: Text('Troisième trimestre')),
                  ],
                  onChanged: _started ? null : (value) { if (value != null) setState(() => _term = value); },
                ),
                const SizedBox(height: 12),
                SizedBox(width: double.infinity, child: FilledButton.icon(
                  onPressed: _submitted ? null : _start,
                  icon: const Icon(Icons.assignment),
                  label: Text(_started ? 'Recommencer le sujet' : 'Commencer la composition'),
                )),
              ]),
            ),
          ),
          if (_started && _questions.isEmpty)
            const Padding(padding: EdgeInsets.all(20), child: Text('Aucun exercice disponible pour cette classe pour le moment.')),
          if (_started && _questions.isNotEmpty) ...[
            Card(child: Padding(padding: const EdgeInsets.all(14), child: Text('Classe : ${widget.level.label} • Trimestre : T$_term • ${_selectedSubjectId == null ? 'Toutes les matières' : demoSubjects.firstWhere((s) => s.id == _selectedSubjectId).name} • ${_questions.length} questions • Note sur 20'))),
            if (_submitted)
              Card(color: const Color(0xFFE8F5F0), child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(children: [
                  const Text('Résultat de la composition', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('${(_correct * 20 / _questions.length).round()}/20', style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Color(0xFF006A4E))),
                  Text('$_correct bonne(s) réponse(s) sur ${_questions.length}'),
                ]),
              )),
            ...List.generate(_questions.length, (index) {
              final q = _questions[index];
              final selected = _answers[q.id];
              final good = selected == q.correctIndex;
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Question ${index + 1}', style: const TextStyle(color: Color(0xFF006A4E), fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(q.question, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    ...List.generate(q.options.length, (i) => RadioListTile<int>(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      value: i,
                      groupValue: selected,
                      onChanged: _submitted ? null : (v) { if (v != null) setState(() => _answers[q.id] = v); },
                      title: Text(q.options[i]),
                    )),
                    if (_submitted) ...[
                      const Divider(),
                      Text(good ? 'Bonne réponse' : 'Réponse correcte : ${q.options[q.correctIndex]}', style: TextStyle(fontWeight: FontWeight.bold, color: good ? Colors.green : Colors.red)),
                      Text('Correction : ${q.explanation}'),
                    ],
                  ]),
                ),
              );
            }),
            if (!_submitted)
              SizedBox(width: double.infinity, child: FilledButton.icon(
                onPressed: _answers.length == _questions.length && !_saving ? _finish : null,
                icon: const Icon(Icons.check_circle),
                label: Text(_saving ? 'Enregistrement…' : 'Terminer • ${_answers.length}/${_questions.length}'),
              ))
            else
              OutlinedButton.icon(
                onPressed: () => setState(() { _started = false; _submitted = false; _answers.clear(); _questions = []; }),
                icon: const Icon(Icons.refresh),
                label: const Text('Préparer une nouvelle composition'),
              ),
          ],
          const SizedBox(height: 18),
          const Text('Important : ces sujets sont des entraînements générés à partir des exercices présents dans ProfTogo. Ils ne constituent pas des sujets officiels du ministère et les trimestres ne sont pas encore associés individuellement à chaque leçon.', style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
