import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/progress_service.dart';
import '../../core/school_level_provider.dart';
import '../../data/sample/sample_data.dart';
import '../lesson/lesson_screen.dart';

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
    ]);
    return _Diagnostic(
      results[0] as ProgressSnapshot,
      results[1] as Map<String, int>,
      results[2] as Map<String, int>,
      results[3] as Set<String>,
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
          final answered = d.progress.answeredExerciseIds.length;
          final correct = d.progress.correctExerciseIds.length;
          final rate = answered == 0 ? 0 : (correct * 100 / answered).round();
          final difficulties = d.lessonErrors.entries.where((e) => e.value >= 2 && lessons.any((l) => l.id == e.key)).toList()
            ..sort((a, b) => b.value.compareTo(a.value));
          return RefreshIndicator(
            onRefresh: () async { setState(() => _future = _load()); await _future; },
            child: ListView(padding: const EdgeInsets.all(16), children: [
              Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Row(children: [Icon(Icons.psychology_alt_rounded, size: 30), SizedBox(width: 10), Expanded(child: Text('Je découvre comment tu apprends', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)))]),
                const SizedBox(height: 10),
                Text(answered == 0
                  ? 'Ton diagnostic commence avec tes premiers exercices. Réponds tranquillement : tes réussites et tes erreurs m’aideront à choisir les révisions utiles.'
                  : 'J’ai observé ' + answered.toString() + ' réponses et ' + correct.toString() + ' réussites. Ton taux de réussite observé est de ' + rate.toString() + ' %. Je continue à apprendre de tes réponses.'),
                const SizedBox(height: 12),
                Wrap(spacing: 8, children: [
                  Chip(avatar: const Icon(Icons.edit_note), label: Text(answered.toString() + ' réponses')),
                  Chip(avatar: const Icon(Icons.check_circle_outline), label: Text(correct.toString() + ' réussites')),
                  Chip(avatar: const Icon(Icons.replay), label: Text(d.reviewIds.length.toString() + ' à revoir')),
                ]),
              ]))),
              const SizedBox(height: 16),
              Text('Mes leçons à renforcer', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              const Text('Une difficulté répétée est un signal pour proposer de la pratique, jamais une étiquette sur toi.'),
              const SizedBox(height: 8),
              if (difficulties.isEmpty)
                Card(child: Padding(padding: const EdgeInsets.all(16), child: Text(answered == 0
                  ? 'Je n’ai pas encore assez de réponses pour identifier tes points difficiles. Commence une leçon puis fais les exercices.'
                  : 'Aucune difficulté répétée n’est confirmée dans les leçons de ta classe. Continue : le diagnostic évolue avec tes réponses.')))
              else
                ...difficulties.take(10).map((entry) {
                  final lesson = lessons.firstWhere((l) => l.id == entry.key);
                  final chapter = chapters.where((c) => c.id == lesson.chapterId);
                  final subject = chapter.isEmpty ? null : subjects.where((s) => s.id == chapter.first.subjectId).firstOrNull;
                  return Card(child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.menu_book_rounded)),
                    title: Text(lesson.title, style: const TextStyle(fontWeight: FontWeight.w800)),
                    subtitle: Text((subject?.name ?? 'Leçon') + ' • ' + entry.value.toString() + ' erreurs observées. Revois le cours et entraîne-toi.'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LessonContentScreen(lesson: lesson))).then((_) => setState(() => _future = _load())),
                  ));
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

class _Diagnostic {
  final ProgressSnapshot progress;
  final Map<String, int> lessonErrors;
  final Map<String, int> exerciseErrors;
  final Set<String> reviewIds;
  const _Diagnostic(this.progress, this.lessonErrors, this.exerciseErrors, this.reviewIds);
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
