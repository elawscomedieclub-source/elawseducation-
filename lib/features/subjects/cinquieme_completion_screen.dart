import 'package:flutter/material.dart';
import '../../data/models/models.dart';

/// Parcours annuel complémentaire de 5e : 18 unités, six par trimestre.
class CinquiemeCompletionScreen extends StatelessWidget {
  const CinquiemeCompletionScreen({super.key});
  static const _units = <_Unit>[
    _Unit('T1 • Français','Le récit, les temps et les fonctions','Un récit organise des événements dans un ordre compréhensible. Le narrateur raconte à la première ou à la troisième personne. Le passé simple présente souvent les actions de premier plan et l’imparfait les descriptions ou habitudes. Le sujet commande l’accord du verbe.','La pluie tombait (description) quand le voyageur entra (action).','Dans cette phrase, quel temps exprime l’action principale : « Il marchait quand il aperçut la maison » ?',['Imparfait','Passé simple','Futur'],1,'Aperçut est au passé simple et marque l’action soudaine.'),
    _Unit('T1 • Mathématiques','Nombres relatifs et opérations','Un nombre relatif est positif, négatif ou nul. Sur une droite graduée, les nombres augmentent vers la droite. Pour additionner deux nombres de même signe, on additionne leurs distances à zéro et on garde le signe ; pour des signes contraires, on soustrait les distances.','−7 + 3 = −4 ; (−2) × 5 = −10.','Calcule −8 + 13.',['−21','5','−5'],1,'Les signes sont différents : 13 − 8 = 5, avec le signe du nombre de plus grande valeur absolue.'),
    _Unit('T1 • Anglais','Daily routines and present simple','Le present simple exprime les habitudes et les vérités générales. À la troisième personne du singulier, on ajoute généralement -s ou -es. Les questions utilisent do ou does ; la négation utilise do not ou does not.','She studies every evening. Does he play football?','Choose the correct sentence.',['He go to school.','He goes to school.','He going to school.'],1,'Avec he, le verbe prend généralement -s : goes.'),
    _Unit('T1 • SVT','Nutrition des plantes et organisation des êtres vivants','Les végétaux chlorophylliens fabriquent leur matière organique à partir d’eau, de sels minéraux et de dioxyde de carbone grâce à la lumière. Les organes d’une plante ont des fonctions complémentaires : racines, tige et feuilles.','Les racines absorbent l’eau et les sels minéraux du sol.','Quel organe absorbe principalement l’eau du sol ?',['La fleur','La racine','Le fruit'],1,'Les racines prélèvent l’eau et les sels minéraux.'),
    _Unit('T1 • Physique-Chimie','Masse, volume et états de la matière','La matière existe principalement sous les états solide, liquide et gazeux. La masse se mesure avec une balance, le volume avec une éprouvette graduée. Lors d’un changement d’état, la nature chimique du corps reste la même.','Un glaçon qui fond devient de l’eau liquide : c’est la fusion.','Quelle unité convient pour mesurer le volume d’un liquide ?',['Le litre','Le kilogramme','Le degré Celsius'],0,'Le litre et le millilitre sont des unités de volume.'),
    _Unit('T1 • Histoire-Géographie-EMC','Repères historiques et géographiques du Togo','Une carte permet de localiser des lieux grâce à son titre, sa légende, son échelle et son orientation. Le Togo se situe en Afrique de l’Ouest et possède une façade sur le golfe de Guinée. Une frise classe les événements du plus ancien au plus récent.','Sur une carte, la flèche du nord aide à orienter les directions.','Quel océan borde le sud du Togo ?',['Océan Indien','Océan Atlantique','Océan Pacifique'],1,'Le littoral togolais donne sur le golfe de Guinée, dans l’Atlantique.'),
    _Unit('T2 • Français','Accords, propositions et discours rapporté','Dans le groupe nominal, déterminant, nom et adjectif s’accordent en genre et en nombre. Une proposition contient un verbe conjugué. Le discours direct rapporte les paroles telles qu’elles sont prononcées ; le discours indirect les intègre au récit.','Les jeunes filles attentives écoutent. « Il vient », dit-elle : elle dit qu’il vient.','Quelle phrase est correctement accordée ?',['Ces élèves sérieux travaillent.','Ces élèves sérieuse travaille.','Cet élèves sérieux travaille.'],0,'Élèves est masculin pluriel : ces et sérieux s’accordent au pluriel.'),
    _Unit('T2 • Mathématiques','Fractions, calcul littéral et proportionnalité','Pour additionner des fractions, on les réduit au même dénominateur. Une expression littérale contient des lettres qui représentent des nombres. Deux grandeurs sont proportionnelles si le quotient correspondant reste constant.','1/3 + 1/6 = 2/6 + 1/6 = 1/2 ; si y = 3x, alors x = 4 donne y = 12.','Calcule 2/5 + 1/5.',['3/5','2/10','3/10'],0,'Les dénominateurs sont identiques : on additionne les numérateurs.'),
    _Unit('T2 • Anglais','Past simple and describing past events','Le past simple décrit une action terminée dans le passé. Les verbes réguliers prennent souvent -ed ; les verbes irréguliers ont une forme particulière. Les questions et négations utilisent did, suivi de la base verbale.','We visited Kpalimé last year. Did you see the waterfall?','Choose the past form of « go ».',['goed','went','goes'],1,'Go est irrégulier : son prétérit est went.'),
    _Unit('T2 • SVT','Respiration et échanges gazeux','La respiration permet aux organismes de réaliser des échanges gazeux avec leur milieu. Chez l’être humain, l’air circule jusqu’aux poumons ; le dioxygène passe dans le sang au niveau des alvéoles pulmonaires et le dioxyde de carbone est rejeté.','L’activité physique augmente les besoins des muscles en dioxygène.','Quel gaz passe des alvéoles pulmonaires vers le sang ?',['Dioxygène','Azote uniquement','Vapeur d’eau uniquement'],0,'Le dioxygène diffuse des alvéoles vers les capillaires sanguins.'),
    _Unit('T2 • Physique-Chimie','Mélanges, solutions et séparation','Un mélange homogène présente un aspect uniforme ; un mélange hétérogène laisse distinguer plusieurs constituants. La décantation, la filtration et l’évaporation permettent de séparer certains mélanges.','Le sable dans l’eau forme un mélange hétérogène que l’on peut filtrer.','Quelle technique retient le sable et laisse passer l’eau ?',['Filtration','Fusion','Aimantation dans tous les cas'],0,'Le filtre retient les particules solides insolubles.'),
    _Unit('T2 • Histoire-Géographie-EMC','Population, activités et organisation du territoire','La population se répartit inégalement selon les ressources, les emplois, les transports et les services. L’agriculture, l’artisanat, le commerce et l’industrie participent à l’économie. Le citoyen respecte les biens publics et les droits d’autrui.','Un marché relie producteurs, commerçants et consommateurs.','Quel indicateur correspond au nombre d’habitants d’un territoire ?',['La population','La température','La superficie seule'],0,'La population désigne l’ensemble des habitants d’un territoire.'),
    _Unit('T3 • Français','Argumentation, poésie et rédaction','Un texte argumentatif défend une opinion à l’aide d’arguments et d’exemples. Les connecteurs organisent le raisonnement : d’abord, ensuite, cependant, donc. Un poème peut jouer sur les images, les sonorités et le rythme.','Thèse : protéger les arbres ; argument : ils limitent l’érosion ; exemple : les haies retiennent le sol.','Quel connecteur introduit une opposition ?',['Donc','Cependant','Ainsi'],1,'Cependant annonce une opposition ou une nuance.'),
    _Unit('T3 • Mathématiques','Triangles, angles, périmètres et aires','La somme des angles d’un triangle vaut 180°. Le périmètre est la longueur du contour. L’aire mesure la surface : pour un triangle, A = base × hauteur ÷ 2. Les unités d’aire sont au carré.','Triangle de base 8 cm et hauteur 5 cm : A = 8 × 5 ÷ 2 = 20 cm².','Un triangle a deux angles de 50° et 60°. Le troisième vaut…',['70°','90°','110°'],0,'180° − 50° − 60° = 70°.'),
    _Unit('T3 • Anglais','Future forms and giving advice','Will sert notamment à exprimer une décision ou une prévision. Be going to exprime souvent un projet ou une intention. Should permet de donner un conseil ; must exprime une obligation forte.','You should revise. We are going to visit Lomé tomorrow.','Which sentence gives advice?',['You should drink water.','I drank water yesterday.','Water is cold.'],0,'Should sert à conseiller : tu devrais boire de l’eau.'),
    _Unit('T3 • SVT','Reproduction, santé et protection de l’environnement','La reproduction assure la continuité des espèces. La puberté correspond à des transformations physiques et physiologiques. L’hygiène, la prévention et l’accès à une information fiable contribuent à la santé. La biodiversité dépend aussi de la protection des habitats.','Protéger une mare et éviter d’y jeter des déchets préserve les organismes qui y vivent.','Quel comportement protège la biodiversité ?',['Détruire les habitats','Polluer les cours d’eau','Préserver les habitats naturels'],2,'La conservation des habitats protège les espèces et les équilibres écologiques.'),
    _Unit('T3 • Physique-Chimie','Électricité, circuits et sécurité','Un circuit électrique simple comporte un générateur, des conducteurs et un récepteur. Le courant circule dans un circuit fermé. Un interrupteur ouvre ou ferme le circuit. Il ne faut jamais manipuler les prises ou fils dénudés.','Une pile reliée correctement à une lampe par des fils forme un circuit fermé.','Dans quel cas la lampe peut-elle s’allumer ?',['Circuit ouvert','Circuit fermé avec générateur','Fils non reliés'],1,'Le circuit doit être fermé et comporter un générateur fonctionnel.'),
    _Unit('T3 • Histoire-Géographie-EMC','Développement durable et préparation au cycle suivant','Le développement durable cherche à concilier protection de l’environnement, progrès social et activités économiques. Les risques naturels et les actions humaines doivent être étudiés à partir d’observations et de documents. Pour préparer la classe suivante, on révise les méthodes de lecture, de calcul et de rédaction.','Économiser l’eau, planter des arbres et réduire les déchets sont des gestes responsables.','Quel principe correspond au développement durable ?',['Utiliser les ressources sans limite','Répondre aux besoins actuels sans compromettre l’avenir','Supprimer toute activité humaine'],1,'Le développement durable protège les possibilités des générations futures.'),
  ];

