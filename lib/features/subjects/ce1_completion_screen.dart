import 'package:flutter/material.dart';
import '../../data/models/models.dart';

/// Parcours CE1 sur les trois trimestres : cours, exemples et exercices corrigés.
class Ce1CompletionScreen extends StatelessWidget {
  const Ce1CompletionScreen({super.key});
  static const _units = <_Unit>[
    _Unit('T1 • Français','Lecture et phrase','Lire un texte, retrouver personnages, lieu et action. Une phrase exprime une idée complète ; elle commence par une majuscule et se termine par une ponctuation.','Texte : « Ama joue dans la cour. » Personnage : Ama ; action : joue ; lieu : la cour.','Où joue Ama ?', ['Dans la cour','Au marché','À la rivière'],0,'Le texte précise « dans la cour ».'),
    _Unit('T1 • Mathématiques','Nombres et additions','Un nombre comporte des centaines, dizaines et unités. Pour additionner, j’aligne les chiffres par rang et je calcule de droite à gauche en reportant les retenues.','572 = 500 + 70 + 2. 268 + 157 = 425.','Dans 684, quel chiffre indique les dizaines ?', ['6','8','4'],1,'Le chiffre des dizaines est 8.'),
    _Unit('T1 • Anglais','Salutations et présentation','Hello et Good morning servent à saluer. My name is… permet de dire son nom. I am… donne une information sur soi.','Hello! My name is Esi. I am a pupil.','Que signifie « Good morning » ?', ['Bonsoir','Bonjour le matin','Au revoir'],1,'Good morning signifie bonjour le matin.'),
    _Unit('T1 • Éveil scientifique','Corps et hygiène','Les yeux permettent de voir, les oreilles d’entendre, le nez de sentir, la langue de goûter et la peau de toucher. Le lavage des mains et l’eau potable protègent la santé.','Je me lave les mains avant de manger et après les toilettes.','Quel organe permet de goûter ?', ['La langue','Le coude','Le genou'],0,'La langue permet de goûter.'),
    _Unit('T1 • Éducation sociale','Vie de classe et responsabilités','Les règles facilitent la vie collective : écouter, attendre son tour, respecter les personnes et prendre soin du matériel. Chaque élève accomplit des tâches adaptées à son âge.','Je lève la main pour demander la parole et je range mes cahiers.','Quel comportement respecte les autres ?', ['Se moquer','Écouter sans interrompre','Crier'],1,'Écouter permet à chacun de participer.'),
    _Unit('T2 • Français','Grammaire et accords','Le nom désigne une personne, un animal, un lieu ou une chose. Le déterminant accompagne le nom et l’adjectif le précise. Le verbe s’accorde avec son sujet.','Dans « les petites chèvres sautent », chèvres est le nom et sautent le verbe.','Complète : Les filles …', ['chante','chantent','chantons'],1,'Le sujet « les filles » est pluriel : chantent.'),
    _Unit('T2 • Mathématiques','Soustraction et multiplication','Pour soustraire, j’aligne les chiffres et j’effectue les échanges nécessaires. La multiplication représente une addition répétée de groupes égaux.','63 − 27 = 36. Quatre groupes de 3 : 3+3+3+3 = 12.','Cinq groupes de 2 font combien ?', ['7','10','12'],1,'5 × 2 = 10.'),
    _Unit('T2 • Anglais','Nombres, couleurs et objets','Les nombres one à ten servent à compter. Couleurs utiles : red, blue, green, yellow, black et white. Book signifie livre, pen stylo, ruler règle.','I have three blue pens = J’ai trois stylos bleus.','Que signifie « green » ?', ['Rouge','Vert','Noir'],1,'Green signifie vert.'),
    _Unit('T2 • Éveil scientifique','Plantes et animaux','Une plante a besoin d’eau, de lumière et d’air. La racine absorbe l’eau. Les animaux peuvent être classés selon leur milieu, leur alimentation ou leur déplacement.','Le poisson nage ; la chèvre marche ; l’oiseau vole généralement.','Quel animal vit principalement dans l’eau ?', ['Le poisson','La poule','Le mouton'],0,'Le poisson est adapté à la vie aquatique.'),
    _Unit('T2 • Éducation sociale','Sécurité et solidarité','Sur la route, je marche dans les espaces prévus, je regarde avant de traverser et je suis les indications d’un adulte responsable. La solidarité consiste à aider et coopérer.','Je m’arrête au bord, j’observe et je traverse avec prudence.','Que signifie coopérer ?', ['Travailler ensemble','Refuser toute aide','Cacher le matériel'],0,'Coopérer signifie agir ensemble.'),
    _Unit('T3 • Français','Conjugaison et rédaction','Le verbe indique une action ou un état. Son infinitif est sa forme de référence. Un paragraphe développe une idée dans un ordre compréhensible, avec ponctuation.','Il chante → chanter ; elle finit → finir.','Quel est l’infinitif de « nous jouons » ?', ['jouer','jouons','joué'],0,'Nous jouons vient du verbe jouer.'),
    _Unit('T3 • Mathématiques','Division et fractions simples','La division partage une quantité en parts égales. La moitié partage en deux parts égales ; le quart en quatre parts égales. Je vérifie un partage par multiplication.','12 mangues pour 3 enfants : 12 ÷ 3 = 4 chacun.','Quelle est la moitié de 18 ?', ['6','8','9'],2,'18 ÷ 2 = 9.'),
    _Unit('T3 • Anglais','Famille et actions','Mother signifie mère, father père, sister sœur et brother frère. Read signifie lire, write écrire, eat manger et sleep dormir.','This is my brother = Voici mon frère.','Que signifie « sister » ?', ['Sœur','Père','Mère'],0,'Sister signifie sœur.'),
    _Unit('T3 • Éveil scientifique','Eau et environnement','La chaleur provoque l’évaporation de l’eau. La vapeur se refroidit, forme des gouttelettes et participe à la formation des nuages. Il faut éviter de polluer l’eau et protéger les arbres.','Après la pluie, l’eau rejoint le sol, les rivières et les lacs.','Comment appelle-t-on le passage de l’eau liquide en vapeur ?', ['Évaporation','Congélation','Fusion'],0,'L’évaporation transforme l’eau liquide en vapeur.'),
    _Unit('T3 • Éducation sociale','Citoyenneté et préparation au CE2','Les symboles nationaux représentent le pays. Le drapeau togolais comporte du vert, du jaune, du rouge et une étoile blanche. Pour progresser, je révise et je corrige mes erreurs.','Après un exercice, je vérifie mes calculs et j’explique ma démarche.','Que faire après une erreur ?', ['L’ignorer','Comprendre et corriger','Cacher son cahier'],1,'Comprendre l’erreur permet de progresser.'),
  ];

