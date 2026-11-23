import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../core/progress_service.dart';
import '../../core/school_level_provider.dart';
import '../../data/models/models.dart';
import '../../data/sample/supplemental_curriculum.dart';

class SupplementalCurriculumScreen extends ConsumerStatefulWidget {
  const SupplementalCurriculumScreen({super.key});
  @override
  ConsumerState<SupplementalCurriculumScreen> createState() => _SupplementalCurriculumScreenState();
}

class _SupplementalCurriculumScreenState extends ConsumerState<SupplementalCurriculumScreen> {
  final FlutterTts _tts = FlutterTts();
  final Set<String> _completed = {};
  final Map<String, int> _selected = {};
  int _lessonIndex = 0;
  bool _loading = true;
  bool _speaking = false;
  String? _feedback;
  late final StreamSubscription<User?> _authSubscription;
  int _progressLoadVersion = 0;

  @override
  void initState() {
    super.initState();
    _tts.setCompletionHandler(() {
      if (mounted) setState(() => _speaking = false);
    });
    _loadProgress();
    // Les exercices validés à l'écran doivent suivre le compte actif.
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((_) async {
      if (!mounted) return;
      await _tts.stop();
      if (!mounted) return;
      setState(() {
        _completed.clear();
        _selected.clear();
        _feedback = null;
        _speaking = false;
        _loading = true;
      });
      await _loadProgress();
    });
  }

  Future<void> _loadProgress() async {
    final version = ++_progressLoadVersion;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    try {
      final progress = await ProgressService.load();
      if (!mounted || version != _progressLoadVersion || FirebaseAuth.instance.currentUser?.uid != uid) return;
      setState(() {
        _completed.addAll(progress.correctExerciseIds);
        _loading = false;
      });
    } catch (_) {
      if (mounted && version == _progressLoadVersion && FirebaseAuth.instance.currentUser?.uid == uid) setState(() => _loading = false);
    }
  }

