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
                        if (level == SchoolLevel.cp1 || lesson.id == 'cp2_syllabes' || lesson.id == 'cp2_addition' || lesson.id == 'cp2_addition_dizaines' || lesson.id == 'cp2_soustraction' || lesson.id == 'cp2_addition_retenue_dizaines' || lesson.id == 'cp2_monnaie_fcfa' || lesson.id == 'ce1_achats_fcfa' || lesson.id == 'cm1_fraction_equivalentes' || lesson.id == 'cm1_perimetre_rectangle' || lesson.id == 'cm2_nombres_decimaux' || lesson.id == 'cm2_proportionnalite_tableau' || lesson.id == 'cm1_accord' || lesson.id == 'cm1_fractions' || lesson.id == 'cm2_aire' || lesson.id == 'ce1_multiplication_groupes' || lesson.id == 'ce1_problemes_addition' || lesson.id == 'ce1_multiplication_table_2' || lesson.id == 'ce1_phrase' || lesson.id == 'ce1_dizaines' || lesson.id == 'ce1_soustraction_emprunt' || lesson.id == 'ce1_mesurer_longueurs' || lesson.id == 'ce2_budget_fcfa' || lesson.id == 'ce2_mesures_longueurs' || lesson.id == 'ce2_mesures_masses' || lesson.id == 'ce2_mesures_capacites' || lesson.id == 'ce2_mesures_duree' || lesson.id == 'ce2_partage_division' || lesson.id == 'ce2_problemes_multiplication' || lesson.id == 'ce2_choisir_operation' || lesson.id == 'ce2_table_multiplication_2' || lesson.id == 'ce2_table_multiplication_3' || lesson.id == 'ce2_table_multiplication_4' || lesson.id == 'ce2_table_multiplication_5' || lesson.id == 'ce2_table_multiplication_6' || lesson.id == 'ce2_table_multiplication_7' || lesson.id == 'ce2_table_multiplication_8' || lesson.id == 'ce2_table_multiplication_9' || lesson.id == 'ce2_table_multiplication_10' || lesson.id == 'ce2_figures_geometriques' || lesson.id == 'ce2_moitie_quart' || lesson.id == 'ce2_division_exacte' || lesson.id == 'ce2_problemes_partage_fcfa' || lesson.id == 'ce2_problemes_deux_etapes' || lesson.id == 'ce2_problemes_multiplication_soustraction' || lesson.id == 'ce2_nombres_jusqua_1000' || lesson.id == 'ce2_comparer_nombres_1000' || lesson.id == 'ce2_addition_soustraction_1000' || lesson.id == 'ce2_multiplication_posee' || lesson.id == 'sixieme_fractions' || lesson.id == 'sixieme_operations_decimales' || lesson.id == 'sixieme_etats_matiere' || lesson.id == 'cinquieme_fractions_addition' || lesson.id == 'cinquieme_proportionnalite_tableau' || lesson.id == 'cinquieme_respiration' || lesson.id == 'quatrieme_equation' || lesson.id == 'quatrieme_thales' || lesson.id == 'quatrieme_vitesse_moyenne' || lesson.id == 'troisieme_pythagore' || lesson.id == 'troisieme_loi_ohm' || lesson.id == 'seconde_fonction' || lesson.id == 'seconde_systeme_equations' || lesson.id == 'seconde_pourcentage_evolution' || lesson.id == 'premiere_derivation' || lesson.id == 'premiere_suite_arithmetique' || lesson.id == 'terminale_probabilite_conditionnelle' || lesson.id == 'terminale_limite_simple' || lesson.id == 'troisieme_argument' || lesson.id == 'troisieme_gene_expression' || lesson.id == 'seconde_resume' || lesson.id == 'seconde_equation_lineaire' || lesson.id == 'premiere_trinome_signe' || lesson.id == 'terminale_derivation' || lesson.id == 'quatrieme_cod' || lesson.id == 'troisieme_equation_second_degre' || lesson.id == 'premiere_method' || lesson.id == 'terminale_bac' || lesson.id == 'ce2_division_partage' || lesson.id == 'ce2_multiplication' || lesson.id == 'cm2_temps' || lesson.id == 'sixieme_nature' || lesson.id == 'cinquieme_present' || lesson.id == 'cinquieme_proportion' || lesson.id == 'quatrieme_circuit_electrique' || lesson.id == 'cm2_aire_triangle' || lesson.id == 'cm2_volume_pave' || lesson.id == 'cm2_fraction_nombre_decimal' || lesson.id == 'cp2_lire_phrases' || lesson.id == 'ce1_comprendre_texte' || lesson.id == 'ce2_phrase_types' || lesson.id == 'ce2_verbe' || lesson.id == 'ce2_sujet_verbe' || lesson.id == 'cm1_cycle_eau' || lesson.id == 'cm2_conjugaison_futur') ...[
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
      'cp1_formes' => const ['⚪', '🟥', '🔺'],
      'cp1_classe' => const ['📖', '📓', '✏️', '🧑‍🏫'],
      'cp1_hygiene' => const ['🧼', '💧', '🪥', '🦷'],
      'cp1_animaux' => const ['🐟', '🐕', '🐔', '🐐'],
      'cp1_corps' => const ['👀', '👂', '👃', '🦶'],
      'cp2_lire_phrases' => const ['Komi arrose le jardin.', 'Qui arrose ? Komi.', 'Que fait Komi ? Il arrose.'],
      'cp2_syllabes' => const ['M + A = MA', 'M + I = MI', 'M + O = MO', 'L + A = LA'],
      'cp2_addition' => const ['4 + 3 = 7', '5 + 3 = 8', '3 + 2 = 5'],
      'cp2_addition_dizaines' => const ['23 + 14', '3 + 4 = 7 unités', '20 + 10 = 30', 'Résultat : 37'],
      'cp2_soustraction' => const ['35 − 12', '5 − 2 = 3 unités', '30 − 10 = 20', 'Résultat : 23'],
      'cp2_addition_retenue_dizaines' => const ['27 + 15', '7 + 5 = 12', 'Écrire 2, retenir 1 dizaine', '2 + 1 + 1 = 4 dizaines', 'Résultat : 42'],
      'cp2_monnaie_fcfa' => const ['250 F', '+', '100 F', '=', '350 F', '500 F', '−', '350 F', '=', '150 F'],
      'ce1_comprendre_texte' => const ['Qui ? Afi et son père', 'Quand ? Samedi matin', 'Où ? Au marché', 'Que font-ils ? Ils achètent du maïs et des tomates'],
      'ce1_multiplication_groupes' => const ['3 groupes', '2 mangues par groupe', '2 + 2 + 2 = 6', '3 × 2 = 6 mangues'],
      'ce1_problemes_addition' => const ['12 billes', '+', '5 billes reçues', '=', '17 billes'],
      'ce1_multiplication_table_2' => const ['2 × 1 = 2', '2 × 2 = 4', '2 × 3 = 6', '2 × 4 = 8', '2 × 5 = 10'],
      'ce1_phrase' => const ['MAJUSCULE', 'Le chat dort', 'POINT FINAL (.)'],
      'ce1_dizaines' => const ['24 = 20 + 4', '2 dizaines = 20', '4 unités = 4', '52 = 5 dizaines + 2 unités'],
      'ce1_soustraction_emprunt' => const ['  5 2', '− 2 8', 'Échanger 1 dizaine : 12 unités', '12 − 8 = 4', '4 − 2 = 2', 'Résultat : 24'],
      'ce1_mesurer_longueurs' => const ['1 m = 100 cm', '1 m 25 cm', '100 cm + 25 cm', '= 125 cm'],
      'cm1_cycle_eau' => const ['Soleil : chauffe l’eau', 'ÉVAPORATION ↑', 'CONDENSATION : formation des nuages', 'PRÉCIPITATIONS ↓', 'Ruissellement / infiltration → rivières et océans'],
      'cm1_fraction_equivalentes' => const ['1/2', '=', '2/4', '=', '3/6', 'Même quantité : une moitié'],
      'cm1_perimetre_rectangle' => const ['Longueur : 6 cm', 'Largeur : 3 cm', 'P = 6 + 3 + 6 + 3', 'P = 18 cm'],
      'cm2_conjugaison_futur' => const ['INFINITIF : chanter', 'JE : chanter + ai = chanterai', 'TU : chanteras • IL : chantera', 'NOUS : chanterons • VOUS : chanterez', 'ILS : chanteront'],
      'cm2_temps' => const ['PASSÉ : hier, j’ai lu', 'PRÉSENT : aujourd’hui, je lis', 'FUTUR : demain, je lirai'],
      'cm2_nombres_decimaux' => const ['3,4 = 3,40', '3,45 > 3,40', 'Comparer les dixièmes', 'puis les centièmes'],
      'cm2_proportionnalite_tableau' => const ['Cahiers : 1 | 2 | 4', 'Prix : 250 F | 500 F | 1 000 F', 'Coefficient : × 250'],
      'cm1_accord' => const ['Un enfant joue.', 'Des enfants jouent.', 'Sujet singulier → joue', 'Sujet pluriel → jouent'],
      'cm1_fractions' => const ['1/2 : une part sur 2', '1/3 : une part sur 3', '1/4 : une part sur 4', 'Dénominateur = parts égales'],
      'cm2_aire_triangle' => const ['Base : 8 cm', 'Hauteur perpendiculaire : 5 cm', 'Aire = base × hauteur ÷ 2', 'Aire = 8 × 5 ÷ 2 = 20 cm²'],
      'cm2_volume_pave' => const ['Longueur : 5 cm', 'Largeur : 3 cm', 'Hauteur : 2 cm', 'V = 5 × 3 × 2 = 30 cm³'],
      'cm2_fraction_nombre_decimal' => const ['35/100', '=', '0,35', '35 centièmes = 0,35'],
      'cm2_aire' => const ['Longueur : 5 cm', 'Largeur : 3 cm', 'Aire = 5 × 3', 'Aire = 15 cm²'],
      'ce1_achats_fcfa' => const ['300 F', '+', '150 F', '=', '450 F', '1 000 F', '−', '450 F', '=', '550 F'],
      'ce2_budget_fcfa' => const ['400 F', '+', '400 F', '+', '500 F', '=', '1 300 F', '1 500 F', '−', '1 300 F', '=', '200 F'],
      'ce2_mesures_longueurs' => const ['1 km', '=', '1 000 m', '2 m', '+', '50 cm', '=', '250 cm', '340 cm', '=', '3 m', '+', '40 cm'],
      'ce2_mesures_masses' => const ['1 kg', '=', '1 000 g', '2 kg', '=', '2 000 g', '1 500 g', '=', '1 kg', '+', '500 g'],
      'ce2_mesures_capacites' => const ['1 L', '=', '1 000 mL', '3 L', '=', '3 000 mL', '500 mL', '=', '0,5 L'],
      'ce2_mesures_duree' => const ['1 h', '=', '60 min', '2 h 30 min', '=', '150 min', '90 min', '=', '1 h', '+', '30 min'],
      'ce2_phrase_types' => const ['Déclarative : Le soleil brille.', 'Interrogative : Où vas-tu ?', 'Impérative : Ferme la porte.'],
      'ce2_verbe' => const ['Les élèves chantent.', 'Qui fait l’action ? Les élèves.', 'Action : chantent (verbe)'],
      'ce2_sujet_verbe' => const ['LES ÉLÈVES', '↓ qui est-ce qui chante ?', 'CHANTENT', 'Sujet : les élèves • Verbe : chantent'],
      'ce2_multiplication' => const ['4 groupes de 3', '3 + 3 + 3 + 3 = 12', '4 × 3 = 12'],
      'ce2_division_partage' => const ['12 oranges', '÷ 3 enfants', '= 4 oranges chacun', '4 + 4 + 4 = 12 : vérification'],
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
      'ce2_addition_soustraction_1000' => const ['235 + 142 = 377', '326 + 158 = 484', '568 − 243 = 325', '700 − 265 = 435'],
      'ce2_multiplication_posee' => const ['124 × 3', '4 × 3 = 12 : écrire 2, retenir 1', '2 × 3 + 1 = 7', '1 × 3 = 3', 'Résultat : 372'],
      'sixieme_nature' => const ['une grande maison', 'Déterminant : une', 'Adjectif : grande', 'Nom : maison'],
      'sixieme_fractions' => const ['Même dénominateur : 5', '1/5 < 3/5 < 4/5', '2/7 + 3/7 = 5/7', 'On garde le dénominateur'],
      'sixieme_operations_decimales' => const ['  12,50', '+  3,25', '= 15,75', '  8,40', '− 2,15', '= 6,25', 'Aligner les virgules'],
      'sixieme_etats_matiere' => const ['SOLIDE : glace', 'forme propre', 'LIQUIDE : eau', 'forme du récipient', 'GAZ : vapeur d’eau', 'occupe l’espace'],
      'cinquieme_present' => const ['JE : je finis', 'TU : tu finis', 'IL / ELLE : il finit', 'NOUS : nous finissons', 'VOUS : vous finissez', 'ILS / ELLES : ils finissent'],
      'cinquieme_proportion' => const ['1 cahier = 200 F', '3 cahiers = 3 × 200 F', '3 cahiers = 600 F', 'Même coefficient : × 3'],
      'cinquieme_fractions_addition' => const ['2/7 + 3/7', '= (2 + 3)/7', '= 5/7', 'Même dénominateur : on le conserve'],
      'cinquieme_proportionnalite_tableau' => const ['Cahiers : 1 | 3 | 5', 'Prix : 200 F | 600 F | 1 000 F', 'Prix unitaire : 200 F'],
      'cinquieme_respiration' => const ['AIR / EAU', 'Dioxygène (O₂)', 'ÊTRE VIVANT', 'Respiration', 'Rejet : dioxyde de carbone (CO₂)', 'Poisson : branchies • humain : poumons'],
      'quatrieme_cod' => const ['Phrase : Afi lit un livre.', 'Verbe : lit', 'Question : Afi lit quoi ?', 'COD : un livre (sans préposition)'],
      'quatrieme_circuit_electrique' => const ['BOUCLE FERMÉE', 'Pile → fils → lampe → fils → pile', 'Interrupteur fermé : lampe allumée', 'Circuit ouvert : lampe éteinte'],
      'quatrieme_equation' => const ['x + 5 = 12', 'x + 5 − 5 = 12 − 5', 'x = 7', 'Même opération des deux côtés'],
      'quatrieme_thales' => const ['A', 'M —— N', 'B ————— C', '(MN) ∥ (BC)', 'AM/AB = AN/AC = MN/BC'],
      'quatrieme_vitesse_moyenne' => const ['Distance : 120 km', 'Durée : 2 h', 'v = d ÷ t', 'v = 120 ÷ 2', 'v = 60 km/h'],
      'troisieme_equation_second_degre' => const ['(x − 3)(x + 2) = 0', 'Produit nul : x − 3 = 0 OU x + 2 = 0', 'x = 3 OU x = −2', 'Solutions : {−2 ; 3}'],
      'troisieme_pythagore' => const ['Triangle rectangle', 'Côtés : 3 et 4', 'Hypoténuse : c', '3² + 4² = c²', '9 + 16 = 25', 'c = 5'],
      'troisieme_loi_ohm' => const ['U = R × I', 'R = 4 Ω', 'I = 2 A', 'U = 4 × 2', 'U = 8 V'],
      'seconde_fonction' => const ['f(x) = 2x + 3', 'x = 4', 'f(4) = 2 × 4 + 3', 'f(4) = 11'],
      'seconde_systeme_equations' => const ['x + y = 10', 'x − y = 2', '2x = 12 → x = 6', '6 + y = 10 → y = 4', 'Solution : (6 ; 4)'],
      'seconde_pourcentage_evolution' => const ['Prix initial : 8 000 F', 'Hausse : 10 %', 'Coefficient : 1,10', '8 000 × 1,10', 'Prix final : 8 800 F'],
      'premiere_method' => const ['1. Analyser la consigne', '2. Formuler l’idée directrice', '3. Développer les arguments', '4. Donner un exemple précis', '5. Conclure en répondant au sujet'],
      'premiere_derivation' => const ['f(x) = x²', 'f’(x) = 2x', 'f’(3) = 2 × 3', 'f’(3) = 6'],
      'premiere_suite_arithmetique' => const ['4 → 7 → 10 → 13', '+3    +3    +3', 'Raison : r = 3'],
      'terminale_bac' => const ['Lire toutes les consignes', 'Répartir le temps entre les questions', 'Commencer par les questions accessibles', 'Garder du temps pour relire'],
      'terminale_probabilite_conditionnelle' => const ['P(A ∩ B) = 0,12', 'P(B) = 0,30', 'P(A | B) = P(A ∩ B) / P(B)', '= 0,12 / 0,30', '= 0,4'],
      'terminale_limite_simple' => const ['f(x) = 3x + 2', 'x → +∞', '3x devient très grand', 'lim (3x + 2) = +∞'],
      'troisieme_argument' => const ['IDÉE', '↓', 'RAISON', '↓', 'EXEMPLE', '↓', 'CONCLUSION'],
      'troisieme_gene_expression' => const ['CELLULE', '↓', 'NOYAU', '↓', 'CHROMOSOMES', '↓', 'ADN', '↓', 'GÈNE = portion d’ADN'],
      'seconde_resume' => const ['Lire le texte', '↓', 'Repérer les idées essentielles', '↓', 'Reformuler brièvement', '↓', 'Respecter l’ordre', 'Sans opinion personnelle'],
      'seconde_equation_lineaire' => const ['3x + 5 = 17', '3x = 17 − 5', '3x = 12', 'x = 12 ÷ 3', 'x = 4'],
      'premiere_trinome_signe' => const ['Produit : (x − 2)(x + 1)', 'Racines : −1 et 2', 'x < −1 : +', '−1 < x < 2 : −', 'x > 2 : +', 'Aux racines : 0'],
      'terminale_derivation' => const ['f’(x) > 0', 'sur un intervalle', '↓', 'f est croissante', 'f’(x) < 0', '↓', 'f est décroissante'],
      'ce2_division_exacte' => const ['24 objets', '÷ 3 élèves', '= 8 chacun', 'Vérification : 8 × 3 = 24'],
      'ce2_problemes_partage_fcfa' => const ['600 F', '÷ 3 enfants', '= 200 F chacun', '200 F × 3 = 600 F'],
      'ce2_problemes_deux_etapes' => const ['125 + 48 = 173', '173 − 37', '= 136 mangues', 'Deux opérations'],
      'ce2_problemes_multiplication_soustraction' => const ['5 × 12 = 60', '60 − 18', '= 42 cahiers', 'Multiplie puis enlève'],
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
      'cp2_lire_phrases' => 'LIS LA PHRASE ET RETROUVE LES INFORMATIONS',
      'cp2_syllabes' => 'ASSEMBLE LES LETTRES POUR LIRE',
      'cp2_addition' => 'RÉUNIS LES QUANTITÉS',
      'cp2_addition_dizaines' => 'ALIGNE DIZAINES ET UNITÉS',
      'cp2_soustraction' => 'SOUSTRAIS LES UNITÉS ET LES DIZAINES',
      'cp2_addition_retenue_dizaines' => 'CALCULE ET REPORTE LA RETENUE',
      'cp2_monnaie_fcfa' => 'CALCULE AVEC LE FRANC CFA',
      'ce1_comprendre_texte' => 'RETROUVE LES INFORMATIONS EXPLICITES DU TEXTE',
      'ce1_multiplication_groupes' => 'REPRÉSENTE DES GROUPES ÉGAUX',
      'ce1_problemes_addition' => 'RÉUNIS LES QUANTITÉS DU PROBLÈME',
      'ce1_multiplication_table_2' => 'CONSTRUIS LA TABLE DE DEUX',
      'ce1_phrase' => 'REPÈRE LE DÉBUT ET LA FIN DE LA PHRASE',
      'ce1_dizaines' => 'DÉCOMPOSE EN DIZAINES ET UNITÉS',
      'ce1_soustraction_emprunt' => 'ÉCHANGE UNE DIZAINE CONTRE 10 UNITÉS',
      'ce1_mesurer_longueurs' => 'MESURE ET CONVERTIS LES LONGUEURS',
      'cm1_cycle_eau' => 'OBSERVE LES ÉTAPES DU CYCLE DE L’EAU',
      'cm1_fraction_equivalentes' => 'COMPARE DES FRACTIONS ÉQUIVALENTES',
      'cm1_perimetre_rectangle' => 'CALCULE LE CONTOUR DU RECTANGLE',
      'cm2_conjugaison_futur' => 'CONJUGUE UN VERBE DU PREMIER GROUPE AU FUTUR',
      'cm2_temps' => 'DISTINGUE LE PASSÉ, LE PRÉSENT ET LE FUTUR',
      'cm2_nombres_decimaux' => 'COMPARE LES DÉCIMAUX RANG PAR RANG',
      'cm2_proportionnalite_tableau' => 'COMPLÈTE LE TABLEAU DE PROPORTIONNALITÉ',
      'cm1_accord' => 'ACCORDE LE VERBE AVEC SON SUJET',
      'cm1_fractions' => 'OBSERVE LES PARTS ÉGALES',
      'cm2_aire_triangle' => 'CALCULE LA MOITIÉ DU PRODUIT BASE × HAUTEUR',
      'cm2_volume_pave' => 'CALCULE LE VOLUME LONGUEUR × LARGEUR × HAUTEUR',
      'cm2_fraction_nombre_decimal' => 'ÉCRIS UNE FRACTION DÉCIMALE EN NOMBRE DÉCIMAL',
      'cm2_aire' => 'CALCULE LA SURFACE DU RECTANGLE',
      'ce1_achats_fcfa' => 'PRÉPARE TON ACHAT ET TA MONNAIE',
      'ce2_budget_fcfa' => 'CALCULE TES DÉPENSES ET TON RESTE',
      'ce2_mesures_longueurs' => 'OBSERVE LES UNITÉS ET CONVERTIS',
      'ce2_mesures_masses' => 'OBSERVE LES MASSES ET CONVERTIS',
      'ce2_mesures_capacites' => 'OBSERVE LES CONTENANCES ET CONVERTIS',
      'ce2_mesures_duree' => 'LIS L’HEURE ET CALCULE LA DURÉE',
      'ce2_phrase_types' => 'RECONNAIS LES TYPES DE PHRASES',
      'ce2_verbe' => 'REPÈRE LE VERBE DANS LA PHRASE',
      'ce2_sujet_verbe' => 'IDENTIFIE LE SUJET ET LE VERBE',
      'ce2_multiplication' => 'COMPRENDS LA MULTIPLICATION COMME GROUPES ÉGAUX',
      'ce2_division_partage' => 'PARTAGE UNE QUANTITÉ EN PARTS ÉGALES',
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
      'ce2_division_exacte' => 'PARTAGE ET VÉRIFIE AVEC LA MULTIPLICATION',
      'ce2_problemes_partage_fcfa' => 'PARTAGE LA MONNAIE EN PARTS ÉGALES',
      'ce2_problemes_deux_etapes' => 'RÉSOUS LE PROBLÈME EN DEUX OPÉRATIONS',
      'ce2_problemes_multiplication_soustraction' => 'CALCULE LE TOTAL PUIS CE QUI RESTE',
      'ce2_multiplication_posee' => 'MULTIPLIE ET EFFECTUE LES RETENUES',
      'sixieme_nature' => 'REPÈRE LE NOM ET L’ADJECTIF DANS UN GROUPE NOMINAL',
      'sixieme_fractions' => 'COMPARE ET ADDITIONNE DES FRACTIONS DE MÊME DÉNOMINATEUR',
      'sixieme_operations_decimales' => 'ALIGNE LES VIRGULES POUR CALCULER',
      'sixieme_etats_matiere' => 'RECONNAIS LES TROIS ÉTATS DE LA MATIÈRE',
      'cinquieme_present' => 'OBSERVE LES TERMINAISONS AU PRÉSENT',
      'cinquieme_proportion' => 'CALCULE LE PRIX DE PLUSIEURS CAHIERS',
      'cinquieme_fractions_addition' => 'ADDITIONNE LES NUMÉRATEURS ET GARDE LE DÉNOMINATEUR',
      'cinquieme_proportionnalite_tableau' => 'LIS LE TABLEAU DE PROPORTIONNALITÉ',
      'cinquieme_respiration' => 'ÉCHANGES GAZEUX LORS DE LA RESPIRATION',
      'quatrieme_circuit_electrique' => 'REPÈRE LA BOUCLE FERMÉE D’UN CIRCUIT SIMPLE',
      'quatrieme_cod' => 'IDENTIFIE LE COD EN POSANT LA QUESTION QUI ? OU QUOI ?',
      'quatrieme_equation' => 'ISOLE L’INCONNUE EN GARDANT L’ÉGALITÉ',
      'quatrieme_thales' => 'REPÈRE LE PARALLÉLISME ET LES RAPPORTS',
      'quatrieme_vitesse_moyenne' => 'CALCULE LA DISTANCE DIVISÉE PAR LA DURÉE',
      'troisieme_equation_second_degre' => 'APPLIQUE LA RÈGLE DU PRODUIT NUL',
      'troisieme_pythagore' => 'CALCULE LA LONGUEUR DE L’HYPOTÉNUSE',
      'troisieme_loi_ohm' => 'APPLIQUE LA LOI D’OHM',
      'seconde_fonction' => 'CALCULE L’IMAGE D’UN NOMBRE',
      'seconde_systeme_equations' => 'RÉSOUS LES DEUX ÉQUATIONS ENSEMBLE',
      'seconde_pourcentage_evolution' => 'APPLIQUE LE COEFFICIENT MULTIPLICATEUR',
      'premiere_method' => 'ORGANISE UNE RÉPONSE ARGUMENTÉE',
      'premiere_derivation' => 'CALCULE LA DÉRIVÉE ET SA VALEUR',
      'premiere_suite_arithmetique' => 'IDENTIFIE LA RAISON DE LA SUITE',
      'terminale_bac' => 'PLANIFIE TON ÉPREUVE ET RELIS TA COPIE',
      'terminale_probabilite_conditionnelle' => 'CALCULE LA PROBABILITÉ CONDITIONNELLE',
      'terminale_limite_simple' => 'OBSERVE LA LIMITE QUAND X TEND VERS +∞',
      'troisieme_argument' => 'ORGANISE UN PARAGRAPHE ARGUMENTÉ',
      'troisieme_gene_expression' => 'DU NOYAU À L’ADN ET AUX GÈNES',
      'seconde_resume' => 'CONSTRUIS UN RÉSUMÉ CLAIR ET FIDÈLE',
      'seconde_equation_lineaire' => 'ISOLE X DANS UNE ÉQUATION',
      'premiere_trinome_signe' => 'LIS LE SIGNE DU PRODUIT SELON X',
      'terminale_derivation' => 'UTILISE LE SIGNE DE LA DÉRIVÉE POUR LES VARIATIONS',
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
