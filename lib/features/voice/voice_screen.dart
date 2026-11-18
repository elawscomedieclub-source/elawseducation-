import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../core/school_level_provider.dart';
import '../../data/models/models.dart';
import '../../data/sample/sample_data.dart';
import '../../shared/widgets/menu_button.dart';

class VoiceScreen extends ConsumerStatefulWidget {
  const VoiceScreen({super.key});

  @override
  ConsumerState<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends ConsumerState<VoiceScreen> {
  final FlutterTts _tts = FlutterTts();
  final SpeechToText _speech = SpeechToText();
  final TextEditingController _textController = TextEditingController();

  String _language = 'fr-FR';
  bool _speaking = false;
  bool _listening = false;
  bool _speechAvailable = false;
  bool _searched = false;
  List<Lesson> _matches = [];

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

  Future<void> _startListening() async {
    if (_speaking) await _tts.stop();
    try {
      _speechAvailable = await _speech.initialize(
        onStatus: (status) {
          if (!mounted) return;
          setState(() => _listening = status == 'listening');
        },
        onError: (error) {
          if (!mounted) return;
          setState(() => _listening = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Microphone : ${error.errorMsg}')),
          );
        },
      );
      if (!_speechAvailable) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reconnaissance vocale indisponible. Vérifie le microphone et le service vocal de ton appareil.'),
          ),
        );
        return;
      }
      await _speech.listen(
        onResult: _onSpeechResult,
        localeId: _language,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 4),
      );
      if (mounted) setState(() => _listening = _speech.isListening);
    } catch (_) {
      if (!mounted) return;
      setState(() => _listening = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible de démarrer le microphone. Vérifie son autorisation.')),
      );
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    if (!mounted) return;
    setState(() {
      _textController.text = result.recognizedWords;
      _textController.selection = TextSelection.collapsed(
        offset: _textController.text.length,
      );
    });
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    if (mounted) setState(() => _listening = false);
  }

  String _normalise(String value) => value
      .toLowerCase()
      .replaceAll(RegExp(r'[.,;:!?()¿¡"“”]'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  void _searchCourses() {
    final question = _normalise(_textController.text);
    if (question.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pose une question ou dicte-la avec le microphone.')),
      );
      return;
    }

    const ignored = {
      'comment', 'pourquoi', 'quelle', 'quelles', 'quel', 'quels',
      'est', 'sont', 'une', 'des', 'les', 'dans', 'avec', 'pour',
      'sur', 'que', 'qui', 'quoi', 'donne', 'moi', 'explique',
      'bonjour', 'professeur', 'prof', 'togo',
    };
    final words = question
        .split(' ')
        .where((word) => word.length > 2 && !ignored.contains(word))
        .toSet();

    final selectedLevel = ref.read(schoolLevelProvider);
    final selectedSubjectIds = demoSubjects
        .where((subject) => subject.level == selectedLevel)
        .map((subject) => subject.id)
        .toSet();
    final selectedChapterIds = demoChapters
        .where((chapter) => selectedSubjectIds.contains(chapter.subjectId))
        .map((chapter) => chapter.id)
        .toSet();
    final lessonsForLevel = demoLessons
        .whereType<Lesson>()
        .where((lesson) => selectedChapterIds.contains(lesson.chapterId));

    final scored = lessonsForLevel.map((lesson) {
      final text = _normalise(
        '${lesson.title} ${lesson.summary} ${lesson.content} ${lesson.keyPoints.join(' ')}',
      );
      final score = words.where((word) => text.contains(word)).length;
      return (lesson: lesson, score: score);
    }).where((item) => item.score > 0).toList()
      ..sort((a, b) => b.score.compareTo(a.score));

    setState(() {
      _matches = scored.take(3).map((item) => item.lesson).toList();
      _searched = true;
    });
  }

  Future<void> _speakLesson(Lesson lesson) async {
    final text = '${lesson.title}. ${lesson.summary}. ${lesson.content}';
    try {
      await _tts.setLanguage(_language);
      await _tts.setSpeechRate(0.43);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      await _tts.speak(text);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lecture vocale indisponible sur cet appareil.')),
      );
    }
  }

  Future<void> _speakAnswer() async {
    if (_matches.isEmpty) return;
    if (_speaking) {
      await _tts.stop();
      if (mounted) setState(() => _speaking = false);
    } else {
      await _speakLesson(_matches.first);
    }
  }

  @override
  void dispose() {
    _speech.cancel();
    _tts.stop();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const ProfTogoMenuButton(),
        title: const Text('Professeur vocal'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 8),
          const Icon(
            Icons.record_voice_over_rounded,
            size: 68,
            color: Color(0xFF006A4E),
          ),
          const SizedBox(height: 12),
          const Text(
            'Pose une question à ProfTogo',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Écris ta question ou utilise le microphone. ProfTogo cherchera des explications dans les leçons disponibles.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            initialValue: _language,
            decoration: const InputDecoration(
              labelText: 'Langue de la question et de la lecture',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'fr-FR', child: Text('Français')),
              DropdownMenuItem(value: 'en-US', child: Text('Anglais')),
              DropdownMenuItem(value: 'pt-PT', child: Text('Portugais')),
              DropdownMenuItem(value: 'es-ES', child: Text('Espagnol')),
            ],
            onChanged: (_listening || _speaking)
                ? null
                : (value) {
                    if (value != null) setState(() => _language = value);
                  },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _textController,
            minLines: 3,
            maxLines: 6,
            onChanged: (_) {
              if (_searched) setState(() => _searched = false);
            },
            decoration: const InputDecoration(
              labelText: 'Ta question',
              hintText: 'Exemple : Comment calculer le périmètre d’un rectangle ?',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 50,
            child: OutlinedButton.icon(
              onPressed: _listening ? _stopListening : _startListening,
              icon: Icon(_listening ? Icons.stop_circle : Icons.mic),
              label: Text(_listening ? 'Arrêter le microphone' : 'Parler à ProfTogo'),
            ),
          ),
          if (_listening) ...[
            const SizedBox(height: 8),
            const Text(
              'Je t’écoute… parle clairement puis fais une petite pause.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF006A4E), fontWeight: FontWeight.w600),
            ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            height: 50,
            child: FilledButton.icon(
              onPressed: _listening ? null : _searchCourses,
              icon: const Icon(Icons.search),
              label: const Text('Chercher dans les cours'),
            ),
          ),
          if (_searched) ...[
            const SizedBox(height: 22),
            const Text(
              'Réponses trouvées dans les cours',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (_matches.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Je ne trouve pas encore cette notion dans les leçons disponibles. Essaie avec d’autres mots ou consulte le menu Matières et cours.',
                  ),
                ),
              ),
            ..._matches.map(
              (lesson) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(lesson.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(lesson.summary),
                      const SizedBox(height: 8),
                      Text(lesson.content),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () => _speakLesson(lesson),
                          icon: const Icon(Icons.volume_up),
                          label: const Text('Écouter cette explication'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_matches.isNotEmpty)
              SizedBox(
                height: 48,
                child: FilledButton.icon(
                  onPressed: _speakAnswer,
                  icon: Icon(_speaking ? Icons.stop : Icons.record_voice_over),
                  label: Text(_speaking ? 'Arrêter la réponse' : 'Écouter la première réponse'),
                ),
              ),
          ],
          const SizedBox(height: 18),
          const Text(
            'La recherche utilise les leçons déjà intégrées à ProfTogo. Elle ne remplace pas encore un assistant intelligent capable de répondre à toutes les questions. La reconnaissance vocale dépend du service vocal et des langues disponibles sur ton appareil ou ton navigateur.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
