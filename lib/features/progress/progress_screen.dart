import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/progress_service.dart';
import '../../core/evaluation_service.dart';
import '../../core/school_level_provider.dart';
import '../../data/sample/sample_data.dart';
import '../../data/sample/supplemental_curriculum.dart';
import '../../data/sample/annual_core_english.dart';
import '../../data/models/models.dart';
import '../lesson/exercise_screen.dart';
import '../lesson/supplemental_curriculum_screen.dart';
import '../../shared/widgets/menu_button.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  late Future<List<dynamic>> _dataFuture;
  late final StreamSubscription<User?> _authSubscription;

  Future<List<dynamic>> _loadData() => Future.wait<dynamic>([
        ProgressService.load(),
        EvaluationService.loadHistory(),
        ProgressService.loadReviewExerciseIds(),
        ProgressService.loadAttemptHistory(),
      ]);

  @override
  void initState() {
    super.initState();
    _dataFuture = _loadData();
    // La page reste montée dans l'IndexedStack : ne pas afficher
    // les résultats du compte précédent après une déconnexion.
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((_) {
      if (!mounted) return;
      setState(() => _dataFuture = _loadData());
    });
  }

  void _refresh() {
    setState(() => _dataFuture = _loadData());
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
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
          final reviewIds = snapshot.data![2] as Set<String>;
          final attempts = snapshot.data![3] as List<ExerciseAttemptRecord>;
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final activityDays = List<DateTime>.generate(
            7,
            (index) => today.subtract(Duration(days: 6 - index)),
          );
          final activityCounts = activityDays.map((day) {
            return attempts.where((attempt) {
              final localDate = attempt.timestamp.toLocal();
              return localDate.year == day.year &&
                  localDate.month == day.month &&
                  localDate.day == day.day;
            }).length;
          }).toList();
          final maxActivity = activityCounts.fold<int>(
            1,
            (maximum, count) => count > maximum ? count : maximum,
          );
          final weekAttempts = attempts.where((attempt) {
            final localDate = attempt.timestamp.toLocal();
            return !localDate.isBefore(activityDays.first) &&
                localDate.isBefore(today.add(const Duration(days: 1)));
          }).toList();
          final weekCorrect = weekAttempts.where((attempt) => attempt.isCorrect).length;
          final weekWrong = weekAttempts.length - weekCorrect;
          final weekAccuracy = weekAttempts.isEmpty
              ? 0
              : (weekCorrect / weekAttempts.length * 100).round();
          final bonusReviewQuestions = supplementalLessons
              .where((lesson) => lesson.level == selectedLevel)
              .expand((lesson) => lesson.questions.map((question) => MapEntry(lesson, question)))
              .where((entry) => reviewIds.contains(entry.value.id))
              .toList();
          final subjects = [
            ...demoSubjects.where((s) => subjectMatchesPath(s, selectedLevel, selectedTrack, selectedSeries)),
            ...annualEnglishSubjects.where((s) => subjectMatchesPath(s, selectedLevel, selectedTrack, selectedSeries)),
          ];
          final subjectIds = subjects.map((s) => s.id).toSet();
          final history = allHistory.where((r) => r.level == selectedLevel.label && (subjectIds.contains(r.subjectId) || r.subjectId.startsWith('composition_${selectedLevel.name}_${selectedTrack.name}_${selectedSeries}_'))).toList();
          final exercisesBySubject = <String, List<String>>{};
          for (final subject in subjects) {
            final chapterIds = [...demoChapters, ...annualEnglishChapters].where((c) => c.subjectId == subject.id).map((c) => c.id).toSet();
            final lessonIds = [...demoLessons, ...annualEnglishLessons].where((l) => chapterIds.contains(l.chapterId)).map((l) => l.id).toSet();
            exercisesBySubject[subject.id] = [...demoExercises, ...annualEnglishExercises]
                .where((e) => lessonIds.contains(e.lessonId)).map((e) => e.id).toList();
          }
          final bonusIds = supplementalLessons
              .where((lesson) => lesson.level == selectedLevel)
              .expand((lesson) => lesson.questions)
              .map((question) => question.id)
              .toSet();
          final allIds = {
            ...exercisesBySubject.values.expand((ids) => ids),
            ...bonusIds,
          };
          final answered = allIds.where(progress.answeredExerciseIds.contains).length;
          final bonusAnswered = bonusIds.where(progress.answeredExerciseIds.contains).length;
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
              const SizedBox(height: 18),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Mon activité des 7 derniers jours',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      const Text('Tentatives réalisées, bonnes réponses et erreurs comprises.',
                          style: TextStyle(fontSize: 12)),
                      const SizedBox(height: 10),
                      Text('Cette semaine : ${weekAttempts.length} tentatives • $weekCorrect bonnes • $weekWrong erreurs',
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text('Taux de réussite : $weekAccuracy %',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF006A4E))),
                      const SizedBox(height: 12),
                      ...List.generate(activityDays.length, (index) {
                        final day = activityDays[index];
                        final weekday = const ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'][day.weekday - 1];
                        final label = day == today ? 'Aujourd’hui' : weekday;
                        final count = activityCounts[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(children: [
                            SizedBox(width: 76, child: Text(label, style: const TextStyle(fontSize: 12))),
                            Expanded(child: LinearProgressIndicator(
                              value: count / maxActivity,
                              minHeight: 8,
                              borderRadius: BorderRadius.circular(8),
                            )),
                            const SizedBox(width: 10),
                            SizedBox(width: 24, child: Text('$count', textAlign: TextAlign.end,
                                style: const TextStyle(fontWeight: FontWeight.w600))),
                          ]),
                        );
                      }),
                      if (weekAttempts.isEmpty)
                        const Text('Ton activité apparaîtra ici après tes premières réponses cette semaine.',
                            style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  const Expanded(
                    child: Text('Mes erreurs à revoir',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  Chip(label: Text('${reviewIds.where((id) => [...demoExercises, ...annualEnglishExercises].any((e) => e.id == id && allIds.contains(e.id))).length + bonusReviewQuestions.length}')),
                ],
              ),
              const SizedBox(height: 8),
              ...[...demoExercises, ...annualEnglishExercises].where((e) => reviewIds.contains(e.id) && allIds.contains(e.id)).map((exercise) => Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('À retravailler', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.deepOrange)),
                      const SizedBox(height: 6),
                      Text(exercise.question, style: const TextStyle(fontWeight: FontWeight.w700, height: 1.35)),
                      const SizedBox(height: 8),
                      Text('Bonne réponse : ${exercise.options[exercise.correctIndex]}'),
                      const SizedBox(height: 6),
                      Text('Explication : ${exercise.explanation}', style: const TextStyle(height: 1.4)),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () async {
                            final matchingLessons = [...demoLessons, ...annualEnglishLessons]
                                .where((lesson) => lesson.id == exercise.lessonId);
                            if (matchingLessons.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('La leçon liée à cet exercice est momentanément indisponible.'),
                                ),
                              );
                              return;
                            }
                            await Navigator.of(context).push<void>(
                              MaterialPageRoute(
                                builder: (_) => ExerciseScreen(
                                  lesson: matchingLessons.first,
                                  reviewExerciseId: exercise.id,
                                ),
                              ),
                            );
                            if (context.mounted) _refresh();
                          },
                          icon: const Icon(Icons.replay_rounded),
                          label: const Text('Retravailler cette question'),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
              ...bonusReviewQuestions.map((entry) => Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Cours bonus • À retravailler',
                          style: TextStyle(fontWeight: FontWeight.w800, color: Colors.deepOrange)),
                      const SizedBox(height: 6),
                      Text(entry.key.title,
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text(entry.value.prompt, style: const TextStyle(height: 1.35)),
                      const SizedBox(height: 8),
                      Text('Bonne réponse : ${entry.value.choices[entry.value.correctIndex]}'),
                      const SizedBox(height: 6),
                      Text('Explication : ${entry.value.explanation}',
                          style: const TextStyle(height: 1.4)),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () async {
                            await Navigator.of(context).push<void>(
                              MaterialPageRoute(
                                builder: (_) => SupplementalCurriculumScreen(
                                  initialLessonId: entry.key.id,
                                ),
                              ),
                            );
                            if (context.mounted) _refresh();
                          },
                          icon: const Icon(Icons.replay_rounded),
                          label: const Text('Ouvrir cette leçon bonus'),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
              if (![...demoExercises, ...annualEnglishExercises].any((e) => reviewIds.contains(e.id) && allIds.contains(e.id)) &&
                  bonusReviewQuestions.isEmpty)
                const Text('Aucune erreur à revoir pour ce niveau. Continue à t’entraîner !'),
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
                  subtitle: Text('${record.chapterTitle.isEmpty ? 'Toute la matière' : record.chapterTitle} • ${record.correct}/${record.total} bonnes réponses • ${record.date.day.toString().padLeft(2, '0')}/${record.date.month.toString().padLeft(2, '0')}/${record.date.year}'),
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
              if (bonusIds.isNotEmpty) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Expanded(
                          child: Text('Cours bonus',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                        Text('$bonusAnswered/${bonusIds.length}'),
                      ]),
                      const SizedBox(height: 7),
                      LinearProgressIndicator(
                        value: bonusIds.isEmpty ? 0 : bonusAnswered / bonusIds.length,
                        minHeight: 9,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${(bonusAnswered / bonusIds.length * 100).round()} %',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 10),
              Text(
                'Sans compte connecté, la progression et les notes restent sur cet appareil. Avec un compte et une connexion disponible, elles peuvent être synchronisées avec Firestore.',
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
