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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _subjectFilter;
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

  Future<void> _read(String text, {String language = 'fr-FR'}) async {
    if (_speaking) {
      await _tts.stop();
      if (mounted) setState(() => _speaking = false);
      return;
    }
    try {
      final level = ref.read(schoolLevelProvider);
      await _tts.stop();
      await _tts.setLanguage(language);
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

  String _speechLanguageFor(String title) {
    final normalized = title.toLowerCase();
    return normalized.contains('anglais') || normalized.contains('english')
        ? 'en-US'
        : 'fr-FR';
  }

  Future<void> _check(SupplementalQuestion question, String lessonId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final answer = _selected[question.id];
    if (answer == null || _completed.contains(question.id)) return;
    if (answer != question.correctIndex) {
      try {
        await ProgressService.recordWrongAnswer(question.id, skillId: 'bonus_$lessonId');
        await ProgressService.recordAttempt(
          exerciseId: question.id,
          lessonId: lessonId,
          isCorrect: false,
        );
      } catch (_) {
        // La correction immédiate reste disponible même si l'historique local échoue.
      }
      if (!mounted || FirebaseAuth.instance.currentUser?.uid != uid) return;
      setState(() => _feedback = 'Essaie encore. Cette question est ajoutée à tes révisions. Écoute la question ou relis la leçon.');
      return;
    }
    try {
      await ProgressService.recordAnswer(exerciseId: question.id, isCorrect: true);
      await ProgressService.recordAttempt(
        exerciseId: question.id,
        lessonId: lessonId,
        isCorrect: true,
      );
      if (!mounted || FirebaseAuth.instance.currentUser?.uid != uid) return;
      setState(() {
        _completed.add(question.id);
        _feedback = 'Bravo ! Bonne réponse. ' + question.explanation;
      });
    } catch (_) {
      if (mounted && FirebaseAuth.instance.currentUser?.uid == uid) setState(() => _feedback = 'Bonne réponse, mais elle n’a pas été enregistrée. Vérifie ta connexion puis appuie de nouveau sur « Vérifier ma réponse ».');
    }
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    _searchController.dispose();
    unawaited(_tts.stop());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final level = ref.watch(schoolLevelProvider);
    final childMode = level.index <= SchoolLevel.cm2.index;
    final allLevelLessons = supplementalLessons.where((item) => item.level == level).toList();
    final subjects = allLevelLessons.map((item) => item.subject).toSet().toList()..sort();
    final query = _searchQuery.trim().toLowerCase();
    final lessons = allLevelLessons.where((item) {
      final matchesSubject = _subjectFilter == null || item.subject == _subjectFilter;
      final matchesSearch = query.isEmpty ||
          item.title.toLowerCase().contains(query) ||
          item.subject.toLowerCase().contains(query) ||
          item.explanation.toLowerCase().contains(query);
      return matchesSubject && matchesSearch;
    }).toList();
    if (allLevelLessons.isEmpty) {
      return Scaffold(appBar: AppBar(title: const Text('Cours bonus')), body: const Center(child: Text('De nouvelles activités seront ajoutées pour cette classe.')));
    }
    if (lessons.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Cours bonus • ${level.label}')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search_off_rounded, size: 48),
              const SizedBox(height: 12),
              const Text('Aucune leçon ne correspond à cette recherche.', textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () => setState(() {
                  _searchQuery = '';
                  _searchController.clear();
                  _subjectFilter = null;
                  _lessonIndex = 0;
                  _feedback = null;
                }),
                icon: const Icon(Icons.clear_all_rounded),
                label: const Text('Effacer les filtres'),
              ),
            ],
          ),
        ),
      );
    }
    if (_lessonIndex >= lessons.length) _lessonIndex = 0;
    final allQuestionCount = allLevelLessons.fold<int>(0, (sum, item) => sum + item.questions.length);
    final allCompletedCount = allLevelLessons
        .expand((item) => item.questions)
        .where((question) => _completed.contains(question.id))
        .length;
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
                TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() {
                    _searchQuery = value;
                    _lessonIndex = 0;
                    _feedback = null;
                  }),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    labelText: 'Rechercher un cours ou une notion',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchQuery.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Effacer la recherche',
                            onPressed: () => setState(() {
                              _searchQuery = '';
                              _searchController.clear();
                              _lessonIndex = 0;
                              _feedback = null;
                            }),
                            icon: const Icon(Icons.close_rounded),
                          ),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _subjectFilter ?? '__all__',
                  decoration: const InputDecoration(
                    labelText: 'Filtrer par matière',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem<String>(value: '__all__', child: Text('Toutes les matières')),
                    ...subjects.map((subject) => DropdownMenuItem<String>(
                      value: subject,
                      child: Text(subject),
                    )),
                  ],
                  onChanged: (value) => setState(() {
                    _subjectFilter = value == '__all__' ? null : value;
                    _lessonIndex = 0;
                    _feedback = null;
                  }),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Progression des cours bonus : $allCompletedCount / $allQuestionCount questions',
                            style: const TextStyle(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: allQuestionCount == 0 ? 0 : allCompletedCount / allQuestionCount,
                          minHeight: 8,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text('Choisis une leçon (${lessons.length}/${allLevelLessons.length})', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                ...lessons.asMap().entries.map((entry) {
                  final selected = entry.key == _lessonIndex;
                  final subjectIcon = switch (entry.value.subject) {
                    'Mathématiques' => Icons.calculate_rounded,
                    'Français' => Icons.text_fields_rounded,
                    'Physique-Chimie' => Icons.science_rounded,
                    'SVT' => Icons.eco_rounded,
                    'Anglais' => Icons.language_rounded,
                    'Philosophie' => Icons.psychology_rounded,
                    'Sciences' => Icons.lightbulb_rounded,
                    _ => Icons.menu_book_rounded,
                  };
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      minVerticalPadding: childMode ? 14 : 8,
                      leading: CircleAvatar(radius: childMode ? 25 : 20, child: Icon(subjectIcon)),
                      title: Text(entry.value.title, style: TextStyle(fontSize: childMode ? 18 : 16, fontWeight: FontWeight.w800)),
                      subtitle: Text('${entry.value.subject} • ${entry.value.questions.where((question) => _completed.contains(question.id)).length}/${entry.value.questions.length} exercices'),
                      trailing: selected
                          ? const Icon(Icons.radio_button_checked_rounded)
                          : entry.value.questions.every((question) => _completed.contains(question.id))
                              ? const Icon(Icons.task_alt_rounded)
                              : const Icon(Icons.arrow_forward_ios_rounded, size: 16),
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
                        if (_hasVisualForLesson(lesson)) ...[
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
                            onPressed: () => _read(lesson.title + '. ' + lesson.explanation + '. Exemple. ' + lesson.example, language: _speechLanguageFor(lesson.title)),
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
                            onPressed: () => _read('Question. ' + question.prompt + '. ' + question.choices.asMap().entries.map((e) => 'Choix ' + (e.key + 1).toString() + '. ' + e.value).join('. '), language: _speechLanguageFor(lesson.title)),
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
                                : () => _check(question, lesson.id),
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


  bool _hasVisualForLesson(SupplementalLesson lesson) {
    const visualLessonIds = <String>{
      'cp2_syllabes',
      'cp2_addition',
      'cp2_addition_dizaines',
      'cp2_soustraction',
      'cp2_addition_retenue_dizaines',
      'cp2_monnaie_fcfa',
      'ce1_achats_fcfa',
      'cm1_fraction_equivalentes',
      'cm1_perimetre_rectangle',
      'cm2_nombres_decimaux',
      'cm2_proportionnalite_tableau',
      'cm1_accord',
      'cm1_fractions',
      'cm2_aire',
      'ce1_multiplication_groupes',
      'ce1_problemes_addition',
      'ce1_multiplication_table_2',
      'ce1_phrase',
      'ce1_dizaines',
      'ce1_soustraction_emprunt',
      'ce1_mesurer_longueurs',
      'ce2_budget_fcfa',
      'ce2_mesures_longueurs',
      'ce2_mesures_masses',
      'ce2_mesures_capacites',
      'ce2_mesures_duree',
      'ce2_partage_division',
      'ce2_problemes_multiplication',
      'ce2_choisir_operation',
      'ce2_table_multiplication_2',
      'ce2_table_multiplication_3',
      'ce2_table_multiplication_4',
      'ce2_table_multiplication_5',
      'ce2_table_multiplication_6',
      'ce2_table_multiplication_7',
      'ce2_table_multiplication_8',
      'ce2_table_multiplication_9',
      'ce2_table_multiplication_10',
      'ce2_figures_geometriques',
      'ce2_moitie_quart',
      'ce2_division_exacte',
      'ce2_problemes_partage_fcfa',
      'ce2_problemes_deux_etapes',
      'ce2_problemes_multiplication_soustraction',
      'ce2_nombres_jusqua_1000',
      'ce2_comparer_nombres_1000',
      'ce2_addition_soustraction_1000',
      'ce2_multiplication_posee',
      'sixieme_fractions',
      'sixieme_operations_decimales',
      'sixieme_etats_matiere',
      'cinquieme_fractions_addition',
      'cinquieme_proportionnalite_tableau',
      'cinquieme_respiration',
      'quatrieme_equation',
      'quatrieme_thales',
      'quatrieme_vitesse_moyenne',
      'troisieme_pythagore',
      'troisieme_loi_ohm',
      'seconde_fonction',
      'seconde_systeme_equations',
      'seconde_pourcentage_evolution',
      'premiere_derivation',
      'premiere_suite_arithmetique',
      'terminale_probabilite_conditionnelle',
      'terminale_limite_simple',
      'troisieme_argument',
      'troisieme_gene_expression',
      'seconde_resume',
      'seconde_equation_lineaire',
      'premiere_trinome_signe',
      'terminale_derivation',
      'quatrieme_cod',
      'troisieme_equation_second_degre',
      'premiere_method',
      'terminale_bac',
      'ce2_division_partage',
      'ce2_multiplication',
      'cm2_temps',
      'sixieme_nature',
      'cinquieme_present',
      'cinquieme_proportion',
      'quatrieme_circuit_electrique',
      'cm2_aire_triangle',
      'cm2_volume_pave',
      'cm2_fraction_nombre_decimal',
      'cp2_lire_phrases',
      'ce1_comprendre_texte',
      'ce2_phrase_types',
      'ce2_verbe',
      'ce2_sujet_verbe',
      'cm1_cycle_eau',
      'cm2_conjugaison_futur',
      'ce2_animaux_regimes_alimentaires',
      'ce2_multiplication_dizaines',
      'cm1_adjectif_qualificatif',
      'cm1_multiples_diviseurs',
      'cm1_mesure_masse',
      'cm2_aire_parallelogramme',
      'cm2_electricite_circuit',
      'sixieme_accord_determinant_nom',
      'sixieme_fraction_unite',
      'cinquieme_energie_renouvelable',
      'cinquieme_adverbe',
      'quatrieme_puissance_dix',
      'quatrieme_reproduction_plantes',
      'troisieme_statistiques_etendue',
      'troisieme_energie_electrique',
      'seconde_vecteurs_coordonnees',
      'seconde_chaines_alimentaires',
      'seconde_anglais_present_simple',
      'premiere_derivation_produit',
      'premiere_suite_geometrique',
      'premiere_probabilite_independante',
      'premiere_lecture_graphique_derivative',
      'terminale_integrale_primitive',
      'terminale_loi_binomiale',
      'terminale_complexes_module',
      'terminale_philosophie_argumentation',
      'cp1_sons_m_et_n',
      'cp2_lire_heure_pleine',
      'ce1_monnaie_fcfa',
      'ce2_multiplication_par_10',
      'cm1_fraction_partie_entier',
      'cm2_volume_cube_pave',
      'sixieme_nature_mots',
      'cinquieme_cycle_eau',
      'quatrieme_voix_active_passive',
      'troisieme_pythagore_reciproque',
      'seconde_force_poids_masse',
      'premiere_oxydoreduction',
      'terminale_genetique_expression',
      'cp1_syllabes_pa_pe',
      'cp2_addition_dizaines_renforce',
      'ce1_phrase_ponctuation',
      'ce2_perimetre_rectangle',
      'cm1_duree_ecoulee',
      'cm2_comparer_fractions',
      'sixieme_orientation_carte',
      'cinquieme_melanges',
      'quatrieme_masse_volume_densite',
      'troisieme_equation_premier_degre',
      'seconde_equation_droite',
      'premiere_suite_arithmetique_renforce',
      'terminale_acide_base_ph',
    };
    return lesson.level == SchoolLevel.cp1 || visualLessonIds.contains(lesson.id);
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
      'cm1_adjectif_qualificatif' => const ['une grande maison blanche', 'Nom : maison', 'Adjectifs : grande, blanche', 'Ils précisent le nom et s’accordent avec lui'],
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
      'ce2_animaux_regimes_alimentaires' => const ['HERBIVORE : végétaux (ex. chèvre)', 'CARNIVORE : autres animaux (ex. lion)', 'OMNIVORE : végétaux + animaux (ex. humain)', 'Classer selon l’alimentation habituelle'],
      'ce2_multiplication_dizaines' => const ['23 × 20', '= 23 × 2 × 10', '= 46 × 10', '= 460'],
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
      'cm1_multiples_diviseurs' => const ['6 × 4 = 24', '20 ÷ 5 = 4', '24 est multiple de 8'],
      'cm1_mesure_masse' => const ['1 kg = 1 000 g', '2 kg = 2 000 g', 'Balance → mesure la masse'],
      'cm2_aire_parallelogramme' => const ['A──────B', ' /    /', '  D──────C', 'hauteur ⟂ = 3 cm', 'base DC = 8 cm', 'Aire = 8 × 3 = 24 cm²'],
      'cm2_electricite_circuit' => const ['PILE (+) → fil → LAMPE', '→ fil → PILE (−)', 'Le circuit forme une boucle fermée'],
      'sixieme_accord_determinant_nom' => const ['UN garçon', 'UNE fille', 'DES élèves', 'Déterminant et nom s’accordent'],
      'sixieme_fraction_unite' => const ['3/3 = 1', '5/5 = 1', 'numérateur = dénominateur'],
      'cinquieme_energie_renouvelable' => const ['SOLEIL → panneau solaire', 'VENT → éolienne', 'EAU → turbine', 'Sources renouvelables'],
      'cinquieme_adverbe' => const ['Il court VITE.', 'Elle parle DOUCEMENT.', 'HIER : adverbe de temps'],
      'quatrieme_puissance_dix' => const ['10¹ = 10', '10² = 100', '10³ = 1 000', '10⁴ = 10 000'],
      'quatrieme_reproduction_plantes' => const ['Étamines → pollen', 'Pollen → stigmate', 'Fécondation → ovule → graine', 'Ovaire → fruit'],
      'troisieme_statistiques_etendue' => const ['Minimum : 4', 'Valeurs : 4, 7, 9, 12', 'Maximum : 12', 'Étendue = 12 − 4 = 8'],
      'troisieme_energie_electrique' => const ['Énergie E', 'E = P × t', '100 W × 2 h = 200 Wh', '1 kWh = 1 000 Wh'],
      'seconde_vecteurs_coordonnees' => const ['A(xA ; yA)', 'B(xB ; yB)', 'AB = (xB − xA ; yB − yA)', 'B − A : arrivée moins départ'],
      'seconde_chaines_alimentaires' => const ['Herbe → criquet', '→ grenouille → serpent', 'La flèche va de l’aliment', 'vers celui qui le mange'],
      'seconde_anglais_present_simple' => const ['I play', 'You play', 'He / She plays', 'They play'],
      'premiere_derivation_produit' => const ['(u × v)’', '= u’v + uv’', '(x × x²)’', '= 1 × x² + x × 2x', '= 3x²'],
      'premiere_suite_geometrique' => const ['3 → 6 → 12 → 24', '×2    ×2    ×2', 'Raison : q = 2'],
      'premiere_probabilite_independante' => const ['A et B indépendants', 'P(A ∩ B) = P(A) × P(B)', '0,5 × 0,2 = 0,1'],
      'premiere_lecture_graphique_derivative' => const ['f’(x) > 0 → f croît', 'f’(x) < 0 → f décroît', 'f’(x) = 0 sur un intervalle', '→ f est constante'],
      'terminale_integrale_primitive' => const ['F’(x) = f(x)', '∫ₐᵇ f(x) dx = F(b) − F(a)', '∫₀² 2x dx = 4'],
      'terminale_loi_binomiale' => const ['n épreuves indépendantes', 'Succès / échec', 'Probabilité du succès : p', 'X compte les succès : B(n,p)'],
      'terminale_complexes_module' => const ['z = a + bi', 'Point M(a ; b)', '|z| = √(a² + b²)', 'Distance OM = module'],
      'terminale_philosophie_argumentation' => const ['SUJET / QUESTION', '↓ problématique', 'THÈSE → ARGUMENT → EXEMPLE', '↓ objection / discussion', 'CONCLUSION'],
      'cp1_sons_m_et_n' => const ['M → maman, moto', 'N → nez, nuit', 'Écoute le premier son'],
      'cp2_lire_heure_pleine' => const ['Grande aiguille → 12', 'Petite aiguille → 4', 'Il est 4 heures'],
      'ce1_monnaie_fcfa' => const ['500 FCFA', '− 350 FCFA', '= 150 FCFA de monnaie'],
      'ce2_multiplication_par_10' => const ['23 × 10', '= 23 dizaines', '= 230'],
      'cm1_fraction_partie_entier' => const ['3/4 de 20', '20 ÷ 4 = 5', '5 × 3 = 15'],
      'cm2_volume_cube_pave' => const ['L = 4 cm', 'l = 3 cm', 'h = 2 cm', 'V = L × l × h', 'V = 24 cm³'],
      'sixieme_nature_mots' => const ['LE PETIT CHAT DORT', 'Nom : chat', 'Adjectif : petit', 'Verbe : dort'],
      'cinquieme_cycle_eau' => const ['Soleil → évaporation ↑', 'Vapeur → condensation ☁', 'Nuages → précipitations ↓', 'Ruissellement / infiltration'],
      'quatrieme_voix_active_passive' => const ['ACTIVE : Le professeur corrige la copie.', 'PASSIVE : La copie est corrigée', 'par le professeur.'],
      'troisieme_pythagore_reciproque' => const ['3² + 4² = 9 + 16', '= 25 = 5²', 'Triangle de côtés 3, 4, 5', '→ triangle rectangle'],
      'seconde_force_poids_masse' => const ['Masse m : en kg', 'Poids P : en N', 'P = m × g', '2 kg × 10 N/kg = 20 N'],
      'premiere_oxydoreduction' => const ['Zn → Zn²⁺ + 2 e⁻', 'Le zinc perd des électrons', 'PERTE → OXYDATION'],
      'terminale_genetique_expression' => const ['ADN (gène)', '↓ transcription', 'ARN messager', '↓ traduction', 'Protéine'],
      'cp1_syllabes_pa_pe' => const ['P + A = PA', 'P + E = PE', 'P + I = PI', 'PA → papa'],
      'cp2_addition_dizaines' => const ['30 + 20 = 50', '12 + 15 = 27', '40 + 8 = 48'],
      'ce1_phrase_ponctuation' => const ['Déclarative → .', 'Question → ?', 'Exclamation → !'],
      'ce2_perimetre_rectangle' => const ['L = 5 cm', 'l = 2 cm', 'P = 2 × (L + l)', 'P = 14 cm'],
      'cm1_duree_ecoulee' => const ['14 h 20 → 14 h 50', '50 − 20 = 30 min', 'Durée = 30 min'],
      'cm2_comparer_fractions' => const ['2/7 < 5/7', '4/9 < 6/9', '3/5 > 3/8'],
      'sixieme_orientation_carte' => const ['N ↑', 'O ← • → E', 'S ↓', 'Boussole → nord'],
      'cinquieme_melanges' => const ['EAU + SEL dissous', '→ mélange homogène', 'EAU + SABLE visible', '→ mélange hétérogène'],
      'quatrieme_masse_volume_densite' => const ['Masse m : balance', 'Volume V : espace occupé', 'ρ = m ÷ V'],
      'troisieme_equation_premier_degre' => const ['2x + 4 = 10', '2x = 6', 'x = 3'],
      'seconde_equation_droite' => const ['y = ax + b', 'a : pente', 'b : ordonnée à l’origine'],
      'premiere_suite_arithmetique_renforce' => const ['2 → 5 → 8 → 11', '+3    +3    +3', 'Raison r = 3'],
      'terminale_acide_base_ph' => const ['pH < 7 : ACIDE', 'pH = 7 : NEUTRE', 'pH > 7 : BASIQUE'],
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
      'cm1_adjectif_qualificatif' => 'REPÈRE LES ADJECTIFS QUI PRÉCISENT LE NOM',
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
      'ce2_animaux_regimes_alimentaires' => 'CLASSE LES ANIMAUX SELON LEUR ALIMENTATION',
      'ce2_multiplication_dizaines' => 'MULTIPLIE PAR 20, 30 OU 40 EN DÉCOMPOSANT',
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
      'cm1_multiples_diviseurs' => 'RECONNAIS LES MULTIPLES ET LES DIVISEURS',
      'cm1_mesure_masse' => 'CONVERTIS LES MASSES EN GRAMMES ET KILOGRAMMES',
      'cm2_aire_parallelogramme' => 'CALCULE L’AIRE AVEC LA BASE ET LA HAUTEUR',
      'cm2_electricite_circuit' => 'REPÈRE LA BOUCLE D’UN CIRCUIT FERMÉ',
      'sixieme_accord_determinant_nom' => 'ACCORDE LE DÉTERMINANT AVEC LE NOM',
      'sixieme_fraction_unite' => 'REPÈRE LES FRACTIONS QUI VALENT UNE UNITÉ',
      'cinquieme_energie_renouvelable' => 'IDENTIFIE LES SOURCES D’ÉNERGIE RENOUVELABLES',
      'cinquieme_adverbe' => 'REPÈRE L’ADVERBE DANS LA PHRASE',
      'quatrieme_puissance_dix' => 'ÉCRIS ET CALCULE LES PUISSANCES DE DIX',
      'quatrieme_reproduction_plantes' => 'SUIS LES ÉTAPES DE LA REPRODUCTION DES PLANTES À FLEURS',
      'troisieme_statistiques_etendue' => 'CALCULE L’ÉTENDUE ENTRE LE MINIMUM ET LE MAXIMUM',
      'troisieme_energie_electrique' => 'CALCULE L’ÉNERGIE AVEC E = P × T',
      'seconde_vecteurs_coordonnees' => 'CALCULE LES COORDONNÉES DU VECTEUR AB',
      'seconde_chaines_alimentaires' => 'LIS LE SENS DES FLÈCHES D’UNE CHAÎNE ALIMENTAIRE',
      'seconde_anglais_present_simple' => 'OBSERVE LE PRÉSENT SIMPLE EN ANGLAIS',
      'premiere_derivation_produit' => 'APPLIQUE LA FORMULE DE DÉRIVATION D’UN PRODUIT',
      'premiere_suite_geometrique' => 'REPÈRE LA RAISON D’UNE SUITE GÉOMÉTRIQUE',
      'premiere_probabilite_independante' => 'CALCULE LA PROBABILITÉ D’UNE INTERSECTION INDÉPENDANTE',
      'premiere_lecture_graphique_derivative' => 'DÉDUIS LES VARIATIONS DU SIGNE DE LA DÉRIVÉE',
      'terminale_integrale_primitive' => 'UTILISE UNE PRIMITIVE POUR CALCULER UNE INTÉGRALE',
      'terminale_loi_binomiale' => 'IDENTIFIE LES CONDITIONS DE LA LOI BINOMIALE',
      'terminale_complexes_module' => 'CALCULE LE MODULE D’UN NOMBRE COMPLEXE',
      'terminale_philosophie_argumentation' => 'ORGANISE UNE DISSERTATION PHILOSOPHIQUE',
      'cp1_sons_m_et_n' => 'RECONNAIS LES SONS M ET N',
      'cp2_lire_heure_pleine' => 'LIS UNE HEURE PLEINE SUR L’HORLOGE',
      'ce1_monnaie_fcfa' => 'CALCULE LA MONNAIE EN FCFA',
      'ce2_multiplication_par_10' => 'MULTIPLIE UN NOMBRE ENTIER PAR 10',
      'cm1_fraction_partie_entier' => 'CALCULE UNE FRACTION D’UNE QUANTITÉ',
      'cm2_volume_cube_pave' => 'CALCULE LE VOLUME D’UN PAVÉ DROIT',
      'sixieme_nature_mots' => 'IDENTIFIE NOM, VERBE ET ADJECTIF',
      'cinquieme_cycle_eau' => 'SUIS LES ÉTAPES DU CYCLE DE L’EAU',
      'quatrieme_voix_active_passive' => 'PASSE DE LA VOIX ACTIVE À LA VOIX PASSIVE',
      'troisieme_pythagore_reciproque' => 'VÉRIFIE SI UN TRIANGLE EST RECTANGLE',
      'seconde_force_poids_masse' => 'DISTINGUE LA MASSE DU POIDS',
      'premiere_oxydoreduction' => 'REPÈRE LE TRANSFERT D’ÉLECTRONS',
      'terminale_genetique_expression' => 'DÉCOUVRE L’EXPRESSION D’UN GÈNE',
      'cp1_syllabes_pa_pe' => 'FORME ET LIS LES SYLLABES PA, PE ET PI',
      'cp2_addition_dizaines' => 'ADDITIONNE DES DIZAINES ET DES UNITÉS',
      'ce1_phrase_ponctuation' => 'CHOISIS LE SIGNE DE PONCTUATION',
      'ce2_perimetre_rectangle' => 'CALCULE LE PÉRIMÈTRE DU RECTANGLE',
      'cm1_duree_ecoulee' => 'CALCULE LA DURÉE ÉCOULÉE',
      'cm2_comparer_fractions' => 'COMPARE DES FRACTIONS',
      'sixieme_orientation_carte' => 'REPÈRE LES DIRECTIONS SUR UNE CARTE',
      'cinquieme_melanges' => 'DISTINGUE LES MÉLANGES HOMOGÈNES ET HÉTÉROGÈNES',
      'quatrieme_masse_volume_densite' => 'RELIE LA MASSE AU VOLUME',
      'troisieme_equation_premier_degre' => 'ISOLE L’INCONNUE DANS UNE ÉQUATION',
      'seconde_equation_droite' => 'IDENTIFIE LA PENTE ET L’ORDONNÉE À L’ORIGINE',
      'premiere_suite_arithmetique_renforce' => 'TROUVE LA RAISON D’UNE SUITE ARITHMÉTIQUE',
      'terminale_acide_base_ph' => 'INTERPRÈTE LE pH D’UNE SOLUTION',
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
