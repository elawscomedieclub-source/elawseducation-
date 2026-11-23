import 'package:flutter/material.dart';

import '../../data/models/models.dart';

/// Supports visuels et activités pratiques ajoutés aux leçons qui s'y prêtent.
/// Les schémas sont dessinés localement : ils restent visibles hors connexion.
class LessonVisualSupport extends StatelessWidget {
  final Lesson lesson;
  const LessonVisualSupport({super.key, required this.lesson});

  _VisualKind? get _kind {
    final title = lesson.title.toLowerCase();
    // Choix volontairement strict : un mot rencontré dans le texte ne suffit
    // pas à afficher un schéma qui pourrait illustrer une autre notion.
    if (RegExp(r'circuit électrique|circuit en série|circuit en parallèle|circuit fermé').hasMatch(title)) return _VisualKind.circuit;
    if (RegExp(r'germination|parties de la plante|structure de la plante|la plante et ses parties').hasMatch(title)) return _VisualKind.plant;
    if (RegExp(r'cycle de l.eau|évaporation|condensation|précipitation').hasMatch(title)) return _VisualKind.water;
    if (RegExp(r'corps humain|parties du corps humain').hasMatch(title)) return _VisualKind.body;
    if (RegExp(r'figures géométriques|figures planes|triangle|rectangle|carré|cercle|polygone').hasMatch(title)) return _VisualKind.geometry;
    if (RegExp(r'fractions|représenter une fraction|fraction en parts égales|moitié|quart|tiers').hasMatch(title)) return _VisualKind.fraction;
    return null;
  }

