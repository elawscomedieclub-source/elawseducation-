import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../core/school_level_provider.dart';
import '../../data/models/models.dart';
import '../../core/reading_practice_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _ReadingCard {
  final String title;
  final String hint;
  final String example;
  const _ReadingCard(this.title, this.hint, this.example);
}

class _ReadingStage {
  final String title;
  final String description;
  final List<_ReadingCard> cards;
  final String question;
  final List<String> choices;
  final int answer;
  final String explanation;
  const _ReadingStage({
    required this.title,
    required this.description,
    required this.cards,
    required this.question,
    required this.choices,
    required this.answer,
    required this.explanation,
  });
}

const _stages = <_ReadingStage>[
  _ReadingStage(
    title: '1. Les lettres et les sons',
    description: 'Regarde la lettre, écoute son son, puis répète doucement.',
    cards: [
      _ReadingCard('M m', 'Le son /m/', 'mmmm'),
      _ReadingCard('A a', 'Le son /a/', 'aaaa'),
      _ReadingCard('S s', 'Le son /s/', 'ssss'),
      _ReadingCard('L l', 'Le son /l/', 'llll'),
      _ReadingCard('T t', 'Le son /t/', 'te'),
      _ReadingCard('O o', 'Le son /o/', 'oooo'),
    ],
    question: 'Quel son entend-on au début du mot « maman » ?',
    choices: [' /m/ comme mmmm', ' /s/ comme ssss', ' /l/ comme llll'],
    answer: 0,
    explanation: 'Maman commence par le son /m/. Pose les lèvres et fais mmmm.',
  ),
  _ReadingStage(
    title: '2. Les syllabes',
    description: 'Associe les sons pour lire une syllabe. Lis chaque ligne lentement.',
    cards: [
      _ReadingCard('MA  ME  MI', 'Avec le son /m/', 'ma, me, mi'),
      _ReadingCard('MO  MU', 'Avec le son /m/', 'mo, mu'),
      _ReadingCard('SA  SE  SI', 'Avec le son /s/', 'sa, se, si'),
      _ReadingCard('SO  SU', 'Avec le son /s/', 'so, su'),
      _ReadingCard('LA  LE  LI', 'Avec le son /l/', 'la, le, li'),
      _ReadingCard('LO  LU', 'Avec le son /l/', 'lo, lu'),
    ],
    question: 'Quelle syllabe entend-on au début de « moto » ?',
    choices: ['MA', 'MO', 'SA'],
    answer: 1,
    explanation: 'Moto commence par MO : le son /m/ associé au son /o/.',
  ),
  _ReadingStage(
    title: '3. Les mots',
    description: 'Découpe le mot en syllabes, puis rassemble-les pour lire le mot entier.',
    cards: [
      _ReadingCard('MA - MAN', '2 syllabes', 'maman'),
      _ReadingCard('MO - TO', '2 syllabes', 'moto'),
      _ReadingCard('SA - LU', '2 syllabes', 'salut'),
      _ReadingCard('LA - PIN', '2 syllabes', 'lapin'),
      _ReadingCard('TO - MA - TE', '3 syllabes', 'tomate'),
      _ReadingCard('BA - NA - NE', '3 syllabes', 'banane'),
    ],
    question: 'Quel mot se découpe en « BA - NA - NE » ?',
    choices: ['Banane', 'Lapin', 'Maman'],
    answer: 0,
    explanation: 'BA - NA - NE forme le mot banane. Lis chaque syllabe, puis le mot entier.',
  ),
  _ReadingStage(
    title: '4. Les petites phrases',
    description: 'Lis les mots dans l’ordre. Fais une petite pause au point.',
    cards: [
      _ReadingCard('Phrase 1', 'Lis doucement', 'Mali a un joli sac.'),
      _ReadingCard('Phrase 2', 'Respecte la pause', 'Afi lit avec sa maman.'),
      _ReadingCard('Phrase 3', 'Lis sans te presser', 'Le lapin mange une tomate.'),
    ],
    question: 'Quelle phrase dit que Afi lit ?',
    choices: ['Afi lit avec sa maman.', 'Mali a un joli sac.', 'Le lapin mange une tomate.'],
    answer: 0,
    explanation: 'Bravo. Tu as retrouvé la phrase qui parle de la lecture de Afi.',
  ),
];

