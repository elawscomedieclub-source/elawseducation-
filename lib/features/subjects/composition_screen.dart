import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/evaluation_service.dart';
import '../../data/models/models.dart';
import '../../data/sample/sample_data.dart';
import 'cp2_completion_screen.dart';
import 'ce1_completion_screen.dart';
import 'ce2_completion_screen.dart';
import 'cm1_completion_screen.dart';
import 'cm2_completion_screen.dart';
import 'sixieme_completion_screen.dart';
import 'cinquieme_completion_screen.dart';
import 'quatrieme_completion_screen.dart';

class CompositionScreen extends StatefulWidget {
  final SchoolLevel level;
  final SchoolTrack track;
  final String series;
  const CompositionScreen({super.key, required this.level, this.track = SchoolTrack.generalLiterary, this.series = 'A4'});

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

  String get _preparationTitle => switch (widget.level) {
    SchoolLevel.cm2 => 'Préparation au CEPD',
    SchoolLevel.troisieme => 'Préparation au BEPC',
    SchoolLevel.premiere => 'Préparation au BAC I',
    SchoolLevel.terminale => 'Préparation au BAC II',
    _ => 'Révision et composition de passage',
  };

  String get _preparationAdvice => switch (widget.level) {
    SchoolLevel.cm2 => 'Révise la lecture, la dictée, les mathématiques, les sciences et les repères sur le Togo. Entraîne-toi à lire les consignes et à rédiger des réponses complètes.',
    SchoolLevel.troisieme => 'Consolide les méthodes de calcul, la rédaction, les sciences et l’analyse de documents. Pour chaque problème, écris les étapes du raisonnement avant la réponse.',
    SchoolLevel.premiere => 'Organise tes révisions par matière et par chapitre. Entraîne-toi à justifier les calculs, construire un plan et employer le vocabulaire scientifique ou littéraire adapté.',
    SchoolLevel.terminale => 'Travaille les notions essentielles, les exercices de synthèse et les sujets chronométrés. Après chaque entraînement, corrige tes erreurs et révise les chapitres concernés.',
    _ => 'Revois les leçons étudiées, refais les exercices sans regarder les réponses, puis entraîne-toi avec une composition. Les corrections servent à repérer les notions à reprendre.',
  };

  String get _resultAdvice {
    final score = _questions.isEmpty
        ? 0
        : (_correct * 20 / _questions.length).round();
    if (score >= 16) {
      return 'Excellent travail ! Continue à approfondir les notions et à expliquer tes démarches.';
    }
    if (score >= 12) {
      return 'Bon travail. Revois les questions ratées pour consolider tes acquis.';
    }
    if (score >= 10) {
      return 'Résultat encourageant. Reprends les leçons correspondantes et refais les exercices.';
    }
    return 'Reprends calmement les cours, note les erreurs et recommence un entraînement après révision.';
  }

