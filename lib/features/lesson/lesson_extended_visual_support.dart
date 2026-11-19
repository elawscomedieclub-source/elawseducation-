import 'package:flutter/material.dart';

import '../../data/models/models.dart';

/// Deuxième bibliothèque de supports visuels : sciences, environnement,
/// technologie et géographie. Les supports sont dessinés avec Flutter et
/// fonctionnent sans connexion ni images distantes.
class ExtendedLessonVisualSupport extends StatelessWidget {
  final Lesson lesson;
  const ExtendedLessonVisualSupport({super.key, required this.lesson});

  _Support? get _support {
    final text = '${lesson.title} ${lesson.content}'.toLowerCase();
    if (RegExp(r'multiplier|multiplication|groupes égaux|partage équitable').hasMatch(text)) {
      return const _Support(
        title: 'La multiplication avec des groupes égaux',
        icon: Icons.calculate,
        nodes: ['4 groupes', '3 objets chacun', '12 objets'],
        explanation: 'Quatre groupes de trois objets donnent 3 + 3 + 3 + 3 = 12, soit 4 × 3 = 12. La multiplication permet de compter plus rapidement des groupes égaux.',
        activity: 'Former des groupes et vérifier une multiplication',
        materials: '12 petits cailloux propres ou bouchons, une feuille et un crayon.',
        steps: ['Pose 12 objets sur la table.', 'Répartis-les en 4 groupes contenant le même nombre.', 'Compte les objets dans un groupe.', 'Écris l’addition répétée puis la multiplication correspondante.', 'Recommence avec 3 groupes de 4 objets.'],
        result: '4 groupes de 3 et 3 groupes de 4 contiennent chacun 12 objets.',
        safety: 'Utilise des objets assez gros pour ne pas être avalés et range-les après l’activité.'
      );
    }
    if (RegExp(r'aimant|magnét|pôle nord|pôle sud').hasMatch(text)) {
      return const _Support(
        title: 'Le magnétisme : deux pôles',
        icon: Icons.explore,
        nodes: ['Pôle nord', 'Aimant', 'Pôle sud'],
        explanation: 'Un aimant possède deux pôles. Deux pôles opposés s’attirent ; deux pôles identiques se repoussent.',
        activity: 'Tester l’attraction magnétique',
        materials: 'Un aimant, un trombone, une pièce, du papier et un morceau de bois.',
        steps: ['Approche l’aimant de chaque objet sans le toucher.', 'Note les objets attirés et ceux qui ne le sont pas.', 'Place une feuille de papier entre l’aimant et le trombone.', 'Compare les résultats et formule une conclusion.'],
        result: 'Tous les métaux ne sont pas attirés par un aimant. Le fer et certains aciers le sont.',
        safety: 'Ne place pas l’aimant près d’un téléphone, d’une carte magnétique ou d’un appareil médical.'
      );
    }
    if (RegExp(r'vibration sonore|propagation du son|son et bruit|oreille|acoustique').hasMatch(text)) {
      return const _Support(
        title: 'Comment le son se propage',
        icon: Icons.graphic_eq,
        nodes: ['Source qui vibre', 'Air en vibration', 'Oreille'],
        explanation: 'Un son est produit par une vibration. Cette vibration se transmet dans un milieu matériel jusqu’à l’oreille.',
        activity: 'Voir une vibration sonore',
        materials: 'Un bol, un film alimentaire, quelques grains de riz et une cuillère.',
        steps: ['Tends le film alimentaire sur le bol.', 'Dépose quelques grains de riz sur le film.', 'Frappe doucement dans tes mains près du bol.', 'Observe les mouvements des grains et recommence à différentes distances.'],
        result: 'Les vibrations de l’air peuvent faire bouger le film et les grains.',
        safety: 'Évite les bruits très forts et ne frappe pas près des oreilles.'
      );
    }
    if (RegExp(r'chaine alimentaire|chaîne alimentaire|réseau alimentaire|écosystème|milieu de vie').hasMatch(text)) {
      return const _Support(
        title: 'Exemple de chaîne alimentaire',
        icon: Icons.eco,
        nodes: ['Herbe', 'Criquet', 'Grenouille', 'Serpent'],
        explanation: 'La flèche indique le transfert de matière et d’énergie : l’être vivant placé après se nourrit de celui qui le précède.',
        activity: 'Construire une chaîne alimentaire locale',
        materials: 'Feuille, crayon et exemples d’êtres vivants observés dans ton environnement.',
        steps: ['Choisis une plante et trois animaux de ton milieu.', 'Identifie qui mange qui.', 'Dessine les êtres vivants dans l’ordre.', 'Trace les flèches du repas vers le consommateur.', 'Explique ce qui pourrait arriver si un maillon disparaissait.'],
        result: 'Les êtres vivants sont liés entre eux. La disparition d’un maillon peut déséquilibrer le milieu.',
        safety: 'Observe les animaux à distance et ne détruis pas leur habitat.'
      );
    }
    if (RegExp(r'composition du sol|types de sol|érosion|humus|couche du sol').hasMatch(text)) {
      return const _Support(
        title: 'Les couches simplifiées du sol',
        icon: Icons.landscape,
        nodes: ['Litière', 'Humus', 'Sol minéral', 'Roche mère'],
        explanation: 'Le sol contient des matières minérales, de l’eau, de l’air et des organismes vivants. Sa formation est lente.',
        activity: 'Comparer deux échantillons de sol',
        materials: 'Deux petits pots, un peu de sable, de terre de jardin et de l’eau.',
        steps: ['Place chaque échantillon dans un pot séparé.', 'Ajoute la même quantité d’eau.', 'Remue doucement puis laisse reposer.', 'Observe les particules et les couches qui se déposent.', 'Compare la couleur et la texture.'],
        result: 'Les sols n’ont pas tous la même composition ni la même capacité à retenir l’eau.',
        safety: 'Ne goûte jamais la terre. Lave-toi les mains après l’activité.'
      );
    }
    if (RegExp(r'mélange homogène|mélange hétérogène|dissolution|filtration|décantation').hasMatch(text)) {
      return const _Support(
        title: 'Séparer les constituants d’un mélange',
        icon: Icons.science,
        nodes: ['Mélange', 'Filtre', 'Résidu + liquide'],
        explanation: 'La filtration retient certains solides dans le filtre et laisse passer le liquide. Elle ne rend pas forcément l’eau potable.',
        activity: 'Réaliser une filtration simple',
        materials: 'Un entonnoir, un filtre à café, un récipient, de l’eau et un peu de sable.',
        steps: ['Mélange le sable avec l’eau dans un récipient.', 'Place le filtre dans l’entonnoir.', 'Verse doucement le mélange.', 'Observe le sable retenu et le liquide recueilli.', 'Décris ce que la filtration a séparé.'],
        result: 'Le sable est retenu par le filtre tandis que l’eau traverse le papier.',
        safety: 'Ne bois jamais le liquide obtenu : une filtration scolaire ne garantit pas la potabilité.'
      );
    }
    if (RegExp(r'levier|poulie|plan incliné|machine simple').hasMatch(text)) {
      return const _Support(
        title: 'Principe d’une machine simple',
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
    if (RegExp(r'points cardinaux|orientation|rose des vents|carte géographique').hasMatch(text)) {
      return const _Support(
        title: 'S’orienter avec les points cardinaux',
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
    if (RegExp(r'mesurer|longueur|monnaie|centimètre|centimètres|franc cfa').hasMatch(text)) {
      return const _Support(
        title: 'Mesurer une longueur et calculer un prix',
        icon: Icons.straighten,
        nodes: ['Règle graduée', 'cm et m', 'Prix total', 'Monnaie rendue'],
        explanation: 'On mesure une longueur avec une unité adaptée. Pour un achat, on additionne les prix ; pour trouver la monnaie rendue, on soustrait le prix de la somme donnée.',
        activity: 'Mesurer un objet et préparer un achat fictif',
        materials: 'Une règle graduée, deux objets de la classe, des étiquettes de prix et des billets dessinés.',
        steps: ['Mesure un crayon en centimètres en plaçant le zéro au début.', 'Mesure un autre objet avec la même règle.', 'Additionne deux prix fictifs.', 'Soustrais le total de la somme donnée pour calculer la monnaie.'],
        result: '1 m = 100 cm. Le prix total est une addition et la monnaie rendue est une soustraction.',
        safety: 'Utilise des objets de classe sans les lancer et ne manipule pas d’argent réel sans autorisation.'
      );
    }
    if (RegExp(r'accord.*verbe|conjugaison|sujet et le verbe|présent').hasMatch(text)) {
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
    if (RegExp(r'animaux|animal|herbivore|carnivore|omnivore').hasMatch(text)) {
      return const _Support(
        title: 'Les animaux et leurs relations alimentaires',
        icon: Icons.pets,
        nodes: ['Végétaux', 'Herbivore', 'Carnivore'],
        explanation: 'Les animaux ont besoin d’eau et de nourriture. Un herbivore mange des végétaux ; un carnivore mange d’autres animaux ; un omnivore consomme les deux types d’aliments.',
        activity: 'Classer des animaux de son environnement',
        materials: 'Des dessins ou noms d’animaux connus et une feuille.',
        steps: ['Choisis quatre animaux connus.', 'Indique ce que chacun mange, sans le capturer.', 'Classe-les selon leur alimentation.', 'Dessine une relation alimentaire simple avec des flèches.'],
        result: 'Les animaux ont des régimes alimentaires différents et dépendent de leur milieu.',
        safety: 'Observe les animaux à distance. Ne touche pas les animaux inconnus et ne détruis pas leurs habitats.'
      );
    }
    if (RegExp(r'métiers|métier|communauté|services de proximité|travailleurs').hasMatch(text)) {
      return const _Support(
        title: 'Les métiers et les services de la communauté',
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
    if (RegExp(r'daily routines|wake up|what time is it|o.clock|morning|afternoon').hasMatch(text)) {
      return const _Support(
        title: 'Organiser sa journée en anglais',
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
    if (RegExp(r'droits de l.enfant|responsabilités|protection|sécurité').hasMatch(text)) {
      return const _Support(
        title: 'Droits, responsabilités et protection',
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
    if (RegExp(r'compréhension|production écrite|paragraphe|informations importantes').hasMatch(text)) {
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
            Wrap(alignment: WrapAlignment.center, crossAxisAlignment: WrapCrossAlignment.center, spacing: 5, runSpacing: 8,
              children: support.nodes.asMap().entries.expand((entry) => [
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9), decoration: BoxDecoration(color: theme.colorScheme.primaryContainer, borderRadius: BorderRadius.circular(10)), child: Text(entry.value, style: TextStyle(color: theme.colorScheme.onPrimaryContainer, fontWeight: FontWeight.w600))),
                if (entry.key < support.nodes.length - 1) Icon(Icons.arrow_forward, size: 18, color: theme.colorScheme.primary),
              ]).toList()),
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
  const _Support({required this.title, required this.icon, required this.nodes, required this.explanation, required this.activity, required this.materials, required this.steps, required this.result, required this.safety});
}