  static int get unitCount => _units.length;
  static int get lessonCount => _units.length;
  static List<Exercise> assessmentExercisesForTerm(int term, {String? subjectName}) {
    final prefix = 'T$term •';
    final result = <Exercise>[];
    for (var i = 0; i < _units.length; i++) {
      final unit = _units[i];
      if (!unit.title.startsWith(prefix)) continue;
      if (subjectName != null && !_matches(unit.title, subjectName)) continue;
      result.add(Exercise(id: 'five_t${term}_u${i}', lessonId: 'five_t${term}_u${i}', question: unit.question, options: unit.options, correctIndex: unit.answer, explanation: unit.explanation));
    }
    return result;
  }
  static bool _matches(String title, String subject) {
    final t = title.toLowerCase(), s = subject.toLowerCase();
    if (s.contains('français') || s.contains('francais')) return t.contains('français');
    if (s.contains('math')) return t.contains('mathématiques');
    if (s.contains('anglais') || s.contains('english')) return t.contains('anglais');
    if (s.contains('svt') || s.contains('science')) return t.contains('svt');
    if (s.contains('physique') || s.contains('chimie') || s.contains('technologie')) return t.contains('physique-chimie');
    if (s.contains('histoire') || s.contains('géographie') || s.contains('education') || s.contains('éducation') || s.contains('emc')) return t.contains('histoire-géographie-emc');
    return false;
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Complément 5ème • Année complète')),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      Card(child: Padding(padding: const EdgeInsets.all(16), child: Text('${unitCount} unités • ${lessonCount} leçons • 3 trimestres\nLis le cours, étudie l’exemple, réponds puis consulte la correction.', style: const TextStyle(fontWeight: FontWeight.w600)))),
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
