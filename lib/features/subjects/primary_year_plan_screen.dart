import 'package:flutter/material.dart';
import '../../data/models/models.dart';

/// Progression annuelle indicative du primaire, organisée par trimestre.
/// Les séquences doivent être confrontées aux guides et progressions officiels
/// de l'année scolaire avant utilisation comme calendrier définitif.
class PrimaryYearPlanScreen extends StatefulWidget {
  final SchoolLevel level;
  const PrimaryYearPlanScreen({super.key, required this.level});

  @override
  State<PrimaryYearPlanScreen> createState() => _PrimaryYearPlanScreenState();
}

class _PrimaryYearPlanScreenState extends State<PrimaryYearPlanScreen> {
  int _term = 0;

  static const Map<SchoolLevel, List<List<String>>> _plans = {
    SchoolLevel.cp1: [
      ['Mathématiques — Dénombrer et lire les nombres de 1 à 10 ; comparer des collections ; reconnaître les formes simples.',
       'Français — Écouter, s’exprimer oralement ; reconnaître les lettres ; associer lettres et sons ; tenir correctement l’outil d’écriture.',
       'Anglais — Saluer ; dire son nom ; comprendre les consignes et le vocabulaire de la classe.',
       'Éveil scientifique — Observer le corps, les animaux, les plantes et les objets du milieu.',
       'Éducation sociale — Hygiène des mains ; propreté de la classe ; respect des camarades ; sécurité avec les adultes.'],
      ['Mathématiques — Consolider les nombres ; décomposer de petites quantités ; réaliser des additions et soustractions concrètes.',
       'Français — Former des syllabes et des mots ; lire des mots et de courtes phrases ; copier des phrases simples.',
       'Anglais — Nombres, couleurs, objets scolaires et membres de la famille.',
       'Éveil scientifique — Besoins des plantes et des animaux ; eau, alimentation et hygiène.',
       'Éducation sociale — Règles de vie ; respect du matériel ; prévention des dangers à la maison et à l’école.'],
      ['Mathématiques — Résoudre de petits problèmes ; comparer et ranger les nombres étudiés ; réviser les formes et les mesures usuelles.',
       'Français — Lire de courtes phrases avec compréhension ; écrire une phrase simple ; réviser sons et lettres.',
       'Anglais — Réutiliser les salutations, nombres, couleurs et consignes dans de petits échanges.',
       'Éveil scientifique — Décrire son environnement et adopter des gestes de protection.',
       'Éducation sociale — Réinvestir les règles d’hygiène, de sécurité, de respect et de solidarité.']
    ],
    SchoolLevel.cp2: [
      ['Mathématiques — Lire, écrire, comparer et ranger les nombres ; additions et soustractions sans difficulté majeure.',
       'Français — Lecture de phrases et petits textes ; compréhension orale ; copie et production de phrases.',
       'Anglais — Salutations, présentation, nombres, couleurs et objets de la classe.',
       'Éveil scientifique — Corps humain, sens, animaux familiers et plantes du milieu.',
       'Éducation sociale — Hygiène personnelle ; propreté ; règles de sécurité et respect.'],
      ['Mathématiques — Consolider la numération ; calcul posé adapté ; problèmes additifs et soustractifs ; premières mesures.',
       'Français — Lire avec fluidité croissante ; identifier personnages et actions ; grammaire de la phrase simple.',
       'Anglais — Famille, maison, consignes et expressions courantes.',
       'Éveil scientifique — Eau, air, alimentation, santé et environnement proche.',
       'Éducation sociale — Vie communautaire ; prévention routière élémentaire ; entraide et civisme.'],
      ['Mathématiques — Résoudre des problèmes variés ; réviser opérations, mesures et figures étudiées.',
       'Français — Comprendre un texte court ; écrire un paragraphe de quelques phrases ; réviser lecture et langue.',
       'Anglais — Dialogues courts de présentation et description.',
       'Éveil scientifique — Expliquer des observations simples et appliquer les règles de santé.',
       'Éducation sociale — Réinvestissement des acquis et évaluations de fin d’année.']
    ],
    SchoolLevel.ce1: [
      ['Mathématiques — Numération ; comparaison ; addition et soustraction ; multiplication comme addition répétée.',
       'Français — Lecture expressive ; compréhension ; phrase, nom, déterminant et verbe ; copie soignée.',
       'Anglais — Se présenter ; école ; nombres, couleurs et consignes.',
       'Sciences — Besoins des plantes et animaux ; parties du corps ; observation du milieu.',
       'Éducation sociale — Hygiène, sécurité, respect des règles et coopération.'],
      ['Mathématiques — Tables de multiplication ; partage et groupements ; mesures de longueur et de masse ; problèmes.',
       'Français — Types de phrases ; accords simples ; présent des verbes usuels ; rédaction guidée.',
       'Anglais — Famille, maison, aliments et activités quotidiennes.',
       'Sciences — Eau et air ; alimentation ; prévention de maladies et protection du milieu.',
       'Éducation sociale — Sécurité routière ; propreté du quartier ; solidarité et citoyenneté.'],
      ['Mathématiques — Consolider les quatre opérations abordées ; résoudre des problèmes ; réviser mesures et géométrie.',
       'Français — Lire différents textes ; conjuguer les verbes étudiés ; produire un texte court cohérent.',
       'Anglais — Comprendre et produire de courts dialogues sur les thèmes étudiés.',
       'Sciences — Décrire, comparer et expliquer des phénomènes observables.',
       'Éducation sociale — Révision, projets collectifs et évaluations.']
    ],
    SchoolLevel.ce2: [
      ['Mathématiques — Numération et opérations ; tables ; problèmes ; segments et figures usuelles.',
       'Français — Lecture-compréhension ; classes de mots ; phrase ; présent et passé composé selon les acquis.',
       'Anglais — Présentation, famille, école et vocabulaire courant.',
       'Sciences et technologie — Eau, air, matière ; êtres vivants et besoins.',
       'Éducation sociale — Hygiène, sécurité, vie communautaire et prévention routière.'],
      ['Mathématiques — Multiplication et division en situations ; fractions simples ; mesures et résolution de problèmes.',
       'Français — Accords dans le groupe nominal ; conjugaison ; vocabulaire ; rédaction structurée.',
       'Anglais — Maison, alimentation, activités et repérage dans l’espace.',
       'Sciences et technologie — Environnement, santé, objets techniques et usages responsables.',
       'Éducation sociale — Citoyenneté, solidarité, protection des biens communs et sécurité.'],
      ['Mathématiques — Réinvestir opérations, fractions simples, mesures et géométrie dans des problèmes.',
       'Français — Comprendre un texte ; améliorer l’orthographe ; produire un récit ou une description courte.',
       'Anglais — Dialogues et descriptions simples sur les thèmes annuels.',
       'Sciences et technologie — Démarche d’observation, explication et prévention.',
       'Éducation sociale — Synthèse des apprentissages et évaluations de fin de sous-cycle.']
    ],
    SchoolLevel.cm1: [
      ['Mathématiques — Grands nombres ; opérations ; fractions usuelles ; mesures et problèmes.',
       'Français — Lecture de textes variés ; grammaire ; nature et fonction simples ; conjugaison.',
       'Anglais — Présentation, routines, heure, école et environnement.',
       'Sciences et technologie — Corps humain ; nutrition ; matière ; observation et expériences simples.',
       'Éducation sociale — Environnement, solidarité, sécurité et vie citoyenne.'],
      ['Mathématiques — Décimaux selon la progression ; proportionnalité intuitive ; mesures ; périmètres et aires simples.',
       'Français — Accords ; temps usuels ; vocabulaire ; rédaction de récits, descriptions et lettres.',
       'Anglais — Activités quotidiennes, lieux, directions et achats simples.',
       'Sciences et technologie — Énergie, eau, hygiène, santé et objets techniques.',
       'Éducation sociale — Ressources naturelles, prévention routière et responsabilités collectives.'],
      ['Mathématiques — Résolution de problèmes complexes adaptés ; consolidation calcul, fractions, mesures et géométrie.',
       'Français — Compréhension approfondie ; révision langue ; production écrite organisée.',
       'Anglais — Comprendre et présenter un sujet familier en phrases simples.',
       'Sciences et technologie — Exploiter des observations et proposer des solutions pratiques.',
       'Éducation sociale — Projet citoyen, révision et évaluations.']
    ],
    SchoolLevel.cm2: [
      ['Mathématiques — Nombres entiers et décimaux ; fractions ; opérations ; problèmes de la vie courante.',
       'Français — Lecture-compréhension ; grammaire ; conjugaison ; orthographe et rédaction.',
       'Anglais — Se présenter, décrire, parler de l’école, de la famille et des habitudes.',
       'Sciences et technologie — Corps humain, santé, matière, énergie et environnement.',
       'Éducation sociale — Citoyenneté, institutions, sécurité routière et protection de l’environnement.'],
      ['Mathématiques — Proportionnalité ; mesures ; géométrie ; problèmes à plusieurs étapes et calcul raisonné.',
       'Français — Analyse de textes ; accords et temps verbaux ; rédaction de récits, lettres et textes argumentés simples.',
       'Anglais — Dialogues, descriptions et compréhension de textes courts.',
       'Sciences et technologie — Ressources, électricité et technologie au quotidien ; prévention et santé.',
       'Éducation sociale — Vie démocratique, solidarité, règles collectives et responsabilités.'],
      ['Mathématiques — Révisions ciblées ; problèmes de synthèse ; entraînement aux formats d’épreuves du CEPD.',
       'Français — Révisions lecture, dictée, étude de texte et rédaction ; entraînements progressifs au CEPD.',
       'Anglais — Révision du vocabulaire et des structures étudiées ; communication simple.',
       'Sciences et technologie — Révisions, exercices d’application et explication de phénomènes.',
       'Éducation sociale — Révisions et entraînements à partir des sujets disponibles, sans remplacer les consignes officielles.']
    ],
  };

  @override
  Widget build(BuildContext context) {
    final terms = _plans[widget.level]!;
    final entries = terms[_term];
    return Scaffold(
      appBar: AppBar(title: Text('Progression annuelle — ${widget.level.label}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Plan de travail des trois trimestres',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Cette progression indicative aide à organiser les apprentissages. '
              'L’enseignant doit l’ajuster aux programmes, aux manuels et au calendrier officiels.'),
          const SizedBox(height: 16),
          Wrap(spacing: 8, children: List.generate(3, (i) => ChoiceChip(
            label: Text('Trimestre ${i + 1}'),
            selected: _term == i,
            onSelected: (_) => setState(() => _term = i),
          ))),
          const SizedBox(height: 12),
          ...entries.map((entry) {
            final parts = entry.split(' — ');
            final title = parts.first;
            final details = parts.length > 1 ? parts.sublist(1).join(' — ') : '';
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title, style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold,
                    color: Color(0xFF006A4E))),
                  const SizedBox(height: 6),
                  Text(details),
                ]),
              ),
            );
          }),
          const SizedBox(height: 8),
          const Text('Étape suivante : transformer chaque objectif en leçons APC, '
              'exercices corrigés, devoirs et évaluations de trimestre.',
              style: TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
