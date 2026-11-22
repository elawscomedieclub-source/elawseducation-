import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../core/school_level_provider.dart';
import '../../data/models/models.dart';
import '../../shared/widgets/menu_button.dart';

class ReadingCoachScreen extends ConsumerStatefulWidget {
  const ReadingCoachScreen({super.key});
  @override
  ConsumerState<ReadingCoachScreen> createState() => _ReadingCoachScreenState();
}

class _ReadingCoachScreenState extends ConsumerState<ReadingCoachScreen> {
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  bool _available = false, _listening = false, _hasResult = false;
  String _recognized = '';
  String? _error;
  List<String> _difficultWords = [];

  String get _passage {
    final level = ref.read(schoolLevelProvider);
    return switch (level) {
      SchoolLevel.cp1 => 'Maman a un joli sac. Le sac est rouge. Ali lit avec sa maman.',
      SchoolLevel.cp2 => 'Le petit garçon va à l’école. Il salue son maître et ouvre son livre.',
      SchoolLevel.ce1 => 'Chaque matin, Afi se lève tôt. Elle prépare son sac, puis marche avec ses amis vers l’école.',
      SchoolLevel.ce2 => 'Au village, les enfants arrosent le jardin. Ils observent les plantes et prennent soin de chaque jeune pousse.',
      SchoolLevel.cm1 => 'La lecture nous permet de découvrir le monde. En lisant chaque jour, nous enrichissons notre vocabulaire et apprenons à mieux nous exprimer.',
      SchoolLevel.cm2 => 'Pour réussir à l’école, il faut être attentif, poser des questions et s’entraîner régulièrement. Chaque effort nous aide à progresser.',
      SchoolLevel.sixieme || SchoolLevel.cinquieme => 'La bibliothèque est un lieu calme où chacun peut lire, apprendre et faire des recherches. Les livres nous apportent des connaissances et développent notre imagination.',
      SchoolLevel.quatrieme || SchoolLevel.troisieme => 'Lire avec précision demande de respecter la ponctuation, de bien articuler les mots et de varier le rythme de la voix. Une lecture attentive facilite aussi la compréhension du texte.',
      SchoolLevel.seconde || SchoolLevel.premiere || SchoolLevel.terminale => 'La maîtrise de la lecture ne consiste pas seulement à prononcer correctement les mots. Elle suppose également de respecter les groupes de sens, de rendre les intentions du texte et de comprendre les nuances du discours.',
    };
  }

  @override
  void initState() {
    super.initState();
    _tts.awaitSpeakCompletion(true);
  }

  Future<void> _startReading() async {
    await _tts.stop();
    setState(() { _recognized = ''; _difficultWords = []; _hasResult = false; _error = null; });
    try {
      _available = await _speech.initialize(
        onStatus: (status) {
          if (!mounted) return;
          setState(() => _listening = status == 'listening');
        },
        onError: (error) {
          if (!mounted) return;
          setState(() {
            _listening = false;
            _error = 'Le service vocal a rencontré un problème : ${error.errorMsg}. Vérifie le micro et le service vocal de ton appareil.';
          });
        },
      );
      if (!_available) {
        if (mounted) setState(() => _error = 'La reconnaissance vocale est indisponible. Vérifie les autorisations du micro et le service vocal de ton téléphone.');
        return;
      }
      await _speech.listen(
        onResult: _onSpeechResult,
        localeId: 'fr-FR',
        listenFor: const Duration(seconds: 45),
        pauseFor: const Duration(seconds: 5),
      );
      if (mounted) setState(() => _listening = _speech.isListening);
    } catch (_) {
      if (mounted) setState(() { _listening = false; _error = 'Impossible d’activer le micro. Autorise son accès dans les paramètres du téléphone.'; });
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    if (!mounted) return;
    setState(() {
      _recognized = result.recognizedWords;
      if (result.finalResult) {
        _hasResult = true;
        _difficultWords = _compareReading(_passage, _recognized);
      }
    });
  }

  Future<void> _stopReading() async {
    await _speech.stop();
    if (!mounted) return;
    setState(() {
      _listening = false;
      if (_recognized.trim().isNotEmpty) {
        _hasResult = true;
        _difficultWords = _compareReading(_passage, _recognized);
      }
    });
  }

  String _normaliseWord(String value) => value.toLowerCase()
      .replaceAll('à', 'a').replaceAll('â', 'a').replaceAll('ä', 'a')
      .replaceAll('é', 'e').replaceAll('è', 'e').replaceAll('ê', 'e').replaceAll('ë', 'e')
      .replaceAll('î', 'i').replaceAll('ï', 'i').replaceAll('ô', 'o').replaceAll('ö', 'o')
      .replaceAll('ù', 'u').replaceAll('û', 'u').replaceAll('ü', 'u').replaceAll('ç', 'c')
      .replaceAll(RegExp(r'[^a-z0-9]'), '');

  List<String> _words(String text) => text.toLowerCase()
      .replaceAll(RegExp(r'[.,;:!?()¿¡"“”]'), ' ')
      .split(RegExp(r'\s+')).where((word) => word.isNotEmpty).toList();

  List<String> _compareReading(String reference, String spoken) {
    final expected = _words(reference), actual = _words(spoken);
    final n = expected.length, m = actual.length;
    final dp = List.generate(n + 1, (_) => List<int>.filled(m + 1, 0));
    for (var i = 0; i <= n; i++) { dp[i][0] = i; }
    for (var j = 0; j <= m; j++) { dp[0][j] = j; }
    for (var i = 1; i <= n; i++) {
      for (var j = 1; j <= m; j++) {
        final cost = _normaliseWord(expected[i - 1]) == _normaliseWord(actual[j - 1]) ? 0 : 1;
        final a = dp[i - 1][j] + 1, b = dp[i][j - 1] + 1, c = dp[i - 1][j - 1] + cost;
        dp[i][j] = [a, b, c].reduce((x, y) => x < y ? x : y);
      }
    }
    final missed = <String>[];
    var i = n, j = m;
    while (i > 0 || j > 0) {
      if (i > 0 && j > 0 &&
          _normaliseWord(expected[i - 1]) == _normaliseWord(actual[j - 1]) &&
          dp[i][j] == dp[i - 1][j - 1]) {
        i--; j--;
      } else if (i > 0 && j > 0 && dp[i][j] == dp[i - 1][j - 1] + 1) {
        missed.add(expected[i - 1]); i--; j--;
      } else if (i > 0 && dp[i][j] == dp[i - 1][j] + 1) {
        missed.add(expected[i - 1]); i--;
      } else if (j > 0) {
        j--;
      } else { break; }
    }
    return missed.reversed.toList();
  }

  Future<void> _speakText(String text, {double rate = .42}) async {
    try {
      await _tts.stop();
      await _tts.setLanguage('fr-FR');
      await _tts.setSpeechRate(rate);
      await _tts.setPitch(1.0);
      await _tts.speak(text);
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La lecture audio n’est pas disponible sur cet appareil.')),
      );
    }
  }

