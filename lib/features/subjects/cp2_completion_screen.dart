import 'package:flutter/material.dart';

/// Complément CP2 : parcours progressif des trois trimestres.
/// Fichier séparé pour préserver intégralement les ressources historiques.
class Cp2CompletionScreen extends StatelessWidget {
  const Cp2CompletionScreen({super.key});

  static const _units = <_Unit>[
    _Unit('T1 • Français', 'Lire et écrire des mots et phrases simples', [
      _Lesson('Réviser les sons et les syllabes',
        'Une syllabe se prononce en une seule émission de voix. Pour lire un mot, je reconnais les lettres, je prononce les syllabes puis je les assemble. Je fais attention aux sons proches.',
        'pa + pa = papa ; ma + ri = mari.',
        'Combien de syllabes entend-on dans « tomate » ?', ['1', '2', '3'], 2,
        'To-ma-te : on entend trois syllabes.'),
      _Lesson('Lire un petit texte et retrouver une information',
        'Je lis le texte doucement. Je cherche les personnages, le lieu et les actions. Pour répondre, je peux retrouver la phrase qui donne l’information.',
        'Texte : « Afi va à l’école. Elle porte son sac. » Afi est le personnage et elle va à l’école.',
        'Où va Afi ?', ['Au marché', 'À l’école', 'À la rivière'], 1,
        'Le texte dit : « Afi va à l’école. »'),
    ]),
    _Unit('T1 • Mathématiques', 'Nombres, opérations et résolution de problèmes', [
      _Lesson('Lire, écrire et décomposer les nombres jusqu’à 100',
        'Un nombre à deux chiffres possède des dizaines et des unités. Dans 34, il y a 3 dizaines et 4 unités. On peut écrire 34 = 30 + 4.',
        '52 = 5 dizaines + 2 unités = 50 + 2.',
        'Dans 47, combien y a-t-il de dizaines ?', ['4', '7', '47'], 0,
        '47 contient 4 dizaines et 7 unités.'),
      _Lesson('Additionner deux nombres sans retenue',
        'Pour additionner, je commence par les unités puis les dizaines. Je peux utiliser des objets, un tableau dizaines-unités ou le calcul posé.',
        '23 + 14 : unités 3 + 4 = 7 ; dizaines 2 + 1 = 3 ; résultat 37.',
        'Combien font 32 + 15 ?', ['37', '47', '57'], 1,
        '32 + 15 = 47.'),
    ]),
    _Unit('T1 • Anglais', 'Salutations, identité et consignes', [
      _Lesson('Se présenter en anglais',
        'Pour saluer, je peux dire Hello. Pour donner mon nom, je dis My name is… Pour demander le nom, je peux dire What is your name?',
        'Hello! My name is Kofi. = Bonjour ! Je m’appelle Kofi.',
        'Que signifie « My name is Ama » ?', ['Je suis à l’école', 'Je m’appelle Ama', 'Au revoir Ama'], 1,
        'My name is… signifie « Je m’appelle… ».'),
    ]),
    _Unit('T1 • Éveil scientifique', 'Le corps humain et les règles d’hygiène', [
      _Lesson('Les parties du corps et leurs rôles',
        'Les yeux servent à voir, les oreilles à entendre, le nez à sentir et la peau à toucher. Chaque partie du corps a un rôle. Nous devons protéger notre corps.',
        'Je ferme les yeux pour les reposer et j’évite de regarder directement le soleil.',
        'Quel organe sert principalement à entendre ?', ['Les oreilles', 'Les mains', 'Les pieds'], 0,
        'Les oreilles permettent d’entendre les sons.'),
    ]),
    _Unit('T1 • Éducation sociale', 'La famille, l’école et les règles de vie', [
      _Lesson('Vivre ensemble dans la classe',
        'À l’école, chacun doit respecter les autres, écouter les consignes, attendre son tour et prendre soin du matériel commun. En cas de désaccord, on parle calmement et on demande l’aide du maître ou de la maîtresse.',
        'Je demande la parole avant de répondre et je partage le matériel.',
        'Quel geste aide la classe à bien travailler ?', ['Crier', 'Écouter les autres', 'Cacher les cahiers'], 1,
        'Écouter les autres favorise le respect et le travail.'),
    ]),
    _Unit('T2 • Français', 'Grammaire, vocabulaire et production écrite', [
      _Lesson('Reconnaître le nom et le déterminant',
        'Le nom désigne une personne, un animal, un lieu ou une chose. Le déterminant se place souvent devant le nom : le, la, un, une, les, des.',
        'Dans « une chèvre », « chèvre » est le nom et « une » est le déterminant.',
        'Dans « le ballon », quel mot est le nom ?', ['le', 'ballon', 'dans'], 1,
        'Ballon désigne une chose : c’est le nom.'),
      _Lesson('Écrire un petit texte dans l’ordre',
        'Pour écrire un petit texte, je rassemble des idées, je les place dans l’ordre et je construis des phrases. Je vérifie les majuscules, les espaces et les points.',
        '« Le matin, Kossi se lève. Il se lave puis il part à l’école. »',
        'Que faut-il vérifier à la fin ?', ['Les majuscules et les points', 'La couleur du sac seulement', 'Le nombre de dessins'], 0,
        'On relit pour vérifier les majuscules, les espaces et la ponctuation.'),
    ]),
    _Unit('T2 • Mathématiques', 'Soustraction, multiplication intuitive et mesures', [
      _Lesson('Soustraire avec ou sans échange',
        'Soustraire, c’est enlever ou comparer. Je peux représenter les nombres avec des dizaines et des unités. Si les unités du premier nombre sont trop petites, je peux échanger une dizaine contre dix unités.',
        '42 − 10 = 32 : on enlève une dizaine.',
        'Combien font 58 − 20 ?', ['28', '38', '48'], 1,
        '58 − 20 = 38.'),
      _Lesson('Découvrir la multiplication comme addition répétée',
        'Multiplier, c’est ajouter plusieurs fois la même quantité. Deux groupes de trois objets donnent 3 + 3 = 6. On peut représenter les groupes avec des dessins.',
        '4 sachets contenant chacun 2 oranges : 2 + 2 + 2 + 2 = 8 oranges.',
        'Trois groupes de 2 font combien ?', ['5', '6', '8'], 1,
        '2 + 2 + 2 = 6.'),
    ]),
    _Unit('T2 • Anglais', 'Famille, objets et couleurs', [
      _Lesson('Nommer quelques membres de la famille',
        'En anglais : mother signifie mère, father signifie père, sister signifie sœur et brother signifie frère. J’écoute le mot et je le répète clairement.',
        'This is my mother. = Voici ma mère.',
        'Que signifie « brother » ?', ['Sœur', 'Frère', 'Mère'], 1,
        'Brother signifie frère.'),
    ]),
    _Unit('T2 • Éveil scientifique', 'Les plantes, les animaux et leur milieu', [
      _Lesson('Les étapes de la croissance d’une plante',
        'Une graine peut germer si les conditions sont favorables. Une petite racine apparaît, puis une tige et des feuilles. La plante grandit avec de l’eau, de l’air et de la lumière.',
        'On observe une graine de haricot dans du coton humide et on note les changements.',
        'Quelle partie apparaît généralement en premier lors de la germination ?', ['La racine', 'Le fruit', 'La fleur'], 0,
        'La jeune racine sort généralement en premier.'),
    ]),
    _Unit('T2 • Éducation sociale', 'Santé, sécurité et protection du milieu', [
      _Lesson('Prévenir les accidents',
        'Je ne joue pas sur la route, je ne touche pas au feu ni aux prises électriques et je ne prends jamais un médicament sans adulte. Je traverse avec prudence et avec l’aide d’un adulte si nécessaire.',
        'Avant de traverser, je m’arrête, j’observe les deux côtés et je suis les consignes de sécurité.',
        'Qui peut aider un enfant à traverser une route ?', ['Un adulte responsable', 'Un véhicule', 'Un inconnu qui appelle de loin'], 0,
        'Un adulte responsable accompagne l’enfant pour traverser en sécurité.'),
    ]),
    _Unit('T3 • Français', 'Compréhension, conjugaison orale et écrite', [
      _Lesson('Repérer qui fait l’action',
        'Dans une phrase, je cherche de qui ou de quoi on parle. Je trouve ensuite ce que cette personne ou cette chose fait.',
        'Dans « Les enfants chantent », on parle des enfants et ils chantent.',
        'Dans « Le chien aboie », qui fait l’action ?', ['Le chien', 'Le bruit', 'La maison'], 0,
        'Le chien est celui qui aboie.'),
    ]),
    _Unit('T3 • Mathématiques', 'Calcul, partage et problèmes de la vie courante', [
      _Lesson('Partager une quantité en parts égales',
        'Partager équitablement, c’est donner la même quantité à chacun. Je distribue un objet à chaque personne à tour de rôle jusqu’à ce qu’il n’y en ait plus.',
        '6 mangues partagées entre 2 enfants : chacun reçoit 3 mangues.',
        '8 crayons partagés entre 4 élèves : combien chacun reçoit-il ?', ['1', '2', '4'], 1,
        '8 crayons répartis également entre 4 élèves donnent 2 crayons chacun.'),
      _Lesson('Résoudre un problème en plusieurs étapes',
        'Je lis l’énoncé, je repère les informations utiles, je choisis l’opération et je vérifie si la réponse est logique. Je peux faire un dessin ou un calcul.',
        'J’ai 10 noix. J’en donne 3 puis j’en reçois 2 : 10 − 3 + 2 = 9.',
        'Afi a 7 billes, en perd 2 et en gagne 4. Combien en a-t-elle ?', ['7', '8', '9'], 2,
        '7 − 2 + 4 = 9 billes.'),
    ]),
    _Unit('T3 • Anglais', 'Actions simples et révision des acquis', [
      _Lesson('Comprendre des actions courantes',
        'Quelques verbes : read (lire), write (écrire), play (jouer), eat (manger), run (courir). Je répète les mots et je les associe à une action.',
        'I read a book. = Je lis un livre.',
        'Que signifie « write » ?', ['Courir', 'Écrire', 'Manger'], 1,
        'Write signifie écrire.'),
    ]),
    _Unit('T3 • Éveil scientifique', 'L’eau, l’air et la protection de la nature', [
      _Lesson('Utiliser l’eau proprement',
        'L’eau est nécessaire aux êtres vivants. Il faut éviter de la gaspiller et ne pas boire une eau dont la propreté n’est pas assurée. On garde les récipients propres et couverts.',
        'Je ferme le robinet après m’être lavé les mains.',
        'Pourquoi faut-il protéger l’eau ?', ['Parce qu’elle est nécessaire à la vie', 'Pour remplir les caniveaux', 'Pour salir les rues'], 0,
        'L’eau est indispensable aux humains, aux animaux et aux plantes.'),
    ]),
    _Unit('T3 • Éducation sociale', 'Citoyenneté, solidarité et bilan de l’année', [
      _Lesson('Participer à la propreté de son école',
        'Chacun peut contribuer à garder l’école propre : utiliser les poubelles, respecter les plantes, ne pas salir les murs et participer aux activités de nettoyage encadrées.',
        'Après une activité, je range le matériel et je jette les déchets dans la poubelle.',
        'Quel comportement protège l’école ?', ['Écrire sur les murs', 'Jeter les déchets au sol', 'Ranger et garder les lieux propres'], 2,
        'Ranger et garder les lieux propres protège l’école et la santé de tous.'),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CP2 • Complément de l’année')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Parcours CP2 organisé sur les trois trimestres et cinq domaines. '
                'Lis le cours, observe l’exemple, réponds à la question puis consulte la correction.',
                style: TextStyle(fontSize: 15, height: 1.45),
              ),
            ),
          ),
          const SizedBox(height: 8),
          ..._units.map((unit) => Card(
            clipBehavior: Clip.antiAlias,
            child: ExpansionTile(
              title: Text(unit.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(unit.subtitle),
              children: unit.lessons.map((lesson) => _LessonTile(lesson: lesson)).toList(),
            ),
          )),
          const SizedBox(height: 16),
          const Text(
            'Ce complément enrichit la base existante. La progression doit être relue et ajustée avec les programmes officiels et les enseignants.',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}

class _Unit {
  final String title, subtitle;
  final List<_Lesson> lessons;
  const _Unit(this.title, this.subtitle, this.lessons);
}

class _Lesson {
  final String title, content, example, question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  const _Lesson(this.title, this.content, this.example, this.question,
      this.options, this.correctIndex, this.explanation);
}

class _LessonTile extends StatefulWidget {
  final _Lesson lesson;
  const _LessonTile({super.key, required this.lesson});

  @override
  State<_LessonTile> createState() => _LessonTileState();
}

class _LessonTileState extends State<_LessonTile> {
  int? selected;
  bool showCorrection = false;

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    final correct = selected == lesson.correctIndex;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(lesson.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 8),
          Text(lesson.content, style: const TextStyle(height: 1.45)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text('Exemple : ${lesson.example}', style: const TextStyle(height: 1.4)),
          ),
          const SizedBox(height: 10),
          Text('Exercice : ${lesson.question}', style: const TextStyle(fontWeight: FontWeight.w600)),
          ...List.generate(lesson.options.length, (index) => RadioListTile<int>(
            dense: true,
            contentPadding: EdgeInsets.zero,
            value: index,
            groupValue: selected,
            title: Text(lesson.options[index]),
            onChanged: (value) => setState(() {
              selected = value;
              showCorrection = false;
            }),
          )),
          Row(children: [
            Expanded(child: FilledButton.tonal(
              onPressed: selected == null ? null : () => setState(() => showCorrection = true),
              child: const Text('Vérifier ma réponse'),
            )),
            const SizedBox(width: 8),
            TextButton(onPressed: () => setState(() {
              selected = null;
              showCorrection = false;
            }), child: const Text('Recommencer')),
          ]),
          if (showCorrection)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: correct ? const Color(0xFFE4F5E9) : const Color(0xFFFFF1DC),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${correct ? 'Bonne réponse !' : 'Réponse incorrecte.'} ${lesson.explanation}',
                style: const TextStyle(height: 1.4),
              ),
            ),
          const Divider(height: 24),
        ],
      ),
    );
  }
}