  static int get unitCount => _units.length;
  static int get lessonCount => _units.length;
  static List<Exercise> assessmentExercisesForTerm(int term, {String? subjectName}) {
    final prefix = 'T$term •';
    final list = <Exercise>[];
    for (var i=0;i<_units.length;i++) {
      final u=_units[i];
      if (!u.title.startsWith(prefix)) continue;
      if (subjectName != null && !_matches(u.title,subjectName)) continue;
      list.add(Exercise(id:'ce1_t${term}_u${i}',lessonId:'ce1_t${term}_u${i}',question:u.question,options:u.options,correctIndex:u.answer,explanation:u.explanation));
    }
    return list;
  }
  static bool _matches(String title,String subject) {
    final t=title.toLowerCase(), s=subject.toLowerCase();
    if(s.contains('français')||s.contains('francais')) return t.contains('français');
    if(s.contains('math')) return t.contains('mathématiques');
    if(s.contains('anglais')||s.contains('english')) return t.contains('anglais');
    if(s.contains('science')) return t.contains('éveil scientifique');
    if(s.contains('social')||s.contains('civique')||s.contains('morale')) return t.contains('éducation sociale');
    return false;
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Complément CE1 • Année complète')),
    body: ListView(padding: const EdgeInsets.all(16),children:[
      Card(child: Padding(padding: const EdgeInsets.all(16),child: Text('${Ce1CompletionScreen.unitCount} unités • ${Ce1CompletionScreen.lessonCount} leçons • 3 trimestres\nLis le cours, observe l’exemple, réponds puis consulte la correction.',style: const TextStyle(fontWeight: FontWeight.w600)))),
      for(final u in _units) _UnitTile(unit:u),
    ]),
  );
}
class _Unit { final String title,objective,content,example,question; final List<String> options; final int answer; final String explanation; const _Unit(this.title,this.objective,this.content,this.example,this.question,this.options,this.answer,this.explanation); }
class _UnitTile extends StatefulWidget { final _Unit unit; const _UnitTile({required this.unit}); @override State<_UnitTile> createState()=>_UnitTileState(); }
class _UnitTileState extends State<_UnitTile> {
  int? choice; bool checked=false;
  @override Widget build(BuildContext context) { final u=widget.unit; return Card(margin:const EdgeInsets.only(bottom:10),child:ExpansionTile(title:Text(u.title,style:const TextStyle(fontWeight:FontWeight.bold)),subtitle:Text(u.objective),children:[Padding(padding:const EdgeInsets.fromLTRB(16,0,16,16),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
    Text(u.content),const SizedBox(height:8),Text('Exemple : ${u.example}',style:const TextStyle(fontStyle:FontStyle.italic)),const SizedBox(height:12),Text(u.question,style:const TextStyle(fontWeight:FontWeight.bold)),
    for(var i=0;i<u.options.length;i++) RadioListTile<int>(dense:true,contentPadding:EdgeInsets.zero,value:i,groupValue:choice,title:Text(u.options[i]),onChanged:checked?null:(v)=>setState(()=>choice=v)),
    FilledButton.tonal(onPressed:choice==null?null:()=>setState(()=>checked=true),child:const Text('Vérifier ma réponse')),
    if(checked) Text('${choice==u.answer?'Bonne réponse ! ':'À revoir. Bonne réponse : ${u.options[u.answer]}. '}${u.explanation}',style:TextStyle(fontWeight:FontWeight.w600,color:choice==u.answer?Colors.green.shade800:Theme.of(context).colorScheme.error)),
    if(checked) TextButton(onPressed:()=>setState(() { choice=null; checked=false; }),child:const Text('Recommencer')),
  ]))]));}
}