  @override
  void dispose() { _speech.cancel(); _tts.stop(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final level = ref.watch(schoolLevelProvider);
    final total = _words(_passage).length;
    final missed = _difficultWords.length;
    final score = _hasResult && total > 0 ? (((total - missed).clamp(0, total) / total) * 100).round() : 0;
    return Scaffold(
      appBar: AppBar(leading: const ProfTogoMenuButton(), title: const Text('Mon coach de lecture')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(
          color: const Color(0xFFE8F5EF),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [
                Icon(Icons.menu_book_rounded, size: 30, color: Color(0xFF006A4E)),
                SizedBox(width: 10),
                Expanded(child: Text('Lis à voix haute, je t’accompagne !', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800))),
              ]),
              const SizedBox(height: 8),
              Text('Exercice adapté à ta classe : ${level.label}. Lis tranquillement le texte, puis active le micro pour comparer les mots entendus au texte.'),
            ]),
          ),
        ),
        const SizedBox(height: 14),
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Ton texte de lecture', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          SelectableText(_passage, style: const TextStyle(fontSize: 20, height: 1.8, letterSpacing: .2)),
          const SizedBox(height: 12),
          OutlinedButton.icon(onPressed: _listening ? null : () => _speakText(_passage, rate: .38), icon: const Icon(Icons.volume_up_rounded), label: const Text('Écouter un modèle lent')),
        ]))),
        const SizedBox(height: 12),
        SizedBox(height: 56, child: FilledButton.icon(
          onPressed: _listening ? _stopReading : _startReading,
          icon: Icon(_listening ? Icons.stop_circle_outlined : Icons.mic_rounded),
          label: Text(_listening ? 'Arrêter ma lecture' : 'Activer le micro et lire'),
        )),
        if (_listening) const Padding(
          padding: EdgeInsets.all(10),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.graphic_eq_rounded, color: Color(0xFF006A4E)), SizedBox(width: 8),
            Text('Je t’écoute… lis à ton rythme.', style: TextStyle(color: Color(0xFF006A4E), fontWeight: FontWeight.w700)),
          ]),
        ),
        if (_error != null) Card(child: Padding(padding: const EdgeInsets.all(12), child: Text(_error!, style: const TextStyle(color: Colors.redAccent)))),
        if (_recognized.isNotEmpty || _hasResult) Card(child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Ce que le service vocal a compris', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
            const SizedBox(height: 8),
            Text(_recognized.isEmpty ? 'Aucune parole reconnue.' : _recognized, style: const TextStyle(height: 1.5)),
          ]),
        )),
        if (_hasResult) Card(child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Ton retour de lecture', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            Text('$score % des mots attendus ont été reconnus', style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: score / 100, minHeight: 9),
            const SizedBox(height: 12),
            if (_difficultWords.isEmpty)
              const Text('Bravo ! Tous les mots du texte ont été reconnus. Refais une lecture en faisant attention à la ponctuation et au sens.')
            else ...[
              const Text('Mots à retravailler', style: TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              const Text('Le service vocal n’a pas retrouvé certains mots. Cela peut venir de la prononciation, du bruit ou de la reconnaissance vocale.'),
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 8, children: _difficultWords.map((word) => ActionChip(
                avatar: const Icon(Icons.volume_up, size: 16), label: Text(word), onPressed: () => _speakText(word),
              )).toList()),
              const SizedBox(height: 12),
              const Text('Conseil : écoute chaque mot, répète-le lentement, découpe-le en syllabes si nécessaire, puis relis la phrase entière.', style: TextStyle(height: 1.45)),
            ],
            const SizedBox(height: 12),
            OutlinedButton.icon(onPressed: () => _speakText(_passage, rate: .38), icon: const Icon(Icons.replay_rounded), label: const Text('Réécouter le texte modèle')),
            FilledButton.icon(onPressed: _startReading, icon: const Icon(Icons.refresh_rounded), label: const Text('Recommencer ma lecture')),
          ]),
        )),
        const SizedBox(height: 8),
        const Text(
          'Important : ce premier coach compare le texte attendu avec les mots reconnus par le service vocal. Il ne mesure pas encore précisément les sons, l’accent ou l’articulation phonétique. Le résultat est indicatif : un mot non reconnu ne signifie pas forcément qu’il a été mal prononcé. PROFTOGO ne sauvegarde pas de fichier audio ; le service vocal du téléphone ou du navigateur peut traiter la voix selon ses propres règles.',
          style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.4),
        ),
      ]),
    );
  }
}
