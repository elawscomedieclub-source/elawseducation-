import 'package:flutter/material.dart';
import '../../data/models/models.dart';

/// Parcours annuel de 3e orienté vers les compétences du BEPC.
class TroisiemeCompletionScreen extends StatelessWidget {
  const TroisiemeCompletionScreen({super.key});
  static const _units = <_Unit>[
    _Unit('T1 • Français','Compréhension, narration et point de vue','Pour comprendre un texte, identifier le thème, les personnages, le cadre, le point de vue et les indices du texte. Le narrateur peut être interne ou externe. Un résumé conserve les idées essentielles sans ajouter d’avis personnel.','Un résumé reprend les événements principaux dans un texte plus court.','Quel élément doit être conservé dans un résumé ?',['Les idées essentielles','Tous les détails secondaires','Des événements inventés'],0,'Un résumé restitue fidèlement les idées principales.'),
    _Unit('T1 • Mathématiques','Calcul numérique, racines et puissances','Les priorités opératoires imposent de traiter les parenthèses, puissances, multiplications et divisions avant additions et soustractions. La racine carrée de a est le nombre positif dont le carré vaut a.','√49 = 7 et 2³ × 2² = 2⁵ = 32.','Calcule √121.',['10','11','12'],1,'11 × 11 = 121, donc √121 = 11.'),
    _Unit('T1 • Anglais','Reading comprehension and present perfect','Pour comprendre un texte, repérer le sujet, les informations explicites et les mots de liaison. Le present perfect (have/has + participe passé) relie une expérience passée au présent.','I have already finished my homework.','Choose the correct sentence.',['She have seen the film.','She has seen the film.','She has saw the film.'],1,'À la troisième personne du singulier, on utilise has + participe passé.'),
    _Unit('T1 • SVT','Génétique et transmission des caractères','Les caractères héréditaires sont transmis des parents aux descendants par l’information génétique portée par les chromosomes. Les caractères observables résultent de facteurs héréditaires et de l’environnement.','Les ressemblances familiales peuvent être liées à la transmission de gènes.','Où se trouve l’essentiel de l’information génétique dans une cellule humaine ?',['Dans les chromosomes du noyau','Dans les cheveux uniquement','Dans le sang seulement'],0,'Les chromosomes du noyau portent l’essentiel de l’information génétique.'),
    _Unit('T1 • Physique-Chimie','Structure de la matière et réactions chimiques','Un atome comprend un noyau et des électrons. Une molécule est formée d’atomes liés. Lors d’une réaction chimique, les atomes se réorganisent : ils sont conservés, même si les substances changent.','Lors de la formation de l’eau, les atomes d’hydrogène et d’oxygène se réorganisent.','Au cours d’une réaction chimique ordinaire, que deviennent les atomes ?',['Ils disparaissent tous','Ils sont réorganisés','Ils deviennent de la lumière'],1,'Les atomes se conservent et se réarrangent pour former de nouvelles espèces.'),
    _Unit('T1 • Histoire-Géographie-EMC','Colonisation, indépendances et citoyenneté','L’étude de la colonisation examine les conquêtes, les administrations, les résistances et les transformations sociales. Les indépendances africaines sont le résultat de processus historiques variés. Le citoyen connaît ses droits et ses devoirs.','Pour analyser un document historique, identifier sa date, son auteur, sa nature et son contexte.','Quel élément aide à situer un document historique ?',['Sa date et son contexte','Sa couleur uniquement','Le nombre de lettres du titre'],0,'La date et le contexte permettent de comprendre le document.'),
    _Unit('T2 • Français','Argumentation, grammaire et discours','Une argumentation défend une thèse à l’aide d’arguments illustrés par des exemples. Les connecteurs organisent le raisonnement. Le discours rapporté peut être direct ou indirect ; la concordance des temps doit être respectée.','Thèse : lire est utile ; argument : la lecture enrichit le vocabulaire ; exemple : elle fait découvrir de nouveaux mots.','Quel connecteur exprime une conséquence ?',['Cependant','Donc','D’abord'],1,'Donc introduit une conséquence ou une conclusion.'),
    _Unit('T2 • Mathématiques','Équations, inéquations et fonctions','Une équation du premier degré se résout en isolant l’inconnue par des opérations équivalentes. Une inéquation se traite de manière proche ; lorsqu’on multiplie ou divise par un nombre négatif, le sens de l’inégalité s’inverse.','5x − 4 = 16 donne 5x = 20 puis x = 4.','Résous 3x + 2 = 17.',['x = 3','x = 5','x = 7'],1,'3x = 15, donc x = 5.'),
    _Unit('T2 • Anglais','Passive voice and expressing opinions','La voix passive met l’accent sur l’action ou le résultat : be + participe passé. Pour donner un avis, utiliser I think, in my opinion, because et however.','English is spoken in many countries.','Choose the passive form of « People build houses ».',['Houses are built.','Houses build.','Houses is building.'],0,'Le sujet houses reçoit l’action : are + built.'),
    _Unit('T2 • SVT','Reproduction, santé et prévention','La reproduction humaine nécessite la rencontre des cellules reproductrices. La fécondation conduit à la formation d’une cellule-œuf. La prévention, l’hygiène, le consentement et les informations provenant de professionnels fiables contribuent à la santé.','La cellule-œuf se forme lors de la fécondation.','Comment appelle-t-on la rencontre des gamètes ?',['Fécondation','Photosynthèse','Digestion'],0,'La fécondation est l’union des cellules reproductrices.'),
    _Unit('T2 • Physique-Chimie','Électricité : loi d’Ohm et puissance','Pour un conducteur ohmique, la loi d’Ohm s’écrit U = R × I. La puissance électrique est P = U × I. Les unités sont le volt, l’ampère, l’ohm et le watt. Les mesures se font avec des appareils adaptés.','Si R = 10 Ω et I = 0,2 A, alors U = 2 V.','Une résistance de 5 Ω est traversée par 2 A. Quelle tension mesure-t-on ?',['2,5 V','7 V','10 V'],2,'U = R × I = 5 × 2 = 10 V.'),
    _Unit('T2 • Histoire-Géographie-EMC','Développement, ressources et population','Le développement se mesure à l’aide d’indicateurs économiques et sociaux. La croissance démographique, l’accès à l’eau, à l’éducation, aux soins et à l’emploi sont des enjeux majeurs. Une carte thématique représente la répartition d’un phénomène.','Une légende permet d’interpréter les couleurs et symboles d’une carte.','Quel indicateur renseigne directement sur la santé d’une population ?',['Espérance de vie','Longueur d’une route','Nombre de drapeaux'],0,'L’espérance de vie est un indicateur démographique et sanitaire.'),
    _Unit('T3 • Français','Synthèse, lettre et préparation au BEPC','Une synthèse organise les informations d’un ou plusieurs documents autour d’idées communes. Une lettre respecte la situation de communication, les formules d’appel et de politesse. Avant de rendre une copie, vérifier consigne, plan, accords et ponctuation.','Une lettre officielle indique clairement l’objet et adopte un ton respectueux.','Quel élément est indispensable dans une lettre formelle ?',['Un objet clair','Des abréviations familières','Des émoticônes obligatoires'],0,'L’objet annonce précisément le motif de la lettre.'),
    _Unit('T3 • Mathématiques','Thalès, trigonométrie et statistiques','Le théorème de Thalès établit des rapports de longueurs lorsque des droites parallèles coupent deux sécantes. Dans un triangle rectangle, sinus, cosinus et tangente relient les angles aux côtés. La moyenne est la somme des valeurs divisée par leur effectif.','Dans un triangle rectangle, sin(angle) = côté opposé / hypoténuse.','La moyenne de 8, 10 et 12 vaut…',['9','10','11'],1,'(8 + 10 + 12) ÷ 3 = 30 ÷ 3 = 10.'),
    _Unit('T3 • Anglais','Reported speech and exam communication','Le discours rapporté reformule les paroles d’une personne. Selon le contexte, les pronoms et les temps peuvent changer. Pour un examen, lire les consignes, repérer les mots-clés et répondre avec des phrases simples et correctes.','Direct: He said, “I am tired.” Reported: He said that he was tired.','Which verb introduces reported speech in the example?',['said','because','tomorrow'],0,'Said introduit les paroles rapportées.'),
    _Unit('T3 • SVT','Immunité, microbes et équilibre écologique','Les microbes comprennent des organismes et agents très variés. Certains sont pathogènes, d’autres sont utiles. Les barrières naturelles, l’hygiène, la vaccination et les soins adaptés contribuent à la prévention. Les écosystèmes reposent sur des interactions.','Le lavage des mains réduit la transmission de nombreux microbes.','Quel geste limite la transmission de microbes ?',['Se laver les mains','Partager une serviette sale','Boire de l’eau non traitée'],0,'Le lavage des mains est une mesure d’hygiène efficace.'),
    _Unit('T3 • Physique-Chimie','Mécanique, énergie et révisions expérimentales','La vitesse moyenne est la distance parcourue divisée par la durée. Une force peut modifier le mouvement ou déformer un objet. L’énergie se transforme et se transfère ; un compte rendu expérimental présente question, hypothèse, protocole, résultats et conclusion.','Un véhicule parcourt 100 km en 2 h : sa vitesse moyenne est 50 km/h.','Une distance de 150 km est parcourue en 3 h. Quelle est la vitesse moyenne ?',['30 km/h','50 km/h','450 km/h'],1,'v = d/t = 150/3 = 50 km/h.'),
    _Unit('T3 • Histoire-Géographie-EMC','Institutions, paix et préparation à la vie citoyenne','Les institutions organisent les pouvoirs et les services publics. La participation citoyenne s’exerce dans le respect des lois, des libertés et de la dignité humaine. La coopération et le règlement pacifique des conflits renforcent la cohésion sociale.','Débattre consiste à écouter, argumenter et respecter les opinions différentes.','Quel comportement favorise un débat démocratique ?',['Écouter et argumenter sans violence','Empêcher les autres de parler','Insulter les opposants'],0,'Le débat démocratique repose sur l’écoute et le respect.'),
  ];
  static int get unitCount => _units.length;
  static int get lessonCount => _units.length;
  static List<Exercise> assessmentExercisesForTerm(int term, {String? subjectName}) {
    final result = <Exercise>[];
    for (var i = 0; i < _units.length; i++) {
      final unit = _units[i];
      if (!unit.title.startsWith('T$term •')) continue;
      if (subjectName != null && !_matches(unit.title, subjectName)) continue;
      result.add(Exercise(id: 'three_t${term}_u${i}', lessonId: 'three_t${term}_u${i}', question: unit.question, options: unit.options, correctIndex: unit.answer, explanation: unit.explanation));
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
    appBar: AppBar(title: const Text('Complément 3ème • Année complète • BEPC')),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      Card(child: Padding(padding: const EdgeInsets.all(16), child: Text('${unitCount} unités • ${lessonCount} leçons • 3 trimestres\nCours, exemples, questions corrigées et préparation progressive au BEPC.', style: const TextStyle(fontWeight: FontWeight.w600)))),
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