  List<Exercise> _buildQuestions() {
    final subjects = demoSubjects
        .where((subject) =>
            subjectMatchesPath(subject, widget.level, widget.track, widget.series) &&
            (_selectedSubjectId == null || subject.id == _selectedSubjectId))
        .toList();

    // Prépare une banque mélangée par matière pour éviter les répétitions.
    final pools = <List<Exercise>>[];
    for (final subject in subjects) {
      final chapterIds = demoChapters
          .where((chapter) => chapter.subjectId == subject.id && chapter.term == _term)
          .map((chapter) => chapter.id)
          .toSet();
      final lessonIds = demoLessons
          .where((lesson) => chapterIds.contains(lesson.chapterId))
          .map((lesson) => lesson.id)
          .toSet();
      final pool = demoExercises
          .where((exercise) => lessonIds.contains(exercise.lessonId))
          .toList()
        ..shuffle(Random());
      if (pool.isNotEmpty) pools.add(pool);
    }

    if (widget.level == SchoolLevel.quatrieme) {
      final selectedName = _selectedSubjectId == null ? null : demoSubjects.firstWhere((s) => s.id == _selectedSubjectId).name;
      final fourPool = QuatriemeCompletionScreen.assessmentExercisesForTerm(_term, subjectName: selectedName)..shuffle(Random());
      if (fourPool.isNotEmpty) pools.add(fourPool);
    }
    if (widget.level == SchoolLevel.quatrieme) {
      final selectedName = _selectedSubjectId == null ? null : demoSubjects.firstWhere((s) => s.id == _selectedSubjectId).name;
      return baseCount + QuatriemeCompletionScreen.assessmentExercisesForTerm(_term, subjectName: selectedName).length;
    }
    if (widget.level == SchoolLevel.cinquieme) {
      final selectedName = _selectedSubjectId == null ? null : demoSubjects.firstWhere((s) => s.id == _selectedSubjectId).name;
      final fivePool = CinquiemeCompletionScreen.assessmentExercisesForTerm(_term, subjectName: selectedName)..shuffle(Random());
      if (fivePool.isNotEmpty) pools.add(fivePool);
    }
    if (widget.level == SchoolLevel.cinquieme) {
      final selectedName = _selectedSubjectId == null ? null : demoSubjects.firstWhere((s) => s.id == _selectedSubjectId).name;
      return baseCount + CinquiemeCompletionScreen.assessmentExercisesForTerm(_term, subjectName: selectedName).length;
    }
    if (widget.level == SchoolLevel.sixieme) {
      final selectedName = _selectedSubjectId == null ? null : demoSubjects.firstWhere((s) => s.id == _selectedSubjectId).name;
      final sixiemePool = SixiemeCompletionScreen.assessmentExercisesForTerm(_term, subjectName: selectedName)..shuffle(Random());
      if (sixiemePool.isNotEmpty) pools.add(sixiemePool);
    }
    if (widget.level == SchoolLevel.sixieme) {
      final selectedName = _selectedSubjectId == null ? null : demoSubjects.firstWhere((s) => s.id == _selectedSubjectId).name;
      return baseCount + SixiemeCompletionScreen.assessmentExercisesForTerm(_term, subjectName: selectedName).length;
    }
    if (widget.level == SchoolLevel.cm2) {
      final selectedName = _selectedSubjectId == null ? null : demoSubjects.firstWhere((s) => s.id == _selectedSubjectId).name;
      final cm2Pool = Cm2CompletionScreen.assessmentExercisesForTerm(_term, subjectName: selectedName)..shuffle(Random());
      if (cm2Pool.isNotEmpty) pools.add(cm2Pool);
    }
    if (widget.level == SchoolLevel.cm2) {
      final selectedName = _selectedSubjectId == null ? null : demoSubjects.firstWhere((s) => s.id == _selectedSubjectId).name;
      return baseCount + Cm2CompletionScreen.assessmentExercisesForTerm(_term, subjectName: selectedName).length;
    }
    if (widget.level == SchoolLevel.cm1) {
      final selectedName = _selectedSubjectId == null ? null : demoSubjects.firstWhere((s) => s.id == _selectedSubjectId).name;
      final cm1Pool = Cm1CompletionScreen.assessmentExercisesForTerm(_term, subjectName: selectedName)..shuffle(Random());
      if (cm1Pool.isNotEmpty) pools.add(cm1Pool);
    }
    if (widget.level == SchoolLevel.cm1) {
      final selectedName = _selectedSubjectId == null ? null : demoSubjects.firstWhere((s) => s.id == _selectedSubjectId).name;
      return baseCount + Cm1CompletionScreen.assessmentExercisesForTerm(_term, subjectName: selectedName).length;
    }
    if (widget.level == SchoolLevel.ce2) {
      final selectedName = _selectedSubjectId == null ? null : demoSubjects.firstWhere((s) => s.id == _selectedSubjectId).name;
      final ce2Pool = Ce2CompletionScreen.assessmentExercisesForTerm(_term, subjectName: selectedName)..shuffle(Random());
      if (ce2Pool.isNotEmpty) pools.add(ce2Pool);
    }

    // Les exercices complémentaires CE1 alimentent les compositions.
    if (widget.level == SchoolLevel.ce2) {
      final selectedName = _selectedSubjectId == null ? null : demoSubjects.firstWhere((s) => s.id == _selectedSubjectId).name;
      return baseCount + Ce2CompletionScreen.assessmentExercisesForTerm(_term, subjectName: selectedName).length;
    }
    if (widget.level == SchoolLevel.ce1) {
      final selectedName = _selectedSubjectId == null ? null : demoSubjects.firstWhere((s) => s.id == _selectedSubjectId).name;
      final ce1Pool = Ce1CompletionScreen.assessmentExercisesForTerm(_term, subjectName: selectedName)..shuffle(Random());
      if (ce1Pool.isNotEmpty) pools.add(ce1Pool);
    }

    // Le complément CP2 alimente les sujets mélangés et les sujets par matière.
    if (widget.level == SchoolLevel.ce1) {
      final selectedName = _selectedSubjectId == null ? null : demoSubjects.firstWhere((s) => s.id == _selectedSubjectId).name;
      return baseCount + Ce1CompletionScreen.assessmentExercisesForTerm(_term, subjectName: selectedName).length;
    }
    if (widget.level == SchoolLevel.cinquieme) {
      final selectedName = _selectedSubjectId == null ? null : demoSubjects.firstWhere((s) => s.id == _selectedSubjectId).name;
      return baseCount + CinquiemeCompletionScreen.assessmentExercisesForTerm(_term, subjectName: selectedName).length;
    }
    if (widget.level == SchoolLevel.cp2) {
      final selectedName = _selectedSubjectId == null
          ? null
          : demoSubjects.firstWhere((s) => s.id == _selectedSubjectId).name;
      final cp2Pool = Cp2CompletionScreen.assessmentExercisesForTerm(
        _term,
        subjectName: selectedName,
      )..shuffle(Random());
      if (cp2Pool.isNotEmpty) pools.add(cp2Pool);
    }

    final limit = _selectedSubjectId == null ? 20 : 10;
    final selected = <Exercise>[];
    final usedIds = <String>{};

    // Premier tour : une question par matière autant que possible.
    // Tours suivants : on ajoute une question par matière à chaque passage.
    var round = 0;
    while (selected.length < limit) {
      var addedInRound = false;
      for (final pool in pools) {
        if (round < pool.length && selected.length < limit) {
          final exercise = pool[round];
          if (usedIds.add(exercise.id)) {
            selected.add(exercise);
            addedInRound = true;
          }
        }
      }
      if (!addedInRound) break;
      round++;
    }

    selected.shuffle(Random());
    return selected;
  }

