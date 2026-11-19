import 'package:flutter/material.dart';
import '../../data/models/models.dart';

/// Progression annuelle indicative du CP1 à la Terminale, organisée par trimestre.
/// Les séquences doivent être confrontées aux guides et progressions officiels
/// de l'année scolaire avant utilisation comme calendrier définitif.
class PrimaryYearPlanScreen extends StatefulWidget {
  final SchoolLevel level;
  final SchoolTrack track;
  final String series;
  const PrimaryYearPlanScreen({super.key, required this.level, this.track = SchoolTrack.generalLiterary, this.series = 'A4'});

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

    SchoolLevel.sixieme: [
      ['Mathématiques — Lire, écrire et comparer les nombres ; calculer avec les entiers et résoudre des problèmes.',
       'Français — Lire un texte narratif, repérer les informations et construire des phrases correctes.',
       'Anglais — Se présenter, saluer et comprendre les consignes de classe.',
       'SVT — Identifier les êtres vivants et décrire leur milieu.',
       'Histoire-Géographie — Utiliser les repères chronologiques et lire une carte simple.'],
      ['Mathématiques — Utiliser les fractions simples, les nombres décimaux, les mesures et les figures.',
       'Français — Reconnaître les classes de mots, accorder et conjuguer les verbes usuels.',
       'Physique-Chimie — Observer la matière, les mélanges et réaliser des mesures simples.',
       'SVT — Étudier le corps humain, la nutrition et les règles d’hygiène.',
       'Géographie — Décrire les paysages, les ressources et les activités humaines.'],
      ['Mathématiques — Résoudre des problèmes de synthèse et construire des figures avec précision.',
       'Français — Rédiger un texte organisé et justifier ses réponses à partir d’un document.',
       'Anglais — Dialoguer et décrire une personne, un lieu ou une activité.',
       'Sciences — Réinvestir les notions de matière, de vivant et de santé.',
       'Histoire-Géographie — Présenter des repères et exploiter une carte ou un document.'],
    ],
    SchoolLevel.cinquieme: [
      ['Mathématiques — Consolider les fractions, les nombres relatifs et les opérations.',
       'Français — Comprendre des textes variés et reconnaître les principales formes de discours.',
       'Anglais — Utiliser le présent simple et le vocabulaire de la vie quotidienne.',
       'SVT — Étudier la nutrition et les besoins des êtres vivants.',
       'Histoire-Géographie — Situer des événements et décrire des civilisations et des territoires.'],
      ['Mathématiques — Résoudre des problèmes de proportionnalité et approfondir la géométrie.',
       'Français — Maîtriser les accords, les temps du récit et la production écrite.',
       'Physique-Chimie — Décrire la matière, les mélanges et les mesures.',
       'SVT — Relier alimentation, santé et fonctionnement du vivant.',
       'Géographie — Expliquer les relations entre population, activités et environnement.'],
      ['Mathématiques — Mobiliser calcul, fractions et constructions dans des problèmes nouveaux.',
       'Français — Produire un récit ou une description cohérente et corriger la langue.',
       'Anglais — Comprendre et jouer des dialogues sur des situations familières.',
       'Sciences — Expliquer une observation et proposer une démarche de prévention.',
       'Histoire-Géographie — Analyser des documents et présenter des repères précis.'],
    ],
    SchoolLevel.quatrieme: [
      ['Mathématiques — Calculer avec les nombres relatifs et les fractions ; introduire le calcul littéral.',
       'Français — Analyser un texte et identifier les procédés d’argumentation.',
       'Anglais — Raconter un événement passé et décrire des expériences.',
       'SVT — Étudier la reproduction, la santé et les relations entre êtres vivants.',
       'Histoire-Géographie — Situer les grandes transformations des sociétés.'],
      ['Mathématiques — Résoudre des équations simples et des problèmes de proportionnalité.',
       'Français — Approfondir grammaire, conjugaison et rédaction organisée.',
       'Physique-Chimie — Étudier les circuits électriques et les transformations de la matière.',
       'SVT — Expliquer les équilibres du milieu et les actions de protection.',
       'Géographie et ECM — Étudier les populations, les ressources, les droits et les devoirs.'],
      ['Mathématiques — Résoudre des problèmes de synthèse et justifier les constructions.',
       'Français — Rédiger un texte argumenté et répondre précisément à une consigne.',
       'Anglais — Comprendre un texte court et exprimer une comparaison.',
       'Sciences — Interpréter des résultats et relier causes et conséquences.',
       'Histoire-Géographie — Exploiter des cartes, des chronologies et des documents.'],
    ],
    SchoolLevel.troisieme: [
      ['Mathématiques — Maîtriser calcul littéral, équations et théorèmes de géométrie.',
       'Français — Comprendre un texte, construire une argumentation et rédiger.',
       'Anglais — Comprendre des messages et s’exprimer sur des sujets familiers.',
       'SVT — Étudier l’hérédité, la santé et les écosystèmes.',
       'Physique-Chimie — Réviser matière, électricité, mécanique et unités.'],
      ['Mathématiques — Étudier fonctions, statistiques et problèmes géométriques.',
       'Français — Préparer dictée, étude de texte, résumé et rédaction.',
       'Physique-Chimie — Résoudre des problèmes et expliquer les phénomènes étudiés.',
       'SVT — Interpréter des documents sur la reproduction, la génétique et l’environnement.',
       'Histoire-Géographie et ECM — Analyser les documents et réviser les repères citoyens.'],
      ['Mathématiques — Traiter des sujets complets et rédiger les étapes du raisonnement.',
       'Français — S’entraîner à toutes les parties de l’épreuve écrite.',
       'Anglais — Réviser vocabulaire, grammaire et compréhension.',
       'Sciences — Résoudre des exercices de synthèse et corriger les erreurs.',
       'Préparation BEPC — Faire des sujets chronométrés et reprendre les notions faibles.'],
    ],
    SchoolLevel.seconde: [
      ['Mathématiques — Ensembles de nombres, calcul algébrique et premières fonctions.',
       'Français — Genres littéraires, lecture méthodique et expression écrite.',
       'Anglais — Communication, vocabulaire et structures grammaticales.',
       'Physique-Chimie — Grandeurs, mesures et démarche expérimentale.',
       'SVT — Cellule, organisation du vivant et observation scientifique.'],
      ['Mathématiques — Équations, géométrie et statistiques descriptives.',
       'Français — Commentaire guidé, grammaire et argumentation.',
       'Anglais — Compréhension de textes et expression orale.',
       'Sciences — Matière, énergie, vivant et environnement.',
       'Histoire-Géographie — Repères, cartes et analyse de documents.'],
      ['Mathématiques — Résoudre des problèmes de synthèse et présenter les calculs.',
       'Français — Rédiger une analyse organisée et justifier une interprétation.',
       'Anglais — Produire des messages écrits et oraux cohérents.',
       'Sciences — Réinvestir les méthodes et les notions essentielles.',
       'Méthodologie — Préparer les évaluations et choisir les matières à renforcer.'],
    ],
    SchoolLevel.premiere: [
      ['Mathématiques — Étudier les fonctions, les variations et les suites selon le parcours.',
       'Français — Analyser les œuvres, les genres et les procédés littéraires.',
       'Anglais — Comprendre des textes et développer une expression précise.',
       'Sciences — Consolider grandeurs physiques, matière et organisation du vivant.',
       'Méthodologie — Construire un plan de révision et rédiger une démonstration.'],
      ['Mathématiques — Approfondir dérivation, problèmes et outils de calcul.',
       'Français — Construire un commentaire et une dissertation guidés.',
       'Anglais — Développer argumentation et compréhension.',
       'Physique-Chimie ou SVT — Interpréter des expériences et résoudre des problèmes.',
       'Spécialités — Travailler les compétences propres à la série choisie.'],
      ['Mathématiques — Traiter des exercices de synthèse et expliquer les démarches.',
       'Français — Produire des réponses structurées et maîtriser les méthodes d’analyse.',
       'Anglais — S’entraîner à l’écrit et à l’oral.',
       'Sciences — Réviser les applications et les raisonnements.',
       'Préparation BAC I — Faire des sujets d’entraînement et corriger les erreurs.'],
    ],
    SchoolLevel.terminale: [
      ['Mathématiques — Analyse, fonctions et suites selon la série.',
       'Philosophie et littérature — Problématiser, définir les notions et argumenter.',
       'Anglais — Comprendre et produire des messages écrits et oraux.',
       'Sciences — Étudier les modèles physiques, chimiques ou biologiques du parcours.',
       'Spécialités — Organiser les révisions selon les exigences de la série.'],
      ['Mathématiques — Approfondir probabilités, intégration ou notions du programme de série.',
       'Philosophie — Construire une dissertation et expliquer un texte.',
       'Sciences — Résoudre des exercices de synthèse et interpréter des documents.',
       'Anglais — S’entraîner sur des textes et des sujets d’expression.',
       'Spécialités — Traiter des cas pratiques, problèmes et travaux techniques.'],
      ['Mathématiques — Traiter des sujets complets et justifier les résultats.',
       'Philosophie — Maîtriser introduction, problématique, arguments et conclusion.',
       'Sciences — Réviser les méthodes et les applications essentielles.',
       'Anglais — Réviser vocabulaire, compréhension et expression.',
       'Préparation BAC II — Faire des examens blancs, gérer le temps et reprendre les lacunes.'],
    ],
  };


  String _seriesFocus() {
    final focus = <String, List<String>>{
      'A4': [
        'Lire et situer les œuvres, identifier les genres et construire une lecture méthodique.',
        'Approfondir le commentaire composé, la dissertation et l’argumentation avec des citations pertinentes.',
        'S’entraîner aux sujets de synthèse, à la gestion du temps et à la rédaction structurée.',
      ],
      'C': [
        'Renforcer le calcul algébrique, les fonctions et les bases de la mécanique et des mesures physiques.',
        'Résoudre des problèmes de physique-chimie en explicitant les lois, unités et étapes de calcul.',
        'Traiter des exercices de synthèse en mathématiques et sciences physiques dans les conditions d’examen.',
      ],
      'D': [
        'Consolider les outils mathématiques et les notions de cellule, matière et organisation du vivant.',
        'Étudier les mécanismes biologiques, la génétique, la physiologie et les phénomènes physiques associés.',
        'S’entraîner à analyser des documents scientifiques et à résoudre des problèmes de mathématiques et SVT.',
      ],
      'G1': [
        'Rédiger des courriers professionnels, organiser les documents et appliquer les règles de communication administrative.',
        'Traiter des dossiers, classer l’information et utiliser les méthodes de secrétariat et de bureautique.',
        'Simuler des situations de secrétariat, d’accueil, de rédaction et de gestion documentaire.',
      ],
      'G2': [
        'Identifier les pièces comptables et enregistrer les opérations courantes selon leur nature.',
        'Tenir les journaux et comptes, contrôler les écritures et préparer les documents de synthèse.',
        'Résoudre des cas pratiques de comptabilité et justifier les traitements appliqués.',
      ],
      'G3': [
        'Étudier le marché, les besoins des clients et les caractéristiques d’un produit ou service.',
        'Préparer une démarche commerciale, argumenter une offre et traiter les objections.',
        'Résoudre des cas de vente, de relation client et d’analyse commerciale.',
      ],
      'E': [
        'Lire les schémas industriels et identifier les composants, grandeurs et règles de sécurité.',
        'Analyser le fonctionnement d’un système électrique ou énergétique et ses protections.',
        'Résoudre des situations techniques en respectant les procédures et la sécurité.',
      ],
      'F1': [
        'Lire un dessin technique, reconnaître les vues, cotations et représentations des pièces mécaniques.',
        'Étudier les matériaux, les procédés d’usinage et les paramètres de fabrication.',
        'Analyser un problème de fabrication et justifier le choix des opérations et contrôles.',
      ],
      'F2': [
        'Identifier les composants électroniques et lire les symboles des schémas.',
        'Analyser les circuits, les signaux et les fonctions des composants.',
        'Résoudre des exercices de diagnostic et de fonctionnement des montages électroniques.',
      ],
      'F3': [
        'Lire les schémas électriques et reconnaître les appareils de commande et de protection.',
        'Étudier les moteurs, les circuits de puissance et les règles d’installation.',
        'Analyser une panne simple et proposer une intervention sûre et méthodique.',
      ],
      'F4': [
        'Lire un plan de bâtiment et identifier les vues, cotations et symboles.',
        'Étudier les matériaux, les ouvrages et les étapes de réalisation d’une construction.',
        'Résoudre des situations de métré, de lecture de plans et d’organisation de chantier.',
      ],
      'Ti/1': [
        'Identifier les équipements, les organes d’un système et les règles de sécurité en atelier.',
        'Organiser une maintenance préventive et relever les signes d’un dysfonctionnement.',
        'Établir un diagnostic simple, proposer une intervention et rendre compte du travail réalisé.',
      ],
    };
    return focus[widget.series]?[_term] ??
        'Réviser les notions propres à la série ${widget.series} à partir des cours, travaux pratiques et consignes de l’enseignant.';
  }

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
          if (widget.level.index >= SchoolLevel.seconde.index)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${widget.track.label} • Série ${widget.series}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(_seriesFocus()),
                ]),
              ),
            ),
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
