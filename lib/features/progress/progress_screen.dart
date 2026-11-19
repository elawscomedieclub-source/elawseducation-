import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/progress_service.dart';
import '../../core/evaluation_service.dart';
import '../../core/school_level_provider.dart';
import '../../data/sample/sample_data.dart';
import '../../data/models/models.dart';
import '../../shared/widgets/menu_button.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  late Future<List<dynamic>> _dataFuture;

  Future<List<dynamic>> _loadData() => Future.wait<dynamic>([
        ProgressService.load(),
        EvaluationService.loadHistory(),
      ]);

  @override
  void initState() {
    super.initState();
    _dataFuture = _loadData();
  }

  void _refresh() {
    setState(() => _dataFuture = _loadData());
  }

  @override
  Widget build(BuildContext context) {
    final selectedLevel = ref.watch(schoolLevelProvider);
    final selectedTrack = ref.watch(schoolTrackProvider);
    final selectedSeries = ref.watch(schoolSeriesProvider);
    return Scaffold(
      appBar: AppBar(
        leading: const ProfTogoMenuButton(),
        title: const Text('Ma progression'),
        actions: [
          IconButton(
            tooltip: 'Actualiser ma progression',
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Impossible de charger la progression pour le moment.'));
          }
          final progress = snapshot.data![0] as ProgressSnapshot;
          final allHistory = snapshot.data![1] as List<EvaluationRecord>;
          final subjects = demoSubjects.where((s) => subjectMatchesPath(s, selectedLevel, selectedTrack, selectedSeries)).toList();
          final subjectIds = subjects.map((s) => s.id).toSet();
          final history = allHistory.where((r) => r.level == selectedLevel.label && (subjectIds.contains(r.subjectId) || r.subjectId.startsWith('composition_${selectedLevel.name}_${selectedTrack.name}_${selectedSeries}_'))).toList();
          final exercisesBySubject = <String, List<String>>{};
          for (final subject in subjects) {
            final chapterIds = demoChapters.where((c) => c.subjectId == subject.id).map((c) => c.id).toSet();
            final lessonIds = demoLessons.where((l) => chapterIds.contains(l.chapterId)).map((l) => l.id).toSet();
            exercisesBySubject[subject.id] = demoExercises
                .where((e) => lessonIds.contains(e.lessonId)).map((e) => e.id).toList();
          }
          final allIds = exercisesBySubject.values.expand((ids) => ids).toSet();
          final answered = allIds.where(progress.answeredExerciseIds.contains).length;
          final xp = progress.xp;
          final overall = allIds.isEmpty ? 0.0 : answered / allIds.length;
          final average = history.isEmpty ? 0.0 : history.map((r) => r.score).reduce((a, b) => a + b) / history.length;
          final best = history.isEmpty ? 0 : history.map((r) => r.score).reduce((a, b) => a > b ? a : b);

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
                  Text(selectedLevel.label + (selectedLevel.index >= SchoolLevel.seconde.index ? ' • ${selectedTrack.label} • Série $selectedSeries' : '')),
                ]),
              ),
              const SizedBox(height: 18),
              Row(children: [
                Expanded(child: _statCard('Exercices validés', '$answered/${allIds.length}', Icons.edit_note)),
                const SizedBox(width: 10),
                Expanded(child: _statCard('Exercices restants', '${allIds.length - answered}', Icons.pending_actions)),
              ]),
              const SizedBox(height: 22),
              const Text('Progression générale', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              LinearProgressIndicator(value: overall, minHeight: 10, borderRadius: BorderRadius.circular(8)),
              const SizedBox(height: 6),
              Text('${(overall * 100).round()} % des exercices validés'),
              const SizedBox(height: 24),
              const Text('Résultats des évaluations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: _statCard('Moyenne', history.isEmpty ? '—' : '${average.toStringAsFixed(1)}/20', Icons.functions)),
                const SizedBox(width: 10),
                Expanded(child: _statCard('Meilleure note', history.isEmpty ? '—' : '$best/20', Icons.emoji_events_outlined)),
              ]),
              const SizedBox(height: 10),
              Text('${history.length} évaluation(s) effectuée(s) en ${selectedLevel.label}.'),
              const SizedBox(height: 12),
              if (history.isEmpty)
                const Text('Tes notes apparaîtront ici après tes premières évaluations.')
              else
                ...history.take(5).map((record) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.assignment_turned_in_outlined, color: Color(0xFF006A4E)),
                  title: Text('${record.subjectName} : ${record.score}/20'),
                  subtitle: Text('${record.correct}/${record.total} bonnes réponses • ${record.date.day.toString().padLeft(2, '0')}/${record.date.month.toString().padLeft(2, '0')}/${record.date.year}'),
                  trailing: Icon(record.score >= 10 ? Icons.check_circle : Icons.trending_up,
                    color: record.score >= 10 ? Colors.green : Colors.orange),
                )),
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
                'La progression et les notes sont enregistrées sur cet appareil. Elles ne se synchronisent pas encore entre plusieurs téléphones.',
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
