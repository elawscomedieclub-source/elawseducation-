import 'package:flutter/material.dart';
import '../../data/models/models.dart';

/// Parcours annuel complémentaire de 4e : six unités par trimestre.
class QuatriemeCompletionScreen extends StatelessWidget {
  const QuatriemeCompletionScreen({super.key});
  static const _units = <_Unit>[
    _Unit('T1 • Français','Récit, description et valeurs des temps','Le récit combine actions et descriptions. L’imparfait présente le cadre, les habitudes et les actions durables ; le passé simple met en avant les actions successives. Les expansions du nom enrichissent la description.','La cour était silencieuse ; soudain, un enfant franchit le portail.','Quel temps convient pour une action brève qui fait avancer le récit ?',['Imparfait','Passé simple','Conditionnel présent'],1,'Le passé simple présente ici une action de premier plan.'),
    _Unit('T1 • Mathématiques','Nombres rationnels et puissances','Un nombre rationnel peut s’écrire comme quotient de deux entiers avec dénominateur non nul. Une puissance abrège une multiplication répétée. Pour multiplier des puissances de même base, on additionne les exposants.','2³ × 2² = 2⁵ = 32.','Calcule 3² × 3³.',['3⁵','3⁶','3¹'],0,'Pour une même base, 3² × 3³ = 3 puissance 2+3 = 3⁵.'),
    _Unit('T1 • Anglais','Past continuous and narrative','Le past continuous se forme avec was/were + verbe en -ing. Il décrit une action en cours dans le passé. Le past simple présente souvent l’événement qui l’interrompt.','I was reading when the phone rang.','Choose the correct form: They … playing when it started to rain.',['was','were','are'],1,'Avec they, on utilise were : they were playing.'),
    _Unit('T1 • SVT','Reproduction humaine et puberté','La puberté est une période de transformations corporelles et psychologiques. Les appareils reproducteurs produisent les cellules reproductrices. Une information scientifique fiable, le respect de soi et d’autrui et la prévention sont essentiels à la santé.','Les changements de la puberté ne se produisent pas exactement au même âge chez tous.','Quelle affirmation est correcte ?',['La puberté arrive au même âge chez tous.','La puberté comporte des transformations variables selon les personnes.','La puberté est une maladie.'],1,'Le rythme du développement varie d’une personne à l’autre.'),
    _Unit('T1 • Physique-Chimie','Atomes, molécules et transformations','La matière est constituée de particules. Une molécule est un assemblage d’atomes. Lors d’une transformation physique, l’espèce chimique ne change pas ; lors d’une transformation chimique, de nouvelles espèces apparaissent.','La fusion de la glace est physique ; la combustion du bois est chimique.','Laquelle est une transformation chimique ?',['La fusion de la glace','La vaporisation de l’eau','La combustion du charbon'],2,'La combustion forme de nouvelles substances : c’est une transformation chimique.'),
    _Unit('T1 • Histoire-Géographie-EMC','Sociétés et territoires au XIXe siècle','L’industrialisation transforme les modes de production, les villes, les transports et les conditions de travail. En géographie, les mobilités et les échanges relient les territoires. L’EMC étudie les libertés, les règles et la responsabilité.','Le chemin de fer accélère le transport des personnes et des marchandises.','Quel changement est associé à l’industrialisation ?',['Développement des usines','Disparition de toute ville','Arrêt des échanges'],0,'Les usines et les nouvelles machines caractérisent l’industrialisation.'),
    _Unit('T2 • Français','Propositions subordonnées et argumentation','Une proposition subordonnée dépend d’une proposition principale. Les relatives complètent un nom ; les conjonctives sont introduites notamment par que. Un texte argumentatif présente une thèse, des arguments et des exemples organisés.','Le livre que tu lis est intéressant : « que tu lis » précise le nom livre.','Dans « La fille qui chante est ma sœur », quelle est la fonction de la proposition introduite par qui ?',['Proposition relative','Proposition indépendante','Proposition interrogative'],0,'Qui introduit une relative qui complète le nom fille.'),
    _Unit('T2 • Mathématiques','Équations et proportionnalité','Résoudre une équation consiste à trouver les valeurs de l’inconnue qui rendent l’égalité vraie. On effectue la même opération aux deux membres. Une situation de proportionnalité peut être représentée par un tableau ou une relation y = kx.','3x + 5 = 20 ; 3x = 15 ; x = 5.','Résous 2x − 7 = 9.',['x = 1','x = 8','x = 16'],1,'2x = 16, donc x = 8.'),
    _Unit('T2 • Anglais','Present perfect and life experiences','Le present perfect se forme avec have/has + participe passé. Il relie une expérience ou un résultat passé au présent. Since indique un point de départ et for une durée.','She has lived here for three years.','Complete: I … never visited Accra.',['have','has','did'],0,'Avec I, on emploie have : I have never visited.'),
    _Unit('T2 • SVT','Système nerveux et commande du mouvement','Les organes des sens reçoivent des informations. Les nerfs transmettent des messages nerveux vers les centres nerveux et les muscles. Le cerveau et la moelle épinière participent à la coordination des réponses.','Retirer rapidement la main d’un objet brûlant est une réponse de protection.','Quel organe coordonne de nombreuses activités volontaires ?',['Le cerveau','L’estomac','Le rein'],0,'Le cerveau traite des informations et participe à la commande des mouvements.'),
    _Unit('T2 • Physique-Chimie','Électricité : tension, intensité et sécurité','L’intensité du courant se mesure avec un ampèremètre monté en série. La tension se mesure avec un voltmètre branché en dérivation. Les appareils doivent être utilisés sur un calibre adapté et dans le respect des consignes de sécurité.','L’unité de l’intensité est l’ampère (A) et celle de la tension le volt (V).','Quel appareil mesure la tension électrique ?',['Ampèremètre','Voltmètre','Balance'],1,'Le voltmètre mesure la tension, en volts.'),
    _Unit('T2 • Histoire-Géographie-EMC','Migrations, urbanisation et citoyenneté','Les migrations sont des déplacements de population. L’urbanisation correspond à l’augmentation de la population vivant en ville et à l’extension des espaces urbains. Les politiques publiques organisent les services et l’accès aux droits.','Une ville attire parfois des habitants par ses écoles, ses soins et ses emplois.','Comment appelle-t-on l’augmentation de la part de population urbaine ?',['Urbanisation','Désertification','Déforestation'],0,'L’urbanisation désigne la croissance des villes et de la population urbaine.'),
    _Unit('T3 • Français','Poésie, théâtre et écriture organisée','La poésie utilise le rythme, les sonorités et les images. Le théâtre est destiné à être joué et présente des dialogues et des didascalies. Une rédaction efficace respecte le sujet, organise les paragraphes et relit la langue.','Une didascalie indique un geste, un déplacement ou le ton d’un personnage.','Dans une pièce de théâtre, que désigne une didascalie ?',['Une indication scénique','Un chapitre de roman','Une rime obligatoire'],0,'Les didascalies donnent des indications pour la mise en scène.'),
    _Unit('T3 • Mathématiques','Théorème de Pythagore et géométrie','Dans un triangle rectangle, le carré de l’hypoténuse est égal à la somme des carrés des deux autres côtés. La réciproque permet de vérifier si un triangle est rectangle. Les unités doivent être cohérentes.','Si les côtés de l’angle droit mesurent 3 cm et 4 cm, l’hypoténuse mesure 5 cm.','Un triangle rectangle a des côtés de l’angle droit 6 cm et 8 cm. L’hypoténuse vaut…',['10 cm','12 cm','14 cm'],0,'6² + 8² = 36 + 64 = 100 ; la racine carrée de 100 vaut 10.'),
    _Unit('T3 • Anglais','Conditionals, obligation and advice','Le first conditional décrit une situation future possible : if + present simple, will + base verbale. Must exprime une obligation ; mustn’t une interdiction ; should un conseil.','If it rains, we will stay at home.','Choose the correct first conditional.',['If she studies, she will pass.','If she will study, she passes.','If she studied, she pass.'],0,'Après if, on emploie le présent simple ; la principale utilise will.'),
    _Unit('T3 • SVT','Écosystèmes, chaînes alimentaires et environnement','Un écosystème associe un milieu et les êtres vivants qui y interagissent. Dans une chaîne alimentaire, la matière et l’énergie passent d’un organisme à un autre. La pollution et la destruction des habitats perturbent les équilibres.','Herbe → criquet → grenouille : chaque maillon dépend des autres.','Dans une chaîne alimentaire, quel organisme est généralement producteur ?',['Une plante verte','Un carnivore','Un champignon uniquement'],0,'Les plantes vertes produisent leur matière organique grâce à la photosynthèse.'),
    _Unit('T3 • Physique-Chimie','Énergie, lumière et prévention des risques','L’énergie peut être transférée et convertie : une lampe transforme une partie de l’énergie électrique en lumière et en chaleur. La lumière se propage en ligne droite dans un milieu homogène transparent. Il faut appliquer les règles de sécurité.','Une lampe torche convertit l’énergie chimique des piles en énergie électrique puis lumineuse.','Dans une lampe allumée, quelle énergie est produite pour éclairer ?',['Énergie lumineuse','Énergie sonore uniquement','Énergie nucléaire'],0,'La lampe émet de l’énergie lumineuse, avec aussi un dégagement de chaleur.'),
    _Unit('T3 • Histoire-Géographie-EMC','Mondialisation, développement durable et bilan','La mondialisation intensifie les échanges de marchandises, d’informations et de personnes. Le développement durable associe dimensions économique, sociale et environnementale. L’élève apprend à analyser un document et à justifier une réponse.','Un produit peut être conçu dans un pays, fabriqué dans un autre et vendu dans plusieurs régions.','Quelles sont les trois dimensions du développement durable ?',['Économique, sociale et environnementale','Sportive, artistique et militaire','Locale, privée et numérique'],0,'Le développement durable cherche un équilibre entre économie, société et environnement.'),
  ];
  static int get unitCount => _units.length;
  static int get lessonCount => _units.length;
  static List<Exercise> assessmentExercisesForTerm(int term, {String? subjectName}) {
    final result = <Exercise>[];
    for (var i = 0; i < _units.length; i++) {
      final unit = _units[i];
      if (!unit.title.startsWith('T$term •')) continue;
      if (subjectName != null && !_matches(unit.title, subjectName)) continue;
      result.add(Exercise(id: 'four_t${term}_u${i}', lessonId: 'four_t${term}_u${i}', question: unit.question, options: unit.options, correctIndex: unit.answer, explanation: unit.explanation));
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
    appBar: AppBar(title: const Text('Complément 4ème • Année complète')),
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
