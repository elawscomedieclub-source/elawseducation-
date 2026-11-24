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
    // Le dessin représente un circuit simple fermé en boucle unique.
    // Il ne doit pas être confondu avec un montage en série/parallèle détaillé.
    if (RegExp(r'circuit électrique simple|circuit fermé').hasMatch(title) &&
        !RegExp(r'en série|en parallèle').hasMatch(title)) return _VisualKind.circuit;
    // Le croquis actuel représente une plante développée, pas les étapes
    // de germination : ne pas l'afficher pour une leçon sur la germination.
    if (RegExp(r'germination').hasMatch(title)) return null;
    if (RegExp(r'parties de la plante|structure de la plante|la plante et ses parties').hasMatch(title)) return _VisualKind.plant;
    // Le schéma représente le cycle complet ; il n'est pas adapté à une
    // leçon isolée sur l'évaporation, la condensation ou les précipitations.
    if (RegExp(r'cycle de l.eau').hasMatch(title)) return _VisualKind.water;
    if (RegExp(r'corps humain|parties du corps humain').hasMatch(title)) return _VisualKind.body;
    // La planche actuelle compare quatre figures : la réserver aux leçons
    // générales. Une leçon sur le seul triangle/carré/etc. ne doit pas recevoir
    // une planche qui pourrait faire croire que les autres figures sont étudiées.
    // Le cercle générique ne doit pas remplacer un schéma spécialisé de trigonométrie.\n    if (RegExp(r'cercle trigonométrique|trigonométrie|angle inscrit|tangente.*cercle|cercle.*tangente').hasMatch(title)) return null;\n    if (RegExp(r'cercle|cercles|disque|disques').hasMatch(title)) return _VisualKind.circle;
    // Un cours consacré au carré reçoit son propre dessin : quatre côtés égaux
    // et quatre angles droits, sans la planche comparative des figures.
    if (RegExp(r'^(?:le\s+|les\s+)?rectangles?\b|^(?:tracer\s+(?:un|des)|(?:(?:la|les)\s+)?(?:construction|propriétés)\s+(?:du|des))\s+rectangles?\b').hasMatch(title)) return _VisualKind.rectangle;
    if (RegExp(r'^(?:le\s+|les\s+)?carrés?\b|^(?:tracer\s+(?:un|des)|(?:(?:la|les)\s+)?(?:construction|propriétés)\s+(?:du|des))\s+carrés?\b').hasMatch(title)) return _VisualKind.square;
    // Un triangle rectangle doit montrer explicitement son angle droit ;
    // le triangle générique ne convient pas à cette leçon ciblée.
    if (RegExp(r'triangle rectangle|triangles rectangles').hasMatch(title)) return _VisualKind.rightTriangle;
    // Ne pas présenter un triangle quelconque comme isocèle, équilatéral ou obtusangle :\n    // ces types nécessitent des côtés/angles explicitement marqués.\n    if (RegExp(r'triangles?\\s+(?:isocèle|équilatéral|scalène|obtusangle|acutangle)').hasMatch(title)) return null;\n    if (RegExp(r'triangle|triangles').hasMatch(title)) return _VisualKind.triangle;
    if (RegExp(r'figures géométriques|figures planes|polygones').hasMatch(title) &&
        !RegExp(r'triangle').hasMatch(title)) return _VisualKind.geometry;
    // Ce schéma compare moitié, quart et trois quarts : ne pas l'afficher
    // pour une leçon ciblant une seule fraction (moitié, tiers ou quart).
    if (RegExp(r'fractions|représenter une fraction|fraction en parts égales').hasMatch(title)) return _VisualKind.fraction;
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
          title: 'Atelier : reconnaître les parties d’une plante',
          materials: 'Une petite plante en pot, un dessin de plante entière ou une plante cultivée dans un récipient transparent.',
          steps: ['Observe la plante sans l’arracher.', 'Repère les feuilles, la tige et les racines si elles sont visibles.', 'Dessine la plante et trace une flèche vers chaque partie.', 'Associe chaque partie à son rôle : absorber l’eau, soutenir ou capter la lumière.'],
          observe: 'La racine absorbe l’eau et les sels minéraux, la tige soutient la plante et transporte la sève, les feuilles captent la lumière.',
          safety: 'Ne goûte aucune plante inconnue. Lave-toi les mains après l’observation et ne déracine pas la plante.'
        );
      case _VisualKind.water:
        return const _PracticalActivity(
          title: 'Atelier : observer l’évaporation et la condensation',
          materials: 'Un récipient transparent, un peu d’eau tiède (jamais chaude), une assiette métallique ou en verre et quelques glaçons. Un adulte accompagne la manipulation.',
          steps: ['Verse un fond d’eau tiède dans le récipient.', 'Pose l’assiette au-dessus sans fermer hermétiquement le récipient.', 'Dépose quelques glaçons sur l’assiette pour refroidir sa face inférieure.', 'Observe les gouttelettes qui peuvent se former sous l’assiette et décris leur origine.'],
          observe: 'Une partie de l’eau s’évapore ; au contact de la surface refroidie, la vapeur se condense en gouttelettes.',
          safety: 'Un adulte manipule l’eau tiède et les glaçons. N’utilise jamais d’eau bouillante et ne bois pas l’eau de l’expérience.'
        );
      case _VisualKind.body:
        return const _PracticalActivity(
          title: 'Atelier : mesurer son pouls',
          materials: 'Une montre ou un chronomètre et une fiche pour noter les résultats.',
          steps: ['Assieds-toi et reste calme pendant deux minutes.', 'Pose doucement deux doigts sur le poignet, sans utiliser le pouce.', 'Compte les battements pendant 30 secondes puis multiplie par deux.', 'Marche rapidement sur place une minute et recommence après l’effort.'],
          observe: 'Le cœur bat généralement plus vite après un effort, puis ralentit pendant le repos.',
          safety: 'Reste dans un effort modéré et arrête si tu ressens une gêne.'
        );
      case _VisualKind.circle:
        return const _PracticalActivity(
          title: 'Atelier : reconnaître et tracer un cercle',
          materials: 'Une feuille, un crayon et un compas (ou un objet rond pour tracer le contour).',
          steps: ['Repère le centre du cercle.', 'Avec un compas, trace un cercle autour du centre.', 'Repère un rayon du centre jusqu’au cercle.', 'Compare le diamètre et le rayon.'],
          observe: 'Le cercle est l’ensemble des points situés à la même distance du centre. Le diamètre passe par le centre et vaut deux rayons.',
          safety: 'Manipule la pointe du compas avec prudence ; si tu utilises un objet rond, demande à un adulte de vérifier qu’il est stable.'
        );
      case _VisualKind.rectangle:
        return const _PracticalActivity(
          title: 'Atelier : construire un rectangle',
          materials: 'Une feuille quadrillée, une règle et une équerre.',
          steps: ['Trace une longueur de 6 cm.', 'Construis un angle droit à une extrémité.', 'Reporte une largeur de 3 cm.', 'Complète les côtés opposés et vérifie les quatre angles droits.'],
          observe: 'Un rectangle possède quatre angles droits. Ses côtés opposés sont parallèles et de même longueur.',
          safety: 'Utilise l’équerre et la règle avec soin.'
        );
      case _VisualKind.square:
        return const _PracticalActivity(
          title: 'Atelier : construire un carré',
          materials: 'Une feuille quadrillée, une règle et un crayon.',
          steps: ['Trace un segment de 4 cm.', 'Construis un angle droit à chaque extrémité.', 'Reporte 4 cm sur chaque côté.', 'Relie les quatre sommets et vérifie les côtés et les angles.'],
          observe: 'Un carré possède quatre côtés de même longueur et quatre angles droits.',
          safety: 'Utilise la règle avec soin.'
        );
      case _VisualKind.rightTriangle:
        return const _PracticalActivity(
          title: 'Atelier : reconnaître un triangle rectangle',
          materials: 'Une feuille, une règle et une équerre.',
          steps: ['Trace deux segments perpendiculaires qui se rencontrent en A.', 'Relie leurs extrémités par un troisième segment.', 'Marque l’angle droit en A.', 'Repère l’hypoténuse : elle est opposée à l’angle droit.'],
          observe: 'Un triangle rectangle possède un angle droit. Le côté opposé à cet angle est l’hypoténuse, le plus long côté du triangle.',
          safety: 'Manipule l’équerre et la règle avec soin.'
        );
      case _VisualKind.triangle:
        return const _PracticalActivity(
          title: 'Atelier : reconnaître et tracer un triangle',
          materials: 'Une feuille, une règle et un crayon.',
          steps: ['Observe le triangle et repère ses trois sommets.', 'Trace un triangle avec une règle en reliant trois points non alignés.', 'Nomme les sommets A, B et C.', 'Compte ses côtés et ses angles.'],
          observe: 'Un triangle est un polygone qui possède trois côtés, trois sommets et trois angles.',
          safety: 'Utilise la règle avec soin et ne la dirige pas vers le visage.'
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
    _VisualKind.circle => 'Schéma : cercle, centre, rayon et diamètre',
    _VisualKind.rectangle => 'Schéma : rectangle, côtés opposés égaux et angles droits',
    _VisualKind.square => 'Schéma : carré, quatre côtés égaux et angles droits',
    _VisualKind.rightTriangle => 'Schéma : triangle rectangle et hypoténuse',
    _VisualKind.triangle => 'Schéma : triangle et ses trois sommets',
    _VisualKind.geometry => 'Quelques figures planes : côtés, sommets et courbes',
    _VisualKind.fraction => 'Schéma : une fraction en parts égales',
  };

  String _diagramCaption(_VisualKind kind) => switch (kind) {
    _VisualKind.circuit => 'Une boucle fermée permet au courant de circuler entre la pile et la lampe.',
    _VisualKind.plant => 'La racine absorbe l’eau, la tige soutient la plante et les feuilles captent la lumière.',
    _VisualKind.water => 'Sous l’action du Soleil, l’eau s’évapore. La vapeur se refroidit et se condense en nuages, puis l’eau retombe sous forme de précipitations et rejoint les sols et les cours d’eau.',
    _VisualKind.body => 'Le schéma situe la tête, le thorax et l’abdomen. Les organes sont représentés de façon simplifiée.',
    _VisualKind.circle => 'Le cercle est une ligne courbe fermée dont tous les points sont à la même distance du centre. Le diamètre passe par le centre et mesure deux rayons.',
    _VisualKind.rectangle => 'Le rectangle est un quadrilatère qui possède quatre angles droits ; ses côtés opposés sont égaux et parallèles.',
    _VisualKind.square => 'Le carré est un quadrilatère : ses quatre côtés sont égaux et ses quatre angles sont droits.',
    _VisualKind.rightTriangle => 'Le triangle rectangle possède un angle droit. L’hypoténuse est le côté opposé à cet angle.',
    _VisualKind.triangle => 'Un triangle est une figure fermée formée de trois segments : AB, BC et CA. Il possède trois sommets.',
    _VisualKind.geometry => 'Compare le triangle, le rectangle, le carré et le cercle. Les polygones ont des côtés droits et des sommets ; le cercle n’en a pas.',
    _VisualKind.fraction => 'Chaque bande est partagée en parts égales. Compare une moitié (1/2), un quart (1/4) et trois quarts (3/4).',
  };
}

