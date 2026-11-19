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
      ['Mathématiques — Numération, fractions simples, opérations et résolution de problèmes ; Français — lecture suivie, compréhension et phrase ; Anglais — se présenter et échanger en classe ; SVT — êtres vivants et milieu ; Histoire-Géographie — repères chronologiques et lecture de cartes.',
       'Mathématiques — nombres décimaux, mesures et constructions géométriques ; Français — classes de mots et conjugaison ; Physique-Chimie — matière, mélanges et mesures ; SVT — corps humain et santé ; Géographie — paysages et activités humaines.',
       'Mathématiques — problèmes de synthèse et géométrie ; Français — rédaction et étude de texte ; Anglais — dialogues et descriptions ; Sciences — révision des notions et démarche d’observation ; Histoire-Géographie — réinvestissement des repères.'],
      ['Mathématiques — calcul réfléchi et problèmes à plusieurs étapes ; Français — accords et vocabulaire ; Anglais — école, famille et quotidien ; SVT — nutrition et hygiène ; Histoire — sociétés anciennes et repères.',
       'Mathématiques — proportionnalité intuitive et mesures ; Français — temps verbaux usuels ; Physique-Chimie — états de la matière et transformations simples ; Géographie — milieu naturel et ressources ; Éducation civique — règles de vie collective.',
       'Révision des notions de l’année, exercices variés, rédaction de réponses complètes et préparation aux évaluations de passage.']
    ],
    SchoolLevel.cinquieme: [
      ['Mathématiques — fractions, nombres relatifs et calcul ; Français — lecture analytique et grammaire ; Anglais — présent simple et vocabulaire courant ; SVT — nutrition et organisation des êtres vivants ; Histoire-Géographie — repères et civilisations.',
       'Mathématiques — proportionnalité, géométrie et problèmes ; Français — conjugaison et production écrite ; Physique-Chimie — matière, mélanges et mesures ; SVT — santé et environnement ; Géographie — populations et activités.',
       'Mathématiques — synthèse des calculs et constructions ; Français — compréhension et rédaction ; Anglais — dialogues ; Sciences — observation et explication ; Histoire-Géographie — étude de documents.'],
      ['Mathématiques — nombres relatifs et fractions ; Français — types de textes et accords ; Anglais — descriptions et habitudes ; SVT — alimentation et santé ; Histoire — repères historiques.',
       'Mathématiques — calcul littéral introductif et figures ; Français — temps du récit ; Physique-Chimie — propriétés de la matière ; Géographie — milieux et ressources ; Éducation civique — responsabilité et solidarité.',
       'Révisions, exercices de raisonnement, étude de documents et entraînements de fin d’année.']
    ],
    SchoolLevel.quatrieme: [
      ['Mathématiques — nombres relatifs, fractions et calcul littéral ; Français — argumentation et analyse de textes ; Anglais — récits au passé ; SVT — reproduction et santé ; Histoire-Géographie — transformations des sociétés.',
       'Mathématiques — équations simples, proportionnalité et géométrie ; Français — grammaire, conjugaison et rédaction ; Physique-Chimie — électricité et transformations ; SVT — environnement ; Géographie — population et ressources.',
       'Mathématiques — problèmes de synthèse ; Français — commentaire guidé et expression écrite ; Anglais — compréhension ; Sciences — interprétation d’expériences ; Histoire-Géographie — documents et cartes.'],
      ['Mathématiques — calcul littéral et équations ; Français — discours rapporté et organisation du texte ; Anglais — comparaisons ; SVT — fonctions des organes ; Histoire — chronologie.',
       'Mathématiques — théorèmes et mesures ; Français — argumentation ; Physique-Chimie — circuits et énergie ; Géographie — aménagement du territoire ; Éducation civique — droits et devoirs.',
       'Révision des notions, exercices progressifs, correction des erreurs et préparation au niveau supérieur.']
    ],
    SchoolLevel.troisieme: [
      ['Mathématiques — calcul littéral, équations et théorèmes ; Français — étude de texte et argumentation ; Anglais — compréhension et expression ; SVT — génétique et santé ; Physique-Chimie — matière et électricité.',
       'Mathématiques — fonctions, statistiques et géométrie ; Français — rédaction organisée et langue ; Physique-Chimie — mécanique et transformations chimiques ; SVT — environnement et reproduction ; Histoire-Géographie — analyse de documents.',
       'Mathématiques — sujets de synthèse ; Français — dictée, étude de texte et rédaction ; Sciences — exercices d’application ; Anglais — compréhension écrite ; Histoire-Géographie et ECM — révision des repères et notions.'],
      ['Mathématiques — fonctions et résolution de problèmes ; Français — argumentation et résumé ; Anglais — temps verbaux et communication ; SVT — hérédité et écosystèmes ; Histoire — repères du programme.',
       'Mathématiques — géométrie et statistiques ; Français — préparation à l’épreuve écrite ; Physique-Chimie — raisonnement et unités ; Géographie — cartes et territoires ; ECM — citoyenneté.',
       'Entraînement progressif au BEPC : sujets chronométrés, rédaction des démarches, correction détaillée et révision ciblée des lacunes.']
    ],
    SchoolLevel.seconde: [
      ['Mathématiques — ensembles de nombres, calcul algébrique et fonctions ; Français — genres littéraires et lecture méthodique ; Anglais — communication et grammaire ; Physique-Chimie — grandeurs et mesures ; SVT — cellule et organisation du vivant.',
       'Mathématiques — équations, géométrie et statistiques ; Français — commentaire guidé et expression ; Anglais — compréhension de textes ; Sciences — matière, énergie, vivant et environnement ; Histoire-Géographie — repères et documents.',
       'Mathématiques — problèmes de synthèse ; Français — rédaction structurée ; Anglais — expression orale et écrite ; Sciences — exercices d’application ; révisions des méthodes de travail et des notions essentielles.'],
      ['Mathématiques — fonctions et calcul raisonné ; Français — analyse de textes ; Anglais — temps et structures ; Physique-Chimie — phénomènes physiques ; SVT — biodiversité.',
       'Mathématiques — statistiques et géométrie ; Français — argumentation ; Sciences — démarche expérimentale ; Histoire-Géographie — étude de documents ; préparation des matières de spécialité.',
       'Consolidation des acquis, devoirs de synthèse et préparation au passage en première.']
    ],
    SchoolLevel.premiere: [
      ['Mathématiques — fonctions, variations et suites selon le parcours ; Français — analyse littéraire et argumentation ; Anglais — compréhension et expression ; Sciences — grandeurs physiques, matière et vivant ; préparation méthodologique aux épreuves.',
       'Mathématiques — dérivation et problèmes ; Français — commentaire et dissertation guidés ; Anglais — textes et communication ; Physique-Chimie ou SVT — raisonnement, expériences et interprétation ; spécialités de série.',
       'Mathématiques — exercices de synthèse ; Français — productions structurées ; Sciences — applications ; Anglais — entraînement écrit et oral ; révision des notions et méthodes du BAC I.'],
      ['Mathématiques — étude de fonctions et suites ; Français — argumentation et œuvres ; Anglais — expression ; Sciences — lois et modèles ; matières de spécialité.',
       'Mathématiques — probabilités et analyse ; Français — commentaire composé ; Sciences — problèmes et interprétation ; Histoire-Géographie selon parcours ; préparation au BAC I.',
       'Révision ciblée, sujets d’entraînement, correction des erreurs et préparation au passage en Terminale.']
    ],
    SchoolLevel.terminale: [
      ['Mathématiques — analyse, fonctions et suites selon la série ; Philosophie/Français — problématisation et argumentation ; Anglais — compréhension et expression ; Sciences — modèles physiques, chimiques ou biologiques ; spécialités de série.',
       'Mathématiques — probabilités, intégration ou approfondissements du programme de série ; Philosophie — notions, dissertation et explication ; Sciences — exercices de synthèse et interprétation ; Anglais — entraînement ; matières techniques ou littéraires de spécialité.',
       'Révision méthodique du BAC II : sujets complets chronométrés, gestion du temps, rédaction rigoureuse, correction détaillée et reprise des chapitres faibles.'],
      ['Mathématiques — consolidation des méthodes et exercices de synthèse ; Philosophie — plans et arguments ; Anglais — sujets écrits ; Sciences — applications et expériences ; matières de spécialité.',
       'Mathématiques — problèmes complexes du parcours ; Philosophie — dissertation et explication ; Sciences — raisonnement et calcul ; entraînements transversaux aux épreuves.',
       'Préparation finale au BAC II : examens blancs, révisions ciblées, correction des erreurs récurrentes et organisation du travail personnel.']
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
