import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../data/models/models.dart';
import '../../core/theme/app_colors.dart';
import 'exercise_screen.dart';

class LessonScreen extends StatelessWidget {
  final Lesson lesson;
  final List<Exercise> exercises;

  const LessonScreen({super.key, required this.lesson, required this.exercises});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leçon'),
        actions: [
          IconButton(
            icon: Icon(PhosphorIconsRegular.speakerHigh),
            tooltip: 'Écouter',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Lecture audio de la leçon (TTS à brancher)')),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            lesson.title,
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(PhosphorIconsRegular.clock, size: 16, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(
                '${lesson.durationMinutes} min',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Summary card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(PhosphorIconsFill.lightbulb, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'En résumé',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(lesson.summary),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Content
          Text(
            lesson.content,
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
          ),
          const SizedBox(height: 28),

          // Key points
          if (lesson.keyPoints.isNotEmpty) ...[
            Text('Points clés à retenir', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            ...lesson.keyPoints.map((point) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(PhosphorIconsFill.checkCircle, color: AppColors.success, size: 20),
                    const SizedBox(width: 10),
                    Expanded(child: Text(point, style: theme.textTheme.bodyLarge)),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),
          ],

          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Mode écoute activé (TTS)')),
                    );
                  },
                  icon: Icon(PhosphorIconsRegular.speakerHigh),
                  label: const Text('Écouter'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ExerciseScreen(
                          exercises: exercises,
                          lessonTitle: lesson.title,
                        ),
                      ),
                    );
                  },
                  icon: Icon(PhosphorIconsRegular.pencilSimple),
                  label: const Text('Exercices'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
