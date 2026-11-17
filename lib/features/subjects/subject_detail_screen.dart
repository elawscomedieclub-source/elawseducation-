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
    final chapters = demoChapters.where((c) => c.subjectId == subject.id).toList();
    final lessonIds = demoLessons
        .where((lesson) => chapters.any((chapter) => chapter.id == lesson.chapterId))
        .map((lesson) => lesson.id)
        .toSet();
    final exerciseCount = demoExercises.where((e) => lessonIds.contains(e.lessonId)).length;

    return Scaffold(
      appBar: AppBar(title: Text(subject.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Programme de ${subject.level.label}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: exerciseCount == 0 ? null : () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EvaluationScreen(subject: subject)),
              ),
              icon: const Icon(Icons.assignment_outlined),
              label: Text('Faire une évaluation • $exerciseCount question(s)'),
            ),
          ),
          const SizedBox(height: 14),
          if (chapters.isEmpty)
            const Text('Les chapitres de cette matière seront ajoutés progressivement.'),
          ...chapters.map((chapter) => Card(
            child: ListTile(
              title: Text(chapter.title),
              subtitle: Text('${chapter.totalLessons} leçons'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => LessonScreen(chapter: chapter)),
              ),
            ),
          )),
        ],
      ),
    );
  }
}