enum _VisualKind { circuit, plant, water, body, circle, rectangle, square, rightTriangle, triangle, geometry, fraction }

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
        // La pile interrompt le conducteur : les deux traits représentent
        // ses bornes et ne doivent pas être traversés par un fil continu.
        canvas.drawLine(const Offset(55,65), const Offset(55,87), ink);
        canvas.drawLine(const Offset(55,109), const Offset(55,145), ink);
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
        // Cœur stylisé placé dans le thorax : repère visuel, non anatomie détaillée.
        final heart=Path()
          ..moveTo(170,116)
          ..cubicTo(151,105,150,91,160,89)
          ..cubicTo(166,88,170,93,170,97)
          ..cubicTo(174,91,181,88,186,93)
          ..cubicTo(196,103,183,113,170,123)
          ..close();
        canvas.drawPath(heart,Paint()..color=const Color(0xFFE46B64)..style=PaintingStyle.fill);
        canvas.drawPath(heart,ink);
        _text(canvas,'tête',Offset(207,30),scale);
        _text(canvas,'cœur',Offset(215,105),scale);
        _text(canvas,'thorax',Offset(215,82),scale);
        _text(canvas,'abdomen',Offset(210,137),scale);
        _text(canvas,'membres',Offset(42,175),scale);
        break;
      case _VisualKind.circle:
        canvas.drawCircle(const Offset(170, 112), 72, fill);
        canvas.drawCircle(const Offset(170, 112), 72, ink);
        canvas.drawCircle(const Offset(170, 112), 4, Paint()..color = colors.primary);
        canvas.drawLine(const Offset(170, 112), const Offset(242, 112), blue);
        canvas.drawLine(const Offset(98, 112), const Offset(242, 112), ink);
        _text(canvas, 'O (centre)', const Offset(126, 120), scale);
        _text(canvas, 'rayon', const Offset(194, 91), scale);
        _text(canvas, 'diamètre', const Offset(175, 135), scale);
        break;
      case _VisualKind.rectangle:
        const rect = Rect.fromLTWH(62, 72, 216, 112);
        canvas.drawRect(rect, fill);
        canvas.drawRect(rect, ink);
        final rightAngle = Paint()..color = colors.primary..style = PaintingStyle.stroke..strokeWidth = 2;
        canvas.drawLine(const Offset(62, 92), const Offset(82, 92), rightAngle);
        canvas.drawLine(const Offset(82, 92), const Offset(82, 72), rightAngle);
        canvas.drawLine(const Offset(258, 72), const Offset(258, 92), rightAngle);
        canvas.drawLine(const Offset(258, 92), const Offset(278, 92), rightAngle);
        canvas.drawLine(const Offset(62, 164), const Offset(82, 164), rightAngle);
        canvas.drawLine(const Offset(82, 164), const Offset(82, 184), rightAngle);
        canvas.drawLine(const Offset(258, 164), const Offset(278, 164), rightAngle);
        canvas.drawLine(const Offset(258, 164), const Offset(258, 184), rightAngle);
        _text(canvas, 'longueur', const Offset(132, 47), scale);
        _text(canvas, 'largeur', const Offset(8, 120), scale);
        _text(canvas, 'côtés opposés égaux', const Offset(92, 198), scale);
        break;
      case _VisualKind.square:
        const rect = Rect.fromLTWH(94, 48, 152, 152);
        canvas.drawRect(rect, fill);
        canvas.drawRect(rect, ink);
        // Petits repères d'angle droit dans les quatre coins.
        final mark = Paint()..color = colors.primary..style = PaintingStyle.stroke..strokeWidth = 2;
        canvas.drawLine(const Offset(94, 68), const Offset(114, 68), mark);
        canvas.drawLine(const Offset(114, 68), const Offset(114, 48), mark);
        canvas.drawLine(const Offset(226, 48), const Offset(226, 68), mark);
        canvas.drawLine(const Offset(226, 68), const Offset(246, 68), mark);
        canvas.drawLine(const Offset(94, 180), const Offset(114, 180), mark);
        canvas.drawLine(const Offset(114, 180), const Offset(114, 200), mark);
        canvas.drawLine(const Offset(226, 180), const Offset(246, 180), mark);
        canvas.drawLine(const Offset(226, 180), const Offset(226, 200), mark);
        _text(canvas, '4 côtés égaux', const Offset(115, 18), scale);
        _text(canvas, 'angle droit', const Offset(10, 75), scale);
        _text(canvas, '4 côtés égaux', const Offset(115, 210), scale);
        break;
      case _VisualKind.rightTriangle:
        final rightTriangle = Path()
          ..moveTo(82, 184)
          ..lineTo(82, 48)
          ..lineTo(270, 184)
          ..close();
        canvas.drawPath(rightTriangle, fill);
        canvas.drawPath(rightTriangle, ink);
        final rightMark = Paint()..color = colors.primary..style = PaintingStyle.stroke..strokeWidth = 2.5;
        canvas.drawLine(const Offset(82, 160), const Offset(106, 160), rightMark);
        canvas.drawLine(const Offset(106, 160), const Offset(106, 184), rightMark);
        _text(canvas, 'A (angle droit)', const Offset(12, 190), scale);
        _text(canvas, 'B', const Offset(70, 25), scale);
        _text(canvas, 'C', const Offset(275, 184), scale);
        _text(canvas, 'hypoténuse', const Offset(156, 105), scale);
        break;
      case _VisualKind.triangle:
        final triangle = Path()
          ..moveTo(70, 180)
          ..lineTo(170, 45)
          ..lineTo(270, 180)
          ..close();
        canvas.drawPath(triangle, fill);
        canvas.drawPath(triangle, ink);
        _text(canvas, 'A', const Offset(58, 184), scale);
        _text(canvas, 'B', const Offset(166, 25), scale);
        _text(canvas, 'C', const Offset(275, 184), scale);
        _text(canvas, 'AB', const Offset(104, 105), scale);
        _text(canvas, 'BC', const Offset(225, 105), scale);
        _text(canvas, 'CA', const Offset(165, 190), scale);
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
        // Trois exemples distincts évitent de présenter 3/4 comme modèle
        // unique lorsqu'un élève étudie la moitié ou le quart.
        const left=112.0, width=190.0, height=34.0;
        const tops=[42.0,105.0,168.0];
        const counts=[2,4,4];
        const colored=[1,1,3];
        for(int row=0;row<3;row++){
          for(int i=0;i<counts[row];i++){
            final rect=Rect.fromLTWH(left+i*width/counts[row],tops[row],width/counts[row],height);
            canvas.drawRect(rect,i<colored[row]?accent:fill);
            canvas.drawRect(rect,ink);
          }
        }
        _text(canvas,'MOITIÉ 1/2',Offset(12,52),scale);
        _text(canvas,'QUART 1/4',Offset(12,115),scale);
        _text(canvas,'TROIS QUARTS',Offset(12,178),scale);
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