  int _availableExerciseCount() {
    final subjects = demoSubjects
        .where((s) => subjectMatchesPath(s, widget.level, widget.track, widget.series) &&
            (_selectedSubjectId == null || s.id == _selectedSubjectId))
        .toList();
    final chapterIds = demoChapters
        .where((c) => subjects.any((subject) => subject.id == c.subjectId) && c.term == _term)
        .map((c) => c.id)
        .toSet();
    final lessonIds = demoLessons
        .where((lesson) => chapterIds.contains(lesson.chapterId))
        .map((lesson) => lesson.id)
        .toSet();
    final baseCount = demoExercises
        .where((exercise) => lessonIds.contains(exercise.lessonId))
        .length;
    if (widget.level == SchoolLevel.cp2) {
      final selectedName = _selectedSubjectId == null
          ? null
          : demoSubjects.firstWhere((s) => s.id == _selectedSubjectId).name;
      return baseCount + Cp2CompletionScreen.assessmentExercisesForTerm(
        _term,
        subjectName: selectedName,
      ).length;
    }
    return baseCount;
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
    try {
      await EvaluationService.save(EvaluationRecord(
        subjectId: 'composition_${widget.level.name}_${widget.track.name}_${widget.series}_T$_term',
        subjectName: widget.level == SchoolLevel.premiere ? 'Préparation BAC I • trimestre $_term' : widget.level == SchoolLevel.terminale ? 'Préparation BAC II • trimestre $_term' : 'Composition du trimestre $_term',
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
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Impossible d’enregistrer le résultat. Réessaie avant de quitter.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.level == SchoolLevel.premiere ? 'Préparation BAC I' : widget.level == SchoolLevel.terminale ? 'Préparation BAC II' : 'Compositions • ${widget.level.label}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(_preparationTitle, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(_preparationAdvice, style: const TextStyle(height: 1.45)),
                const SizedBox(height: 8),
                const Text('Méthode conseillée : 1) relire le cours ; 2) refaire les exemples ; 3) traiter les exercices seul ; 4) faire une composition ; 5) corriger ses erreurs et reprendre les points difficiles.'),
                const SizedBox(height: 8),
                const Text('Choisis un trimestre et une matière. Tu peux préparer un sujet mélangé ou t’entraîner dans une seule matière. Les questions disponibles sont tirées au hasard. Un sujet mélangé peut contenir jusqu’à 20 questions, selon les matières et exercices disponibles.'),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Les chapitres sont répartis sur les trois trimestres selon leur ordre dans le programme. Le choix T1, T2 ou T3 filtre les exercices de la période sélectionnée ; l’enseignant peut ajuster cette progression.',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String?>(
                  value: _selectedSubjectId,
                  decoration: const InputDecoration(labelText: 'Matière', border: OutlineInputBorder()),
                  items: [
                    const DropdownMenuItem<String?>(value: null, child: Text('Toutes les matières')),
                    ...demoSubjects.where((s) => subjectMatchesPath(s, widget.level, widget.track, widget.series)).map((s) => DropdownMenuItem<String?>(value: s.id, child: Text(s.name))),
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
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${_availableExerciseCount()} exercice(s) disponible(s) pour cette sélection. '
                    '${_selectedSubjectId == null ? 'Le sujet mélangé propose jusqu’à 2 questions par matière et 20 au total.' : 'Une composition dans cette matière propose jusqu’à 10 questions.'}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(width: double.infinity, child: FilledButton.icon(
                  onPressed: (_submitted || _availableExerciseCount() == 0) ? null : _start,
                  icon: const Icon(Icons.assignment),
                  label: Text(_availableExerciseCount() == 0
                      ? 'Aucun exercice disponible'
                      : (_started ? 'Recommencer le sujet' : 'Commencer la composition')),
                )),
              ]),
            ),
          ),
          if (_started && _questions.isEmpty)
            const Padding(padding: EdgeInsets.all(20), child: Text('Aucun exercice disponible pour cette classe pour le moment.')),
          if (_started && _questions.isNotEmpty) ...[
            Card(child: Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Classe : ${widget.level.label}${widget.level.index >= SchoolLevel.seconde.index ? ' • ${widget.track.label} • Série ${widget.series}' : ''} • Trimestre : T$_term'),
              Text('Matière : ${_selectedSubjectId == null ? 'Toutes les matières' : demoSubjects.firstWhere((s) => s.id == _selectedSubjectId).name}'),
              Text('${_questions.length} questions • Note sur 20 • ${(20 / _questions.length).toStringAsFixed(1)} point(s) par bonne réponse'),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: _answers.length / _questions.length),
              Text('${_answers.length} réponse(s) sur ${_questions.length}', style: const TextStyle(fontSize: 12)),
            ]))),
            if (_submitted)
              Card(color: const Color(0xFFE8F5F0), child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(children: [
                  const Text('Résultat de la composition', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('${(_correct * 20 / _questions.length).round()}/20', style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Color(0xFF006A4E))),
                  Text('$_correct bonne(s) réponse(s) sur ${_questions.length}'),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: _questions.isEmpty ? 0 : _correct / _questions.length,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  const SizedBox(height: 10),
                  Text(_resultAdvice, textAlign: TextAlign.center),
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
                    Text('Question ${index + 1} • ${(20 / _questions.length).toStringAsFixed(1)} point(s)', style: const TextStyle(color: Color(0xFF006A4E), fontWeight: FontWeight.bold)),
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
}    if (widget.level == SchoolLevel.quatrieme) {
      final selectedName = _selectedSubjectId == null ? null : demoSubjects.firstWhere((s) => s.id == _selectedSubjectId).name;
      return baseCount + QuatriemeCompletionScreen.assessmentExercisesForTerm(_term, subjectName: selectedName).length;
    }

