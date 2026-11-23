import 'package:flutter/material.dart';
import '../../data/models/models.dart';

class PhysicsCourseSupport extends StatelessWidget {
  final Lesson lesson;
  final String chapterTitle;
  final String chapterId;
  const PhysicsCourseSupport({super.key, required this.lesson, this.chapterTitle = '', this.chapterId = ''});
  @override Widget build(BuildContext context) {
    final s=(chapterTitle+' '+lesson.title+' '+lesson.summary+' '+lesson.content).toLowerCase();
    final topics=<_Topic>[];
    final lessonHeading = (lesson.title + ' ' + lesson.summary).toLowerCase();
    if (RegExp(r'équilibre|concourantes|polygone des forces').hasMatch(lessonHeading)) {
      topics.add(_mechanics[1]);
    } else if (RegExp(r'interaction|actions réciproques|action réciproque').hasMatch(lessonHeading)) {
      topics.add(_mechanics[2]);
    } else if (chapterId == 'ly_premiere_sc_mecanique_c' && RegExp(r'force|mécanique').hasMatch(lessonHeading)) {
      topics.add(_mechanics[0]);
    }
    if (RegExp(r'transistor|photorésistance').hasMatch(lessonHeading)) topics.add(_transistor);
    if(topics.isEmpty)return const SizedBox.shrink();
    return Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      const SizedBox(height:22),const Text('Cours approfondi — Physique et technologie',style:TextStyle(fontSize:20,fontWeight:FontWeight.w800)),
      const Text('Explications, schémas légendés, exemples et exercices corrigés.',style:TextStyle(height:1.4)),
      ...topics.map((t)=>_TopicCard(topic:t)),
    ]);
  }
}
class _Topic {
 final String title,objective,explanation,example,formula,caption;
 final int diagram;
 final List<String> key,questions,corrections;
 final List<List<String>> choices;
 final List<int> answers;
 const _Topic(this.title,this.objective,this.explanation,this.example,this.formula,this.caption,this.diagram,this.key,this.questions,this.choices,this.answers,this.corrections);
}
const _mechanics=<_Topic>[
_Topic('1. Les forces','Objectif : reconnaître et représenter une force.',
'Une force est une action mécanique exercée par un corps sur un autre. Elle peut mettre un objet en mouvement, modifier sa vitesse ou sa direction, ou le déformer. On la représente par un vecteur (une flèche). Elle possède quatre caractéristiques : point d’application, direction (droite d’action), sens et intensité. Son unité SI est le newton (N), mesuré avec un dynamomètre.',
'Quand un élève pousse une table, sa main exerce une force de contact. La Terre exerce aussi à distance le poids sur la table. Le poids d’une masse m vaut P = m × g. Près de la Terre, g ≈ 9,8 N/kg ; on prend souvent 10 N/kg dans les exercices.',
'P = m × g     •     unité : newton (N)',
'A : point d’application. La flèche donne la direction horizontale et le sens vers la droite. Sa longueur représente l’intensité ; sans échelle, aucune valeur numérique ne peut être lue.',0,
['Une force est une action mécanique.','Elle possède quatre caractéristiques.','L’intensité se mesure en newtons.','Le poids est une force : P = mg.'],
['Quelle est l’unité SI d’une force ?','Quelles sont les quatre caractéristiques ?','Quel est le poids d’une masse de 2 kg si g = 10 N/kg ?'],
[['Le newton (N)','Le kilogramme (kg)','Le watt (W)'],['Direction, couleur, masse et volume','Point d’application, direction, sens et intensité','Masse, vitesse, durée et volume'],['10 N','20 N','200 N']],[0,1,1],
['Le newton (N) est l’unité SI.','Point d’application, direction, sens et intensité.','P = 2 × 10 = 20 N.']),
_Topic('2. Équilibre d’un corps soumis à des forces concourantes','Objectif : vérifier si plusieurs forces maintiennent un corps en équilibre.',
'Des forces sont concourantes lorsque leurs droites d’action passent par un même point. Un corps est en équilibre si la résultante vectorielle des forces est nulle. Il ne suffit pas d’additionner les intensités : il faut tenir compte des directions et des sens. Pour trois forces, les vecteurs placés bout à bout forment un triangle fermé.',
'Un anneau immobile est tiré par deux cordes : une tension de 30 N vers la droite et une tension de 40 N vers le haut. Leur résultante vaut 50 N. Une troisième force de 50 N, de sens opposé, équilibre l’anneau.',
'Σ F⃗ = 0⃗     •     ΣFₓ = 0     •     ΣFᵧ = 0',
'Les trois droites d’action se rencontrent en O. Les vecteurs se compensent ; le polygone des forces se ferme. Le dessin illustre le principe, pas une échelle de mesure.',1,
['Les forces ont un même point de concours.','L’équilibre exige une somme vectorielle nulle.','Les projections sur chaque axe sont nulles.','Le polygone des forces est fermé.'],
['Quelle condition traduit l’équilibre ?','Deux forces seules peuvent-elles équilibrer un corps ?','Deux forces perpendiculaires valent 6 N et 8 N. Quelle intensité doit avoir la force équilibrante ?'],
[['La somme vectorielle est nulle','La somme des masses est nulle','La vitesse est maximale'],['Oui, si elles sont opposées, de même intensité et même droite','Oui, quelles que soient leurs directions','Jamais'],['14 N','10 N','2 N']],[0,0,1],
['La somme vectorielle des forces est le vecteur nul.','Oui, si elles ont même droite d’action, même intensité et sens opposés.','√(6² + 8²) = 10 N ; la force équilibrante vaut 10 N.']),
_Topic('3. Relations entre les corps solides : interactions','Objectif : identifier les actions mécaniques réciproques.',
'Lorsque deux solides interagissent, chacun exerce une action mécanique sur l’autre. L’interaction peut être de contact (main et table, roue et route, corde et charge) ou à distance (gravitation, magnétisme). Les deux forces réciproques ont même direction et même intensité, mais des sens opposés. Elles agissent sur deux corps différents : elles ne s’annulent donc pas sur un même corps.',
'Une personne pousse un mur. La personne exerce une force sur le mur ; le mur exerce simultanément une force opposée sur la personne. Le mur peut rester immobile parce que d’autres forces, notamment celles du sol, interviennent aussi.',
'F⃗(A→B) = − F⃗(B→A)',
'La main pousse le bloc vers la droite ; le bloc exerce sur la main une force de même intensité vers la gauche. Chaque force agit sur un solide différent.',2,
['Une interaction met en jeu deux corps.','Elle peut être de contact ou à distance.','Les forces réciproques ont même direction et intensité.','Elles sont de sens opposés et agissent sur deux corps distincts.'],
['Une force de contact nécessite-t-elle un contact ?','Les deux forces agissent-elles sur le même corps ?','Comment sont orientées les forces réciproques ?'],
[['Oui','Non','Seulement à distance'],['Oui','Non','Seulement sur le corps le plus lourd'],['Même direction et sens opposés','Directions perpendiculaires','Même direction et même sens']],[0,1,0],
['Oui, les corps sont en contact directement ou par un lien.','Non, chaque force agit sur l’un des deux corps.','Même direction, même intensité, mais sens opposés.'])
];
const _transistor=_Topic('4. Un détecteur utilisant un transistor','Objectif : comprendre comment un capteur commande une charge.',
'Un transistor bipolaire NPN possède trois bornes : base (B), collecteur (C) et émetteur (E). Il peut fonctionner comme un interrupteur électronique : un faible courant de base commande le courant entre collecteur et émetteur. Dans un détecteur de lumière, une photorésistance (LDR) change de résistance selon l’éclairement. Avec une résistance, elle forme un diviseur de tension qui commande la base. Quand la commande est suffisante, le transistor conduit et peut allumer une LED ou activer un avertisseur.',
'La LDR et R1 forment le capteur ; R2 limite le courant de base ; le transistor commande la LED. Le branchement du diviseur détermine si la LED s’allume dans l’obscurité ou à la lumière. Le seuil dépend des résistances et du transistor.',
'Transistor bloqué : I_C ≈ 0     •     transistor passant : I_C > 0',
'Schéma fonctionnel de principe uniquement : il montre la chaîne capteur → commande → transistor → sortie, pas les fils de câblage. Pour réaliser le montage, il faut un schéma électrique complet indiquant la polarité, la masse commune, le brochage exact B/C/E du composant et les valeurs des résistances. La LED exige une résistance série adaptée.',3,
['Identifier B, C et E.','Le capteur transforme la lumière en variation électrique.','La base commande le courant collecteur-émetteur.','La résistance série limite le courant de la LED.','Utiliser une alimentation basse tension sous contrôle de l’enseignant.'],
['Quelles sont les trois bornes du transistor bipolaire ?','Quel est son rôle dans le détecteur ?','Pourquoi placer une résistance en série avec la LED ?'],
[['Base, collecteur, émetteur','Anode, cathode, grille','Source, drain, grille'],['Il commande le courant de la charge','Il mesure directement la lumière','Il remplace l’alimentation'],['Pour limiter le courant','Pour augmenter la tension','Pour inverser la polarité']],[0,0,0],
['Base (B), collecteur (C) et émetteur (E).','Il fonctionne comme un interrupteur commandé par la base.','Elle limite le courant et protège la LED.']);

