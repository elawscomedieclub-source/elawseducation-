import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../core/school_level_provider.dart';
import '../../core/progress_service.dart';
import '../../data/models/models.dart';
import '../../data/sample/sample_data.dart';

class ExerciseScreen extends ConsumerStatefulWidget {
  final Lesson lesson;
  /// When set, opens only this exercise from the review list.
  final String? reviewExerciseId;
  const ExerciseScreen({super.key, required this.lesson, this.reviewExerciseId});

  @override
  ConsumerState<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends ConsumerState<ExerciseScreen> {
  final FlutterTts _tts = FlutterTts();
  bool _speaking = false;
  final Map<String, int> _selectedAnswers = {};
  final Set<String> _answeredIds = {};
  final Set<String> _correctIds = {};
  final Set<String> _checkingIds = {};
  final Map<String, String> _feedback = {};
  bool _loading = true;
  bool _progressUnavailable = false;
  int _currentIndex = 0;
  late final StreamSubscription<User?> _authSubscription;
  int _progressLoadVersion = 0;

  @override
  void initState() {
    super.initState();
    _tts.setCompletionHandler(() {
      if (mounted) setState(() => _speaking = false);
    });
    _loadProgress();
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((_) {
      if (!mounted) return;
      setState(() {
        _selectedAnswers.clear();
        _answeredIds.clear();
        _correctIds.clear();
        _checkingIds.clear();
        _feedback.clear();
        _currentIndex = 0;
        _progressUnavailable = false;
        _loading = true;
      });
      _loadProgress();
    });
  }

  Future<void> _speakExercise(Exercise exercise) async {
    if (_speaking) {
      await _tts.stop();
      if (mounted) setState(() => _speaking = false);
      return;
    }
    final letters = ['A', 'B', 'C', 'D', 'E', 'F'];
    final choices = exercise.options.asMap().entries.map((entry) =>
      'Choix ${entry.key < letters.length ? letters[entry.key] : entry.key + 1}. ${entry.value}'
    ).join('. ');
    final explanation = _answeredIds.contains(exercise.id)
        ? ' Explication. ${exercise.explanation}'
        : '';
    try {
      await _tts.stop();
      await _tts.setLanguage('fr-FR');
      await _tts.setSpeechRate(0.70);
      if (mounted) setState(() => _speaking = true);
      await _tts.speak('Question ${_currentIndex + 1}. ${exercise.question}. $choices.$explanation');
    } catch (_) {
      if (mounted) {
        setState(() => _speaking = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('La lecture audio n’est pas disponible sur cet appareil.')),
        );
      }
    }
  }

