import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/progress_service.dart';
import '../../core/school_level_provider.dart';
import '../../data/models/models.dart';
import '../../data/sample/sample_data.dart';
import '../../shared/widgets/menu_button.dart';
import '../subjects/subject_detail_screen.dart';
import '../lesson/supplemental_curriculum_screen.dart';

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

  void _refreshProgress() {
    setState(() => _progressFuture = ProgressService.load());
  }

  @override
  Widget build(BuildContext context) {
    final level = ref.watch(schoolLevelProvider);
    final childMode = level.index <= SchoolLevel.cm2.index;
    final track = ref.watch(schoolTrackProvider);
    final series = ref.watch(schoolSeriesProvider);
    final subjects = demoSubjects
        .where((subject) => subjectMatchesPath(subject, level, track, series))
        .toList();
    final chapterIds = demoChapters
        .where((chapter) => subjects.any((subject) => subject.id == chapter.subjectId))
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
    final trackLabel = level.index >= SchoolLevel.seconde.index
        ? ' • ${track.label} • Série $series'
        : '';

    return Scaffold(
      appBar: AppBar(
        leading: const ProfTogoMenuButton(),
        title: const Text('ProfTogo', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            tooltip: 'Actualiser ma progression',
            onPressed: _refreshProgress,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: FutureBuilder<ProgressSnapshot>(
        future: _progressFuture,
        builder: (context, snapshot) {
          final progress = snapshot.data;
          final validated = progress == null
              ? 0
              : exerciseIds.where(progress.correctExerciseIds.contains).length;
          final percent = exerciseIds.isEmpty
              ? 0
              : (validated / exerciseIds.length * 100).round();

          return RefreshIndicator(
            onRefresh: () async => _refreshProgress(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
              children: [
                _WelcomePanel(
                  levelLabel: '${level.label}$trackLabel',
                  onRefresh: _refreshProgress,
                ),
                const SizedBox(height: 18),
                if (!childMode) Row(
                  children: [
                    Expanded(
                      child: _MetricCard(
                        icon: Icons.stars_rounded,
                        value: progress == null ? '—' : '${progress.xp}',
                        label: 'Points XP',
                        tint: const Color(0xFFFFF4CC),
                        iconColor: const Color(0xFF946500),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _MetricCard(
                        icon: Icons.check_circle_rounded,
                        value: '$validated',
                        label: 'Exercices réussis',
                        tint: const Color(0xFFE5F4EC),
                        iconColor: const Color(0xFF087443),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _MetricCard(
                        icon: Icons.menu_book_rounded,
                        value: '${subjects.length}',
                        label: 'Matières',
                        tint: const Color(0xFFEAF1FF),
                        iconColor: const Color(0xFF3159A5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                if (!childMode) Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text('Mon objectif de progression',
                                  style: TextStyle(fontWeight: FontWeight.w800)),
                            ),
                            Text('$percent %',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w800,
                                )),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                            value: snapshot.connectionState == ConnectionState.waiting
                                ? null
                                : (exerciseIds.isEmpty ? 0 : validated / exerciseIds.length),
                            minHeight: 10,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          snapshot.connectionState == ConnectionState.waiting
                              ? 'Chargement de tes résultats…'
                              : snapshot.hasError
                                  ? 'Ta progression est momentanément indisponible. Tu peux continuer à apprendre.'
                                  : exerciseIds.isEmpty
                                      ? 'Les exercices de cette classe seront bientôt enrichis.'
                                      : '$validated exercice(s) réussi(s) sur ${exerciseIds.length}. Continue régulièrement !',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
                if (childMode) Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        const Icon(Icons.face_rounded, size: 42),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Bienvenue ! Choisis une matière. Tu peux écouter les questions dans les exercices.',
                            style: TextStyle(fontSize: 18, height: 1.35, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onPrimaryContainer),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(childMode ? 'Choisis ta matière' : 'Tes matières',
                          style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
                    ),
                    Text('${subjects.length} disponibles',
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  childMode ? 'Touche une grande carte pour commencer.' : 'Choisis une matière pour ouvrir ses chapitres, ses leçons et ses exercices.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 12),
                if (subjects.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Icon(Icons.auto_stories_rounded,
                              size: 42, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(height: 10),
                          Text('Programme en préparation',
                              style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 6),
                          Text(
                            'Les ressources de ${level.label} seront ajoutées et vérifiées progressivement.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...subjects.map((subject) {
                    final subjectChapterIds = demoChapters
                        .where((chapter) => chapter.subjectId == subject.id)
                        .map((chapter) => chapter.id)
                        .toSet();
                    final subjectLessons = demoLessons
                        .where((lesson) => subjectChapterIds.contains(lesson.chapterId))
                        .toList();
                    final subjectLessonIds =
                        subjectLessons.map((lesson) => lesson.id).toSet();
                    final subjectExercises = demoExercises
                        .where((exercise) => subjectLessonIds.contains(exercise.lessonId))
                        .toList();
                    final done = progress == null
                        ? 0
                        : subjectExercises
                            .where((exercise) => progress.correctExerciseIds.contains(exercise.id))
                            .length;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _SubjectCard(
                        subject: subject,
                        chapterCount: subjectChapterIds.length,
                        lessonCount: subjectLessons.length,
                        exerciseCount: subjectExercises.length,
                        completedCount: done,
                        childMode: childMode,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SubjectDetailScreen(subject: subject),
                          ),
                        ),
                      ),
                    );
                  }),
                const SizedBox(height: 12),
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: childMode ? 12 : 6),
                    leading: CircleAvatar(radius: childMode ? 27 : 22, child: const Icon(Icons.auto_stories_rounded)),
                    title: Text(childMode ? 'Mes leçons bonus' : 'Cours bonus et révisions', style: TextStyle(fontWeight: FontWeight.w800, fontSize: childMode ? 19 : 16)),
                    subtitle: Text(childMode ? 'Petites leçons, écoute et exercices faciles.' : 'Leçons et exercices supplémentaires pour ta classe.'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 17),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SupplementalCurriculumScreen())),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: ListTile(
                    leading: Icon(Icons.lightbulb_outline_rounded,
                        color: Theme.of(context).colorScheme.onPrimaryContainer),
                    title: Text('Un conseil pour réussir',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        )),
                    subtitle: Text(
                      'Lis la leçon, écoute les explications si tu le souhaites, puis fais les exercices sans regarder la correction.',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        height: 1.35,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _WelcomePanel extends StatelessWidget {
  final String levelLabel;
  final VoidCallback onRefresh;

  const _WelcomePanel({required this.levelLabel, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF087443), Color(0xFF034D35)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(color: Color(0x1F004D35), blurRadius: 16, offset: Offset(0, 7)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.waving_hand_rounded, color: Color(0xFFFFE082)),
              const SizedBox(width: 8),
              const Expanded(
                child: Text('BONJOUR, ÉLÈVE !',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                      fontSize: 12,
                    )),
              ),
              IconButton(
                tooltip: 'Actualiser',
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Chaque leçon te rapproche de la réussite.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              height: 1.18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.school_rounded, color: Color(0xFFFFE082), size: 18),
                const SizedBox(width: 7),
                Flexible(
                  child: Text(levelLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color tint;
  final Color iconColor;

  const _MetricCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.tint,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
        child: Column(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: tint,
              child: Icon(icon, size: 19, color: iconColor),
            ),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(value,
                  style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
            ),
            const SizedBox(height: 2),
            Text(label,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final Subject subject;
  final int chapterCount;
  final int lessonCount;
  final int exerciseCount;
  final int completedCount;
  final bool childMode;
  final VoidCallback onTap;

  const _SubjectCard({
    required this.subject,
    required this.chapterCount,
    required this.lessonCount,
    required this.exerciseCount,
    required this.completedCount,
    required this.childMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = exerciseCount == 0 ? 0.0 : completedCount / exerciseCount;
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(childMode ? 20 : 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: childMode ? 28 : 20,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Icon(Icons.menu_book_rounded,
                        size: childMode ? 30 : 24,
                        color: theme.colorScheme.onPrimaryContainer),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(subject.name,
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: childMode ? 20 : 16)),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                ],
              ),
              if (!childMode) const SizedBox(height: 12),
              if (!childMode) Wrap(
                spacing: 12,
                runSpacing: 5,
                children: [
                  _MiniInfo(icon: Icons.folder_open_outlined, label: '$chapterCount chapitres'),
                  _MiniInfo(icon: Icons.article_outlined, label: '$lessonCount leçons'),
                  _MiniInfo(icon: Icons.quiz_outlined, label: '$exerciseCount exercices'),
                ],
              ),
              if (!childMode) const SizedBox(height: 12),
              if (!childMode) Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(value: ratio, minHeight: 7),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text('$completedCount/$exerciseCount',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontFeatures: const [],
                      )),
                ],
              ),
              if (!childMode) const SizedBox(height: 4),
              if (!childMode) Text('Exercices réussis',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  )),
              if (childMode) const Align(
                alignment: Alignment.centerRight,
                child: Text('Touche pour ouvrir →', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniInfo extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MiniInfo({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
