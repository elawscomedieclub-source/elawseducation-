import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../data/models/models.dart';
import '../../data/sample/sample_data.dart';
import 'exercise_screen.dart';
import 'apc_lesson_guide.dart';
import 'apc_mission_screen.dart';

class LessonScreen extends StatelessWidget {
  final Chapter chapter;
  const LessonScreen({super.key, required this.chapter});

  @override
  Widget build(BuildContext context) {
    final lessons = demoLessons.where((lesson) => lesson.chapterId == chapter.id).toList();

    return Scaffold(
      appBar: AppBar(title: Text(chapter.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (lessons.isEmpty)
            const Text('Les leçons de ce chapitre seront bientôt disponibles.'),
          ...lessons.map(
            (lesson) => Card(
              child: ListTile(
                leading: const Icon(Icons.article_outlined),
                title: Text(lesson.title),
                subtitle: Text(lesson.summary),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LessonContentScreen(lesson: lesson),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LessonContentScreen extends StatefulWidget {
  final Lesson lesson;
  const LessonContentScreen({super.key, required this.lesson});

  @override
  State<LessonContentScreen> createState() => _LessonContentScreenState();
}

class _LessonContentScreenState extends State<LessonContentScreen> {
  final FlutterTts _tts = FlutterTts();
  bool _speaking = false;

  @override
  void initState() {
    super.initState();
    _tts.setStartHandler(() {
      if (mounted) setState(() => _speaking = true);
    });
    _tts.setCompletionHandler(() {
      if (mounted) setState(() => _speaking = false);
    });
    _tts.setCancelHandler(() {
      if (mounted) setState(() => _speaking = false);
    });
    _tts.setErrorHandler((_) {
      if (mounted) setState(() => _speaking = false);
    });
    _tts.awaitSpeakCompletion(true);
  }

  String get _lessonText {
    final points = widget.lesson.keyPoints.isEmpty
        ? ''
        : ' À retenir : ${widget.lesson.keyPoints.join('. ')}.';
    return '${widget.lesson.title}. ${widget.lesson.summary}. ${widget.lesson.content}.$points';
  }

  Future<void> _toggleReading() async {
    if (_speaking) {
      await _tts.stop();
      if (mounted) setState(() => _speaking = false);
      return;
    }

    try {
      await _tts.setLanguage('fr-FR');
      await _tts.setSpeechRate(0.43);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      await _tts.speak(_lessonText);
    } catch (_) {
      if (!mounted) return;
      setState(() => _speaking = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lecture vocale indisponible. Vérifie les voix installées sur ton appareil.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    final chapter = demoChapters.firstWhere(
      (item) => item.id == lesson.chapterId,
      orElse: () => demoChapters.first,
    );
    final apc = ApcLessonGuide.forLesson(lesson, chapter);

    return Scaffold(
      appBar: AppBar(title: Text(lesson.title)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5F0),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFB7DCCB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(children: [
                  Icon(Icons.lightbulb_outline, color: Color(0xFF006A4E)),
                  SizedBox(width: 8),
                  Expanded(child: Text('APPRENDRE AVEC L’APC', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF006A4E)))),
                ]),
                const SizedBox(height: 12),
                const Text('Compétence visée', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(apc.competence),
                const SizedBox(height: 12),
                const Text('Situation-problème', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(apc.situation),
                const SizedBox(height: 12),
                const Text('Ta mission', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(apc.mission),
                const SizedBox(height: 12),
                const Text('Démarche de travail', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                ...apc.steps.asMap().entries.map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text('${entry.key + 1}. ${entry.value}'),
                )),
                const SizedBox(height: 8),
                const Text('Production attendue', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(apc.production),
                const SizedBox(height: 12),
                const Text('Critères de réussite', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                ...apc.criteria.map((criterion) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Icon(Icons.check_circle_outline, size: 18, color: Color(0xFF006A4E)),
                    const SizedBox(width: 6),
                    Expanded(child: Text(criterion)),
                  ]),
                )),
                const SizedBox(height: 12),
                const Text('Questions de transfert', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text('1. Quelle connaissance de la leçon as-tu utilisée pour traiter cette situation ?'),
                const SizedBox(height: 4),
                const Text('2. Explique les étapes de ta démarche avec tes propres mots.'),
                const SizedBox(height: 4),
                const Text('3. Dans quelle autre situation de la vie quotidienne peux-tu réutiliser cet apprentissage ?'),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(
            lesson.summary,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 48,
            child: OutlinedButton.icon(
              onPressed: _toggleReading,
              icon: Icon(_speaking ? Icons.stop_circle_outlined : Icons.volume_up_outlined),
              label: Text(_speaking ? 'Arrêter la lecture' : 'Écouter cette leçon'),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Le cours pas à pas',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ..._buildCourseBlocks(context, lesson.content),
          const SizedBox(height: 20),
          const Text(
            'À retenir',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ...lesson.keyPoints.map(
            (point) => ListTile(
              leading: const Icon(Icons.check_circle, color: Color(0xFF006A4E)),
              title: Text(point),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            icon: const Icon(Icons.assignment_outlined),
            label: const Text('Réaliser la mission APC'),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ApcMissionScreen(lesson: lesson)),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ExerciseScreen(lesson: lesson)),
            ),
            child: const Text('Faire les exercices'),
          ),
        ],
      ),
    );
  }
}\n
List<Widget> _buildCourseBlocks(BuildContext context, String content) {
  final paragraphs = content
      .split(RegExp(r'\n\s*\n'))
      .map((part) => part.trim())
      .where((part) => part.isNotEmpty)
      .toList();

  return paragraphs.asMap().entries.map((entry) {
    final index = entry.key;
    final paragraph = entry.value;
    final firstLine = paragraph.split('\n').first.trim();
    final mission = RegExp(r'^(MISSION APC|MISSION|À TOI DE JOUER)', caseSensitive: false)
        .hasMatch(firstLine);

    if (mission) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5F0),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFB7DCCB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('MISSION / APPLICATION',
                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF006A4E))),
            const SizedBox(height: 6),
            Text(paragraph, style: const TextStyle(fontSize: 15, height: 1.55)),
          ],
        ),
      );
    }

    final numbered = RegExp(r'^(\d+)\.\s*([^\n.]+)\.?').firstMatch(firstLine);
    if (numbered != null) {
      final title = numbered.group(2)!.trim();
      final remainder = paragraph.substring(numbered.end).trim();
      return Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${numbered.group(1)}. $title',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              if (remainder.isNotEmpty) ...[
                const SizedBox(height: 7),
                Text(remainder, style: const TextStyle(fontSize: 15, height: 1.55)),
              ],
            ],
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: index == 0
            ? Theme.of(context).colorScheme.surfaceContainerHighest
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Text(paragraph,
          style: TextStyle(
            fontSize: 15,
            height: 1.55,
            fontWeight: index == 0 ? FontWeight.w600 : FontWeight.normal,
          )),
    );
  }).toList();
}
