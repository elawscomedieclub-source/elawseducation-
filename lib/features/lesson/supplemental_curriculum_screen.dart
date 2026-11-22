import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../core/progress_service.dart';
import '../../core/school_level_provider.dart';
import '../../data/models/models.dart';
import '../../data/sample/supplemental_curriculum.dart';

class SupplementalCurriculumScreen extends ConsumerStatefulWidget {
  const SupplementalCurriculumScreen({super.key});
  @override
  ConsumerState<SupplementalCurriculumScreen> createState() => _SupplementalCurriculumScreenState();
}

class _SupplementalCurriculumScreenState extends ConsumerState<SupplementalCurriculumScreen> {
  final FlutterTts _tts = FlutterTts();
  final Set<String> _completed = {};
  final Map<String, int> _selected = {};
  int _lessonIndex = 0;
  bool _loading = true;
  bool _speaking = false;
  String? _feedback;

  @override
  void initState() {
    super.initState();
    _tts.setCompletionHandler(() {
      if (mounted) setState(() => _speaking = false);
    });
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    try {
      final progress = await ProgressService.load();
      if (!mounted) return;
      setState(() {
        _completed.addAll(progress.correctExerciseIds);
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _read(String text) async {
    if (_speaking) {
      await _tts.stop();
      if (mounted) setState(() => _speaking = false);
      return;
    }
    try {
      final level = ref.read(schoolLevelProvider);
      await _tts.stop();
      await _tts.setLanguage('fr-FR');
      await _tts.setSpeechRate(level.index <= SchoolLevel.cp2.index ? 0.38 : level.index <= SchoolLevel.cm2.index ? 0.46 : 0.54);
      if (mounted) setState(() => _speaking = true);
      await _tts.speak(text);
    } catch (_) {
      if (mounted) {
        setState(() => _speaking = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('La lecture audio n’est pas disponible sur ce téléphone.')));
      }
    }
  }

  Future<void> _check(SupplementalQuestion question) async {
    final answer = _selected[question.id];
    if (answer == null || _completed.contains(question.id)) return;
    if (answer != question.correctIndex) {
      setState(() => _feedback = 'Essaie encore. Écoute la question ou relis la leçon.');
      return;
    }
    try {
      await ProgressService.recordAnswer(exerciseId: question.id, isCorrect: true);
      if (!mounted) return;
      setState(() {
        _completed.add(question.id);
        _feedback = 'Bravo ! Bonne réponse. ' + question.explanation;
      });
    } catch (_) {
      if (mounted) setState(() => _feedback = 'Bonne réponse ! La sauvegarde sera réessayée plus tard.');
    }
  }

  @override
  void dispose() {
    unawaited(_tts.stop());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final level = ref.watch(schoolLevelProvider);
    final childMode = level.index <= SchoolLevel.cm2.index;
    final lessons = supplementalLessons.where((item) => item.level == level).toList();
    if (lessons.isEmpty) {
      return Scaffold(appBar: AppBar(title: const Text('Cours bonus')), body: const Center(child: Text('De nouvelles activités seront ajoutées pour cette classe.')));
    }
    if (_lessonIndex >= lessons.length) _lessonIndex = 0;
    final lesson = lessons[_lessonIndex];
    final questionIndex = _selectedQuestionIndex(lesson);
    final question = lesson.questions[questionIndex];
    final completedCount = lesson.questions.where((item) => _completed.contains(item.id)).length;

    return Scaffold(
      appBar: AppBar(title: Text('Cours bonus • ' + level.label)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
              children: [
                Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      childMode ? 'Bonjour ! Choisis une petite leçon, écoute-la, puis réponds aux questions.' : 'Des leçons courtes et des exercices supplémentaires pour réviser.',
                      style: TextStyle(fontSize: childMode ? 18 : 16, height: 1.4, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onPrimaryContainer),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text('Choisis une leçon', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                ...lessons.asMap().entries.map((entry) {
                  final selected = entry.key == _lessonIndex;
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      minVerticalPadding: childMode ? 14 : 8,
                      leading: CircleAvatar(radius: childMode ? 25 : 20, child: Icon(entry.value.subject == 'Mathématiques' ? Icons.calculate_rounded : Icons.menu_book_rounded)),
                      title: Text(entry.value.title, style: TextStyle(fontSize: childMode ? 18 : 16, fontWeight: FontWeight.w800)),
                      subtitle: Text(entry.value.subject),
                      trailing: selected ? const Icon(Icons.check_circle_rounded) : const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                      selected: selected,
                      onTap: () => setState(() {
                        _lessonIndex = entry.key;
                        _feedback = null;
                      }),
                    ),
                  );
                }),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(lesson.title, style: TextStyle(fontSize: childMode ? 23 : 20, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 10),
                        Text(lesson.explanation, style: TextStyle(fontSize: childMode ? 19 : 16, height: 1.5)),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(12)),
                          child: Text('Exemple : ' + lesson.example, style: TextStyle(fontSize: childMode ? 18 : 16, height: 1.4)),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () => _read(lesson.title + '. ' + lesson.explanation + '. Exemple. ' + lesson.example),
                            icon: Icon(_speaking ? Icons.stop_rounded : Icons.volume_up_rounded),
                            label: Text(_speaking ? 'Arrêter la lecture' : 'Écouter la leçon'),
                            style: FilledButton.styleFrom(minimumSize: Size.fromHeight(childMode ? 58 : 48), textStyle: TextStyle(fontSize: childMode ? 17 : 15, fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [Expanded(child: Text('Question ' + (questionIndex + 1).toString() + ' sur ' + lesson.questions.length.toString(), style: const TextStyle(fontWeight: FontWeight.w800))), Text(completedCount.toString() + '/' + lesson.questions.length.toString())]),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(value: completedCount / lesson.questions.length, minHeight: 8),
                        const SizedBox(height: 14),
                        Text(question.prompt, style: TextStyle(fontSize: childMode ? 21 : 18, fontWeight: FontWeight.w800, height: 1.35)),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => _read('Question. ' + question.prompt + '. ' + question.choices.asMap().entries.map((e) => 'Choix ' + (e.key + 1).toString() + '. ' + e.value).join('. ')),
                            icon: const Icon(Icons.volume_up_rounded),
                            label: const Text('Écouter la question'),
                            style: OutlinedButton.styleFrom(minimumSize: Size.fromHeight(childMode ? 52 : 44)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...List.generate(question.choices.length, (index) {
                          final isDone = _completed.contains(question.id);
                          return Card(
                            margin: const EdgeInsets.only(bottom: 7),
                            child: RadioListTile<int>(
                              value: index,
                              groupValue: _selected[question.id],
                              onChanged: isDone ? null : (value) => setState(() {
                                _selected[question.id] = value!;
                                _feedback = null;
                              }),
                              minVerticalPadding: childMode ? 15 : 8,
                              title: Text(question.choices[index], style: TextStyle(fontSize: childMode ? 20 : 16, fontWeight: childMode ? FontWeight.w600 : FontWeight.normal)),
                            ),
                          );
                        }),
                        if (_feedback != null) ...[
                          const SizedBox(height: 8),
                          Text(_feedback!, style: TextStyle(fontWeight: FontWeight.w700, color: _completed.contains(question.id) ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.error, height: 1.4)),
                        ],
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: _completed.contains(question.id)
                                ? () => setState(() {
                                    _feedback = null;
                                    if (questionIndex == lesson.questions.length - 1 && completedCount == lesson.questions.length) {
                                      _lessonIndex = (_lessonIndex + 1) % lessons.length;
                                    }
                                  })
                                : () => _check(question),
                            style: FilledButton.styleFrom(minimumSize: Size.fromHeight(childMode ? 58 : 48)),
                            child: Text(_completed.contains(question.id)
                                ? (questionIndex == lesson.questions.length - 1 && completedCount == lesson.questions.length ? 'Terminer cette leçon' : 'Question suivante')
                                : 'Vérifier ma réponse'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  int _selectedQuestionIndex(SupplementalLesson lesson) {
    for (var i = 0; i < lesson.questions.length; i++) {
      if (!_completed.contains(lesson.questions[i].id)) return i;
    }
    return lesson.questions.length - 1;
  }
}
