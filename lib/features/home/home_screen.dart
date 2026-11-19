import '../../shared/widgets/menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/school_level_provider.dart';
import '../../data/sample/sample_data.dart';
import '../../data/models/models.dart';
import '../../core/progress_service.dart';
import '../subjects/subject_detail_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Future<ProgressSnapshot> _progressFuture;

  @override
  void initState() {
    super.initState();
    _progressFuture = ProgressService.load();
  }

  @override
  Widget build(BuildContext context) {
    final selectedLevel = ref.watch(schoolLevelProvider);
    final selectedTrack = ref.watch(schoolTrackProvider);
    final selectedSeries = ref.watch(schoolSeriesProvider);
    final subjects = demoSubjects
        .where((subject) => subjectMatchesPath(subject, selectedLevel, selectedTrack, selectedSeries))
        .toList();

    return Scaffold(
      appBar: AppBar(
        leading: const ProfTogoMenuButton(),
        title: const Text('ProfTogo',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            tooltip: 'Actualiser la progression',
            onPressed: () => setState(() => _progressFuture = ProgressService.load()),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF006A4E),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('BONJOUR, ÉLÈVE !',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 8),
                const Text(
                  'Prêt à apprendre quelque chose de nouveau ?',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text('Ta classe : ${selectedLevel.label}' + (selectedLevel.index >= SchoolLevel.seconde.index ? ' • ${selectedTrack.label} • Série $selectedSeries' : ''),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                const Text('Continue tes efforts : chaque leçon compte.',
                    style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text('Ta progression',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          FutureBuilder<ProgressSnapshot>(
            future: _progressFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LinearProgressIndicator(minHeight: 3);
              }
              if (snapshot.hasError || !snapshot.hasData) {
                return const Text('La progression sera disponible dès que le stockage local fonctionnera.');
              }
              final progress = snapshot.data!;
              final chapterIds = demoChapters
                  .where((chapter) => subjects.any((subject) => subject.id == chapter.subjectId))
                  .map((chapter) => chapter.id)
                  .toSet();
              final lessonIds = demoLessons
                  .where((lesson) => chapterIds.contains(lesson.chapterId))
                  .map((lesson) => lesson.id)
                  .toSet();
              final levelExerciseIds = demoExercises
                  .where((exercise) => lessonIds.contains(exercise.lessonId))
                  .map((exercise) => exercise.id)
                  .toSet();
              final validated = levelExerciseIds
                  .where(progress.correctExerciseIds.contains)
                  .length;
              return Row(children: [
                _stat('⭐', '${progress.xp} XP', 'Points'),
                _stat('✓', '$validated', 'Validés'),
                _stat('📚', '${levelExerciseIds.length}', 'Exercices de la classe'),
              ]);
            },
          ),
          const SizedBox(height: 24),
          const Text('Matières à découvrir',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          if (subjects.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Text(
                  'Les cours de ' + selectedLevel.label +
                  ' sont en préparation. Consulte régulièrement ProfTogo '
                  'pour découvrir les nouvelles leçons.',
                ),
              ),
            )
          else
            ...subjects.map((subject) {
              final chapterIds = demoChapters
                  .where((chapter) => chapter.subjectId == subject.id)
                  .map((chapter) => chapter.id)
                  .toSet();
              final lessonIds = demoLessons
                  .where((lesson) => chapterIds.contains(lesson.chapterId))
                  .map((lesson) => lesson.id)
                  .toSet();
              final exerciseIds = demoExercises
                  .where((exercise) => lessonIds.contains(exercise.lessonId))
                  .map((exercise) => exercise.id)
                  .toSet();
              return FutureBuilder<ProgressSnapshot>(
                future: _progressFuture,
                builder: (context, progressSnapshot) {
                  final progress = progressSnapshot.data;
                  final done = progress == null
                      ? 0
                      : exerciseIds.where(progress.correctExerciseIds.contains).length;
                  final ratio = exerciseIds.isEmpty ? 0.0 : done / exerciseIds.length;
                  final subtitle = progressSnapshot.connectionState == ConnectionState.waiting
                      ? 'Chargement de ta progression…'
                      : progressSnapshot.hasError
                          ? 'Progression momentanément indisponible'
                          : '$done/${exerciseIds.length} exercices validés • ${(ratio * 100).round()} %';
                  return Card(
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFFE8F5F0),
                        child: Icon(Icons.menu_book, color: Color(0xFF006A4E)),
                      ),
                      title: Text(subject.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(subtitle),
                          const SizedBox(height: 6),
                          LinearProgressIndicator(
                            value: progress == null ? null : ratio,
                            minHeight: 5,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SubjectDetailScreen(subject: subject)),
                      ),
                    ),
                  );
                },
              );
            }),
        ],
      ),
    );
  }

  static Widget _stat(String icon, String value, String label) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(children: [
            Text(icon),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(fontSize: 11)),
          ]),
        ),
      ),
    );
  }
}
