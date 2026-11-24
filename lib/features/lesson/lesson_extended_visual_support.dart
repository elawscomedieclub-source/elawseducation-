import 'package:flutter/material.dart';

import '../../data/models/models.dart';

/// Deuxième bibliothèque de supports visuels : sciences, environnement,
/// technologie et géographie. Les supports sont dessinés avec Flutter et
/// fonctionnent sans connexion ni images distantes.
class ExtendedLessonVisualSupport extends StatelessWidget {
  final Lesson lesson;
  const ExtendedLessonVisualSupport({super.key, required this.lesson});

  _Support? get _support {
    final text = lesson.title.toLowerCase();
    if (RegExp(r'groupes égaux|multiplication par addition répétée').hasMatch(text)) {
      return const _Support(
        title: 'La multiplication représentée par des groupes égaux',
        showArrows: false,
        icon: Icons.calculate,
        nodes: ['4 groupes de 3', '3 + 3 + 3 + 3', '4 × 3 = 12'],
        explanation: 'Quatre groupes de trois objets donnent 3 + 3 + 3 + 3 = 12, soit 4 × 3 = 12. La multiplication permet de compter plus rapidement des groupes égaux.',
        activity: 'Former des groupes et vérifier une multiplication',
        materials: '12 petits cailloux propres ou bouchons, une feuille et un crayon.',
        steps: ['Pose 12 objets sur la table.', 'Répartis-les en 4 groupes contenant le même nombre.', 'Compte les objets dans un groupe.', 'Écris l’addition répétée puis la multiplication correspondante.', 'Recommence avec 3 groupes de 4 objets.'],
        result: '4 groupes de 3 et 3 groupes de 4 contiennent chacun 12 objets.',
        safety: 'Utilise des objets assez gros pour ne pas être avalés et range-les après l’activité.'
      );
    }
    if (RegExp(r'aimants? et magnétisme|magnétisme|pôles d.un aimant|aimant permanent').hasMatch(text)) {
      return const _Support(
        title: 'Le magnétisme : deux pôles',
        showArrows: false,
        icon: Icons.explore,
        nodes: ['Pôle nord', 'Aimant', 'Pôle sud'],
        explanation: 'Un aimant possède deux pôles. Deux pôles opposés s’attirent ; deux pôles identiques se repoussent.',
        activity: 'Observer l’attraction et la répulsion des pôles',
        materials: 'Deux aimants dont les pôles nord et sud sont repérés.',
        steps: ['Choisis un pôle de chaque aimant.', 'Approche doucement les deux pôles nord l’un de l’autre, sans les laisser heurter.', 'Inverse un aimant pour rapprocher un pôle nord et un pôle sud.', 'Observe et note si les aimants s’attirent ou se repoussent.'],
        result: 'Deux pôles identiques se repoussent ; deux pôles opposés s’attirent. Ne conclus pas qu’un aimant attire tous les métaux. ',
        safety: 'Ne place pas l’aimant près d’un téléphone, d’une carte magnétique ou d’un appareil médical.'
      );
    }
    if (RegExp(r'propagation du son|vibration sonore|production du son').hasMatch(text)) {
      return const _Support(
        title: 'Comment le son se propage',
        icon: Icons.graphic_eq,
        nodes: ['Source qui vibre', 'Milieu matériel', 'Oreille'],
        explanation: 'Un son est produit par une vibration. Elle se transmet dans un milieu matériel (air, eau ou solide) jusqu’à l’oreille ; le son ne se propage pas dans le vide.',
        activity: 'Observer la vibration qui produit un son',
        materials: 'Une boîte en carton vide et un élastique épais, en bon état.',
        steps: ['Place l’élastique autour de la boîte sans le tendre excessivement.', 'Avec l’accord de l’enseignant, pince doucement l’élastique et relâche-le.', 'Observe le mouvement rapide de l’élastique et écoute le son produit.', 'Pince-le doucement à différents endroits et compare les sons.'],
        result: 'L’élastique vibre lorsqu’il produit un son. La boîte peut renforcer le son en transmettant ses vibrations à l’air.',
        safety: 'N’utilise pas un élastique usé ou trop tendu. Ne le dirige pas vers le visage et ne produis pas de sons forts près des oreilles.'
      );
    }
    if (RegExp(r'chaine alimentaire|chaîne alimentaire|réseau alimentaire').hasMatch(text)) {
      return const _Support(
        title: 'Exemple de chaîne alimentaire',
        icon: Icons.eco,
        nodes: ['Herbe', 'Criquet', 'Grenouille', 'Serpent'],
        explanation: 'La flèche va de l’organisme mangé vers celui qui le mange : elle indique le transfert de matière et d’énergie.',
        activity: 'Construire une chaîne alimentaire locale',
        materials: 'Feuille, crayon et exemples d’êtres vivants observés dans ton environnement.',
        steps: ['Choisis une plante et trois animaux de ton milieu.', 'Identifie qui mange qui à partir d’observations ou d’un document fiable.', 'Dessine les êtres vivants dans l’ordre.', 'Trace chaque flèche de l’aliment vers le consommateur.', 'Vérifie que chaque organisme peut réellement se nourrir de celui qui le précède.'],
        result: 'Exemple possible : herbe → criquet → grenouille → serpent. La chaîne dépend du milieu et toutes les espèces ne suivent pas nécessairement cette suite.',
        safety: 'Observe les animaux à distance et ne détruis pas leur habitat.'
      );
    }
    if (RegExp(r'composition du sol|constituants du sol').hasMatch(text)) {
      return const _Support(
        title: 'Les principaux constituants du sol',
        showArrows: false,
        icon: Icons.landscape,
        nodes: ['Matières minérales', 'Matière organique', 'Eau', 'Air'],
        explanation: 'Le sol est un mélange de particules minérales, de matière organique, d’eau et d’air. Les proportions varient selon le lieu et les conditions du milieu.',
        activity: 'Observer un échantillon de sol et identifier ses constituants',
        materials: 'Un peu de terre, une coupelle, une loupe si disponible et un bocal transparent.',
        steps: ['Observe la terre sèche dans la coupelle.', 'Repère les petits fragments minéraux et les restes végétaux visibles.', 'Place une petite quantité dans le bocal et ajoute un peu d’eau avec l’aide de l’enseignant.', 'Observe les bulles d’air qui peuvent s’échapper et les particules qui se déposent.', 'Note les constituants observés et ceux qui ne sont pas visibles directement.'],
        result: 'Un sol contient des éléments solides, de l’eau et de l’air ; il abrite aussi des organismes vivants.',
        safety: 'Ne goûte pas la terre, évite la poussière et lave-toi les mains après l’activité.'
      );
    }
    if (RegExp(r'couches du sol|profil du sol|horizons du sol').hasMatch(text)) {
      return const _Support(
        title: 'Profil simplifié des horizons du sol',
        showArrows: false,
        icon: Icons.landscape,
        nodes: ['Litière et humus', 'Horizon A', 'Horizon B', 'Roche mère altérée'],
        explanation: 'Un profil de sol présente des horizons superposés. Leur épaisseur et leur aspect varient selon le climat, la roche, les organismes et la durée de formation ; ce schéma est simplifié et ne décrit pas tous les sols.',
        activity: 'Lire et légender un profil de sol',
        materials: 'Un dessin de profil de sol, une feuille et un crayon.',
        steps: ['Observe les horizons représentés sur le document.', 'Repère la couche de surface riche en matière organique.', 'Repère les horizons plus profonds et la roche mère altérée.', 'Compare deux profils et note leurs différences.'],
        result: 'Les horizons sont des couches du sol qui se distinguent par leurs propriétés.',
        safety: 'Pour une observation sur le terrain, reste avec l’enseignant et ne creuse pas près d’une route ou d’un ouvrage.'
      );
    }
    if (RegExp(r'décantation d.un échantillon de sol|décantation du sol').hasMatch(text)) {
      return const _Support(
        title: 'Observer la décantation d’un échantillon de sol',
        icon: Icons.landscape,
        showArrows: false,
        nodes: ['Sol + eau', 'Matières flottantes', 'Particules déposées', 'Eau plus claire'],
        explanation: 'Après agitation et repos, certaines matières organiques peuvent flotter et les particules minérales se déposent à des vitesses différentes. Cette observation montre la composition d’un échantillon ; elle ne représente pas les véritables horizons d’un sol en place.',
        activity: 'Observer les constituants d’un sol par décantation',
        materials: 'Un bocal transparent avec couvercle, un peu de terre de jardin, de l’eau et une cuillère.',
        steps: ['Place une petite quantité de terre dans le bocal.', 'Ajoute de l’eau en laissant un espace libre, puis ferme le couvercle.', 'Agite doucement le bocal et pose-le sur une surface stable.', 'Laisse reposer plusieurs heures sans le déplacer.', 'Observe les matières flottantes, les dépôts au fond et l’eau au-dessus.'],
        result: 'L’échantillon peut montrer des matières organiques et des particules minérales qui se déposent. La séparation dépend de la taille et de la nature des particules.',
        safety: 'Ne goûte jamais la terre ni l’eau du bocal. Évite de respirer la poussière, lave-toi les mains et fais l’activité avec l’aide d’un adulte.'
      );
    }
    // Ce schéma montre uniquement une filtration sable-eau.
    // Il ne convient pas à la classification des mélanges homogènes
    // ni à une leçon consacrée à la décantation.
    if (RegExp(r'mélange homogène').hasMatch(text)) return null;
    if (RegExp(r'filtration').hasMatch(text)) {
      return const _Support(
        title: 'Filtrer un mélange de sable et d’eau',
        icon: Icons.science,
        nodes: ['Sable + eau', 'Filtre', 'Sable retenu', 'Eau filtrée'],
        explanation: 'La filtration retient le sable dans le filtre et laisse passer l’eau. Elle ne rend pas forcément l’eau potable.',
        activity: 'Réaliser une filtration simple',
        materials: 'Un entonnoir, un filtre à café, un récipient, de l’eau et un peu de sable.',
        steps: ['Mélange le sable avec l’eau dans un récipient.', 'Place le filtre dans l’entonnoir.', 'Verse doucement le mélange.', 'Observe le sable retenu et l’eau recueillie.', 'Décris ce que la filtration a séparé.'],
        result: 'Le sable est retenu par le filtre tandis que l’eau traverse le papier.',
        safety: 'Ne bois jamais l’eau obtenue : une filtration scolaire ne garantit pas la potabilité.'
      );
    }
    if (RegExp(r'levier').hasMatch(text)) {
      return const _Support(
        title: 'Principe d’une machine simple',
        showArrows: false,
        icon: Icons.build,
        nodes: ['Effort', 'Point d’appui', 'Charge'],
        explanation: 'Une machine simple peut modifier la direction ou l’intensité de l’effort nécessaire pour déplacer une charge.',
        activity: 'Observer l’effet d’un levier',
        materials: 'Une règle solide, une gomme et un petit objet léger.',
        steps: ['Pose la gomme sous la règle pour former le point d’appui.', 'Place le petit objet à une extrémité.', 'Appuie doucement sur l’autre extrémité.', 'Déplace le point d’appui et compare l’effort ressenti.'],
        result: 'La position du point d’appui influence l’effort nécessaire.',
        safety: 'Utilise uniquement un objet léger et ne dirige jamais la règle vers le visage.'
      );
    }
    // La rose des vents ne représente pas les coordonnées géographiques,
    // l'échelle, la légende ou les symboles d'une carte.
    if (RegExp(r'latitude|longitude|coordonnées géographiques|échelle d.une carte|légende d.une carte|symboles cartographiques|calculer une distance sur une carte|projection cartographique').hasMatch(text)) return null;
    if (RegExp(r'points cardinaux|rose des vents|s orienter avec une carte|lire une carte géographique').hasMatch(text)) {
      return const _Support(
        title: 'S’orienter avec les points cardinaux',
        showArrows: false,
        icon: Icons.navigation,
        nodes: ['Nord', 'Est', 'Sud', 'Ouest'],
        explanation: 'Les quatre points cardinaux servent à décrire une direction et à lire une carte.',
        activity: 'Réaliser une rose des vents',
        materials: 'Une feuille, une règle, un crayon et une boussole si disponible.',
        steps: ['Trace deux lignes perpendiculaires.', 'Place le Nord en haut et le Sud en bas.', 'Inscris l’Est à droite et l’Ouest à gauche.', 'Repère la direction de deux lieux de ton école ou quartier.'],
        result: 'Une direction peut être décrite à partir des points cardinaux.',
        safety: 'Réalise l’activité dans un endroit sûr, avec l’accord de ton enseignant.'
      );
    }
    // La conversion km/m ne suffit pas pour illustrer les autres unités,
    // les vitesses ou les calculs de durée.
    if (RegExp(r'vitesse moyenne|durée du trajet|temps de parcours|mètre par seconde|kilomètres? par heure|\bkm/h\b|\bm/s\b|convertir.*(cm|mm|dm)|millimètre.*centimètre|centimètre.*millimètre').hasMatch(text)) return null;
    if (RegExp(r'kilomètre|kilomètres|km\b|convertir.*distance|distance.*kilométr').hasMatch(text)) {
      return const _Support(
        title: 'Mesurer et convertir une distance en kilomètres',
        icon: Icons.route,
        nodes: ['1 km', '1 000 m', 'Distance parcourue'],
        explanation: 'Le kilomètre sert à mesurer de grandes distances. Un kilomètre équivaut à mille mètres : 1 km = 1 000 m. Pour convertir des kilomètres en mètres, on multiplie par 1 000.',
        activity: 'Estimer et comparer une distance connue',
        materials: 'Un itinéraire sûr connu avec un adulte, une carte ou un panneau de distance et un cahier.',
        steps: ['Choisis avec un adulte un trajet sûr dont la distance est indiquée.', 'Note la distance en kilomètres.', 'Convertis-la en mètres en multipliant par 1 000.', 'Compare deux distances en utilisant la même unité.'],
        result: '2 km = 2 000 m ; 0,5 km = 500 m. Il faut comparer les distances dans une unité commune.',
        safety: 'Ne parcours pas de route ni de quartier seul pour mesurer une distance. Utilise une carte ou une mesure déjà disponible.'
      );
    }
    if (RegExp(r'mesure des longueurs|mesurer une longueur|unités de longueur|\bcentimètres?\b|\bmillimètres?\b|\bmètres?\b|règle graduée').hasMatch(text)) {
      return const _Support(
        title: 'Mesurer une longueur avec une règle graduée',
        icon: Icons.straighten,
        nodes: ['Placer le zéro', 'Aligner l’objet', 'Lire la graduation', 'Noter en cm'],
        explanation: 'Pour mesurer un objet, on aligne son début sur le zéro de la règle, puis on lit la graduation située à son autre extrémité. On écrit toujours l’unité.',
        activity: 'Mesurer deux objets de la classe',
        materials: 'Une règle graduée et deux objets sans danger.',
        steps: ['Place le zéro de la règle au début du premier objet.', 'Lis la graduation à l’autre extrémité.', 'Note la mesure en centimètres.', 'Recommence avec le deuxième objet et compare.'],
        result: 'La longueur est la distance entre les deux extrémités. 1 m = 100 cm.',
        safety: 'Ne pousse pas la règle vers le visage et manipule les objets avec soin.'
      );
    }
    if (RegExp(r'monnaie|franc cfa|calculer un achat|prix total|monnaie rendue').hasMatch(text)) {
      return const _Support(
        title: 'Calculer un achat et la monnaie rendue',
        icon: Icons.payments_outlined,
        nodes: ['Prix des articles', 'Somme donnée', 'Soustraction', 'Monnaie rendue'],
        explanation: 'On additionne les prix pour trouver le total. On soustrait ensuite ce total de la somme donnée pour calculer la monnaie à rendre.',
        activity: 'Simuler un achat au marché',
        materials: 'Des étiquettes de prix et des billets dessinés.',
        steps: ['Choisis deux articles et lis leurs prix.', 'Additionne les deux prix.', 'Choisis une somme suffisante pour payer.', 'Soustrais le total de la somme donnée.'],
        result: 'Monnaie rendue = somme donnée − prix total.',
        safety: 'Utilise de la monnaie fictive pour cette activité.'
      );
    }
    if (RegExp(r'accord du verbe|sujet et verbe|accord sujet-verbe|accord du sujet avec le verbe').hasMatch(text)) {
      return const _Support(
        title: 'La phrase : sujet et verbe',
        icon: Icons.menu_book,
        nodes: ['SUJET', 'VERBE', 'COMPLÉMENT'],
        explanation: 'Le sujet indique qui fait l’action. Le verbe exprime l’action et change selon le sujet. Exemple : Les élèves (sujet) lisent (verbe) un texte (complément).',
        activity: 'Construire et transformer des phrases',
        materials: 'Des étiquettes de mots ou des petits papiers.',
        steps: ['Écris trois sujets : je, nous, les élèves.', 'Choisis le verbe chanter et écris sa forme au présent.', 'Associe chaque sujet à la bonne forme.', 'Souligne le sujet et entoure le verbe dans chaque phrase.'],
        result: 'Je chante ; nous chantons ; les élèves chantent. Le verbe s’accorde avec le sujet.',
        safety: 'Relis les phrases à voix haute pour vérifier qu’elles ont du sens.'
      );
    }
    if (RegExp(r'régime alimentaire|herbivore|carnivore|omnivore').hasMatch(text)) {
      return const _Support(
        title: 'Les animaux et leurs relations alimentaires',
        showArrows: false,
        icon: Icons.pets,
        nodes: ['Trois régimes : herbivore • carnivore • omnivore'],
        explanation: 'Ces cases sont des catégories, pas une chaîne avec des flèches. Un herbivore mange des végétaux ; un carnivore mange d’autres animaux ; un omnivore consomme des aliments d’origine végétale et animale.',
        activity: 'Classer des animaux de son environnement',
        materials: 'Des dessins ou noms d’animaux connus et une feuille.',
        steps: ['Choisis quatre animaux connus.', 'Indique ce que chacun mange, sans le capturer.', 'Classe-les selon leur alimentation.', 'Explique pourquoi chaque animal appartient à cette catégorie en t’appuyant sur son régime.'],
        result: 'Les herbivores consomment des végétaux, les carnivores d’autres animaux et les omnivores des aliments d’origine végétale et animale. Les catégories peuvent varier selon les espèces et les aliments réellement consommés.',
        safety: 'Observe les animaux à distance. Ne touche pas les animaux inconnus et ne détruis pas leurs habitats.'
      );
    }
    if (RegExp(r'métiers|métier|services de proximité|services de la communauté|travailleurs de la communauté').hasMatch(text)) {
      return const _Support(
        title: 'Les métiers et les services de la communauté',
        showArrows: false,
        icon: Icons.groups,
        nodes: ['École', 'Centre de santé', 'Marché', 'Mairie'],
        explanation: 'Les personnes et les services répondent à des besoins différents. Ils contribuent ensemble à la vie de la communauté.',
        activity: 'Réaliser une carte des services du quartier',
        materials: 'Une feuille, un crayon et les noms de services connus.',
        steps: ['Choisis trois services de ton quartier.', 'Écris le besoin auquel chacun répond.', 'Associe un métier à chaque service.', 'Présente une règle de respect pour chaque lieu.'],
        result: 'Une communauté fonctionne grâce à la participation et au respect de ses membres.',
        safety: 'Ne visite aucun lieu sans l’accord d’un adulte responsable.'
      );
    }
    if (RegExp(r'daily routines|wake up|moments of the day').hasMatch(text)) {
      return const _Support(
        title: 'Organiser sa journée en anglais',
        showArrows: false,
        icon: Icons.schedule,
        nodes: ['Morning', 'Afternoon', 'Evening', 'Night'],
        explanation: 'Ces mots indiquent les moments de la journée. On peut les utiliser pour présenter ses habitudes et dire quand une action se déroule.',
        activity: 'Présenter quatre moments de sa journée',
        materials: 'Une feuille et un crayon.',
        steps: ['Dessine quatre cases.', 'Écris Morning, Afternoon, Evening et Night.', 'Ajoute une action simple dans chaque case.', 'Présente tes phrases à un camarade en anglais.'],
        result: 'I go to school in the morning. I sleep at night.',
        safety: 'Écoute ton camarade et respecte son rythme de lecture.'
      );
    }
    if (RegExp(r'droits de l.enfant|responsabilités de l.enfant|droits et devoirs de l.enfant|protection de l.enfance').hasMatch(text)) {
      return const _Support(
        title: 'Droits, responsabilités et protection',
        showArrows: false,
        icon: Icons.shield_outlined,
        nodes: ['Droits', 'Respect', 'Responsabilités', 'Protection'],
        explanation: 'Les droits protègent chaque enfant. Les responsabilités adaptées à son âge aident à respecter les autres. En cas de danger, l’enfant demande l’aide d’un adulte responsable.',
        activity: 'Créer une affiche des règles qui protègent les élèves',
        materials: 'Une feuille, des crayons et des exemples de règles de classe.',
        steps: ['Écris deux droits importants des enfants.', 'Ajoute deux responsabilités adaptées à l’école.', 'Choisis une règle pour prévenir les accidents.', 'Présente l’affiche et explique pourquoi ces règles sont utiles.'],
        result: 'Une classe sûre respecte les droits, les règles et la dignité de chaque élève.',
        safety: 'Si une situation de violence ou de danger existe, parle à un adulte de confiance.'
      );
    }
    if (RegExp(r'compréhension de texte|comprendre un texte|production écrite|rédiger un paragraphe|organiser un paragraphe').hasMatch(text)) {
      return const _Support(
        title: 'Méthode pour comprendre et rédiger',
        icon: Icons.edit_note,
        nodes: ['Lire', 'Repérer', 'Organiser', 'Relire'],
        explanation: 'Une bonne réponse s’appuie sur le texte. Un paragraphe clair présente un sujet, développe quelques idées dans un ordre logique et se termine par une conclusion.',
        activity: 'Lire un court texte puis rédiger cinq phrases',
        materials: 'Un petit texte, un cahier et un crayon.',
        steps: ['Lis le texte une première fois.', 'Repère qui, où, quand et ce qui se passe.', 'Écris les idées dans l’ordre.', 'Relis pour corriger les majuscules, les points et les accords.'],
        result: 'Les réponses sont précises et le paragraphe est organisé.',
        safety: 'Respecte les idées des autres et cite le texte lorsque tu justifies une réponse.'
      );
    }
    // Pas de schéma générique : mieux vaut ne rien afficher qu'illustrer la mauvaise notion.
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final support = _support;
    if (support == null) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Autres supports visuels', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Card(child: Padding(padding: const EdgeInsets.all(14), child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Icon(support.icon, color: theme.colorScheme.primary), const SizedBox(width: 8), Expanded(child: Text(support.title, style: const TextStyle(fontWeight: FontWeight.bold)))]),
            const SizedBox(height: 14),
            Semantics(
              label: 'Schéma : ${support.nodes.join(', ')}',
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: .55),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                ),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 10,
                  children: support.nodes.asMap().entries.expand((entry) => [
                    ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 94, minHeight: 54),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.colorScheme.primary.withValues(alpha: .35)),
                        ),
                        child: Text(
                          entry.value,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            height: 1.25,
                          ),
                        ),
                      ),
                    ),
                    if (support.showArrows && entry.key < support.nodes.length - 1)
                      Icon(Icons.arrow_forward_rounded,
                          size: 22, color: theme.colorScheme.primary),
                  ]).toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(support.explanation, style: const TextStyle(height: 1.45)),
          ],
        ))),
        Card(child: Padding(padding: const EdgeInsets.all(14), child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(children: [Icon(Icons.science_outlined), SizedBox(width: 8), Text('Expérience ou activité pratique', style: TextStyle(fontWeight: FontWeight.bold))]),
            const SizedBox(height: 10),
            Text(support.activity, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('Matériel : ${support.materials}'),
            const SizedBox(height: 8),
            const Text('Étapes', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            ...support.steps.asMap().entries.map((e) => Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [CircleAvatar(radius: 10, child: Text('${e.key + 1}', style: const TextStyle(fontSize: 11))), const SizedBox(width: 8), Expanded(child: Text(e.value, style: const TextStyle(height: 1.4)))]))),
            const SizedBox(height: 6),
            Text('Résultat attendu : ${support.result}', style: const TextStyle(height: 1.45)),
            const SizedBox(height: 8),
            Text('Précaution : ${support.safety}', style: TextStyle(height: 1.4, color: theme.colorScheme.error)),
          ],
        ))),
      ]),
    );
  }
}

class _Support {
  final String title, explanation, activity, materials, result, safety;
  final IconData icon;
  final List<String> nodes, steps;
  final bool showArrows;
  const _Support({required this.title, required this.icon, required this.nodes, required this.explanation, required this.activity, required this.materials, required this.steps, required this.result, required this.safety, this.showArrows = true});
}
