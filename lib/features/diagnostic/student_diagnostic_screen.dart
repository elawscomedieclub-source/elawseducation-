import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/progress_service.dart';
import '../../core/school_level_provider.dart';
import '../../data/models/models.dart';
import '../../core/reading_practice_service.dart';
import '../reading/reading_basics_screen.dart';
import '../../data/sample/sample_data.dart';
import '../lesson/lesson_screen.dart';
import '../lesson/exercise_screen.dart';

class StudentDiagnosticScreen extends ConsumerStatefulWidget {
  const StudentDiagnosticScreen({super.key});
  @override
  ConsumerState<StudentDiagnosticScreen> createState() => _StudentDiagnosticScreenState();
}

class _StudentDiagnosticScreenState extends ConsumerState<StudentDiagnosticScreen> {
  late Future<_Diagnostic> _future;
  @override
  void initState() { super.initState(); _future = _load(); }

  Future<_Diagnostic> _load() async {
    final results = await Future.wait([
      ProgressService.load(),
      ProgressService.loadSkillDifficultyCounts(),
      ProgressService.loadWrongAttemptCounts(),
      ProgressService.loadReviewExerciseIds(),
      ReadingPracticeService.loadCompletedStages(),
      ReadingPracticeService.loadAttemptCount(),
      ReadingPracticeService.loadStageWrongCounts(),
      ProgressService.loadLearningBarrierCounts(),
    ]);
    return _Diagnostic(
      results[0] as ProgressSnapshot,
      results[1] as Map<String, int>,
      results[2] as Map<String, int>,
      results[3] as Set<String>,
      results[4] as Set<int>,
      results[5] as int,
      results[6] as Map<int, int>,
      results[7] as Map<String, int>,
    );
  }

