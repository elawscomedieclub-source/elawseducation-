import 'package:flutter/material.dart';

import '../../data/models/models.dart';
import '../../data/sample/sample_data.dart';
import '../lesson/lesson_screen.dart';
import 'evaluation_screen.dart';

class SubjectDetailScreen extends StatelessWidget {
  final Subject subject;
  const SubjectDetailScreen({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    final chapters = demoChapters
        .where((chapter) => chapter.subjectId == subject.id)
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));
    final chapterIds = chapters.map((chapter) => chapter.id).toSet();
    final lessons = demoLessons
        .where((lesson) => chapterIds.contains(lesson.chapterId))
        .toList();
    final lessonIds = lessons.map((lesson) => lesson.id).toSet();
    final exercises = demoExercises
        .where((exercise) => lessonIds.contains(exercise.lessonId))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(subject.name)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 26),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF087443), Color(0xFF034D35)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('TON PROGRAMME',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                      fontSize: 11,
                    )),
                const SizedBox(height: 7),
                Text(
                  subject.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Classe : ${subject.level.label}',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _ProgramMetric(value: '${chapters.length}', label: 'Chapitres'),
                    _ProgramMetric(value: '${lessons.length}', label: 'Leçons'),
                    _ProgramMetric(value: '${exercises.length}', label: 'Exercices'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: exercises.isEmpty
                  ? null
                  : () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EvaluationScreen(subject: subject),
                        ),
                      ),
              icon: const Icon(Icons.assignment_rounded),
              label: Text('Faire une évaluation • ${exercises.length} question(s) disponibles'),
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              const Expanded(
                child: Text('Chapitres et leçons',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              ),
              Text('${chapters.length} au programme',
                  style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
          const SizedBox(height: 10),
          if (chapters.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Text('Les chapitres de cette matière seront ajoutés progressivement.'),
              ),
            ),
          ...chapters.asMap().entries.map((entry) {
            final index = entry.key;
            final chapter = entry.value;
            final chapterLessons = lessons
                .where((lesson) => lesson.chapterId == chapter.id)
                .toList();
            final chapterLessonIds =
                chapterLessons.map((lesson) => lesson.id).toSet();
            final chapterExerciseCount = exercises
                .where((exercise) => chapterLessonIds.contains(exercise.lessonId))
                .length;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 9),
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Text('${index + 1}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w800,
                        )),
                  ),
                  title: Text(chapter.title,
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 4,
                      children: [
                        _ChapterMeta(
                          icon: Icons.article_outlined,
                          label: '${chapterLessons.length} leçon(s)',
                        ),
                        _ChapterMeta(
                          icon: Icons.quiz_outlined,
                          label: '$chapterExerciseCount exercice(s)',
                        ),
                      ],
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 17),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LessonScreen(chapter: chapter),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ProgramMetric extends StatelessWidget {
  final String value;
  final String label;

  const _ProgramMetric({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              )),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}

class _ChapterMeta extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ChapterMeta({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
