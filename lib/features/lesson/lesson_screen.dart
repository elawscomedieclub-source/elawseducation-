import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../data/models/models.dart';
import '../../data/sample/sample_data.dart';
import 'exercise_screen.dart';
import 'apc_lesson_guide.dart';
import 'apc_mission_screen.dart';
import 'lesson_visual_support.dart';
import 'lesson_extended_visual_support.dart';
import 'physics_course_support.dart';

class LessonScreen extends StatelessWidget {
  final Chapter chapter;
  const LessonScreen({super.key, required this.chapter});

  @override
  Widget build(BuildContext context) {
    final lessons = demoLessons.where((lesson) => lesson.chapterId == chapter.id).toList();

    return Scaffold(
      appBar: AppBar(title: Text(chapter.title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Icon(Icons.menu_book_rounded,
                    size: 30,
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${lessons.length} leçon(s) dans ce chapitre',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          )),
                      const SizedBox(height: 3),
                      Text('Lis chaque leçon, observe les exemples puis entraîne-toi.',
                          style: TextStyle(
                            height: 1.3,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          if (lessons.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Text('Les leçons de ce chapitre seront bientôt disponibles.'),
              ),
            ),
          ...lessons.asMap().entries.map((entry) {
            final index = entry.key;
            final lesson = entry.value;
            final exerciseCount = demoExercises
                .where((exercise) => exercise.lessonId == lesson.id)
                .length;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Text('${index + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        )),
                  ),
                  title: Text(lesson.title,
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(lesson.summary,
                            maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 12,
                          runSpacing: 4,
                          children: [
                            _LessonMeta(
                              icon: Icons.schedule_rounded,
                              label: '${lesson.durationMinutes} min',
                            ),
                            _LessonMeta(
                              icon: Icons.quiz_outlined,
                              label: '$exerciseCount exercice(s)',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 17),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LessonContentScreen(lesson: lesson),
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

class LessonContentScreen extends StatefulWidget {
  final Lesson lesson;
  const LessonContentScreen({super.key, required this.lesson});

  @override
  State<LessonContentScreen> createState() => _LessonContentScreenState();
}

class _LessonContentScreenState extends State<LessonContentScreen> {
  final FlutterTts _tts = FlutterTts();
  bool _speaking = false;
  bool _paused = false;
  double _speechRate = 0.74;

  double _defaultSpeechRateForLesson() {
    final chapter = demoChapters.where((item) => item.id == widget.lesson.chapterId);
    if (chapter.isEmpty) return 0.74;
    final subject = demoSubjects.where((item) => item.id == chapter.first.subjectId);
    if (subject.isEmpty) return 0.74;
    final level = subject.first.level;
    if (level.index <= SchoolLevel.cp2.index) return 0.58;
    if (level.index <= SchoolLevel.cm2.index) return 0.66;
    if (level.index <= SchoolLevel.troisieme.index) return 0.74;
    return 0.80;
  }

  @override
  void initState() {
    super.initState();
    _speechRate = _defaultSpeechRateForLesson();
    _tts.setStartHandler(() {
      if (mounted) setState(() { _speaking = true; _paused = false; });
    });
    _tts.setCompletionHandler(() {
      if (mounted) setState(() { _speaking = false; _paused = false; });
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

  Future<void> _startReading() async {
    try {
      await _tts.stop();
      await _tts.setLanguage('fr-FR');
      await _tts.setSpeechRate(_speechRate);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      if (mounted) setState(() { _speaking = true; _paused = false; });
      await _tts.speak(_lessonText);
    } catch (_) {
      if (!mounted) return;
      setState(() { _speaking = false; _paused = false; });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lecture vocale indisponible. Vérifie que la synthèse vocale française est installée sur ton téléphone.'),
        ),
      );
    }
  }

  Future<void> _pauseReading() async {
    try {
      await _tts.pause();
      if (mounted) setState(() => _paused = true);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('La pause vocale n’est pas prise en charge par cette voix.')),
        );
      }
    }
  }

  Future<void> _resumeReading() async {
    try {
      await _tts.setSpeechRate(_speechRate);
      await _tts.speak(_lessonText);
      if (mounted) setState(() { _speaking = true; _paused = false; });
    } catch (_) {
      if (mounted) setState(() { _speaking = false; _paused = false; });
    }
  }

  Future<void> _stopReading() async {
    await _tts.stop();
    if (mounted) setState(() { _speaking = false; _paused = false; });
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
    final subject = demoSubjects.firstWhere(
      (item) => item.id == chapter.subjectId,
      orElse: () => demoSubjects.first,
    );
    final childMode = subject.level.index <= SchoolLevel.cm2.index;

    return Scaffold(
      appBar: AppBar(title: Text(lesson.title), actions: [const Padding(padding: EdgeInsets.only(right: 14), child: Icon(Icons.auto_stories_rounded))]),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(22, 18, 22, 30),
        children: [
          if (childMode) Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tu peux écouter le cours', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  const Text('Appuie sur le bouton pour entendre les explications. Tu peux arrêter la voix quand tu veux.'),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _speaking ? _stopReading : _startReading,
                      icon: Icon(_speaking ? Icons.stop_rounded : Icons.volume_up_rounded),
                      label: Text(_speaking ? 'Arrêter la lecture' : 'Écouter le cours'),
                      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(58), textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            clipBehavior: Clip.antiAlias,
            child: ExpansionTile(
              initiallyExpanded: false,
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFE8F5F0),
                child: Icon(Icons.lightbulb_outline, color: Color(0xFF006A4E)),
              ),
              title: const Text('Mission APC',
                  style: TextStyle(fontWeight: FontWeight.w800)),
              subtitle: Text(
                apc.competence,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5F0),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFB7DCCB)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Situation-problème',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(apc.situation),
                      const SizedBox(height: 12),
                      const Text('Ta mission',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(apc.mission),
                      const SizedBox(height: 12),
                      const Text('Démarche de travail',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      ...apc.steps.asMap().entries.map((entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 11,
                              backgroundColor: const Color(0xFF087443),
                              child: Text(
                                '${entry.key + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(entry.value)),
                          ],
                        ),
                      )),
                      const SizedBox(height: 8),
                      const Text('Production attendue',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(apc.production),
                      const SizedBox(height: 12),
                      const Text('Critères de réussite',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      ...apc.criteria.map((criterion) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle_outline,
                                size: 18, color: Color(0xFF006A4E)),
                            const SizedBox(width: 6),
                            Expanded(child: Text(criterion)),
                          ],
                        ),
                      )),
                      const SizedBox(height: 12),
                      const Text('Questions de transfert',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      const Text('1. Quelle connaissance de la leçon as-tu utilisée pour traiter cette situation ?'),
                      const SizedBox(height: 4),
                      const Text('2. Explique les étapes de ta démarche avec tes propres mots.'),
                      const SizedBox(height: 4),
                      const Text('3. Dans quelle autre situation de la vie quotidienne peux-tu réutiliser cet apprentissage ?'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.flag_rounded,
                          color: Theme.of(context).colorScheme.onPrimaryContainer),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text('L’essentiel de la leçon',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            )),
                      ),
                      Text('${lesson.durationMinutes} min',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          )),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    lesson.summary,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.45,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(Icons.record_voice_over, color: Theme.of(context).colorScheme.onSecondaryContainer),
                    const SizedBox(width: 8),
                    Expanded(child: Text('Écouter le cours', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSecondaryContainer))),
                  ]),
                  const SizedBox(height: 4),
                  Text('La voix lit le cours en français. Ajuste la vitesse selon ton confort.', style: Theme.of(context).textTheme.bodySmall),
                  Row(children: [
                    const Text('Lent'),
                    Expanded(
                      child: Slider(
                        value: _speechRate,
                        min: 0.30,
                        max: 0.75,
                        divisions: 9,
                        label: _speechRate.toStringAsFixed(2),
                        onChanged: (value) => setState(() => _speechRate = value),
                      ),
                    ),
                    const Text('Rapide'),
                  ]),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _speaking && !_paused ? _pauseReading : (_paused ? _resumeReading : _startReading),
                          icon: Icon(_speaking && !_paused ? Icons.pause : Icons.play_arrow),
                          label: Text(_speaking && !_paused ? 'Pause' : (_paused ? 'Reprendre' : 'Écouter')),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filledTonal(
                        tooltip: 'Arrêter la voix',
                        onPressed: _speaking || _paused ? _stopReading : null,
                        icon: const Icon(Icons.stop),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E8),
              border: Border.all(color: const Color(0xFFE6D8B8)),
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 3))],
            ),
            child: const Text('📖  Mon cahier de leçon', style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF72552B))),
          ),
          const SizedBox(height: 10),
          const Text(
            'Le cours pas à pas',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ..._buildCourseBlocks(context, lesson.content),
          LessonVisualSupport(lesson: lesson),
          ExtendedLessonVisualSupport(lesson: lesson),
          PhysicsCourseSupport(lesson: lesson, chapterTitle: chapter.title, chapterId: chapter.id),
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
}

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
      final scheme = Theme.of(context).colorScheme;
      final sectionColor = index.isEven ? scheme.primaryContainer : scheme.secondaryContainer;
      final sectionTextColor = index.isEven ? scheme.onPrimaryContainer : scheme.onSecondaryContainer;
      return Card(
        color: sectionColor,
        margin: const EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Icon(Icons.bookmark, size: 19, color: sectionTextColor),
                const SizedBox(width: 7),
                Expanded(child: Text('${numbered.group(1)}. $title',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: sectionTextColor))),
              ]),
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

class _LessonMeta extends StatelessWidget {
  final IconData icon;
  final String label;

  const _LessonMeta({required this.icon, required this.label});

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

