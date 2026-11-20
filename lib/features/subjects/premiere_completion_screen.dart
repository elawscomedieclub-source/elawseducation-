import 'package:flutter/material.dart';
import '../../data/models/models.dart';

/// Tronc commun annuel de Première, à compléter par les contenus propres à chaque série.
class PremiereCompletionScreen extends StatelessWidget {
  final SchoolTrack track;
  final String series;
  const PremiereCompletionScreen({super.key, required this.track, required this.series});
  static const _units = <_Unit>[
    _Unit('T1 • Français','Argumentation et littérature d’idées','Un texte argumentatif défend une thèse avec des arguments et des exemples. L’analyse examine la stratégie de l’auteur, les procédés rhétoriques et le contexte. Une dissertation construit une réponse progressive à une problématique.','Un argument convaincant est expliqué et illustré par un exemple précis.','Quel élément soutient directement une thèse ?',['Un argument','Une date sans lien','Une répétition vide'],0,'L’argument justifie la position défendue.'),
    _Unit('T1 • Mathématiques','Second degré et fonctions polynomiales','Une fonction du second degré s’écrit ax²+bx+c avec a non nul. Sa courbe est une parabole. Le discriminant permet d’étudier les racines d’un trinôme ; le sommet donne un extremum.','Pour x²−5x+6, les racines sont 2 et 3.','Quelle est la forme générale d’un trinôme du second degré ?',['ax²+bx+c avec a≠0','ax+b uniquement','a/x uniquement'],0,'Le terme de degré 2 est indispensable et son coefficient est non nul.'),
    _Unit('T1 • Anglais','Advanced tenses and structured argument','Les temps permettent de distinguer action achevée, durée et antériorité. Le past perfect (had + participe passé) situe une action avant une autre action passée. Un paragraphe argumentatif développe une idée avec exemples et connecteurs.','When I arrived, the lesson had already started.','Choose the correct form: She … before we arrived.',['has left','had left','is leaving'],1,'Had left marque l’action antérieure à notre arrivée passée.'),
    _Unit('T1 • SVT','Information génétique et expression des caractères','L’ADN porte une information organisée en gènes sur les chromosomes. L’expression d’un gène conduit à la production de molécules qui participent aux caractères. Les mutations peuvent modifier la séquence de l’ADN.','Un gène est une portion d’ADN portant une information héréditaire.','Quelle molécule porte l’information génétique ?',['ADN','Amidon','Eau'],0,'L’ADN est le support moléculaire de l’information génétique.'),
    _Unit('T1 • Physique-Chimie','Réactions, quantité de matière et solutions','La mole est l’unité de quantité de matière. La relation n=m/M relie quantité, masse et masse molaire. Une équation chimique équilibrée respecte la conservation des atomes et de la charge.','Pour 18 g d’eau et M=18 g/mol, n=1 mol.','Quelle relation relie n, m et M ?',['n=m/M','n=m×M','n=M/m'],0,'La quantité de matière est la masse divisée par la masse molaire.'),
    _Unit('T1 • Histoire-Géographie','Transformations politiques et dynamiques mondiales','L’étude historique met en relation événements, acteurs, causes et conséquences. En géographie, les territoires sont marqués par des flux, des réseaux et des inégalités. Une composition doit mobiliser des connaissances précises et organiser les exemples.','Une étude de document commence par identifier sa nature, son auteur, sa date et son contexte.','Quel réflexe est essentiel avant d’interpréter un document ?',['Identifier sa source et son contexte','Ignorer sa date','Lire uniquement sa légende'],0,'La source et le contexte permettent d’évaluer la portée du document.'),
    _Unit('T2 • Français','Roman, théâtre et commentaire composé','Le commentaire composé organise l’analyse autour d’axes cohérents. Il relie les procédés d’écriture à leurs effets et au sens du texte. Au théâtre, dialogue, didascalies, conflit et double énonciation contribuent à la représentation.','Un axe de commentaire formule une idée d’analyse, pas une simple liste de procédés.','Que doit expliquer un commentaire littéraire ?',['Le sens et les effets des procédés','Uniquement la biographie de l’auteur','Seulement le nombre de lignes'],0,'Le commentaire interprète les choix d’écriture et leurs effets.'),
    _Unit('T2 • Mathématiques','Suites numériques et dérivation','Une suite associe un terme à chaque entier naturel de son domaine. Une suite arithmétique ajoute une constante ; une suite géométrique multiplie par une constante. La dérivée renseigne sur les variations d’une fonction.','Suite arithmétique de premier terme 3 et raison 2 : u4=9 si u0=3.','Une suite arithmétique vérifie u0=4 et r=3. Quelle est u2 ?',['7','10','13'],1,'u2 = u0 + 2r = 4 + 6 = 10.'),
    _Unit('T2 • Anglais','Relative clauses and reported speech','Les propositions relatives précisent un nom avec who, which ou that. Le discours rapporté reformule les paroles et peut entraîner un recul des temps. La précision grammaticale améliore les écrits académiques.','The student who won the prize is my friend.','Which word can introduce a relative clause about a person?',['who','whereas','because'],0,'Who peut introduire une relative dont l’antécédent est une personne.'),
    _Unit('T2 • SVT','Immunité et fonctionnement de l’organisme','Le système immunitaire reconnaît et combat des agents étrangers. Les barrières naturelles, l’inflammation et les réponses immunitaires spécifiques participent à la défense. La vaccination prépare une mémoire immunitaire.','Les lymphocytes participent à des réponses immunitaires spécifiques.','Quel est l’objectif de la vaccination ?',['Préparer une réponse immunitaire','Remplacer tous les organes','Empêcher toute respiration'],0,'La vaccination prépare le système immunitaire à reconnaître un agent pathogène.'),
    _Unit('T2 • Physique-Chimie','Mécanique, énergie et circuits','Le mouvement se décrit dans un référentiel. Une force est caractérisée par direction, sens, valeur et point d’application. L’énergie électrique peut être convertie en énergie mécanique, thermique ou lumineuse.','La résultante des forces permet d’étudier l’évolution du mouvement.','Quelle grandeur caractérise l’action mécanique d’un objet sur un autre ?',['Force','Masse volumique uniquement','Température'],0,'Une force modélise une action mécanique.'),
    _Unit('T2 • Histoire-Géographie','Économie, mondialisation et territoires','La mondialisation organise des flux de marchandises, capitaux, personnes et informations. Les territoires ne bénéficient pas tous des mêmes connexions. L’analyse doit changer d’échelle et comparer les acteurs et les effets.','Une façade maritime concentre souvent ports, industries et réseaux logistiques.','Quel flux est associé à la mondialisation ?',['Flux de marchandises','Uniquement les nuages','Aucun échange'],0,'Les échanges de marchandises constituent un flux majeur.'),
    _Unit('T3 • Français','Dissertation et maîtrise de l’expression','Une dissertation formule une problématique et construit une démonstration. Chaque partie répond à un aspect de la question et s’appuie sur des exemples pertinents. La conclusion répond au sujet sans introduire une nouvelle démonstration.','Un plan équilibré évite les répétitions et fait progresser le raisonnement.','Quel est le rôle de la conclusion ?',['Répondre au problème posé et faire le bilan','Ajouter un sujet sans rapport','Remplacer l’introduction'],0,'La conclusion synthétise la réponse apportée à la problématique.'),
    _Unit('T3 • Mathématiques','Probabilités, statistiques et synthèse','Une variable aléatoire associe une valeur numérique à chaque issue d’une expérience aléatoire. L’espérance donne une moyenne théorique. Les statistiques décrivent une série par moyenne, médiane, dispersion et représentations.','Pour deux issues équiprobables donnant 0 et 10, l’espérance vaut 5.','Une variable vaut 2 ou 8 avec probabilité 1/2 chacune. Son espérance vaut…',['4','5','10'],1,'E=2×1/2+8×1/2=5.'),
    _Unit('T3 • Anglais','Academic writing and conditional structures','Les conditionnels expriment des hypothèses réelles ou imaginaires. Le second conditional utilise if + past simple, would + base verbale. Un essai clair comporte une introduction, des paragraphes argumentés et une conclusion.','If I had more time, I would learn another language.','Choose the correct second conditional.',['If I have time, I would go.','If I had time, I would go.','If I would have time, I go.'],1,'Le second conditional utilise le past simple après if et would dans la principale.'),
    _Unit('T3 • SVT','Écosystèmes et enjeux environnementaux','Les écosystèmes reposent sur des interactions entre organismes et milieu. Les cycles de matière et les flux d’énergie structurent leur fonctionnement. Les activités humaines modifient les habitats, les ressources et le climat.','La biodiversité inclut diversité des espèces, diversité génétique et diversité des écosystèmes.','Quelle action contribue à préserver les écosystèmes ?',['Restaurer les habitats dégradés','Polluer les cours d’eau','Surexploiter les espèces'],0,'La restauration des habitats aide les populations et les interactions écologiques.'),
    _Unit('T3 • Physique-Chimie','Ondes, signaux et bilan expérimental','Une onde transporte de l’énergie sans transport global de matière. La fréquence se mesure en hertz et la période en secondes. Un compte rendu rigoureux distingue observation, interprétation et conclusion.','La fréquence et la période sont liées par f=1/T.','Une onde a une période de 0,02 s. Sa fréquence vaut…',['20 Hz','50 Hz','200 Hz'],1,'f=1/0,02=50 Hz.'),
    _Unit('T3 • Histoire-Géographie','Développement durable et préparation aux examens','Le développement durable articule économie, société et environnement. Une composition exige une problématique, un plan, des exemples localisés et une conclusion. Les documents doivent être cités et confrontés avec les connaissances.','Une bonne copie répond précisément au sujet et justifie les affirmations.','Quelles dimensions associe le développement durable ?',['Économique, sociale, environnementale','Uniquement financière','Uniquement politique'],0,'Les trois dimensions doivent être prises en compte ensemble.'),
  ];
  static int get unitCount => _units.length;
  static int get lessonCount => _units.length;
  static List<Exercise> assessmentExercisesForTerm(int term, {String? subjectName}) {
    final result = <Exercise>[];
    for (var i = 0; i < _units.length; i++) {
      final unit = _units[i];
      if (!unit.title.startsWith('T$term •')) continue;
      if (subjectName != null && !_matches(unit.title, subjectName)) continue;
      result.add(Exercise(id: 'prem_t${term}_u${i}', lessonId: 'prem_t${term}_u${i}', question: unit.question, options: unit.options, correctIndex: unit.answer, explanation: unit.explanation));
    }
    return result;
  }
  static bool _matches(String title, String subject) {
    final t = title.toLowerCase(), s = subject.toLowerCase();
    if (s.contains('français') || s.contains('francais') || s.contains('littérature')) return t.contains('français');
    if (s.contains('math')) return t.contains('mathématiques');
    if (s.contains('anglais') || s.contains('english')) return t.contains('anglais');
    if (s.contains('svt') || s.contains('science') || s.contains('biologie')) return t.contains('svt');
    if (s.contains('physique') || s.contains('chimie')) return t.contains('physique-chimie');
    if (s.contains('histoire') || s.contains('géographie') || s.contains('education') || s.contains('éducation') || s.contains('emc')) return t.contains('histoire-géographie');
    return false;
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Complément Première • Série $series')),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      Card(child: Padding(padding: const EdgeInsets.all(16), child: Text('Parcours : ${track.label} • Série $series\n${unitCount} unités communes • ${lessonCount} leçons • 3 trimestres\nLes enseignements spécifiques de la série restent accessibles dans la liste des matières.', style: const TextStyle(fontWeight: FontWeight.w600)))),
      for (final unit in _units) _UnitTile(unit: unit),
    ]),
  );
}
class _Unit {
  final String title, objective, content, example, question;
  final List<String> options;
  final int answer;
  final String explanation;
  const _Unit(this.title, this.objective, this.content, this.example, this.question, this.options, this.answer, this.explanation);
}
class _UnitTile extends StatefulWidget {
  final _Unit unit;
  const _UnitTile({required this.unit});
  @override State<_UnitTile> createState() => _UnitTileState();
}
class _UnitTileState extends State<_UnitTile> {
  int? choice;
  bool checked = false;
  @override Widget build(BuildContext context) {
    final unit = widget.unit;
    return Card(margin: const EdgeInsets.only(bottom: 10), child: ExpansionTile(
      title: Text(unit.title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(unit.objective),
      children: [Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(unit.content), const SizedBox(height: 8),
        Text('Exemple : ${unit.example}', style: const TextStyle(fontStyle: FontStyle.italic)),
        const SizedBox(height: 12), Text(unit.question, style: const TextStyle(fontWeight: FontWeight.bold)),
        for (var i = 0; i < unit.options.length; i++) RadioListTile<int>(dense: true, contentPadding: EdgeInsets.zero, value: i, groupValue: choice, title: Text(unit.options[i]), onChanged: checked ? null : (value) => setState(() => choice = value)),
        FilledButton.tonal(onPressed: choice == null ? null : () => setState(() => checked = true), child: const Text('Vérifier ma réponse')),
        if (checked) Text('${choice == unit.answer ? 'Bonne réponse ! ' : 'À revoir. Bonne réponse : ${unit.options[unit.answer]}. '}${unit.explanation}', style: TextStyle(fontWeight: FontWeight.w600, color: choice == unit.answer ? Colors.green.shade800 : Theme.of(context).colorScheme.error)),
        if (checked) TextButton(onPressed: () => setState(() { choice = null; checked = false; }), child: const Text('Recommencer')),
      ]))],
    ));
  }
}
