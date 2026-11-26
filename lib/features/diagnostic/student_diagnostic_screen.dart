import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/progress_service.dart';
import '../../core/school_level_provider.dart';
import '../../data/models/models.dart';
import '../../core/reading_practice_service.dart';
import '../reading/reading_basics_screen.dart';
import '../../data/sample/sample_data.dart';
import '../../data/sample/annual_core_catalog.dart';
import '../lesson/lesson_screen.dart';
import '../lesson/exercise_screen.dart';

class StudentDiagnosticScreen extends ConsumerStatefulWidget {
  const StudentDiagnosticScreen({super.key});
  @override
  ConsumerState<StudentDiagnosticScreen> createState() => _StudentDiagnosticScreenState();
}

class _StudentDiagnosticScreenState extends ConsumerState<StudentDiagnosticScreen> {
  late Future<_Diagnostic> _future;
  late final StreamSubscription<User?> _authSubscription;

  @override
  void initState() {
    super.initState();
    _future = _load();
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((_) {
      if (!mounted) return;
      setState(() => _future = _load());
    });
  }

  @override
  void dispose() {
    unawaited(_authSubscription.cancel());
    super.dispose();
  }

  Future<_Diagnostic> _load() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final results = await Future.wait([
      ProgressService.load(),
      ProgressService.loadSkillDifficultyCounts(),
      ProgressService.loadWrongAttemptCounts(),
      ProgressService.loadReviewExerciseIds(),
      ReadingPracticeService.loadCompletedStages(),
      ReadingPracticeService.loadAttemptCount(),
      ReadingPracticeService.loadStageWrongCounts(),
      ProgressService.loadLearningBarrierCounts(),
      ProgressService.loadAttemptHistory(),
    ]);
    // Une bascule de compte pendant les lectures parallèles peut mélanger
    // des données locales de deux élèves. On recommence avec le compte actif.
    if (FirebaseAuth.instance.currentUser?.uid != uid) return _load();
    return _Diagnostic(
      results[0] as ProgressSnapshot,
      results[1] as Map<String, int>,
      results[2] as Map<String, int>,
      results[3] as Set<String>,
      results[4] as Set<int>,
      results[5] as int,
      results[6] as Map<int, int>,
      results[7] as Map<String, int>,
      results[8] as List<ExerciseAttemptRecord>,
    );
  }

  @override
  Widget build(BuildContext context) {
    final level = ref.watch(schoolLevelProvider);
    final track = ref.watch(schoolTrackProvider);
    final series = ref.watch(schoolSeriesProvider);
    final subjects = [...demoSubjects, ...annualCoreSubjects].where((s) => subjectMatchesPath(s, level, track, series)).toList();
    final chapters = [...demoChapters, ...annualCoreChapters].where((c) => subjects.any((s) => s.id == c.subjectId)).toList();
    final lessons = [...demoLessons, ...annualCoreLessons].where((l) => chapters.any((c) => c.id == l.chapterId)).toList();
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
          final now = DateTime.now();
          final weekStart = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 6));
          final weekRecords = d.attemptHistory.where((a) => !a.timestamp.isBefore(weekStart) && !a.timestamp.isAfter(now)).toList();
          final dayCounts = List<int>.filled(7, 0);
          for (final record in weekRecords) {
            final localDate = record.timestamp.toLocal();
            final dayIndex = DateTime(localDate.year, localDate.month, localDate.day)
                .difference(weekStart)
                .inDays;
            if (dayIndex >= 0 && dayIndex < 7) dayCounts[dayIndex]++;
          }
          final weekCorrect = weekRecords.where((a) => a.isCorrect).length;
          final weekWrong = weekRecords.length - weekCorrect;
          final recentRecords = d.attemptHistory.take(10).toList();
          final previousRecords = d.attemptHistory.skip(10).take(10).toList();
          final recentCorrect = recentRecords.where((a) => a.isCorrect).length;
          final recentRate = recentRecords.isEmpty ? 0 : (recentCorrect * 100 / recentRecords.length).round();
          final previousCorrect = previousRecords.where((a) => a.isCorrect).length;
          final previousRate = previousRecords.isEmpty ? 0 : (previousCorrect * 100 / previousRecords.length).round();
          final trendLabel = recentRecords.length < 3
              ? 'Je collecte encore quelques réponses pour mieux comprendre ton rythme.'
              : previousRecords.length < 3
                  ? 'Je commence à repérer les notions qui te demandent plus d’efforts.'
                  : recentRate >= previousRate + 10
                      ? 'Tes réponses récentes montrent une progression. Continue cette méthode.'
                      : recentRate <= previousRate - 10
                          ? 'Les dernières questions sont plus difficiles. Nous allons ralentir et reprendre les bases.'
                          : 'Tes résultats récents sont assez stables. Une pratique régulière t’aidera à consolider tes acquis.';
          final personalizedMethod = recentRecords.length < 3
              ? 'Réponds à quelques exercices supplémentaires : je pourrai ensuite te proposer une révision plus précise.'
              : recentRate < 50
                  ? 'Lis d’abord la leçon, écoute l’explication si tu le souhaites, observe un exemple corrigé, puis fais 3 exercices à ton rythme.'
                  : recentRate < 80
                      ? 'Alterne une courte relecture et 4 à 5 exercices. Après chaque erreur, explique pourquoi la bonne réponse est correcte.'
                      : 'Tu peux avancer vers la leçon suivante. Reviens demain sur 2 ou 3 questions pour vérifier que tu retiens bien la notion.';
          final correct = d.progress.correctExerciseIds.length;
          // Chaque erreur est une tentative distincte ; les réussites sont
          // comptées une fois par exercice validé.
          final wrongAttempts = d.exerciseErrors.values.fold<int>(
            0,
            (total, count) => total + count,
          );
          final attempts = correct + wrongAttempts;
          final rate = attempts == 0 ? 0 : (correct * 100 / attempts).round();
          final latestWrongByLesson = <String, DateTime>{};
          for (final attempt in d.attemptHistory.where((item) => !item.isCorrect)) {
            final previous = latestWrongByLesson[attempt.lessonId];
            if (previous == null || attempt.timestamp.isAfter(previous)) {
              latestWrongByLesson[attempt.lessonId] = attempt.timestamp;
            }
          }
          final difficulties = d.lessonErrors.entries.where((e) => e.value >= 2 && lessons.any((l) => l.id == e.key)).toList()
            ..sort((a, b) {
              final byCount = b.value.compareTo(a.value);
              if (byCount != 0) return byCount;
              final aDate = latestWrongByLesson[a.key];
              final bDate = latestWrongByLesson[b.key];
              if (aDate == null && bDate == null) return 0;
              if (aDate == null) return 1;
              if (bDate == null) return -1;
              return bDate.compareTo(aDate);
            });

          // État pédagogique calculé uniquement à partir des exercices réellement
          // présents et des réponses enregistrées pour le compte courant.
          final lessonProgress = lessons.map((lesson) {
            final exercises = [...demoExercises, ...annualCoreExercises].where((e) => e.lessonId == lesson.id).toList();
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
              if (byStatus != 0) return byStatus;
              final byWrong = b.wrong.compareTo(a.wrong);
              if (byWrong != 0) return byWrong;
              final byReview = b.review.compareTo(a.review);
              if (byReview != 0) return byReview;
              final aDate = latestWrongByLesson[a.lesson.id];
              final bDate = latestWrongByLesson[b.lesson.id];
              if (aDate != null && bDate != null) {
                final byRecency = bDate.compareTo(aDate);
                if (byRecency != 0) return byRecency;
              } else if (aDate != null) {
                return -1;
              } else if (bDate != null) {
                return 1;
              }
              return a.lesson.title.compareTo(b.lesson.title);
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
              if (recentRecords.isNotEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(children: [
                          Icon(Icons.auto_awesome_rounded),
                          SizedBox(width: 9),
                          Expanded(child: Text('Ma méthode adaptée', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800))),
                        ]),
                        const SizedBox(height: 8),
                        Text('Sur tes ${recentRecords.length} réponses les plus récentes : $recentCorrect correcte(s), soit $recentRate % de réussite.'),
                        if (previousRecords.length >= 3) ...[
                          const SizedBox(height: 5),
                          Text('Période précédente : $previousRate %.'),
                        ],
                        const SizedBox(height: 7),
                        Text(trendLabel),
                        const SizedBox(height: 10),
                        Text(personalizedMethod, style: const TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 7),
                        const Text('Cette recommandation se met à jour à partir de tes réponses enregistrées, séparées par compte sur cet appareil.', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
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
                      if (nextLesson.wrong > 0 || nextLesson.review > 0) ...[
                        const SizedBox(height: 5),
                        Text(
                          [
                            if (nextLesson.wrong > 0) '${nextLesson.wrong} réponse(s) incorrecte(s) enregistrée(s)',
                            if (nextLesson.review > 0) '${nextLesson.review} exercice(s) placé(s) en révision',
                          ].join(' • '),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
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
              if (nextLesson != null) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(children: [
                          Icon(Icons.timer_outlined),
                          SizedBox(width: 9),
                          Expanded(child: Text('Ma séance de 10 minutes', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800))),
                        ]),
                        const SizedBox(height: 7),
                        const Text('Une petite séance suffit pour avancer. Voici un parcours simple :'),
                        const SizedBox(height: 10),
                        const _GuideLine(Icons.menu_book_outlined, '2 min — relis le cours et repère l’idée importante.'),
                        const _GuideLine(Icons.edit_note_rounded, '5 min — fais quelques exercices sans regarder la réponse.'),
                        const _GuideLine(Icons.check_circle_outline, '2 min — corrige et comprends tes erreurs.'),
                        const _GuideLine(Icons.record_voice_over_outlined, '1 min — explique la notion avec tes propres mots.'),
                        const SizedBox(height: 4),
                        Text('Le temps est indicatif : avance à ton rythme, sans te presser.', style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ExerciseScreen(lesson: nextLesson.lesson)))
                                .then((_) => setState(() => _future = _load())),
                            icon: const Icon(Icons.play_arrow_rounded),
                            label: const Text('Faire ma séance'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              const SizedBox(height: 16),
              Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Row(children: [Icon(Icons.history_rounded), SizedBox(width: 9), Expanded(child: Text('Mon activité récente', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)))]),
                const SizedBox(height: 8),
                if (d.attemptHistory.isEmpty)
                  const Text('Ton historique daté commencera dès tes prochaines réponses. Tes anciennes réussites restent dans ta progression, mais elles n’ont pas d’heure enregistrée.' )
                else ...[
                  Text('Ces 7 derniers jours : ${weekRecords.length} tentative(s), $weekCorrect réponse(s) correcte(s) et $weekWrong incorrecte(s).'),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(7, (index) {
                      final day = weekStart.add(Duration(days: index));
                      final labels = const ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
                      final count = dayCounts[index];
                      return Column(
                        children: [
                          Text(labels[index], style: Theme.of(context).textTheme.bodySmall),
                          const SizedBox(height: 5),
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: count > 0
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.surfaceContainerHighest,
                            child: Text(
                              count == 0 ? '·' : count.toString(),
                              style: TextStyle(
                                color: count > 0
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : Theme.of(context).colorScheme.onSurfaceVariant,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(day.day.toString(), style: Theme.of(context).textTheme.bodySmall),
                        ],
                      );
                    }),
                  ),
                  const SizedBox(height: 10),
                  const Text('Chaque jour compte : une petite séance suffit. Les jours sans activité ne retirent aucun point.', style: TextStyle(fontSize: 12)),
                  const SizedBox(height: 10),
                  ...d.attemptHistory.take(5).map((attempt) {
                    final lesson = lessons.where((l) => l.id == attempt.lessonId).firstOrNull;
                    final date = attempt.timestamp.toLocal();
                    final dateLabel = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
                    return Padding(padding: const EdgeInsets.only(bottom: 7), child: Row(children: [
                      Icon(attempt.isCorrect ? Icons.check_circle_outline : Icons.refresh_rounded, color: attempt.isCorrect ? Colors.green : Colors.deepOrange, size: 19),
                      const SizedBox(width: 8),
                      Expanded(child: Text(lesson?.title ?? 'Exercice', maxLines: 2, overflow: TextOverflow.ellipsis)),
                      Text(dateLabel, style: Theme.of(context).textTheme.bodySmall),
                    ]));
                  }),
                  const Text('Historique local, séparé par compte ; les 200 réponses les plus récentes sont conservées.', style: TextStyle(fontSize: 12)),
                ],
              ]))),
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
                  final hasExercises = [...demoExercises, ...annualCoreExercises].any((exercise) => exercise.lessonId == lesson.id);
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
  final List<ExerciseAttemptRecord> attemptHistory;
  const _Diagnostic(this.progress, this.lessonErrors, this.exerciseErrors, this.reviewIds, this.readingStages, this.readingAttempts, this.readingWrongCounts, this.barrierCounts, this.attemptHistory);
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