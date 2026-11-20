import 'package:flutter/material.dart';
import '../../data/models/models.dart';

/// Tronc commun annuel de Terminale, avec préparation progressive au BAC II.
class TerminaleCompletionScreen extends StatelessWidget {
  final SchoolTrack track;
  final String series;
  const TerminaleCompletionScreen({super.key, required this.track, required this.series});
  static const _units = <_Unit>[
    _Unit('T1 • Français','Méthode de dissertation et problématique','La dissertation répond à une question par une démonstration structurée. Définir les termes du sujet, dégager une tension, formuler une problématique et annoncer un plan cohérent. Chaque argument doit être justifié et illustré.','Un plan dialectique peut examiner une thèse, ses limites puis proposer un dépassement.','Quel élément guide toute la dissertation ?',['La problématique','La longueur de la copie','Le nombre de citations'],0,'La problématique oriente la démonstration et organise le plan.'),
    _Unit('T1 • Mathématiques','Limites et continuité des fonctions','La limite décrit le comportement d’une fonction lorsque x approche une valeur ou l’infini. La continuité en un point signifie que la limite y est égale à la valeur de la fonction. Les tableaux de variations résument le comportement.','Pour f(x)=x², lorsque x tend vers 3, f(x) tend vers 9.','Si f est continue en a, que vaut lim f(x) quand x tend vers a ?',['f(a)','0 toujours','L’infini toujours'],0,'La continuité donne lim f(x)=f(a).'),
    _Unit('T1 • Anglais','Advanced reading, synthesis and essay','Une synthèse compare les idées principales de plusieurs documents sans les juxtaposer. Un essai défend une position avec une introduction claire, des arguments développés et une conclusion. Les connecteurs assurent la cohésion.','On the one hand… on the other hand… permet de présenter deux aspects.','Which expression introduces a contrast?',['However','Furthermore','For example'],0,'However introduit une opposition ou une nuance.'),
    _Unit('T1 • SVT','Génétique moléculaire et évolution','L’ADN est constitué de nucléotides et porte des séquences de gènes. La réplication copie l’information génétique avant la division cellulaire. Les mutations créent de la diversité ; la sélection naturelle modifie la fréquence des caractères héréditaires au fil des générations.','Une mutation peut être neutre, défavorable ou avantageuse selon l’environnement.','Quel processus copie l’ADN avant une division cellulaire ?',['Réplication','Digestion','Fermentation'],0,'La réplication permet de copier l’ADN.'),
    _Unit('T1 • Physique-Chimie','Quantité de matière et équilibres chimiques','Une transformation chimique se décrit par une équation équilibrée. L’avancement permet de suivre les quantités de réactifs et de produits. À l’équilibre chimique, les réactions directe et inverse se poursuivent à vitesses égales dans un système fermé.','L’équation 2H₂ + O₂ → 2H₂O respecte la conservation des atomes.','Pourquoi équilibrer une équation chimique ?',['Respecter la conservation des atomes','Changer les éléments chimiques','Supprimer les produits'],0,'Le nombre de chaque type d’atome doit être identique des deux côtés.'),
    _Unit('T1 • Histoire-Géographie','Relations internationales et enjeux contemporains','L’analyse géopolitique étudie les acteurs, les intérêts, les territoires et les rapports de force. Les documents doivent être contextualisés et confrontés. Les enjeux contemporains incluent ressources, migrations, conflits, coopération et développement.','Une organisation internationale peut faciliter la coopération entre États.','Quel élément faut-il identifier dans une analyse géopolitique ?',['Acteurs et intérêts','Uniquement les couleurs','La longueur du document'],0,'Les acteurs et leurs intérêts aident à expliquer les relations de pouvoir.'),
    _Unit('T2 • Français','Littérature, interprétation et expression personnelle','L’interprétation littéraire confronte le texte, sa forme, son contexte et ses effets. Les citations servent de preuves et doivent être commentées. L’expression personnelle doit rester argumentée, nuancée et organisée.','Une citation n’est utile que si elle soutient une interprétation expliquée.','Que faut-il faire après une citation dans une analyse ?',['Expliquer son rapport à l’idée','Passer immédiatement au sujet suivant','La répéter sans commentaire'],0,'Le commentaire montre ce que la citation prouve et comment elle fonctionne.'),
    _Unit('T2 • Mathématiques','Dérivation, primitives et intégrales','La dérivée mesure le taux de variation local et permet d’étudier les variations. Une primitive F d’une fonction f vérifie F’=f. L’intégrale peut représenter une aire algébrique sous une courbe.','Une primitive de 2x est x².','Quelle est une primitive de 3x² ?',['x³','6x','3x³'],0,'La dérivée de x³ est 3x².'),
    _Unit('T2 • Anglais','Nuance, modal verbs and formal debate','Les modaux expriment degré de certitude, obligation, possibilité ou conseil. Must have + participe passé exprime une déduction sur le passé ; might have exprime une possibilité. Un débat demande d’écouter et de répondre aux arguments.','She must have forgotten the meeting.','Which phrase expresses possibility about the past?',['might have missed','must miss','is missing'],0,'Might have + participe passé exprime une possibilité passée.'),
    _Unit('T2 • SVT','Immunité, régulation et santé','La réponse immunitaire spécifique implique reconnaissance d’antigènes, activation des lymphocytes et production d’effecteurs. Les mécanismes de régulation limitent les réactions excessives. La prévention repose sur vaccination, hygiène et suivi médical.','Les anticorps se lient spécifiquement à des antigènes.','Quelle cellule peut produire des anticorps après différenciation ?',['Plasmocyte','Globule rouge','Neurone'],0,'Les plasmocytes sont des cellules sécrétrices d’anticorps.'),
    _Unit('T2 • Physique-Chimie','Électricité, induction et énergie','Les phénomènes électriques peuvent être étudiés par les relations entre tension, intensité, résistance et puissance. Une variation de flux magnétique peut induire une tension. Les conversions énergétiques s’analysent avec rendement et pertes.','P=U×I permet de calculer la puissance électrique reçue.','Un appareil fonctionne sous 12 V avec 2 A. Sa puissance vaut…',['6 W','14 W','24 W'],2,'P=12×2=24 W.'),
    _Unit('T2 • Histoire-Géographie','Mondialisation, inégalités et développement','Les échanges mondiaux connectent les territoires mais les bénéfices et les contraintes sont inégalement répartis. Les indicateurs de développement combinent dimensions économiques, sociales et sanitaires. Les politiques publiques peuvent réduire certaines inégalités.','Comparer deux pays exige plusieurs indicateurs et un contexte.','Pourquoi utiliser plusieurs indicateurs de développement ?',['Pour rendre compte de dimensions différentes','Pour éviter toute comparaison','Pour ne mesurer que la population'],0,'Le développement est multidimensionnel.'),
    _Unit('T3 • Français','Synthèse finale et préparation à l’épreuve écrite','Une copie d’examen doit répondre exactement au sujet, respecter le genre demandé et suivre une progression logique. Gérer le temps : analyser le sujet, bâtir le plan, rédiger, puis réserver une relecture.','La relecture vérifie les accords, la ponctuation, les transitions et la réponse à la consigne.','Quelle étape doit être réservée avant de rendre la copie ?',['La relecture','L’ajout d’un nouveau sujet','La suppression de l’introduction'],0,'La relecture permet de corriger les erreurs et vérifier la cohérence.'),
    _Unit('T3 • Mathématiques','Probabilités conditionnelles et synthèse','Une probabilité conditionnelle P(A|B) étudie la probabilité de A sachant B. Pour des événements indépendants, P(A∩B)=P(A)P(B). Les raisonnements doivent préciser l’univers, les événements et les hypothèses.','Si A et B sont indépendants, P(A|B)=P(A).','Si A et B sont indépendants, quelle relation est vraie ?',['P(A∩B)=P(A)P(B)','P(A∩B)=P(A)+P(B)','P(A)=0 toujours'],0,'L’indépendance permet de multiplier les probabilités.'),
    _Unit('T3 • Anglais','Exam essay, synthesis and oral presentation','Une présentation orale suit une structure claire : introduction, points principaux, exemples et conclusion. Articuler les idées, parler distinctement et répondre avec précision. En essai, éviter les affirmations sans justification.','To conclude, the evidence suggests that… introduit une conclusion.','Which phrase is suitable to conclude an essay?',['To conclude','At first glance only','By the way'],0,'To conclude annonce clairement la conclusion.'),
    _Unit('T3 • SVT','Biodiversité, climat et responsabilité humaine','Le climat résulte d’interactions complexes entre atmosphère, océans, surfaces continentales et vivant. Les activités humaines influencent les émissions de gaz à effet de serre et les habitats. L’adaptation et l’atténuation sont complémentaires.','Réduire les émissions et protéger les écosystèmes sont deux leviers d’action.','Quel gaz contribue fortement à l’effet de serre d’origine humaine ?',['Dioxyde de carbone','Dioxygène','Argon'],0,'Le dioxyde de carbone est un gaz à effet de serre majeur lié aux activités humaines.'),
    _Unit('T3 • Physique-Chimie','Ondes, mécanique et résolution de problèmes','Les ondes mécaniques nécessitent un milieu matériel ; les ondes électromagnétiques peuvent se propager dans le vide. La mécanique relie forces et mouvement. Un problème se résout en identifiant données, inconnues, loi adaptée et unités.','Pour une onde, v=λf relie célérité, longueur d’onde et fréquence.','Une onde a λ=2 m et f=5 Hz. Sa célérité vaut…',['2,5 m/s','7 m/s','10 m/s'],2,'v=λf=2×5=10 m/s.'),
    _Unit('T3 • Histoire-Géographie','Citoyenneté mondiale et bilan des apprentissages','Les défis mondiaux nécessitent coopération, institutions, choix responsables et analyse critique des sources. Pour une composition, construire une problématique, hiérarchiser les arguments, mobiliser des exemples localisés et conclure clairement.','Une source fiable se vérifie par son auteur, sa date, sa méthode et sa corroboration.','Quel réflexe aide à vérifier une information ?',['Comparer plusieurs sources fiables','Partager sans lire','Ignorer l’auteur'],0,'La confrontation des sources permet de vérifier une information.'),
  ];
  static int get unitCount => _units.length;
  static int get lessonCount => _units.length;
  static List<Exercise> assessmentExercisesForTerm(int term, {String? subjectName}) {
    final result = <Exercise>[];
    for (var i = 0; i < _units.length; i++) {
      final unit = _units[i];
      if (!unit.title.startsWith('T$term •')) continue;
      if (subjectName != null && !_matches(unit.title, subjectName)) continue;
      result.add(Exercise(id: 'term_t${term}_u${i}', lessonId: 'term_t${term}_u${i}', question: unit.question, options: unit.options, correctIndex: unit.answer, explanation: unit.explanation));
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
    appBar: AppBar(title: Text('Complément Terminale • Série $series • BAC II')),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      Card(child: Padding(padding: const EdgeInsets.all(16), child: Text('Parcours : ${track.label} • Série $series\n${unitCount} unités de consolidation • ${lessonCount} leçons • 3 trimestres\nÀ compléter par les matières et épreuves spécifiques de la série.', style: const TextStyle(fontWeight: FontWeight.w600)))),
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
