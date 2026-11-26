import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/school_level_provider.dart';
import '../../core/progress_service.dart';
import '../../data/models/models.dart';
import '../../data/sample/sample_data.dart';
import '../../data/sample/annual_core_catalog.dart';
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
  double _speechRate = 0.72;
  List<Map<String, dynamic>> _availableVoices = [];
  String? _selectedVoiceKey;
  List<Lesson> _matches = [];
  List<ExerciseAttemptRecord> _attemptHistory = [];
  Set<String> _reviewExerciseIds = {};
  bool _learnerContextLoaded = false;
  bool _studyPlanQuery = false;
  String _coachMessage = '';

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
    _loadAvailableVoices();
    _loadLearnerContext();
  }

  Future<void> _loadLearnerContext() async {
    try {
      final history = await ProgressService.loadAttemptHistory();
      final reviewIds = await ProgressService.loadReviewExerciseIds();
      if (!mounted) return;
      setState(() {
        _attemptHistory = history;
        _reviewExerciseIds = reviewIds;
        _learnerContextLoaded = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _learnerContextLoaded = false);
    }
  }

  String _voiceKey(Map<String, dynamic> voice) => '${voice['name']}|${voice['locale']}';

  List<Map<String, dynamic>> get _voicesForLanguage {
    final prefix = _language.split('-').first.toLowerCase();
    return _availableVoices.where((voice) =>
      '${voice['locale'] ?? ''}'.toLowerCase().startsWith(prefix)).toList();
  }

  Map<String, dynamic>? get _selectedVoice {
    for (final voice in _voicesForLanguage) {
      if (_voiceKey(voice) == _selectedVoiceKey) return voice;
    }
    return _voicesForLanguage.isEmpty ? null : _voicesForLanguage.first;
  }

  Future<void> _loadAvailableVoices() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString('proftogo_voice_language');
      final savedRate = prefs.getDouble('proftogo_voice_rate');
      final savedVoiceKey = prefs.getString('proftogo_voice_key');
      final raw = await _tts.getVoices;
      if (raw is! List) return;
      final voices = raw.whereType<Map>().map((voice) => Map<String, dynamic>.from(voice)).where((voice) =>
        voice['name'] != null && voice['locale'] != null).toList();
      int quality(Map<String, dynamic> voice) => int.tryParse('${voice['quality'] ?? ''}') ?? 0;
      int naturalScore(Map<String, dynamic> voice) {
        final name = '${voice['name'] ?? ''}'.toLowerCase();
        return ['neural', 'natural', 'enhanced', 'premium', 'wavenet', 'studio']
            .where(name.contains).length;
      }
      voices.sort((a, b) {
        final byNatural = naturalScore(b).compareTo(naturalScore(a));
        if (byNatural != 0) return byNatural;
        final byQuality = quality(b).compareTo(quality(a));
        if (byQuality != 0) return byQuality;
        final aNetwork = a['network_required'] == true ? 1 : 0;
        final bNetwork = b['network_required'] == true ? 1 : 0;
        return bNetwork.compareTo(aNetwork);
      });
      if (!mounted) return;
      setState(() {
        _language = savedLanguage ?? _language;
        _speechRate = (savedRate ?? _speechRate).clamp(0.50, 1.0).toDouble();
        _availableVoices = voices;
        final matching = _voicesForLanguage;
        _selectedVoiceKey = matching.any((voice) => _voiceKey(voice) == savedVoiceKey)
            ? savedVoiceKey
            : matching.isEmpty ? null : _voiceKey(matching.first);
      });
    } catch (_) {
      // Certains moteurs vocaux ne permettent pas d'énumérer leurs voix.
    }
  }

  Future<void> _saveVoiceSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('proftogo_voice_language', _language);
    await prefs.setDouble('proftogo_voice_rate', _speechRate);
    if (_selectedVoiceKey != null) {
      await prefs.setString('proftogo_voice_key', _selectedVoiceKey!);
    }
  }

  String _prepareNarration(String raw) {
    return raw
        .replaceAll(RegExp(r'[#*_`~]'), '')
        .replaceAll(RegExp(r'^\s*[-•]\s*', multiLine: true), '')
        .replaceAll(RegExp(r'[\r\n]+'), '. ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'\.\s*\.'), '.')
        .trim();
  }

  Future<void> _applySelectedVoice() async {
    final voice = _selectedVoice;
    if (voice == null) return;
    await _tts.setVoice({
      'name': voice['name'].toString(),
      'locale': voice['locale'].toString(),
    });
  }

  Future<void> _previewVoice() async {
    if (_speaking) await _tts.stop();
    try {
      await _tts.setLanguage(_language);
      await _applySelectedVoice();
      await _tts.setSpeechRate(_speechRate);
      await _tts.setPitch(1.0);
      await _tts.setVolume(1.0);
      await _tts.speak(_prepareNarration('Bonjour ! Je suis ton professeur. Prenons le temps de comprendre cette leçon, étape par étape.'));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cette voix ne peut pas être utilisée. Essaie une autre voix installée sur ton téléphone.')));
    }
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

    final studyPlanQuery = [
      'quoi reviser', 'que reviser', 'quoi travailler', 'comment progresser',
      'mes difficultes', 'mes difficultés', 'mon niveau', 'recommande',
      'recommandation', 'plan de revision', 'plan de révision',
      'a revoir', 'à revoir', 'par quoi commencer', 'aide moi a progresser',
    ].any(question.contains) ||
        question.contains('revis') ||
        question.contains('révis') ||
        question.contains('difficult') ||
        question.contains('progres');

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
    final selectedTrack = ref.read(schoolTrackProvider);
    final selectedSeries = ref.read(schoolSeriesProvider);
    final selectedSubjectIds = [...demoSubjects, ...annualCoreSubjects]
        .where((subject) => subjectMatchesPath(subject, selectedLevel, selectedTrack, selectedSeries))
        .map((subject) => subject.id).toSet();
    final selectedChapterIds = [...demoChapters, ...annualCoreChapters]
        .where((chapter) => selectedSubjectIds.contains(chapter.subjectId))
        .map((chapter) => chapter.id).toSet();
    final lessonsForLevel = [...demoLessons.whereType<Lesson>(), ...annualCoreLessons]
        .where((lesson) => selectedChapterIds.contains(lesson.chapterId))
        .toList();

    final allExercises = [...demoExercises, ...annualCoreExercises];
    final exerciseById = {for (final exercise in allExercises) exercise.id: exercise};
    final attemptsByLesson = <String, int>{};
    final recentWrongByLesson = <String, int>{};
    final recentCorrectByLesson = <String, int>{};
    final cutoff = DateTime.now().subtract(const Duration(days: 14));
    for (final attempt in _attemptHistory) {
      attemptsByLesson.update(attempt.lessonId, (count) => count + 1, ifAbsent: () => 1);
      if (!attempt.timestamp.isBefore(cutoff)) {
        if (attempt.isCorrect) {
          recentCorrectByLesson.update(attempt.lessonId, (count) => count + 1, ifAbsent: () => 1);
        } else {
          recentWrongByLesson.update(attempt.lessonId, (count) => count + 1, ifAbsent: () => 1);
        }
      }
    }
    final lessonsWithReview = <String>{};
    for (final exerciseId in _reviewExerciseIds) {
      final exercise = exerciseById[exerciseId];
      if (exercise != null) lessonsWithReview.add(exercise.lessonId);
    }

    int personalPriority(Lesson lesson) {
      final review = lessonsWithReview.contains(lesson.id) ? 100 : 0;
      final recentWrong = recentWrongByLesson[lesson.id] ?? 0;
      final recentCorrect = recentCorrectByLesson[lesson.id] ?? 0;
      final notYetStudied = (attemptsByLesson[lesson.id] ?? 0) == 0 ? 5 : 0;
      return review + recentWrong * 10 + notYetStudied - recentCorrect * 2;
    }

    List<Lesson> matches;
    String coachMessage = '';
    if (studyPlanQuery) {
      final ranked = lessonsForLevel.toList()
        ..sort((a, b) => personalPriority(b).compareTo(personalPriority(a)));
      final due = ranked.where((lesson) =>
        lessonsWithReview.contains(lesson.id) ||
        (recentWrongByLesson[lesson.id] ?? 0) > 0).toList();
      final notStudied = ranked.where((lesson) =>
        (attemptsByLesson[lesson.id] ?? 0) == 0).toList();
      matches = (due.isNotEmpty ? due : (notStudied.isNotEmpty ? notStudied : ranked))
          .take(3).toList();

      if (!_learnerContextLoaded) {
        coachMessage = 'Je n’ai pas encore pu charger ton historique. Je te propose des leçons de ta classe ; tes prochaines réponses permettront d’affiner le conseil.';
      } else if (_attemptHistory.isEmpty) {
        coachMessage = 'Je commence à construire ton parcours. Je ne vois pas encore de réponses enregistrées : commence par ces leçons, puis je pourrai cibler tes difficultés et tes progrès.';
      } else if (due.isNotEmpty) {
        final recentDifficulties = recentWrongByLesson.values.fold<int>(0, (sum, value) => sum + value);
        coachMessage = 'J’ai repéré des notions à reprendre à partir de tes erreurs récentes et de tes exercices marqués pour révision. Je les place en priorité, puis nous avancerons vers de nouvelles leçons.';
        if (recentDifficulties > 0) {
          coachMessage += ' ${recentDifficulties} réponse(s) incorrecte(s) ont été enregistrées sur les 14 derniers jours.';
        }
      } else if (notStudied.isNotEmpty) {
        coachMessage = 'Tes réponses récentes ne signalent pas de difficulté à reprendre en priorité. Je te propose maintenant des leçons de ta classe que tu n’as pas encore travaillées';
      } else {
        coachMessage = 'Tu as déjà travaillé les leçons de ta classe et je ne vois pas de difficulté récente marquée. Je te propose de consolider les notions les moins récentes';
      }
    } else {
      final scored = lessonsForLevel.map((lesson) {
        final text = _normalise(
          '${lesson.title} ${lesson.summary} ${lesson.content} ${lesson.keyPoints.join(' ')}',
        );
        final keywordScore = words.where((word) => text.contains(word)).length;
        final score = keywordScore * 10 + personalPriority(lesson);
        return (lesson: lesson, score: score, keywordScore: keywordScore);
      }).where((item) => item.keywordScore > 0).toList()
        ..sort((a, b) => b.score.compareTo(a.score));
      matches = scored.take(3).map((item) => item.lesson).toList();
    }

    setState(() {
      _matches = matches;
      _studyPlanQuery = studyPlanQuery;
      _coachMessage = coachMessage;
      _searched = true;
    });
  }

  Future<void> _speakLesson(Lesson lesson) async {
    final keyPoints = lesson.keyPoints.isEmpty ? '' : 'Les points à retenir : ${lesson.keyPoints.join('. ')}.';
    final text = _prepareNarration('${lesson.title}. ${lesson.summary}. ${lesson.content}. $keyPoints');
    try {
      await _tts.setLanguage(_language);
      await _applySelectedVoice();
      await _tts.setSpeechRate(_speechRate);
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
            'Écris ta question ou dicte-la. ProfTogo recherche dans les cours de ta classe et de ta série, puis peut lire les explications à voix haute.',
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
                    if (value != null) {
                      setState(() {
                        _language = value;
                        final voices = _voicesForLanguage;
                        _selectedVoiceKey = voices.isEmpty ? null : _voiceKey(voices.first);
                      });
                      _saveVoiceSettings();
                    }
                  },
          ),
          const SizedBox(height: 12),
          if (_voicesForLanguage.isNotEmpty) ...[
            DropdownButtonFormField<String>(
              key: ValueKey('voice-$_language-$_selectedVoiceKey'),
              initialValue: _selectedVoiceKey,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Voix du professeur', border: OutlineInputBorder()),
              items: _voicesForLanguage.map((voice) => DropdownMenuItem<String>(
                value: _voiceKey(voice),
                child: Text('${voice['name']} · ${voice['locale']}', overflow: TextOverflow.ellipsis),
              )).toList(),
              onChanged: (_speaking || _listening) ? null : (value) {
                if (value != null) {
                  setState(() => _selectedVoiceKey = value);
                  _saveVoiceSettings();
                }
              },
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: (_speaking || _listening) ? null : _previewVoice,
              icon: const Icon(Icons.record_voice_over_outlined),
              label: const Text('Écouter un exemple de cette voix'),
            ),
          ] else const Text('Les voix proposées dépendent du moteur vocal installé sur ton téléphone.'),
          if (_voicesForLanguage.isNotEmpty)
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text('ProfTogo privilégie les voix améliorées lorsqu’elles sont disponibles. La langue, la voix et la vitesse choisies sont réutilisées pour la lecture des cours et des questions.', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.speed, color: Color(0xFF006A4E)),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text('Vitesse de la voix', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Text(_speechRate < 0.68 ? 'Lente' : (_speechRate >= 0.82 ? 'Rapide' : 'Normale')),
                    ],
                  ),
                  Slider(
                    value: _speechRate,
                    min: 0.50,
                    max: 1.0,
                    divisions: 10,
                    label: _speechRate.toStringAsFixed(2),
                    onChanged: (_speaking || _listening)
                        ? null
                        : (value) {
                            setState(() => _speechRate = value);
                            _saveVoiceSettings();
                          },
                  ),
                  const Text(
                    'Choisis un débit plus rapide ou plus posé. Une voix de meilleure qualité, si elle est installée, rendra aussi la lecture plus naturelle.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
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
            Text(
              _studyPlanQuery ? 'Ton plan de révision personnalisé' : 'Réponses trouvées dans les cours',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (_studyPlanQuery && _coachMessage.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Text(_coachMessage),
                ),
              ),
            const SizedBox(height: 8),
            if (_matches.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Je ne trouve pas encore cette notion dans les leçons de ta classe. Essaie avec un mot-clé plus simple (par exemple « fraction », « cellule » ou « verbe »), ou consulte Matières et cours.',
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
            'ProfTogo recherche dans les cours de ta classe et utilise tes réponses récentes pour proposer des révisions adaptées. Si une notion n’est pas présente dans les leçons, il te le signale au lieu d’inventer une réponse. La lecture utilise les voix installées sur ton téléphone : la voix exacte de ChatGPT ne peut pas être transférée dans l’application. La reconnaissance vocale dépend aussi du service et des langues disponibles sur ton appareil.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