  Future<void> _loadProgress() async {
    final version = ++_progressLoadVersion;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    try {
      final progress = await ProgressService.load();
      if (!mounted ||
          version != _progressLoadVersion ||
          FirebaseAuth.instance.currentUser?.uid != uid) return;
      setState(() {
        _answeredIds
          ..clear()
          ..addAll(progress.answeredExerciseIds);
        _correctIds
          ..clear()
          ..addAll(progress.correctExerciseIds);
        _loading = false;
      });
    } catch (_) {
      if (!mounted ||
          version != _progressLoadVersion ||
          FirebaseAuth.instance.currentUser?.uid != uid) return;
      setState(() {
        _progressUnavailable = true;
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    unawaited(_tts.stop());
    super.dispose();
  }

  Future<void> _checkAnswer(Exercise exercise) async {
    final answer = _selectedAnswers[exercise.id];
    if (answer == null ||
        _answeredIds.contains(exercise.id) ||
        _checkingIds.contains(exercise.id)) {
      return;
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    final isCorrect = answer == exercise.correctIndex;
    setState(() => _checkingIds.add(exercise.id));
    try {
      final earnedXp = await ProgressService.recordAnswer(
        exerciseId: exercise.id,
        isCorrect: isCorrect,
      );
      if (!mounted || FirebaseAuth.instance.currentUser?.uid != uid) return;
      if (isCorrect) {
        await ProgressService.clearReviewExercise(exercise.id);
      } else {
        await ProgressService.recordWrongAnswer(
          exercise.id,
          skillId: widget.lesson.id,
        );
      }
      if (!mounted || FirebaseAuth.instance.currentUser?.uid != uid) return;
      setState(() {
        _checkingIds.remove(exercise.id);
        if (isCorrect) {
          _answeredIds.add(exercise.id);
          _correctIds.add(exercise.id);
        }
        _feedback[exercise.id] = isCorrect
            ? (earnedXp ? 'Bonne réponse ! +10 XP' : 'Bonne réponse !')
            : 'Pas tout à fait. Relis l’explication et essaie encore.';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_feedback[exercise.id]!)),
      );
    } catch (_) {
      if (!mounted || FirebaseAuth.instance.currentUser?.uid != uid) return;
      setState(() => _checkingIds.remove(exercise.id));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enregistrement impossible. Vérifie puis réessaie.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final childMode = ref.watch(schoolLevelProvider).index <= SchoolLevel.cm2.index;
    final items = demoExercises.where((e) =>
        e.lessonId == widget.lesson.id &&
        (widget.reviewExerciseId == null || e.id == widget.reviewExerciseId),
      ).toList();
    final completedCount = items.where((e) => _correctIds.contains(e.id)).length;
    final completion = items.isEmpty ? 0.0 : completedCount / items.length;

    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Exercices')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Exercices')),
        body: const Center(child: Text('Les exercices arrivent bientôt.')),
      );
    }

    if (_currentIndex >= items.length) {
      return Scaffold(
        appBar: AppBar(title: const Text('Bilan des exercices')),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 18),
            Icon(Icons.emoji_events_rounded,
                size: 76, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 14),
            const Text('Séance terminée !',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text('$completedCount bonne(s) réponse(s) sur ${items.length}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            const SizedBox(height: 14),
            LinearProgressIndicator(value: completion, minHeight: 10),
            const SizedBox(height: 14),
            Text(
              completedCount == items.length
                  ? 'Excellent ! Tous les exercices de cette leçon sont validés.'
                  : 'Reprends les questions non validées, relis les explications et réessaie.',
              textAlign: TextAlign.center,
              style: const TextStyle(height: 1.5),
            ),
            const SizedBox(height: 22),
            FilledButton.icon(
              onPressed: () => setState(() => _currentIndex = 0),
              icon: const Icon(Icons.replay_rounded),
              label: const Text('Revoir les exercices'),
            ),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.menu_book_outlined),
              label: const Text('Retour à la leçon'),
            ),
          ],
        ),
      );
    }

    final exercise = items[_currentIndex];
    final answered = _answeredIds.contains(exercise.id);
    final selected = _selectedAnswers[exercise.id];
    final isCorrect = _correctIds.contains(exercise.id);
    final isLast = _currentIndex == items.length - 1;

    return Scaffold(
      appBar: AppBar(title: Text(widget.reviewExerciseId != null
          ? 'Je corrige mon erreur'
          : childMode ? 'Je m’entraîne' : 'Exercices • question par question')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          if (_progressUnavailable)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text('La progression enregistrée ne peut pas être chargée pour le moment. Tu peux continuer les exercices, mais vérifie le stockage de ton appareil avant de quitter.'),
              ),
            ),
          Text(
            widget.reviewExerciseId != null
                ? 'Reprends cette question calmement. Relis l’explication, cherche pourquoi la bonne réponse est correcte, puis réessaie sans te presser.'
                : childMode
                ? 'Écoute la question, puis touche la réponse qui te semble juste. Tu peux réécouter autant que tu veux.'
                : 'Réponds à une question, vérifie ta réponse, puis passe à la suivante. Chaque bonne réponse rapporte 10 XP.',
            style: const TextStyle(fontSize: 15, height: 1.4),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => _speakExercise(exercise),
              icon: Icon(_speaking ? Icons.stop_circle_rounded : Icons.volume_up_rounded),
              label: Text(_speaking ? 'Arrêter la lecture' : 'Écouter la question et les réponses'),
              style: FilledButton.styleFrom(
                minimumSize: Size.fromHeight(childMode ? 58 : 48),
                textStyle: TextStyle(fontSize: childMode ? 17 : 15, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Progression de la leçon',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${_currentIndex + 1}/${items.length}'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (_currentIndex + 1) / items.length,
                    minHeight: 8,
                  ),
                  const SizedBox(height: 7),
                  Text('$completedCount exercice(s) validé(s) sur ${items.length}.'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'QUESTION ${_currentIndex + 1}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: .6,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    exercise.question,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.35),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(exercise.options.length, (index) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: RadioListTile<int>(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                      value: index,
                      groupValue: isCorrect ? exercise.correctIndex : selected,
                      onChanged: answered || _checkingIds.contains(exercise.id)
                          ? null
                          : (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedAnswers[exercise.id] = value;
                                  _feedback.remove(exercise.id);
                                });
                              }
                            },
                      minVerticalPadding: childMode ? 16 : 10,
                      visualDensity: VisualDensity.standard,
                      title: Text(
                        childMode ? '${String.fromCharCode(65 + index)}. ${exercise.options[index]}' : exercise.options[index],
                        style: TextStyle(fontSize: childMode ? 19 : 16, height: 1.3, fontWeight: childMode ? FontWeight.w600 : FontWeight.normal),
                      ),
                    ));
                  }),
                  if (_feedback.containsKey(exercise.id) && !answered) ...[
                    const SizedBox(height: 8),
                    Text(
                      _feedback[exercise.id]!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text('Explication : ${exercise.explanation}'),
                    ),
                  ],
                  if (answered) ...[
                    const Divider(height: 24),
                    Text(
                      isCorrect ? 'Bonne réponse validée !' : 'Réponse déjà enregistrée',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: isCorrect
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text('Bonne réponse : ${exercise.options[exercise.correctIndex]}'),
                    const SizedBox(height: 7),
                    Text('Explication : ${exercise.explanation}',
                        style: const TextStyle(height: 1.45)),
                  ],
                  if (!answered) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: selected == null || _checkingIds.contains(exercise.id)
                            ? null
                            : () => _checkAnswer(exercise),
                        icon: const Icon(Icons.check_circle_outline),
                        label: Text(_checkingIds.contains(exercise.id)
                            ? 'Vérification…'
                            : 'Vérifier ma réponse'),
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => setState(() => _currentIndex++),
                        icon: Icon(isLast ? Icons.flag_rounded : Icons.arrow_forward_rounded),
                        label: Text(isLast ? 'Terminer les exercices' : 'Question suivante'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: _currentIndex == 0
                ? null
                : () => setState(() => _currentIndex--),
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Question précédente'),
          ),
        ],
      ),
    );
  }
}