  @override
  Widget build(BuildContext context) {
    final level = ref.watch(schoolLevelProvider);
    final track = ref.watch(schoolTrackProvider);
    final series = ref.watch(schoolSeriesProvider);
    final subjects = demoSubjects.where((s) => subjectMatchesPath(s, level, track, series)).toList();
    final chapters = demoChapters.where((c) => subjects.any((s) => s.id == c.subjectId)).toList();
    final lessons = demoLessons.where((l) => chapters.any((c) => c.id == l.chapterId)).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Mon diagnostic intelligent'), actions: [
        IconButton(onPressed: () => setState(() => _future = _load()), icon: const Icon(Icons.refresh_rounded)),
      ]),
      body: FutureBuilder<_Diagnostic>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snap.hasData) return const Center(child: Text('Diagnostic momentanément indisponible.'));
          final d = snap.data!;
          final correct = d.progress.correctExerciseIds.length;
          // Chaque erreur est une tentative distincte ; les réussites sont
          // comptées une fois par exercice validé.
          final wrongAttempts = d.exerciseErrors.values.fold<int>(
            0,
            (total, count) => total + count,
          );
          final attempts = correct + wrongAttempts;
          final rate = attempts == 0 ? 0 : (correct * 100 / attempts).round();
          final difficulties = d.lessonErrors.entries.where((e) => e.value >= 2 && lessons.any((l) => l.id == e.key)).toList()
            ..sort((a, b) => b.value.compareTo(a.value));

          // État pédagogique calculé uniquement à partir des exercices réellement
          // présents et des réponses enregistrées pour le compte courant.
          final lessonProgress = lessons.map((lesson) {
            final exercises = demoExercises.where((e) => e.lessonId == lesson.id).toList();
            final correctCount = exercises.where((e) => d.progress.correctExerciseIds.contains(e.id)).length;
            final reviewCount = exercises.where((e) => d.reviewIds.contains(e.id)).length;
            final wrongCount = exercises.fold<int>(0, (sum, e) => sum + (d.exerciseErrors[e.id] ?? 0));
            final status = exercises.isEmpty
                ? 'indisponible'
                : correctCount == exercises.length
                    ? 'reussi'
                    : reviewCount > 0 || wrongCount >= 2
                        ? 'a_revoir'
                        : correctCount > 0
                            ? 'en_progres'
                            : wrongCount > 0
                                ? 'a_reprendre'
                                : 'a_decouvrir';
            return _LessonProgress(lesson, exercises.length, correctCount, reviewCount, wrongCount, status);
          }).where((item) => item.total > 0).toList()
            ..sort((a, b) {
              int rank(String status) => switch (status) {
                'a_revoir' => 0,
                'a_reprendre' => 1,
                'en_progres' => 2,
                'a_decouvrir' => 3,
                _ => 4,
              };
              final byStatus = rank(a.status).compareTo(rank(b.status));
              return byStatus != 0 ? byStatus : a.lesson.title.compareTo(b.lesson.title);
            });
          final nextLesson = lessonProgress.isEmpty ? null : lessonProgress.first;
          return RefreshIndicator(
            onRefresh: () async { setState(() => _future = _load()); await _future; },
            child: ListView(padding: const EdgeInsets.all(16), children: [
              Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Row(children: [Icon(Icons.psychology_alt_rounded, size: 30), SizedBox(width: 10), Expanded(child: Text('Je découvre comment tu apprends', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)))]),
                const SizedBox(height: 10),
                Text(attempts == 0
                  ? 'Ton diagnostic commence avec tes premiers exercices. Réponds tranquillement : tes réussites et tes erreurs m’aideront à choisir les révisions utiles.'
                  : 'J’ai observé ' + attempts.toString() + ' tentatives et ' + correct.toString() + ' réussites. Ton taux de réussite observé est de ' + rate.toString() + ' %. Je continue à apprendre de tes réponses.'),
                const SizedBox(height: 12),
                Wrap(spacing: 8, children: [
                  Chip(avatar: const Icon(Icons.edit_note), label: Text(attempts.toString() + ' tentatives')),
                  Chip(avatar: const Icon(Icons.check_circle_outline), label: Text(correct.toString() + ' réussites')),
                  Chip(avatar: const Icon(Icons.replay), label: Text(d.reviewIds.length.toString() + ' à revoir')),
                ]),
              ]))),
              if (nextLesson != null) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Row(children: [
                        Icon(Icons.flag_circle_rounded),
                        SizedBox(width: 9),
                        Expanded(child: Text('Ma prochaine étape', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800))),
                      ]),
                      const SizedBox(height: 8),
                      Text(nextLesson.status == 'a_revoir' || nextLesson.status == 'a_reprendre'
                          ? 'Je te conseille de reprendre cette leçon en priorité :'
                          : nextLesson.status == 'en_progres'
                              ? 'Tu as déjà commencé cette leçon. Continue pour valider les exercices disponibles :'
                              : 'Choisis cette leçon pour commencer ton entraînement :'),
                      const SizedBox(height: 6),
                      Text(nextLesson.lesson.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 10),
                      Wrap(spacing: 8, runSpacing: 8, children: [
                        OutlinedButton.icon(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LessonContentScreen(lesson: nextLesson.lesson)))
                              .then((_) => setState(() => _future = _load())),
                          icon: const Icon(Icons.menu_book_outlined),
                          label: const Text('Revoir le cours'),
                        ),
                        FilledButton.icon(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ExerciseScreen(lesson: nextLesson.lesson)))
                              .then((_) => setState(() => _future = _load())),
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: const Text('Commencer'),
                        ),
                      ]),
                    ]),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(children: [
                        Icon(Icons.auto_stories_rounded),
                        SizedBox(width: 9),
                        Expanded(child: Text('Mon apprentissage de la lecture', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800))),
                      ]),
                      const SizedBox(height: 8),
                      Text('${d.readingStages.length} étape(s) validée(s) sur 4 • ${d.readingAttempts} tentative(s)'),
                      if (d.readingWrongCounts.values.any((count) => count >= 2)) ...[
                        const SizedBox(height: 8),
                        const Text('Une étape mérite un entraînement supplémentaire : plusieurs réponses y ont été incorrectes. Ce n’est pas un échec, mais un repère pour reprendre calmement.', style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        ...d.readingWrongCounts.entries.where((e) => e.value >= 2).map((e) => Text('• Étape ${e.key + 1} : ${e.value} réponse(s) incorrecte(s) observée(s).')),
                      ],
                      const SizedBox(height: 8),
                      LinearProgressIndicator(value: d.readingStages.length / 4),
                      const SizedBox(height: 8),
                      Text(
                        d.readingStages.length == 4
                          ? 'Tu as terminé les quatre étapes de base. Tu peux les reprendre pour entretenir tes acquis.'
                          : 'Continue le parcours dans l’ordre : sons et lettres, syllabes, mots, puis petites phrases. Les étapes non validées restent à travailler.',
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReadingBasicsScreen()))
                              .then((_) => setState(() => _future = _load())),
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: const Text('Continuer mon atelier de lecture'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Ce qui peut te gêner', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                const Text('Ces indications viennent de tes propres choix après une réponse incorrecte. Elles ne sont pas un diagnostic automatique.'),
                const SizedBox(height: 8),
                _GuideLine(Icons.record_voice_over_outlined, 'Lecture de la consigne : ' + (d.barrierCounts['lecture'] ?? 0).toString() + ' indication(s)'),
                _GuideLine(Icons.menu_book_outlined, 'Compréhension de la leçon : ' + (d.barrierCounts['comprehension'] ?? 0).toString() + ' indication(s)'),
                _GuideLine(Icons.psychology_outlined, 'Choix de la méthode : ' + (d.barrierCounts['methode'] ?? 0).toString() + ' indication(s)'),
              ]))),
              const SizedBox(height: 16),
              Text('Où j’en suis dans mes leçons', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              const Text('Ces repères concernent uniquement les exercices disponibles dans l’application. Une réussite sur ces questions ne signifie pas encore que toute la notion est maîtrisée.'),
              const SizedBox(height: 8),
              if (lessonProgress.isEmpty)
                const Card(child: Padding(padding: EdgeInsets.all(14), child: Text('Les exercices de cette classe apparaîtront ici au fur et à mesure de leur disponibilité.')))
              else
                ...lessonProgress.take(12).map((item) {
                  final label = switch (item.status) {
                    'reussi' => 'Réussi sur les exercices disponibles',
                    'a_revoir' => 'À revoir',
                    'a_reprendre' => 'À reprendre',
                    'en_progres' => 'En progrès',
                    _ => 'À découvrir',
                  };
                  final color = switch (item.status) {
                    'reussi' => Colors.green,
                    'a_revoir' || 'a_reprendre' => Colors.deepOrange,
                    'en_progres' => Colors.blue,
                    _ => Theme.of(context).colorScheme.onSurfaceVariant,
                  };
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(13),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(item.lesson.title, style: const TextStyle(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 5),
                        Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        Text('${item.correct}/${item.total} exercice(s) validé(s) • ${item.review} à revoir • ${item.wrong} réponse(s) incorrecte(s) enregistrée(s)'),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(value: item.correct / item.total),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Wrap(spacing: 8, children: [
                            TextButton(
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LessonContentScreen(lesson: item.lesson)))
                                  .then((_) => setState(() => _future = _load())),
                              child: const Text('Voir le cours'),
                            ),
                            if (item.status != 'reussi')
                              FilledButton.tonal(
                                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ExerciseScreen(lesson: item.lesson)))
                                    .then((_) => setState(() => _future = _load())),
                                child: const Text('S’entraîner'),
                              ),
                          ]),
                        ),
                      ]),
                    ),
                  );
                }),
              const SizedBox(height: 18),
              Text('Mes leçons à renforcer', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              const Text('Une difficulté répétée est un signal pour proposer de la pratique, jamais une étiquette sur toi.'),
              const SizedBox(height: 8),
              if (difficulties.isEmpty)
                Card(child: Padding(padding: const EdgeInsets.all(16), child: Text(attempts == 0
                  ? 'Je n’ai pas encore assez de réponses pour identifier tes points difficiles. Commence une leçon puis fais les exercices.'
                  : 'Aucune difficulté répétée n’est confirmée dans les leçons de ta classe. Continue : le diagnostic évolue avec tes réponses.')))
              else
                ...difficulties.take(10).map((entry) {
                  final lesson = lessons.firstWhere((l) => l.id == entry.key);
                  final chapter = chapters.where((c) => c.id == lesson.chapterId);
                  final subject = chapter.isEmpty ? null : subjects.firstWhere((s) => s.id == chapter.first.subjectId);
                  final hasExercises = demoExercises.any((exercise) => exercise.lessonId == lesson.id);
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            const CircleAvatar(child: Icon(Icons.menu_book_rounded)),
                            const SizedBox(width: 10),
                            Expanded(child: Text(lesson.title, style: const TextStyle(fontWeight: FontWeight.w800))),
                            Chip(label: Text(entry.value.toString() + ' erreurs')),
                          ]),
                          const SizedBox(height: 6),
                          Text(subject?.name ?? 'Leçon'),
                          const SizedBox(height: 8),
                          const Text('Parcours conseillé : revoir le cours, écouter les explications si besoin, puis refaire les exercices.'),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => LessonContentScreen(lesson: lesson)),
                                ).then((_) => setState(() => _future = _load())),
                                icon: const Icon(Icons.menu_book_outlined),
                                label: const Text('Revoir le cours'),
                              ),
                              if (hasExercises)
                                FilledButton.icon(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => ExerciseScreen(lesson: lesson)),
                                  ).then((_) => setState(() => _future = _load())),
                                  icon: const Icon(Icons.fitness_center_rounded),
                                  label: const Text('M’entraîner'),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              const SizedBox(height: 16),
              Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                Text('Comment je vais t’aider', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                SizedBox(height: 10),
                _GuideLine(Icons.visibility_outlined, 'Observer tes réponses et les erreurs qui reviennent.'),
                _GuideLine(Icons.menu_book_outlined, 'Te proposer de reprendre une explication.'),
                _GuideLine(Icons.fitness_center_rounded, 'Te faire progresser avec des exercices adaptés.'),
                _GuideLine(Icons.trending_up_rounded, 'Suivre tes réussites au fil du temps.'),
              ]))),
              const SizedBox(height: 12),
              Text('Pour le moment, les observations sont enregistrées sur cet appareil et séparées par compte. Le diagnostic couvre les leçons déjà suivies : il ne prétend pas encore analyser toutes les compétences.', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 16),
              FilledButton.icon(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.school_outlined), label: const Text('Retourner apprendre')),
            ]),
          );
        },
      ),
    );
  }
}

class _LessonProgress {
  final Lesson lesson;
  final int total;
  final int correct;
  final int review;
  final int wrong;
  final String status;
  const _LessonProgress(this.lesson, this.total, this.correct, this.review, this.wrong, this.status);
}

class _Diagnostic {
  final ProgressSnapshot progress;
  final Map<String, int> lessonErrors;
  final Map<String, int> exerciseErrors;
  final Set<String> reviewIds;
  final Set<int> readingStages;
  final int readingAttempts;
  final Map<int, int> readingWrongCounts;
  final Map<String, int> barrierCounts;
  const _Diagnostic(this.progress, this.lessonErrors, this.exerciseErrors, this.reviewIds, this.readingStages, this.readingAttempts, this.readingWrongCounts, this.barrierCounts);
}
class _GuideLine extends StatelessWidget {
  final IconData icon;
  final String label;
  const _GuideLine(this.icon, this.label);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 9),
    child: Row(children: [Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary), const SizedBox(width: 10), Expanded(child: Text(label))]),
  );
}