import 'package:flutter/material.dart';
import '../../core/progress_service.dart';
import '../../data/models/models.dart';
import '../../data/sample/sample_data.dart';

class ExerciseScreen extends StatefulWidget {
  final Lesson lesson;
  const ExerciseScreen({super.key, required this.lesson});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final Map<String, int> _selectedAnswers = {};
  final Set<String> _answeredIds = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final progress = await ProgressService.load();
    if (!mounted) return;
    setState(() {
      _answeredIds.addAll(progress.answeredExerciseIds);
      _loading = false;
    });
  }

  Future<void> _checkAnswer(Exercise exercise) async {
    final answer = _selectedAnswers[exercise.id];
    if (answer == null || _answeredIds.contains(exercise.id)) return;
    final isCorrect = answer == exercise.correctIndex;
    final earnedXp = await ProgressService.recordAnswer(
      exerciseId: exercise.id,
      isCorrect: isCorrect,
    );
    if (!mounted) return;
    setState(() => _answeredIds.add(exercise.id));
    final message = earnedXp
        ? 'Bonne réponse ! +10 XP'
        : isCorrect
            ? 'Bonne réponse ! Cet exercice a déjà été comptabilisé.'
            : 'Pas tout à fait. La réponse a été enregistrée.';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = demoExercises.where((e) => e.lessonId == widget.lesson.id).toList();

    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Exercices')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Exercices')),
      body: items.isEmpty
          ? const Center(child: Text('Les exercices arrivent bientôt.'))
          : ListView(
              padding: const EdgeInsets.all(18),
              children: [
                const Text(
                  'Réponds aux questions et gagne 10 XP pour chaque bonne réponse.',
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 16),
                ...items.map((exercise) {
                  final answered = _answeredIds.contains(exercise.id);
                  final selected = _selectedAnswers[exercise.id];
                  final correct = selected == exercise.correctIndex;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 18),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exercise.question,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...List.generate(exercise.options.length, (index) {
                            return RadioListTile<int>(
                              contentPadding: EdgeInsets.zero,
                              value: index,
                              groupValue: selected,
                              onChanged: answered
                                  ? null
                                  : (value) {
                                      if (value != null) {
                                        setState(() => _selectedAnswers[exercise.id] = value);
                                      }
                                    },
                              title: Text(exercise.options[index]),
                            );
                          }),
                          if (!answered)
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                onPressed: selected == null
                                    ? null
                                    : () => _checkAnswer(exercise),
                                child: const Text('Vérifier ma réponse'),
                              ),
                            )
                          else ...[
                            Text(
                              selected == exercise.correctIndex
                                  ? 'Bonne réponse'
                                  : 'Réponse déjà enregistrée',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: selected == exercise.correctIndex
                                    ? Colors.green
                                    : Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(exercise.explanation),
                          ],
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
    );
  }
}
