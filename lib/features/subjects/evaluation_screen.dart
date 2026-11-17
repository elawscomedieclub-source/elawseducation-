import 'package:flutter/material.dart';
import '../../core/evaluation_service.dart';
import '../../data/models/models.dart';
import '../../data/sample/sample_data.dart' hide Lesson;

class EvaluationScreen extends StatefulWidget {
  final Subject subject;
  const EvaluationScreen({super.key, required this.subject});

  @override
  State<EvaluationScreen> createState() => _EvaluationScreenState();
}

class _EvaluationScreenState extends State<EvaluationScreen> {
  final Map<String, int> _answers = {};
  List<EvaluationRecord> _history = [];
  bool _loading = true;
  bool _submitted = false;
  bool _saving = false;
  int _correct = 0;

  List<Exercise> get _questions {
    final chapterIds = demoChapters
        .where((chapter) => chapter.subjectId == widget.subject.id)
        .map((chapter) => chapter.id)
        .toSet();
    final lessonIds = demoLessons
        .whereType<Lesson>()
        .where((lesson) => chapterIds.contains(lesson.chapterId))
        .map((lesson) => lesson.id)
        .toSet();
    return demoExercises
        .where((exercise) => lessonIds.contains(exercise.lessonId))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final records = await EvaluationService.loadHistory();
      if (!mounted) return;
      setState(() {
        _history = records.where((r) => r.subjectId == widget.subject.id).toList();
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('L’historique des notes est momentanément indisponible.')),
      );
    }
  }

  Future<void> _finishEvaluation() async {
    final questions = _questions;
    if (questions.isEmpty ||
        _answers.length != questions.length ||
        _submitted ||
        _saving) {
      return;
    }
    final correct = questions.where((q) => _answers[q.id] == q.correctIndex).length;
    final score = (correct * 20 / questions.length).round();
    final record = EvaluationRecord(
      subjectId: widget.subject.id,
      subjectName: widget.subject.name,
      level: widget.subject.level.label,
      score: score,
      correct: correct,
      total: questions.length,
      date: DateTime.now(),
    );

    setState(() => _saving = true);
    try {
      await EvaluationService.save(record);
      if (!mounted) return;
      setState(() {
        _correct = correct;
        _submitted = true;
        _saving = false;
        _history.insert(0, record);
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Impossible d’enregistrer la note. Réessaie avant de quitter.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final questions = _questions;
    return Scaffold(
      appBar: AppBar(title: Text('Évaluation • ${widget.subject.name}')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : questions.isEmpty
              ? const Center(child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('Aucun exercice disponible pour cette matière. Les questions seront ajoutées progressivement.', textAlign: TextAlign.center),
                ))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5F0),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Évaluation de ${widget.subject.name}', style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text('Classe : ${widget.subject.level.label} • ${questions.length} question(s)'),
                          const SizedBox(height: 6),
                          const Text('Réponds à toutes les questions. La note sera calculée sur 20.'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    if (_submitted)
                      Card(
                        color: _correct * 2 >= questions.length ? const Color(0xFFE8F5F0) : null,
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(children: [
                            const Text('Résultat de ton évaluation', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text('${(_correct * 20 / questions.length).round()}/20', style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Color(0xFF006A4E))),
                            Text('$_correct bonne(s) réponse(s) sur ${questions.length}'),
                            const SizedBox(height: 6),
                            Text(_correct * 2 >= questions.length ? 'Bravo, continue tes efforts !' : 'Continue à réviser, tu peux progresser !'),
                          ]),
                        ),
                      ),
                    ...List.generate(questions.length, (index) {
                      final question = questions[index];
                      final selected = _answers[question.id];
                      final isCorrect = selected == question.correctIndex;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 14),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Question ${index + 1}/${questions.length}', style: const TextStyle(color: Color(0xFF006A4E), fontWeight: FontWeight.bold)),
                              const SizedBox(height: 7),
                              Text(question.question, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                              ...List.generate(question.options.length, (optionIndex) => RadioListTile<int>(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                value: optionIndex,
                                groupValue: selected,
                                onChanged: _submitted ? null : (value) {
                                  if (value != null) setState(() => _answers[question.id] = value);
                                },
                                title: Text(question.options[optionIndex]),
                              )),
                              if (_submitted) ...[
                                const Divider(),
                                Text(isCorrect ? 'Bonne réponse' : 'Réponse correcte : ${question.options[question.correctIndex]}',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: isCorrect ? Colors.green : Colors.red)),
                                const SizedBox(height: 4),
                                Text('Correction : ${question.explanation}'),
                              ],
                            ],
                          ),
                        ),
                      );
                    }),
                    if (!_submitted)
                      FilledButton.icon(
                        onPressed: _answers.length == questions.length && !_saving ? _finishEvaluation : null,
                        icon: const Icon(Icons.check_circle_outline),
                        label: Text(_saving ? 'Enregistrement…' : 'Terminer et voir ma note (${_answers.length}/${questions.length})'),
                      )
                    else
                      OutlinedButton.icon(
                        onPressed: () => setState(() { _answers.clear(); _submitted = false; _saving = false; _correct = 0; }),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Recommencer cette évaluation'),
                      ),
                    const SizedBox(height: 24),
                    const Text('Historique de mes notes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    if (_history.isEmpty)
                      const Text('Tes résultats apparaîtront ici après ta première évaluation.')
                    else
                      ..._history.take(10).map((record) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.assignment_turned_in_outlined, color: Color(0xFF006A4E)),
                        title: Text('${record.score}/20 • ${record.correct}/${record.total} bonnes réponses'),
                        subtitle: Text('${record.date.day.toString().padLeft(2, '0')}/${record.date.month.toString().padLeft(2, '0')}/${record.date.year}'),
                      )),
                    const SizedBox(height: 12),
                    Text('Les notes sont conservées sur cet appareil.', style: TextStyle(color: Theme.of(context).hintColor, fontSize: 12)),
                  ],
                ),
    );
  }
}
