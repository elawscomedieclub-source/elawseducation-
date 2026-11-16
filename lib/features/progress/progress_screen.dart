import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/progress_service.dart';
import '../../core/school_level_provider.dart';
import '../../data/sample/sample_data.dart';
import '../../data/models/models.dart';
import '../../shared/widgets/menu_button.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLevel = ref.watch(schoolLevelProvider);
    return Scaffold(
      appBar: AppBar(leading: const ProfTogoMenuButton(), title: const Text('Ma progression')),
      body: FutureBuilder<ProgressSnapshot>(
        future: ProgressService.load(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Impossible de charger la progression pour le moment.'));
          }
          final progress = snapshot.data!;
          final subjects = demoSubjects.where((s) => s.level == selectedLevel).toList();
          final exercisesBySubject = <String, List<String>>{};
          for (final subject in subjects) {
            final chapterIds = demoChapters.where((c) => c.subjectId == subject.id).map((c) => c.id).toSet();
            final lessonIds = demoLessons.where((l) => chapterIds.contains(l.chapterId)).map((l) => l.id).toSet();
            exercisesBySubject[subject.id] = demoExercises
                .where((e) => lessonIds.contains(e.lessonId)).map((e) => e.id).toList();
          }
          final allIds = exercisesBySubject.values.expand((ids) => ids).toSet();
          final answered = allIds.where(progress.answeredExerciseIds.contains).length;
          final correct = allIds.where(progress.correctExerciseIds.contains).length;
          final xp = correct * 10;
          final overall = allIds.isEmpty ? 0.0 : answered / allIds.length;

          return ListView(
            padding: const EdgeInsets.all(18),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: const Color(0xFFE8F5F0), borderRadius: BorderRadius.circular(18)),
                child: Column(children: [
                  const Text('Tes points d’apprentissage', style: TextStyle(color: Color(0xFF245B48))),
                  const SizedBox(height: 5),
                  Text('$xp XP', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF006A4E))),
                  Text('Niveau ${selectedLevel.label}'),
                ]),
              ),
              const SizedBox(height: 18),
              Row(children: [
                Expanded(child: _statCard('Exercices réussis', '$answered/${allIds.length}', Icons.edit_note)),
                const SizedBox(width: 10),
                Expanded(child: _statCard('Bonnes réponses', '$correct', Icons.check_circle_outline)),
              ]),
              const SizedBox(height: 22),
              const Text('Progression générale', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              LinearProgressIndicator(value: overall, minHeight: 10, borderRadius: BorderRadius.circular(8)),
              const SizedBox(height: 6),
              Text('${(overall * 100).round()} % des exercices répondus'),
              const SizedBox(height: 24),
              const Text('Progression par matière', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              if (subjects.isEmpty) const Text('Aucune matière disponible pour ce niveau.')
              else ...subjects.map((subject) {
                final ids = exercisesBySubject[subject.id] ?? [];
                final done = ids.where(progress.answeredExerciseIds.contains).length;
                final value = ids.isEmpty ? 0.0 : done / ids.length;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Expanded(child: Text(subject.name, style: const TextStyle(fontWeight: FontWeight.w600))),
                      Text('$done/${ids.length}'),
                    ]),
                    const SizedBox(height: 7),
                    LinearProgressIndicator(value: value, minHeight: 9, borderRadius: BorderRadius.circular(8)),
                    const SizedBox(height: 4),
                    Text('${(value * 100).round()} %', style: Theme.of(context).textTheme.bodySmall),
                  ]),
                );
              }),
              const SizedBox(height: 10),
              Text(
                'La progression est enregistrée sur cet appareil. Elle ne se synchronise pas encore entre plusieurs téléphones.',
                style: TextStyle(color: Theme.of(context).hintColor, fontSize: 12),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: const Color(0xFFF2F5F4), borderRadius: BorderRadius.circular(14)),
    child: Column(children: [
      Icon(icon, color: const Color(0xFF006A4E)),
      const SizedBox(height: 6),
      Text(value, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
      Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
    ]),
  );
}
