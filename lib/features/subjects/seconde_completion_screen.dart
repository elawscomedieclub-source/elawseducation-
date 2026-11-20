import 'package:flutter/material.dart';
import '../../data/models/models.dart';

/// Socle annuel de Seconde : cours transversaux et repères de spécialisation.
class SecondeCompletionScreen extends StatelessWidget {
  final SchoolTrack track;
  final String series;
  const SecondeCompletionScreen({super.key, required this.track, required this.series});
  static const _units = <_Unit>[
    _Unit('T1 • Français','Méthodes de lecture et étude du roman','Analyser un récit demande de distinguer auteur, narrateur et personnage, de repérer le point de vue, la chronologie et les procédés d’écriture. Une citation doit être courte, exacte et expliquée.','Pour commenter une citation, présenter l’idée, citer le passage puis expliquer son effet.','Qui raconte un récit ?',['Le narrateur','Toujours l’auteur réel','Le lecteur'],0,'Le narrateur est la voix qui raconte ; il ne se confond pas nécessairement avec l’auteur.'),
    _Unit('T1 • Mathématiques','Fonctions, intervalles et calcul algébrique','Une fonction associe à chaque nombre de son domaine une unique image. On note f(x) l’image de x. Les intervalles décrivent des ensembles de réels ; développer et factoriser permettent de transformer des expressions.','Si f(x)=2x+3, alors f(4)=11.','Pour f(x)=3x−2, quelle est l’image de 5 ?',['10','13','15'],1,'f(5)=3×5−2=13.'),
    _Unit('T1 • Anglais','Tenses, description and communication','Les temps verbaux situent les actions. Le present simple décrit habitudes et vérités ; le present continuous décrit une action en cours ; le past simple présente un fait terminé. Adapter le registre au destinataire.','She usually walks, but today she is taking a bus.','Choose the correct form: Listen! The baby …',['cries','is crying','cry'],1,'Listen! indique une action en cours : is crying.'),
    _Unit('T1 • SVT','Cellule, organisation du vivant et biomolécules','La cellule est l’unité structurale et fonctionnelle du vivant. La membrane délimite la cellule, le cytoplasme contient des structures et le noyau porte l’information génétique chez les cellules eucaryotes. Les biomolécules participent au fonctionnement cellulaire.','Les cellules végétales possèdent notamment une paroi et des chloroplastes.','Quelle structure contient l’essentiel de l’ADN dans une cellule eucaryote ?',['Le noyau','La paroi','La membrane seule'],0,'Le noyau contient les chromosomes et l’essentiel de l’ADN.'),
    _Unit('T1 • Physique-Chimie','Mesures, unités et constitution de la matière','Une mesure doit préciser une valeur et une unité. La matière est constituée d’atomes ; les molécules sont des assemblages d’atomes. Les changements d’état sont des transformations physiques.','La masse se mesure en kilogrammes et le volume en mètres cubes ou litres.','Quelle est l’unité SI de la masse ?',['Le kilogramme','Le litre','Le newton'],0,'L’unité SI de masse est le kilogramme (kg).'),
    _Unit('T1 • Histoire-Géographie','Humanisme, Renaissance et dynamiques territoriales','L’humanisme et la Renaissance renouvellent les arts, les sciences et la diffusion des savoirs en Europe. En géographie, analyser un territoire implique de décrire les populations, les activités, les réseaux et les inégalités spatiales.','Une carte thématique doit être lue avec son titre, sa légende et son échelle.','Quel phénomène favorise la diffusion des idées à la Renaissance ?',['L’imprimerie','La disparition des livres','La fermeture des écoles'],0,'L’imprimerie accélère la reproduction et la circulation des textes.'),
    _Unit('T2 • Français','Poésie, théâtre et outils de l’analyse littéraire','La poésie travaille les images, les rythmes, les sonorités et les formes. Le théâtre associe texte, dialogue, didascalies et représentation. Une analyse organise des observations en paragraphes cohérents et s’appuie sur des procédés précis.','Une métaphore rapproche deux réalités sans outil de comparaison.','Quelle figure rapproche deux éléments sans « comme » ?',['Métaphore','Comparaison','Énumération'],0,'La métaphore établit une assimilation directe.'),
    _Unit('T2 • Mathématiques','Équations, inéquations et géométrie analytique','Une équation se résout par transformations équivalentes. Une inéquation définit un ensemble de solutions. Dans un repère, les coordonnées localisent un point et permettent de calculer des déplacements et des distances simples.','2x+6=14 donne x=4.','Résous 4x−8=12.',['x=1','x=5','x=8'],1,'4x=20 donc x=5.'),
    _Unit('T2 • Anglais','Comparatives, superlatives and argumentation','Le comparatif compare deux éléments : taller than, more interesting than. Le superlatif exprime un degré extrême : the tallest, the most useful. Pour argumenter, présenter une opinion et la justifier avec because, although et however.','This book is more interesting than that one.','Choose the correct superlative: Mount Everest is … mountain.',['the highest','higher','high'],0,'The highest est le superlatif de high.'),
    _Unit('T2 • SVT','Nutrition, métabolisme et échanges','Les organismes échangent matière et énergie avec leur environnement. La digestion rend les nutriments absorbables ; la respiration cellulaire libère de l’énergie utilisable. Les végétaux chlorophylliens réalisent la photosynthèse.','Les nutriments passent de l’intestin grêle vers le sang.','Où se fait l’essentiel de l’absorption des nutriments ?',['Intestin grêle','Œsophage','Trachée'],0,'La paroi de l’intestin grêle permet l’absorption des nutriments.'),
    _Unit('T2 • Physique-Chimie','Solutions, concentration et transformations chimiques','Une solution est un mélange homogène constitué d’un solvant et d’un ou plusieurs solutés. La concentration massique est le quotient de la masse de soluté par le volume de solution. Une réaction chimique transforme les réactifs en produits.','10 g de sel dans 2 L de solution donnent 5 g/L.','La concentration massique de 12 g de soluté dans 3 L vaut…',['3 g/L','4 g/L','36 g/L'],1,'C = m/V = 12/3 = 4 g/L.'),
    _Unit('T2 • Histoire-Géographie','Population, mobilités et urbanisation','Les dynamiques démographiques combinent natalité, mortalité et migrations. L’urbanisation transforme les paysages et crée des besoins en logements, transports, eau et services. Les cartes et graphiques permettent de comparer les territoires.','Un solde migratoire positif signifie que les arrivées dépassent les départs.','Que signifie un solde migratoire positif ?',['Plus d’arrivées que de départs','Plus de départs que d’arrivées','Aucune migration'],0,'Le territoire gagne des habitants par les migrations.'),
    _Unit('T3 • Français','Argumentation, dissertation et expression écrite','Une dissertation répond à une question par une réflexion organisée : introduction, développement structuré et conclusion. Chaque paragraphe développe une idée, l’explique et l’illustre. La relecture vérifie la cohérence et la langue.','Une introduction présente le sujet, pose la problématique et annonce le plan.','Quel élément annonce les grandes parties du raisonnement ?',['L’annonce du plan','La signature','La bibliographie uniquement'],0,'L’annonce du plan indique l’organisation du développement.'),
    _Unit('T3 • Mathématiques','Statistiques, probabilités et fonctions','La moyenne résume une série de valeurs ; la médiane partage une série ordonnée en deux groupes de même effectif. Une probabilité est comprise entre 0 et 1. Les représentations graphiques aident à étudier une fonction.','Pour un dé équilibré, P(obtenir 6)=1/6.','Quelle est la probabilité d’obtenir un nombre pair sur un dé équilibré ?',['1/6','1/2','2/3'],1,'Les issues paires sont 2, 4 et 6 : 3 sur 6, soit 1/2.'),
    _Unit('T3 • Anglais','Conditionals, modal verbs and formal writing','Le first conditional décrit une conséquence future possible. Les modaux can, must, should et might expriment capacité, obligation, conseil et possibilité. Une lettre formelle respecte la structure et un registre poli.','If we work together, we will finish on time.','Choose the correct sentence.',['If it rains, we will stay inside.','If it will rain, we stay inside.','If it raining, we stayed inside.'],0,'La proposition introduite par if est au présent simple.'),
    _Unit('T3 • SVT','Écosystèmes, biodiversité et santé','Un écosystème associe des êtres vivants et leur milieu. Les interactions alimentaires et les facteurs physiques structurent son fonctionnement. La biodiversité contribue à la stabilité des milieux ; les activités humaines peuvent la préserver ou la menacer.','Une chaîne alimentaire montre des relations de nutrition entre organismes.','Quel facteur peut menacer la biodiversité ?',['Destruction des habitats','Protection des forêts','Restauration des mares'],0,'La destruction des habitats réduit les ressources et les lieux de vie des espèces.'),
    _Unit('T3 • Physique-Chimie','Mouvement, forces et énergie','La vitesse moyenne est v=d/t. Une force peut modifier la vitesse, la direction ou la forme d’un objet. L’énergie se conserve lors des transformations, même si elle change de forme et se dissipe en partie.','Un objet parcourt 60 m en 10 s : v=6 m/s.','Une voiture parcourt 120 km en 2 h. Sa vitesse moyenne est…',['40 km/h','60 km/h','240 km/h'],1,'v = 120 ÷ 2 = 60 km/h.'),
    _Unit('T3 • Histoire-Géographie','Mondialisation, développement et citoyenneté','La mondialisation met en relation les territoires par les échanges, les transports, les communications et les flux financiers. Le développement se mesure par des indicateurs multiples. Une analyse géographique relie échelles locale, nationale et mondiale.','Un port est une interface entre les échanges maritimes et les réseaux terrestres.','Quel réseau facilite les échanges mondiaux ?',['Réseaux de transport et de communication','Uniquement les sentiers isolés','Aucun réseau'],0,'Les transports et communications connectent les territoires.'),
  ];
  static int get unitCount => _units.length;
  static int get lessonCount => _units.length;
  static List<Exercise> assessmentExercisesForTerm(int term, {String? subjectName}) {
    final result = <Exercise>[];
    for (var i = 0; i < _units.length; i++) {
      final unit = _units[i];
      if (!unit.title.startsWith('T$term •')) continue;
      if (subjectName != null && !_matches(unit.title, subjectName)) continue;
      result.add(Exercise(id: 'sec_t${term}_u${i}', lessonId: 'sec_t${term}_u${i}', question: unit.question, options: unit.options, correctIndex: unit.answer, explanation: unit.explanation));
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
    appBar: AppBar(title: Text('Complément Seconde • Série $series')),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      Card(child: Padding(padding: const EdgeInsets.all(16), child: Text('Parcours : ${track.label} • Série $series\n${unitCount} unités communes • ${lessonCount} leçons • 3 trimestres\nLes cours communs sont complétés par les matières propres à la série dans la liste des matières.', style: const TextStyle(fontWeight: FontWeight.w600)))),
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