  _PracticalActivity? get _activity {
    switch (_kind) {
      case _VisualKind.circuit:
        return const _PracticalActivity(
          title: 'Atelier : construire un circuit simple',
          materials: 'Une pile de 1,5 V, une petite ampoule adaptée, deux fils isolés et un support.',
          steps: ['Relie un fil entre la borne positive de la pile et une borne de l’ampoule.', 'Relie la seconde borne de l’ampoule à la borne négative de la pile.', 'Observe l’ampoule, puis débranche un fil et compare.'],
          observe: 'L’ampoule s’allume lorsque le circuit forme une boucle fermée. Elle s’éteint lorsque la boucle est interrompue.',
          safety: 'Utilise uniquement une petite pile. Ne branche jamais ce montage sur une prise électrique.'
        );
      case _VisualKind.plant:
        return const _PracticalActivity(
          title: 'Atelier : observer la germination',
          materials: 'Deux petits récipients, du coton, quelques graines de haricot et de l’eau.',
          steps: ['Place du coton humide dans les deux récipients.', 'Dépose quelques graines dans chacun.', 'Garde le premier humide et laisse le second sans ajout d’eau.', 'Observe chaque jour pendant une semaine et note les changements.'],
          observe: 'La graine convenablement humidifiée gonfle puis laisse sortir une petite racine et une pousse.',
          safety: 'Ne consomme pas les graines utilisées pour l’expérience. Lave-toi les mains après la manipulation.'
        );
      case _VisualKind.water:
        return const _PracticalActivity(
          title: 'Atelier : observer l’évaporation et la condensation',
          materials: 'Un verre transparent, un peu d’eau et une assiette froide. Un adulte accompagne la manipulation.',
          steps: ['Verse un peu d’eau dans le verre et observe son niveau.', 'Pose l’assiette froide au-dessus du verre sans le fermer hermétiquement.', 'Observe les petites gouttes qui peuvent apparaître sous l’assiette.', 'Décris le changement de l’eau et relie-le au cycle naturel.'],
          observe: 'La vapeur d’eau peut se refroidir et former de petites gouttes : c’est la condensation.',
          safety: 'N’utilise pas d’eau bouillante. Cette démonstration ne rend pas l’eau potable.'
        );
      case _VisualKind.body:
        return const _PracticalActivity(
          title: 'Atelier : mesurer son pouls',
          materials: 'Une montre ou un chronomètre et une fiche pour noter les résultats.',
          steps: ['Assieds-toi et reste calme pendant deux minutes.', 'Pose doucement deux doigts sur le poignet, sans utiliser le pouce.', 'Compte les battements pendant 30 secondes puis multiplie par deux.', 'Marche rapidement sur place une minute et recommence après l’effort.'],
          observe: 'Le cœur bat généralement plus vite après un effort, puis ralentit pendant le repos.',
          safety: 'Reste dans un effort modéré et arrête si tu ressens une gêne.'
        );
      case _VisualKind.geometry:
        return const _PracticalActivity(
          title: 'Atelier : construire et mesurer une figure',
          materials: 'Une feuille, une règle, un crayon et un rapporteur si disponible.',
          steps: ['Trace une figure en suivant les mesures données dans la leçon.', 'Marque les sommets et nomme les côtés.', 'Mesure les longueurs et les angles.', 'Calcule le périmètre ou l’aire selon la consigne.'],
          observe: 'Les mesures permettent de vérifier la construction et de justifier le résultat.',
          safety: 'Utilise les instruments de mesure avec soin.'
        );
      case _VisualKind.fraction:
        return const _PracticalActivity(
          title: 'Atelier : représenter une fraction',
          materials: 'Une feuille quadrillée, un crayon et des crayons de couleur.',
          steps: ['Dessine un rectangle et partage-le en parts égales.', 'Colorie le nombre de parts indiqué par le numérateur.', 'Compte toutes les parts pour identifier le dénominateur.', 'Compare deux dessins pour déterminer quelle fraction est la plus grande.'],
          observe: 'Le dénominateur indique le nombre total de parts égales et le numérateur indique les parts choisies.',
          safety: 'Vérifie que les parts dessinées ont la même taille.'
        );
      case null:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final kind = _kind;
    final activity = _activity;
    if (kind == null || activity == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 22),
        const Text('Voir et comprendre', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Card(
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Text(_diagramTitle(kind),
                        style: const TextStyle(fontWeight: FontWeight.bold))),
                    IconButton(
                      tooltip: 'Agrandir le schéma',
                      onPressed: () => _showExpandedDiagram(context, kind),
                      icon: const Icon(Icons.fullscreen_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Semantics(
                  label: _diagramTitle(kind),
                  hint: 'Schéma agrandissable pour voir les détails.',
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _showExpandedDiagram(context, kind),
                    child: Container(
                      width: double.infinity,
                      height: 270,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CustomPaint(
                          painter: _LessonDiagramPainter(kind, Theme.of(context).colorScheme),
                          child: const SizedBox.expand(),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(children: [
                  Icon(Icons.touch_app_outlined, size: 16,
                      color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 5),
                  Expanded(child: Text('Appuie sur le schéma pour l’agrandir et voir les détails.',
                      style: Theme.of(context).textTheme.bodySmall)),
                ]),
                const SizedBox(height: 8),
                Text(_diagramCaption(kind), style: const TextStyle(height: 1.5)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(children: [
                  Icon(Icons.science_outlined, color: Color(0xFF006A4E)),
                  SizedBox(width: 8),
                  Expanded(child: Text('Pratique et expérience', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))),
                ]),
                const SizedBox(height: 10),
                Text(activity.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Matériel', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(activity.materials),
                const SizedBox(height: 10),
                const Text('Étapes à suivre', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                ...activity.steps.asMap().entries.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    CircleAvatar(radius: 11, child: Text('${e.key + 1}', style: const TextStyle(fontSize: 12))),
                    const SizedBox(width: 8),
                    Expanded(child: Text(e.value, style: const TextStyle(height: 1.4))),
                  ]),
                )),
                const SizedBox(height: 8),
                const Text('Ce que tu dois observer', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(activity.observe, style: const TextStyle(height: 1.45)),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: .45), borderRadius: BorderRadius.circular(10)),
                  child: Text('Sécurité : ${activity.safety}', style: const TextStyle(height: 1.4)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showExpandedDiagram(BuildContext context, _VisualKind kind) {
    final colors = Theme.of(context).colorScheme;
    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog.fullscreen(
        child: Scaffold(
          appBar: AppBar(
            title: Text(_diagramTitle(kind)),
            actions: [
              IconButton(
                tooltip: 'Fermer le schéma agrandi',
                onPressed: () => Navigator.of(dialogContext).pop(),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: InteractiveViewer(
                    minScale: 1,
                    maxScale: 4,
                    boundaryMargin: const EdgeInsets.all(80),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: AspectRatio(
                          aspectRatio: 340 / 210,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: colors.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: colors.outlineVariant),
                            ),
                            child: CustomPaint(
                              painter: _LessonDiagramPainter(kind, colors),
                              child: const SizedBox.expand(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: Text(
                    '${_diagramCaption(kind)}\nPince ou écarte deux doigts pour zoomer.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _diagramTitle(_VisualKind kind) => switch (kind) {
    _VisualKind.circuit => 'Schéma : circuit électrique fermé',
    _VisualKind.plant => 'Croquis : les parties d’une plante',
    _VisualKind.water => 'Schéma : le cycle de l’eau',
    _VisualKind.body => 'Schéma : le corps humain',
    _VisualKind.geometry => 'Quelques figures planes : côtés, sommets et courbes',
    _VisualKind.fraction => 'Schéma : une fraction en parts égales',
  };

  String _diagramCaption(_VisualKind kind) => switch (kind) {
    _VisualKind.circuit => 'Une boucle fermée permet au courant de circuler entre la pile et la lampe.',
    _VisualKind.plant => 'La racine absorbe l’eau, la tige soutient la plante et les feuilles captent la lumière.',
    _VisualKind.water => 'Sous l’action du Soleil, l’eau s’évapore. La vapeur se refroidit et se condense en nuages, puis l’eau retombe sous forme de précipitations et rejoint les sols et les cours d’eau.',
    _VisualKind.body => 'Le schéma situe la tête, le thorax et l’abdomen. Les organes sont représentés de façon simplifiée.',
    _VisualKind.geometry => 'Compare le triangle, le rectangle, le carré et le cercle. Les polygones ont des côtés droits et des sommets ; le cercle n’en a pas.',
    _VisualKind.fraction => 'La bande est partagée en quatre parts égales : trois parts colorées représentent trois quarts.',
  };
}

enum _VisualKind { circuit, plant, water, body, geometry, fraction }

class _PracticalActivity {
  final String title, materials, observe, safety;
  final List<String> steps;
  const _PracticalActivity({required this.title, required this.materials, required this.steps, required this.observe, required this.safety});
}

class _LessonDiagramPainter extends CustomPainter {
  final _VisualKind kind;
  final ColorScheme colors;
  const _LessonDiagramPainter(this.kind, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 340;
    canvas.save();
    canvas.scale(scale, scale);
    final ink = Paint()..color = colors.onSurface..strokeWidth = 2.4..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final fill = Paint()..color = colors.primaryContainer..style = PaintingStyle.fill;
    final accent = Paint()..color = const Color(0xFF16865D)..style = PaintingStyle.fill;
    final blue = Paint()..color = const Color(0xFF2585C5)..style = PaintingStyle.stroke..strokeWidth = 3;
    switch (kind) {
      case _VisualKind.circuit:
        canvas.drawLine(const Offset(55,65), const Offset(55,145), ink);
        canvas.drawLine(const Offset(55,65), const Offset(270,65), ink);
        canvas.drawLine(const Offset(270,65), const Offset(270,145), ink);
        canvas.drawLine(const Offset(270,145), const Offset(55,145), ink);
        canvas.drawLine(const Offset(43,91), const Offset(67,91), ink..strokeWidth=4);
        canvas.drawLine(const Offset(47,105), const Offset(63,105), ink..strokeWidth=2);
        canvas.drawCircle(const Offset(270,105), 20, fill..style=PaintingStyle.fill);
        canvas.drawCircle(const Offset(270,105), 20, ink..style=PaintingStyle.stroke);
        canvas.drawLine(const Offset(258,93), const Offset(282,117), ink);
        canvas.drawLine(const Offset(282,93), const Offset(258,117), ink);
        _text(canvas,'PILE',Offset(22,158),scale);
        _text(canvas,'LAMPE',Offset(245,158),scale);
        _text(canvas,'fils conducteurs',Offset(112,35),scale);
        break;
      case _VisualKind.plant:
        canvas.drawRect(const Rect.fromLTWH(130,125,80,36), Paint()..color=const Color(0xFFB87943));
        canvas.drawLine(const Offset(170,125), const Offset(170,48), Paint()..color=const Color(0xFF16865D)..strokeWidth=6..strokeCap=StrokeCap.round);
        final leaf=Path()..moveTo(170,83)..quadraticBezierTo(105,45,105,78)..quadraticBezierTo(133,112,170,83);
        canvas.drawPath(leaf, accent);
        final leaf2=Path()..moveTo(170,68)..quadraticBezierTo(225,27,237,61)..quadraticBezierTo(218,96,170,68);
        canvas.drawPath(leaf2, accent);
        for (int i=0;i<5;i++){canvas.drawLine(Offset(170,125),Offset(140+i*14,181),Paint()..color=const Color(0xFFB87943)..strokeWidth=2);}
        _text(canvas,'feuilles',Offset(238,43),scale);
        _text(canvas,'tige',Offset(181,94),scale);
        _text(canvas,'racines',Offset(205,165),scale);
        _text(canvas,'sol',Offset(90,143),scale);
        break;
      case _VisualKind.water:
        canvas.drawCircle(const Offset(55,48), 22, Paint()..color=const Color(0xFFFFC247));
        canvas.drawOval(const Rect.fromLTWH(195,35,100,36), fill..style=PaintingStyle.fill);
        canvas.drawOval(const Rect.fromLTWH(220,22,55,48), fill);
        // Précipitations : flèches orientées des nuages vers le sol.
        canvas.drawLine(const Offset(245,83),const Offset(245,126),blue);
        canvas.drawLine(const Offset(245,126),const Offset(238,116),blue);
        canvas.drawLine(const Offset(245,126),const Offset(252,116),blue);
        // Évaporation : flèche montante depuis la surface de l’eau.
        canvas.drawLine(const Offset(112,160),const Offset(112,105),blue);
        canvas.drawLine(const Offset(112,105),const Offset(105,115),blue);
        canvas.drawLine(const Offset(112,105),const Offset(119,115),blue);
        // Retour de l’eau vers la rivière ou la mer.
        canvas.drawPath(Path()..moveTo(35,178)..quadraticBezierTo(95,150,155,178)..quadraticBezierTo(220,205,310,168), blue..strokeWidth=5);
        _text(canvas,'soleil',Offset(25,80),scale);
        _text(canvas,'nuages',Offset(215,8),scale);
        _text(canvas,'pluie',Offset(260,112),scale);
        _text(canvas,'eau',Offset(150,194),scale);
        _text(canvas,'évaporation',Offset(62,88),scale);
        break;
      case _VisualKind.body:
        canvas.drawCircle(const Offset(170,42), 25, fill);
        canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(137,70,66,86),const Radius.circular(22)),fill);
        canvas.drawLine(const Offset(137,87),const Offset(103,137),ink);
        canvas.drawLine(const Offset(203,87),const Offset(237,137),ink);
        canvas.drawLine(const Offset(153,154),const Offset(143,195),ink);
        canvas.drawLine(const Offset(187,154),const Offset(197,195),ink);
        canvas.drawCircle(const Offset(170,105), 10, Paint()..color=const Color(0xFFE46B64));
        _text(canvas,'tête',Offset(207,30),scale);
        _text(canvas,'thorax',Offset(215,90),scale);
        _text(canvas,'abdomen',Offset(210,137),scale);
        _text(canvas,'membres',Offset(42,175),scale);
        break;
      case _VisualKind.geometry:
        // Planche comparative : les quatre figures restent visibles même
        // lorsque la leçon ne porte que sur l'une d'elles.
        final triangle=Path()..moveTo(48,112)..lineTo(92,38)..lineTo(136,112)..close();
        canvas.drawPath(triangle, ink);
        canvas.drawRect(const Rect.fromLTWH(188,48,112,62),fill);
        canvas.drawRect(const Rect.fromLTWH(188,48,112,62),ink);
        canvas.drawRect(const Rect.fromLTWH(48,155,72,72),fill);
        canvas.drawRect(const Rect.fromLTWH(48,155,72,72),ink);
        canvas.drawCircle(const Offset(244,191),36,fill);
        canvas.drawCircle(const Offset(244,191),36,ink);
        _text(canvas,'TRIANGLE',Offset(43,120),scale);
        _text(canvas,'RECTANGLE',Offset(202,116),scale);
        _text(canvas,'CARRÉ',Offset(60,231),scale);
        _text(canvas,'CERCLE',Offset(225,235),scale);
        break;
      case _VisualKind.fraction:
        const left=30.0, top=78.0, width=280.0, height=58.0;
        for(int i=0;i<4;i++){
          final rect=Rect.fromLTWH(left+i*width/4,top,width/4,height);
          canvas.drawRect(rect,i<3?accent:fill);
          canvas.drawRect(rect,ink);
        }
        _text(canvas,'3 parts coloriées sur 4',Offset(88,38),scale);
        _text(canvas,'3/4',Offset(150,153),scale);
        break;
    }
    canvas.restore();
  }

  void _text(Canvas canvas, String value, Offset position, double scale) {
    final painter=TextPainter(text:TextSpan(text:value,style:TextStyle(color:colors.onSurface,fontSize:11,fontWeight:FontWeight.w600)),textDirection:TextDirection.ltr)..layout(maxWidth:100);
    painter.paint(canvas,position);
  }

  @override
  bool shouldRepaint(covariant _LessonDiagramPainter oldDelegate) => oldDelegate.kind != kind || oldDelegate.colors != colors;
}
