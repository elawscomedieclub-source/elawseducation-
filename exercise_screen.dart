import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../data/models/models.dart';
import '../../core/theme/app_colors.dart';

class ExerciseScreen extends StatefulWidget {
  final List<Exercise> exercises;
  final String lessonTitle;

  const ExerciseScreen({
    super.key,
    required this.exercises,
    required this.lessonTitle,
  });

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  int currentIndex = 0;
  int? selectedOption;
  bool showResult = false;
  int correctCount = 0;

  Exercise get current => widget.exercises[currentIndex];

  void _select(int index) {
    if (showResult) return;
    setState(() => selectedOption = index);
  }

  void _validate() {
    if (selectedOption == null) return;
    setState(() {
      showResult = true;
      if (selectedOption == current.correctIndex) {
        correctCount++;
      }
    });
  }

  void _next() {
    if (currentIndex < widget.exercises.length - 1) {
      setState(() {
        currentIndex++;
        selectedOption = null;
        showResult = false;
      });
    } else {
      // Finished
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Bravo !'),
          content: Text(
            'Tu as obtenu $correctCount/${widget.exercises.length} bonnes réponses.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Terminer'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Exercice ${currentIndex + 1}/${widget.exercises.length}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.lessonTitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              current.question,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 28),
            ...List.generate(current.options.length, (index) {
              final isSelected = selectedOption == index;
              final isCorrect = index == current.correctIndex;
              Color? borderColor;
              Color? bgColor;

              if (showResult) {
                if (isCorrect) {
                  borderColor = AppColors.success;
                  bgColor = AppColors.success.withOpacity(0.1);
                } else if (isSelected && !isCorrect) {
                  borderColor = AppColors.error;
                  bgColor = AppColors.error.withOpacity(0.1);
                }
              } else if (isSelected) {
                borderColor = AppColors.primary;
                bgColor = AppColors.primary.withOpacity(0.08);
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Material(
                  color: bgColor ?? theme.cardTheme.color,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => _select(index),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: borderColor ?? theme.dividerColor.withOpacity(0.5),
                          width: borderColor != null ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(child: Text(current.options[index])),
                          if (showResult && isCorrect)
                            Icon(PhosphorIconsFill.checkCircle, color: AppColors.success),
                          if (showResult && isSelected && !isCorrect)
                            Icon(PhosphorIconsFill.xCircle, color: AppColors.error),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
            if (showResult) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  current.explanation,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
            const Spacer(),
            if (!showResult)
              ElevatedButton(
                onPressed: selectedOption != null ? _validate : null,
                child: const Text('Valider'),
              )
            else
              ElevatedButton(
                onPressed: _next,
                child: Text(
                  currentIndex < widget.exercises.length - 1 ? 'Question suivante' : 'Voir le résultat',
                ),
              ),
          ],
        ),
      ),
    );
  }
}