  Future<void> _read(String text) async {
    if (_speaking) {
      await _tts.stop();
      if (mounted) setState(() => _speaking = false);
      return;
    }
    try {
      final level = ref.read(schoolLevelProvider);
      await _tts.stop();
      await _tts.setLanguage('fr-FR');
      await _tts.setSpeechRate(level.index <= SchoolLevel.cp2.index ? 0.58 : level.index <= SchoolLevel.cm2.index ? 0.66 : level.index <= SchoolLevel.troisieme.index ? 0.74 : 0.80);
      if (mounted) setState(() => _speaking = true);
      await _tts.speak(text);
    } catch (_) {
      if (mounted) {
        setState(() => _speaking = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('La lecture audio n’est pas disponible sur ce téléphone.')));
      }
    }
  }

  Future<void> _check(SupplementalQuestion question) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final answer = _selected[question.id];
    if (answer == null || _completed.contains(question.id)) return;
    if (answer != question.correctIndex) {
      setState(() => _feedback = 'Essaie encore. Écoute la question ou relis la leçon.');
      return;
    }
    try {
      await ProgressService.recordAnswer(exerciseId: question.id, isCorrect: true);
      if (!mounted || FirebaseAuth.instance.currentUser?.uid != uid) return;
      setState(() {
        _completed.add(question.id);
        _feedback = 'Bravo ! Bonne réponse. ' + question.explanation;
      });
    } catch (_) {
      if (mounted && FirebaseAuth.instance.currentUser?.uid == uid) setState(() => _feedback = 'Bonne réponse ! La sauvegarde sera réessayée plus tard.');
    }
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    unawaited(_tts.stop());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final level = ref.watch(schoolLevelProvider);
    final childMode = level.index <= SchoolLevel.cm2.index;
    final lessons = supplementalLessons.where((item) => item.level == level).toList();
    if (lessons.isEmpty) {
      return Scaffold(appBar: AppBar(title: const Text('Cours bonus')), body: const Center(child: Text('De nouvelles activités seront ajoutées pour cette classe.')));
    }
    if (_lessonIndex >= lessons.length) _lessonIndex = 0;
    final lesson = lessons[_lessonIndex];
    final questionIndex = _selectedQuestionIndex(lesson);
    final question = lesson.questions[questionIndex];
    final completedCount = lesson.questions.where((item) => _completed.contains(item.id)).length;

    return Scaffold(
      appBar: AppBar(title: Text('Cours bonus • ' + level.label)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
              children: [
                Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      childMode ? 'Bonjour ! Choisis une petite leçon, écoute-la, puis réponds aux questions.' : 'Des leçons courtes et des exercices supplémentaires pour réviser.',
                      style: TextStyle(fontSize: childMode ? 18 : 16, height: 1.4, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onPrimaryContainer),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text('Choisis une leçon', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                ...lessons.asMap().entries.map((entry) {
                  final selected = entry.key == _lessonIndex;
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      minVerticalPadding: childMode ? 14 : 8,
                      leading: CircleAvatar(radius: childMode ? 25 : 20, child: Icon(entry.value.subject == 'Mathématiques' ? Icons.calculate_rounded : Icons.menu_book_rounded)),
                      title: Text(entry.value.title, style: TextStyle(fontSize: childMode ? 18 : 16, fontWeight: FontWeight.w800)),
                      subtitle: Text(entry.value.subject),
                      trailing: selected ? const Icon(Icons.check_circle_rounded) : const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                      selected: selected,
                      onTap: () => setState(() {
                        _lessonIndex = entry.key;
                        _feedback = null;
                      }),
                    ),
                  );
                }),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(lesson.title, style: TextStyle(fontSize: childMode ? 23 : 20, fontWeight: FontWeight.w800)),
                        if (level == SchoolLevel.cp1 || lesson.id == 'cp2_monnaie_fcfa' || lesson.id == 'ce1_achats_fcfa' || lesson.id == 'ce2_budget_fcfa' || lesson.id == 'ce2_mesures_longueurs' || lesson.id == 'ce2_mesures_masses' || lesson.id == 'ce2_mesures_capacites' || lesson.id == 'ce2_mesures_duree' || lesson.id == 'ce2_partage_division' || lesson.id == 'ce2_problemes_multiplication' || lesson.id == 'ce2_choisir_operation' || lesson.id == 'ce2_table_multiplication_2' || lesson.id == 'ce2_table_multiplication_3' || lesson.id == 'ce2_table_multiplication_4' || lesson.id == 'ce2_table_multiplication_5' || lesson.id == 'ce2_table_multiplication_6' || lesson.id == 'ce2_table_multiplication_7' || lesson.id == 'ce2_table_multiplication_8' || lesson.id == 'ce2_table_multiplication_9' || lesson.id == 'ce2_table_multiplication_10' || lesson.id == 'ce2_figures_geometriques' || lesson.id == 'ce2_moitie_quart') ...[
                          const SizedBox(height: 14),
                          _lessonVisual(lesson),
                          const SizedBox(height: 14),
                        ],
                        const SizedBox(height: 10),
                        Text(lesson.explanation, style: TextStyle(fontSize: childMode ? 19 : 16, height: 1.5)),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(12)),
                          child: Text('Exemple : ' + lesson.example, style: TextStyle(fontSize: childMode ? 18 : 16, height: 1.4)),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () => _read(lesson.title + '. ' + lesson.explanation + '. Exemple. ' + lesson.example),
                            icon: Icon(_speaking ? Icons.stop_rounded : Icons.volume_up_rounded),
                            label: Text(_speaking ? 'Arrêter la lecture' : 'Écouter la leçon'),
                            style: FilledButton.styleFrom(minimumSize: Size.fromHeight(childMode ? 58 : 48), textStyle: TextStyle(fontSize: childMode ? 17 : 15, fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [Expanded(child: Text('Question ' + (questionIndex + 1).toString() + ' sur ' + lesson.questions.length.toString(), style: const TextStyle(fontWeight: FontWeight.w800))), Text(completedCount.toString() + '/' + lesson.questions.length.toString())]),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(value: completedCount / lesson.questions.length, minHeight: 8),
                        const SizedBox(height: 14),
                        Text(question.prompt, style: TextStyle(fontSize: childMode ? 21 : 18, fontWeight: FontWeight.w800, height: 1.35)),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => _read('Question. ' + question.prompt + '. ' + question.choices.asMap().entries.map((e) => 'Choix ' + (e.key + 1).toString() + '. ' + e.value).join('. ')),
                            icon: const Icon(Icons.volume_up_rounded),
                            label: const Text('Écouter la question'),
                            style: OutlinedButton.styleFrom(minimumSize: Size.fromHeight(childMode ? 52 : 44)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...List.generate(question.choices.length, (index) {
                          final isDone = _completed.contains(question.id);
                          return Card(
                            margin: const EdgeInsets.only(bottom: 7),
                            child: RadioListTile<int>(
                              value: index,
                              groupValue: _selected[question.id],
                              onChanged: isDone ? null : (value) => setState(() {
                                _selected[question.id] = value!;
                                _feedback = null;
                              }),
                              minVerticalPadding: childMode ? 15 : 8,
                              title: Text(question.choices[index], style: TextStyle(fontSize: childMode ? 20 : 16, fontWeight: childMode ? FontWeight.w600 : FontWeight.normal)),
                            ),
                          );
                        }),
                        if (_feedback != null) ...[
                          const SizedBox(height: 8),
                          Text(_feedback!, style: TextStyle(fontWeight: FontWeight.w700, color: _completed.contains(question.id) ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.error, height: 1.4)),
                        ],
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: _completed.contains(question.id)
                                ? () => setState(() {
                                    _feedback = null;
                                    if (questionIndex == lesson.questions.length - 1 && completedCount == lesson.questions.length) {
                                      _lessonIndex = (_lessonIndex + 1) % lessons.length;
                                    }
                                  })
                                : () => _check(question),
                            style: FilledButton.styleFrom(minimumSize: Size.fromHeight(childMode ? 58 : 48)),
                            child: Text(_completed.contains(question.id)
                                ? (questionIndex == lesson.questions.length - 1 && completedCount == lesson.questions.length ? 'Terminer cette leçon' : 'Question suivante')
                                : 'Vérifier ma réponse'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }


  Widget _lessonVisual(SupplementalLesson lesson) {
    final isLetters = lesson.id == 'cp1_voyelles' || lesson.id == 'cp1_syllabes';
    final isCounting = lesson.id == 'cp1_compter' || lesson.id == 'cp1_nombres_10' || lesson.id == 'cp1_nombres_20';
    final items = switch (lesson.id) {
      'cp1_voyelles' => const ['A', 'E', 'I', 'O', 'U'],
      'cp1_syllabes' => const ['MA', 'ME', 'MI', 'MO', 'MU', 'LA', 'LE', 'LI', 'LO', 'LU'],
      'cp1_mots_simples' => const ['MAMA', 'PAPA', 'AMI', 'MAMI'],
      'cp1_addition_images' => const ['🍎🍎', '+', '🍎', '=', '3'],
      'cp1_soustraction_images' => const ['🍌🍌🍌', '−', '🍌', '=', '2'],
      'cp1_compter' => const ['🍎', '🍌', '🍊', '🥭', '🍍'],
      'cp1_nombres_10' => const ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'],
      'cp1_nombres_20' => const ['11', '12', '13', '14', '15', '16', '17', '18', '19', '20'],
      'cp1_ordonner_nombres' => const ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'],
      'cp1_couleurs' => const ['🔴', '🟡', '🔵', '🟢'],
      'cp1_formes' => const ['⚪', '🟥', '🔺', '⭐'],
      'cp1_classe' => const ['📖', '📓', '✏️', '🧑‍🏫'],
      'cp1_hygiene' => const ['🧼', '💧', '🪥', '🦷'],
      'cp1_animaux' => const ['🐟', '🐕', '🐔', '🐐'],
      'cp1_corps' => const ['👀', '👂', '👃', '🦶'],
      'cp2_monnaie_fcfa' => const ['250 F', '+', '100 F', '=', '350 F', '500 F', '−', '350 F', '=', '150 F'],
      'ce1_achats_fcfa' => const ['300 F', '+', '150 F', '=', '450 F', '1 000 F', '−', '450 F', '=', '550 F'],
      'ce2_budget_fcfa' => const ['400 F', '+', '400 F', '+', '500 F', '=', '1 300 F', '1 500 F', '−', '1 300 F', '=', '200 F'],
      'ce2_mesures_longueurs' => const ['1 km', '=', '1 000 m', '2 m', '+', '50 cm', '=', '250 cm', '340 cm', '=', '3 m', '+', '40 cm'],
      'ce2_mesures_masses' => const ['1 kg', '=', '1 000 g', '2 kg', '=', '2 000 g', '1 500 g', '=', '1 kg', '+', '500 g'],
      'ce2_mesures_capacites' => const ['1 L', '=', '1 000 mL', '3 L', '=', '3 000 mL', '500 mL', '=', '0,5 L'],
      'ce2_mesures_duree' => const ['1 h', '=', '60 min', '2 h 30 min', '=', '150 min', '90 min', '=', '1 h', '+', '30 min'],
      'ce2_problemes_multiplication' => const ['3 paquets', '×', '4 cahiers', '=', '12 cahiers', '5 paniers', '×', '6 mangues', '=', '30 mangues'],
      'ce2_choisir_operation' => const ['Réunir', '+', 'Retirer', '−', 'Groupes égaux', '×', 'Partager', '÷'],
      'ce2_partage_division' => const ['12 crayons', '÷', '3 élèves', '=', '4 chacun', '15 mangues', '÷', '5 personnes', '=', '3 chacun'],
      'ce2_table_multiplication_2' => const ['2 × 1 = 2', '2 × 2 = 4', '2 × 3 = 6', '2 × 4 = 8', '2 × 5 = 10'],
      'ce2_table_multiplication_3' => const ['3 × 1 = 3', '3 × 2 = 6', '3 × 3 = 9', '3 × 4 = 12', '3 × 5 = 15'],
      'ce2_table_multiplication_4' => const ['4 × 1 = 4', '4 × 2 = 8', '4 × 3 = 12', '4 × 4 = 16', '4 × 5 = 20'],
      'ce2_table_multiplication_5' => const ['5 × 1 = 5', '5 × 2 = 10', '5 × 3 = 15', '5 × 4 = 20', '5 × 5 = 25'],
      'ce2_table_multiplication_6' => const ['6 × 1 = 6', '6 × 2 = 12', '6 × 3 = 18', '6 × 4 = 24', '6 × 5 = 30'],
      'ce2_table_multiplication_7' => const ['7 × 1 = 7', '7 × 2 = 14', '7 × 3 = 21', '7 × 4 = 28', '7 × 5 = 35'],
      'ce2_table_multiplication_8' => const ['8 × 1 = 8', '8 × 2 = 16', '8 × 3 = 24', '8 × 4 = 32', '8 × 5 = 40'],
      'ce2_table_multiplication_9' => const ['9 × 1 = 9', '9 × 2 = 18', '9 × 3 = 27', '9 × 4 = 36', '9 × 5 = 45'],
      'ce2_table_multiplication_10' => const ['10 × 1 = 10', '10 × 2 = 20', '10 × 3 = 30', '10 × 4 = 40', '10 × 5 = 50'],
      'ce2_figures_geometriques' => const ['△ Triangle : 3 côtés', '□ Carré : 4 côtés égaux', '▭ Rectangle : côtés opposés égaux', '○ Cercle : 0 sommet'],
      'ce2_moitie_quart' => const ['12 mangues ÷ 2 = 6', 'MOITIÉ : 2 parts égales', '12 mangues ÷ 4 = 3', 'QUART : 4 parts égales'],
      'ce2_nombres_jusqua_1000' => const ['347 = 300 + 40 + 7', '3 centaines', '4 dizaines', '7 unités', '506 = 500 + 6'],
      'ce2_comparer_nombres_1000' => const ['348 < 384', '906 > 690', '340 < 403 < 430', '725 = 725'],
      _ => const ['👀', '📚', '✏️'],
    };
    final heading = switch (lesson.id) {
      'cp1_voyelles' => 'REGARDE ET PRONONCE',
      'cp1_syllabes' => 'ASSEMBLE ET LIS LES SYLLABES',
      'cp1_mots_simples' => 'LIS LES MOTS EN ASSEMBLANT LES SYLLABES',
      'cp1_addition_images' => 'RÉUNIS ET COMPTE',
      'cp1_soustraction_images' => 'ENLÈVE ET COMPTE CE QUI RESTE',
      'cp1_compter' => 'COMPTE LES OBJETS',
      'cp1_nombres_10' => 'COMPTE JUSQU’À DIX',
      'cp1_nombres_20' => 'COMPTE DE ONZE À VINGT',
      'cp1_ordonner_nombres' => 'RANGE DU PLUS PETIT AU PLUS GRAND',
      'cp1_couleurs' => 'OBSERVE LES COULEURS',
      'cp1_formes' => 'OBSERVE LES FORMES',
      'cp1_classe' => 'LES OBJETS DE LA CLASSE',
      'cp1_hygiene' => 'LES GESTES POUR ÊTRE PROPRE',
      'cp1_animaux' => 'OBSERVE LES ANIMAUX',
      'cp1_corps' => 'MONTRE LES PARTIES DU CORPS',
      'cp2_monnaie_fcfa' => 'CALCULE AVEC LE FRANC CFA',
      'ce1_achats_fcfa' => 'PRÉPARE TON ACHAT ET TA MONNAIE',
      'ce2_budget_fcfa' => 'CALCULE TES DÉPENSES ET TON RESTE',
      'ce2_mesures_longueurs' => 'OBSERVE LES UNITÉS ET CONVERTIS',
      'ce2_mesures_masses' => 'OBSERVE LES MASSES ET CONVERTIS',
      'ce2_mesures_capacites' => 'OBSERVE LES CONTENANCES ET CONVERTIS',
      'ce2_mesures_duree' => 'LIS L’HEURE ET CALCULE LA DURÉE',
      'ce2_problemes_multiplication' => 'TROUVE LE TOTAL DES GROUPES',
      'ce2_choisir_operation' => 'OBSERVE LA SITUATION ET CHOISIS L’OPÉRATION',
      'ce2_partage_division' => 'PARTAGE EN PARTS ÉGALES',
      'ce2_table_multiplication_2' => 'COMPTE DE DEUX EN DEUX',
      'ce2_table_multiplication_3' => 'COMPTE DE TROIS EN TROIS',
      'ce2_table_multiplication_4' => 'COMPTE DE QUATRE EN QUATRE',
      'ce2_table_multiplication_5' => 'COMPTE DE CINQ EN CINQ',
      'ce2_table_multiplication_6' => 'COMPTE DE SIX EN SIX',
      'ce2_table_multiplication_7' => 'COMPTE DE SEPT EN SEPT',
      'ce2_table_multiplication_8' => 'COMPTE DE HUIT EN HUIT',
      'ce2_table_multiplication_9' => 'COMPTE DE NEUF EN NEUF',
      'ce2_table_multiplication_10' => 'COMPTE DE DIX EN DIX',
      'ce2_figures_geometriques' => 'OBSERVE LES FORMES ET COMPTE LES CÔTÉS',
      'ce2_moitie_quart' => 'PARTAGE EN PARTS ÉGALES',
      _ => 'REGARDE ET DÉCOUVRE',
    };
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            heading,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: items.map((item) => Container(
              constraints: const BoxConstraints(minWidth: 52, minHeight: 54),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                item,
                style: TextStyle(
                  fontSize: isLetters ? 27 : 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
            )).toList(),
          ),
          if (lesson.id == 'cp1_compter') ...[
            const SizedBox(height: 8),
            const Text('1   2   3   4   5', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          ],
        ],
      ),
    );
  }

  int _selectedQuestionIndex(SupplementalLesson lesson) {
    for (var i = 0; i < lesson.questions.length; i++) {
      if (!_completed.contains(lesson.questions[i].id)) return i;
    }
    return lesson.questions.length - 1;
  }
}