class ReadingBasicsScreen extends ConsumerStatefulWidget {
  const ReadingBasicsScreen({super.key});

  @override
  ConsumerState<ReadingBasicsScreen> createState() => _ReadingBasicsScreenState();
}

class _ReadingBasicsScreenState extends ConsumerState<ReadingBasicsScreen> {
  final FlutterTts _tts = FlutterTts();
  int _stageIndex = 0;
  final Set<int> _completed = {};
  int? _selectedAnswer;
  bool _answered = false;
  int _attemptCount = 0;
  Map<int, int> _stageWrongCounts = {};
  bool _loadingProgress = true;

  @override
  void initState() {
    super.initState();
    _tts.awaitSpeakCompletion(true);
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final values = await Future.wait([
      ReadingPracticeService.loadCompletedStages(),
      ReadingPracticeService.loadAttemptCount(),
      ReadingPracticeService.loadStageWrongCounts(),
    ]);
    if (!mounted) return;
    setState(() {
      _completed
        ..clear()
        ..addAll(values[0] as Set<int>);
      _attemptCount = values[1] as int;
      _stageWrongCounts = values[2] as Map<int, int>;
      _loadingProgress = false;
    });
  }

  Future<void> _speak(String text) async {
    try {
      await _tts.stop();
      await _tts.setLanguage('fr-FR');
      await _tts.setSpeechRate(.38);
      await _tts.setPitch(1.0);
      await _tts.speak(text);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('La lecture audio n’est pas disponible sur cet appareil.')),
        );
      }
    }
  }

  void _chooseStage(int index) {
    setState(() {
      _stageIndex = index;
      _selectedAnswer = null;
      _answered = false;
    });
  }

  Future<void> _checkAnswer() async {
    if (_selectedAnswer == null) return;
    final isCorrect = _selectedAnswer == _stages[_stageIndex].answer;
    await ReadingPracticeService.recordAttempt(
      stageIndex: _stageIndex,
      isCorrect: isCorrect,
    );
    final attempts = await ReadingPracticeService.loadAttemptCount();
    final wrongCounts = await ReadingPracticeService.loadStageWrongCounts();
    if (!mounted) return;
    setState(() {
      _answered = true;
      _attemptCount = attempts;
      _stageWrongCounts = wrongCounts;
      if (isCorrect) _completed.add(_stageIndex);
    });
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stage = _stages[_stageIndex];
    final level = ref.watch(schoolLevelProvider);
    final progress = _completed.length / _stages.length;
    final stageWrongCount = _stageWrongCounts[_stageIndex] ?? 0;
    final drillExamples = _stageIndex == 0
        ? ['mmmm', 'ssss', 'llll', 'aaaa']
        : _stageIndex == 1
            ? ['ma, me, mi', 'sa, se, si', 'la, le, li', 'mo, so, lo']
            : _stageIndex == 2
                ? ['ma-man : maman', 'mo-to : moto', 'la-pin : lapin', 'ba-na-ne : banane']
                : ['Mali lit.', 'Afi aime sa maman.', 'Le lapin mange.'];

    return Scaffold(
      appBar: AppBar(title: const Text('Atelier sons et syllabes')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: const Color(0xFFE8F5EF),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(children: [
                    Icon(Icons.auto_stories_rounded, color: Color(0xFF006A4E), size: 30),
                    SizedBox(width: 10),
                    Expanded(child: Text('J’apprends à lire pas à pas', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800))),
                  ]),
                  const SizedBox(height: 8),
                  Text('Parcours de révision adapté à ta classe : ${level.label}. Tu peux écouter, répéter et recommencer autant de fois que nécessaire.'),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(value: progress, minHeight: 8),
                  const SizedBox(height: 5),
                  Text('${_completed.length} étape(s) validée(s) sur 4 • $_attemptCount tentative(s) enregistrée(s)'),
                  if (_loadingProgress) const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: LinearProgressIndicator(minHeight: 3),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(_stages.length, (index) {
              final done = _completed.contains(index);
              return ChoiceChip(
                selected: _stageIndex == index,
                avatar: Icon(done ? Icons.check_circle : Icons.circle_outlined, size: 18),
                label: Text('Étape ${index + 1}'),
                onSelected: (_) => _chooseStage(index),
              );
            }),
          ),
          const SizedBox(height: 14),
          Text(stage.title, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(stage.description, style: const TextStyle(height: 1.45)),
          const SizedBox(height: 12),
          ...stage.cards.map((card) => Card(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              title: Text(card.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1)),
              subtitle: Text('${card.hint}  •  Exemple : ${card.example}'),
              trailing: IconButton(
                tooltip: 'Écouter',
                icon: const Icon(Icons.volume_up_rounded, color: Color(0xFF006A4E)),
                onPressed: () => _speak(card.example),
              ),
              onTap: () => _speak(card.example),
            ),
          )),
          if (stageWrongCount >= 2) ...[
            Card(
              color: const Color(0xFFFFF4E5),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(children: [
                      Icon(Icons.lightbulb_outline_rounded, color: Colors.deepOrange),
                      SizedBox(width: 8),
                      Expanded(child: Text('Petit entraînement conseillé', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16))),
                    ]),
                    const SizedBox(height: 6),
                    const Text('Tu as rencontré plusieurs difficultés dans cette étape. Prends ton temps : écoute ces exemples, puis essaie de les lire à voix haute.'),
                    const SizedBox(height: 8),
                    ...drillExamples.map((example) => ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(example, style: const TextStyle(fontWeight: FontWeight.w700)),
                      trailing: IconButton(
                        tooltip: 'Écouter',
                        icon: const Icon(Icons.volume_up_rounded),
                        onPressed: () => _speak(example),
                      ),
                      onTap: () => _speak(example),
                    )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Je vérifie si j’ai compris', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  Text(stage.question, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  ...List.generate(stage.choices.length, (index) => RadioListTile<int>(
                    value: index,
                    groupValue: _selectedAnswer,
                    contentPadding: EdgeInsets.zero,
                    title: Text(stage.choices[index]),
                    onChanged: _answered ? null : (value) => setState(() => _selectedAnswer = value),
                  )),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _selectedAnswer == null || _answered ? null : _checkAnswer,
                      child: const Text('Vérifier ma réponse'),
                    ),
                  ),
                  if (_answered) ...[
                    const SizedBox(height: 10),
                    Text(
                      _selectedAnswer == stage.answer
                          ? 'Bravo ! Étape validée. ${stage.explanation}'
                          : 'Ce n’est pas encore cela. Réécoute les exemples et essaie encore.',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: _selectedAnswer == stage.answer ? const Color(0xFF087443) : Colors.deepOrange,
                        height: 1.4,
                      ),
                    ),
                    if (_selectedAnswer != stage.answer)
                      TextButton(
                        onPressed: () => setState(() { _selectedAnswer = null; _answered = false; }),
                        child: const Text('Réessayer'),
                      ),
                  ],
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _stageIndex == 0 ? null : () => _chooseStage(_stageIndex - 1),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Précédent'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _stageIndex == _stages.length - 1 ? null : () => _chooseStage(_stageIndex + 1),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Suivant'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Ce parcours est un entraînement de lecture. La validation d’une étape signifie que la réponse au petit exercice est correcte ; elle ne prouve pas à elle seule que l’élève maîtrise définitivement la lecture.',
            style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.4),
          ),
        ],
      ),
    );
  }
}