class _TopicCard extends StatefulWidget{
 final _Topic topic;const _TopicCard({required this.topic});
 @override State<_TopicCard> createState()=>_TopicCardState();
}
class _TopicCardState extends State<_TopicCard>{
 final Map<int,int> selected={};bool corrected=false;
 @override Widget build(BuildContext context){
  final t=widget.topic;final cs=Theme.of(context).colorScheme;
  return Card(margin:const EdgeInsets.only(top:14),clipBehavior:Clip.antiAlias,child:Padding(padding:const EdgeInsets.all(14),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
   Text(t.title,style:const TextStyle(fontSize:18,fontWeight:FontWeight.w800)),
   const SizedBox(height:5),Text(t.objective,style:TextStyle(color:cs.primary,fontWeight:FontWeight.w600)),
   const SizedBox(height:12),const Text('Explication du cours',style:TextStyle(fontWeight:FontWeight.bold)),
   const SizedBox(height:5),Text(t.explanation,style:const TextStyle(height:1.5)),
   const SizedBox(height:12),const Text('Schéma explicatif',style:TextStyle(fontWeight:FontWeight.bold)),
   const SizedBox(height:7),GestureDetector(
    onTap:()=>showDialog<void>(context:context,builder:(ctx)=>Dialog.fullscreen(child:Scaffold(appBar:AppBar(title:Text(t.title),leading:IconButton(icon:const Icon(Icons.close),onPressed:()=>Navigator.pop(ctx))),body:Center(child:InteractiveViewer(minScale:1,maxScale:4,child:SizedBox(width:680,height:t.diagram==3?624:462,child:CustomPaint(painter:_Painter(t.diagram,cs),child:const SizedBox.expand()))))))),
    child:Container(width:double.infinity,height:t.diagram==3?330:245,decoration:BoxDecoration(color:cs.surfaceContainerHighest,border:Border.all(color:cs.outlineVariant),borderRadius:BorderRadius.circular(12)),child:ClipRRect(borderRadius:BorderRadius.circular(12),child:CustomPaint(painter:_Painter(t.diagram,cs),child:const SizedBox.expand())))),
   const SizedBox(height:7),Text(t.caption,style:Theme.of(context).textTheme.bodySmall?.copyWith(height:1.4)),
   const SizedBox(height:12),const Text('Exemple expliqué',style:TextStyle(fontWeight:FontWeight.bold)),const SizedBox(height:5),Text(t.example,style:const TextStyle(height:1.5)),
   const SizedBox(height:10),Container(width:double.infinity,padding:const EdgeInsets.all(12),decoration:BoxDecoration(color:cs.secondaryContainer,borderRadius:BorderRadius.circular(10)),child:SelectableText(t.formula,textAlign:TextAlign.center,style:TextStyle(fontWeight:FontWeight.w800,fontSize:16,color:cs.onSecondaryContainer))),
   const SizedBox(height:12),const Text('À retenir',style:TextStyle(fontWeight:FontWeight.bold)),
   ...t.key.map((v)=>Padding(padding:const EdgeInsets.only(top:6),child:Row(crossAxisAlignment:CrossAxisAlignment.start,children:[Icon(Icons.check_circle,size:18,color:cs.primary),const SizedBox(width:7),Expanded(child:Text(v,style:const TextStyle(height:1.4)))]))),
   const Divider(height:24),const Text('Exercices de compréhension',style:TextStyle(fontWeight:FontWeight.bold)),
   ...List.generate(t.questions.length,(i)=>Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
    const SizedBox(height:10),Text((i+1).toString()+'. '+t.questions[i],style:const TextStyle(fontWeight:FontWeight.w600)),
    ...List.generate(3,(j)=>RadioListTile<int>(dense:true,contentPadding:EdgeInsets.zero,value:j,groupValue:selected[i],onChanged:(v){if(v!=null)setState((){selected[i]=v;corrected=false;});},title:Text(t.choices[i][j]))),
    if(corrected)Container(width:double.infinity,padding:const EdgeInsets.all(9),decoration:BoxDecoration(color:selected[i]==t.answers[i]?Colors.green.withValues(alpha:.10):cs.errorContainer,borderRadius:BorderRadius.circular(8)),child:Text((selected[i]==t.answers[i]?'Bonne réponse. ':'À revoir. ')+t.corrections[i],style:const TextStyle(height:1.4))),
   ])),
   const SizedBox(height:8),FilledButton.icon(onPressed:selected.length==t.questions.length?()=>setState(()=>corrected=true):null,icon:const Icon(Icons.fact_check_outlined),label:const Text('Corriger mes réponses')),
   if(corrected)Text('Résultat : '+List.generate(t.answers.length,(i)=>selected[i]==t.answers[i]?1:0).reduce((a,b)=>a+b).toString()+' / '+t.answers.length.toString(),style:const TextStyle(fontWeight:FontWeight.bold)),
  ])));
 }
}
class _Painter extends CustomPainter{
 final int kind;final ColorScheme cs;_Painter(this.kind,this.cs);
 @override void paint(Canvas c,Size s){
  c.save();c.scale(s.width/360,s.height/(kind==3?330:245));
  final ink=Paint()..color=cs.onSurface..strokeWidth=2.4..style=PaintingStyle.stroke;
  final blue=Paint()..color=const Color(0xFF1565C0)..strokeWidth=3..style=PaintingStyle.stroke;
  final red=Paint()..color=const Color(0xFFC62828)..strokeWidth=3..style=PaintingStyle.stroke;
  final green=Paint()..color=const Color(0xFF2E7D32)..strokeWidth=3..style=PaintingStyle.stroke;
  final fill=Paint()..color=cs.primaryContainer..style=PaintingStyle.fill;
  void line(Offset a,Offset b,Paint p)=>c.drawLine(a,b,p);
  void arrow(Offset a,Offset b,Paint p){line(a,b,p);final d=b-a;final u=d/d.distance;final n=Offset(-u.dy,u.dx);final q=Path()..moveTo(b.dx,b.dy)..lineTo(b.dx-u.dx*12+n.dx*6,b.dy-u.dy*12+n.dy*6)..lineTo(b.dx-u.dx*12-n.dx*6,b.dy-u.dy*12-n.dy*6)..close();c.drawPath(q,Paint()..color=p.color..style=PaintingStyle.fill);}
  void label(String t,Offset p,{double w=130,double f=13}){final x=TextPainter(text:TextSpan(text:t,style:TextStyle(color:cs.onSurface,fontSize:f,fontWeight:FontWeight.w700)),textDirection:TextDirection.ltr)..layout(maxWidth:w);x.paint(c,p);}
  if(kind==0){
   c.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(105,105,125,76),const Radius.circular(10)),fill);c.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(105,105,125,76),const Radius.circular(10)),ink);c.drawCircle(const Offset(105,143),5,Paint()..color=red.color..style=PaintingStyle.fill);arrow(const Offset(105,143),const Offset(305,143),blue);label('A : application',const Offset(8,115),w:95);label('F⃗',const Offset(285,115),w:35,f:19);label('Bloc solide',const Offset(130,137),w:100);label('Direction horizontale',const Offset(105,200),w:170,f:12);
  }else if(kind==1){
   const o=Offset(180,125);c.drawCircle(o,7,Paint()..color=cs.onSurface);arrow(o,const Offset(75,48),blue);arrow(o,const Offset(290,48),red);arrow(o,const Offset(180,225),green);label('F₁',const Offset(42,25));label('F₂',const Offset(295,25));label('F₃',const Offset(192,204));label('O : point de concours',const Offset(108,136),w:155,f:12);label('Σ F⃗ = 0⃗',const Offset(130,5),w:110,f:16);
  }else if(kind==2){
   c.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(30,88,115,72),const Radius.circular(8)),fill);c.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(30,88,115,72),const Radius.circular(8)),ink);c.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(215,88,115,72),const Radius.circular(8)),fill);c.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(215,88,115,72),const Radius.circular(8)),ink);label('MAIN',const Offset(66,115));label('BLOC',const Offset(252,115));arrow(const Offset(145,72),const Offset(215,72),blue);arrow(const Offset(215,183),const Offset(145,183),red);label('F(main → bloc)',const Offset(145,39),w:155,f:11);label('F(bloc → main)',const Offset(145,192),w:155,f:11);label('Même intensité, sens opposés',const Offset(75,225),w:220,f:12);
  }else{
   // Schéma fonctionnel lisible : détection, commande et action.
   void block(Rect r,String title,String subtitle){
    c.drawRRect(RRect.fromRectAndRadius(r,const Radius.circular(12)),fill);
    c.drawRRect(RRect.fromRectAndRadius(r,const Radius.circular(12)),ink);
    label(title,Offset(r.left+8,r.top+13),w:r.width-16,f:11);
    label(subtitle,Offset(r.left+8,r.top+38),w:r.width-16,f:9);
   }
   label('DÉTECTEUR DE LUMIÈRE — PRINCIPE',const Offset(22,12),w:320,f:14);
   block(const Rect.fromLTWH(18,82,94,76),'CAPTEUR','LDR + R1');
   block(const Rect.fromLTWH(133,82,94,76),'COMMANDE','signal vers B');
   block(const Rect.fromLTWH(248,82,94,76),'TRANSISTOR','NPN : B, C, E');
   arrow(const Offset(112,120),const Offset(133,120),blue);
   arrow(const Offset(227,120),const Offset(248,120),blue);
   label('lumière',const Offset(31,57),w:80,f:12);
   arrow(const Offset(57,75),const Offset(70,82),green);
   block(const Rect.fromLTWH(205,220,137,70),'SORTIE','LED / avertisseur');
   arrow(const Offset(295,158),const Offset(295,220),red);
   label('Le transistor agit comme un interrupteur',const Offset(22,185),w:320,f:12);
   label('Alimentation basse tension',const Offset(22,304),w:240,f:12);
  }
  c.restore();
 }
 @override bool shouldRepaint(covariant _Painter old)=>old.kind!=kind||old.cs!=cs;
}
