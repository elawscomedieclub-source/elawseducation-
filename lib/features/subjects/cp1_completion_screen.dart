import 'package:flutter/material.dart';

/// Parcours complémentaire CP1 pour les deuxième et troisième trimestres.
/// Ce module est volontairement séparé des données historiques afin de ne
/// remplacer aucun cours déjà publié.
class Cp1CompletionScreen extends StatelessWidget {
  const Cp1CompletionScreen({super.key});

  static int get chapterCount => _chapters.length;
  static int get lessonCount => _chapters.fold(0, (sum, chapter) => sum + chapter.lessons.length);

  static const _chapters = <_Cp1Chapter>[
    _Cp1Chapter('T2 • Mathématiques', 'Consolider les nombres et les premières opérations', [
      _Cp1Lesson('Compter, lire et écrire les nombres jusqu’à 20',
        'On compte les objets un par un, sans en oublier et sans compter deux fois le même objet. Chaque nombre possède un nom et une écriture en chiffres. Après 10 viennent 11, 12, 13, 14, 15, 16, 17, 18, 19 et 20.',
        'Avec 14 graines, je peux faire un groupe de 10 graines et encore 4 graines : 14 = 10 + 4.',
        'Quel nombre vient juste après 16 ?', ['15', '17', '20'], 1,
        'Après 16 vient 17.'),
      _Cp1Lesson('Comparer et ranger des nombres',
        'Pour comparer deux collections, on peut compter les objets de chaque collection. Le nombre le plus grand représente la plus grande quantité. On peut aussi ranger plusieurs nombres du plus petit au plus grand.',
        '12 est plus petit que 15. Dans l’ordre croissant : 8, 12, 15.',
        'Quel est le plus grand nombre ?', ['9', '14', '11'], 1,
        '14 est plus grand que 9 et 11.'),
    ]),
    _Cp1Chapter('T2 • Mathématiques', 'Addition et soustraction avec des objets', [
      _Cp1Lesson('Comprendre l’addition',
        'Additionner, c’est réunir des quantités. On utilise le signe +. On compte tous les objets réunis pour trouver le total.',
        '3 mangues + 2 mangues = 5 mangues. On écrit 3 + 2 = 5.',
        'Awa a 4 crayons et reçoit 2 crayons. Combien en a-t-elle ?', ['5', '6', '7'], 1,
        '4 + 2 = 6 crayons.'),
      _Cp1Lesson('Comprendre la soustraction',
        'Soustraire, c’est enlever une quantité ou chercher ce qui reste. On utilise le signe −. On part de la quantité de départ et on enlève les objets indiqués.',
        'Il y a 6 oranges. On en mange 2. Il reste 6 − 2 = 4 oranges.',
        'Il y a 7 oiseaux. 3 s’envolent. Combien restent-ils ?', ['3', '4', '5'], 1,
        '7 − 3 = 4 oiseaux.'),
    ]),
    _Cp1Chapter('T2 • Français', 'Construire des syllabes, lire et écrire des mots', [
      _Cp1Lesson('Assembler des lettres en syllabes',
        'Une syllabe est un morceau de mot que l’on prononce en une seule émission de voix. On peut assembler une consonne et une voyelle : m + a donne ma ; l + i donne li. Il faut prononcer lentement puis répéter.',
        'm + a = ma ; p + i = pi ; la + mi = lami (on entend deux syllabes dans « ami » : a-mi).',
        'Quelle syllabe obtient-on avec m et i ?', ['mi', 'ma', 'mo'], 0,
        'La lettre m suivie de i forme la syllabe mi.'),
      _Cp1Lesson('Lire et copier des mots simples',
        'Pour lire un mot, on observe les lettres, on prononce les syllabes puis on assemble les sons. Pour copier, on regarde le modèle, on écrit les lettres dans le bon ordre et on vérifie.',
        'Le mot « maman » se lit ma-man. Je copie : maman.',
        'Quel mot commence par la syllabe « pa » ?', ['papa', 'moto', 'lune'], 0,
        'Papa commence par la syllabe pa.'),
    ]),
    _Cp1Chapter('T2 • Français', 'Comprendre et produire une phrase simple', [
      _Cp1Lesson('Reconnaître une phrase',
        'Une phrase exprime une idée complète. À l’écrit, elle commence par une majuscule et se termine par un point, un point d’interrogation ou un point d’exclamation.',
        '« Le bébé dort. » est une phrase complète. « Dans la cour » ne donne pas encore une idée complète.',
        'Quel signe termine cette phrase : « Le soleil brille… » ?', ['Une virgule', 'Un point', 'Un tiret'], 1,
        'Une phrase déclarative se termine généralement par un point.'),
      _Cp1Lesson('Écrire une phrase à partir d’une image ou d’une action',
        'Pour écrire une phrase, je dis d’abord mon idée à l’oral. Je choisis les mots, je les place dans l’ordre, je commence par une majuscule et je termine par un point.',
        'Idée : une fille joue. Phrase : « La fille joue. »',
        'Quelle phrase est correctement écrite ?', ['le chat dort', 'Le chat dort.', 'Le chat dort'], 1,
        'La phrase commence par une majuscule et se termine par un point.'),
    ]),
    _Cp1Chapter('T2 • Anglais', 'Nombres, couleurs et objets de la classe', [
      _Cp1Lesson('Dire les nombres de one à ten',
        'En anglais, on apprend les nombres en les écoutant et en les répétant : one, two, three, four, five, six, seven, eight, nine, ten. On peut compter des doigts ou des objets.',
        'One book = un livre. Two pencils = deux crayons.',
        'Que signifie « three » ?', ['Deux', 'Trois', 'Cinq'], 1,
        'Three signifie trois.'),
      _Cp1Lesson('Nommer les couleurs et les objets',
        'Quelques couleurs : red (rouge), blue (bleu), green (vert), yellow (jaune), black (noir), white (blanc). Objets : book (livre), pen (stylo), bag (sac), ruler (règle).',
        'A red bag = un sac rouge. A blue pen = un stylo bleu.',
        'Que signifie « blue » ?', ['Vert', 'Rouge', 'Bleu'], 2,
        'Blue signifie bleu.'),
    ]),
    _Cp1Chapter('T2 • Éveil scientifique', 'Les besoins des êtres vivants', [
      _Cp1Lesson('Reconnaître les besoins des plantes',
        'Une plante vivante a besoin d’eau, de lumière et d’air pour bien grandir. La terre peut lui apporter un support et des éléments nutritifs. Une plante oubliée sans eau peut se faner.',
        'On arrose une plante avec une quantité raisonnable d’eau et on la place dans un endroit lumineux.',
        'De quoi une plante a-t-elle besoin pour vivre ?', ['D’eau et de lumière', 'De plastique', 'De fumée'], 0,
        'L’eau et la lumière sont indispensables à la croissance de la plante.'),
      _Cp1Lesson('Prendre soin des animaux',
        'Les animaux ont besoin d’eau, de nourriture, d’air et d’un abri adapté. Il faut les traiter sans violence et demander l’aide d’un adulte pour les soigner.',
        'Un poussin a besoin d’eau propre, de nourriture et d’un endroit sûr.',
        'Que faut-il donner à un animal pour qu’il vive ?', ['De l’eau et de la nourriture', 'Du sable seulement', 'Des déchets dangereux'], 0,
        'Les animaux ont besoin d’eau et d’une nourriture adaptée.'),
    ]),
    _Cp1Chapter('T2 • Éducation sociale', 'Hygiène personnelle et sécurité', [
      _Cp1Lesson('Se laver correctement les mains',
        'On se lave les mains avec de l’eau propre et du savon, notamment avant de manger et après les toilettes. On frotte les paumes, le dos des mains et entre les doigts, puis on rince et on sèche.',
        'Après avoir joué dans la terre, je me lave les mains avant de toucher mon repas.',
        'Quand faut-il se laver les mains ?', ['Avant de manger', 'Jamais', 'Seulement le dimanche'], 0,
        'Il faut notamment se laver les mains avant de manger.'),
      _Cp1Lesson('Éviter les dangers à la maison et à l’école',
        'On ne touche pas aux prises électriques, aux objets tranchants, au feu ou aux médicaments sans un adulte. En cas de danger, on s’éloigne et on appelle immédiatement un adulte de confiance.',
        'Si je trouve un médicament par terre, je ne le prends pas : je préviens un adulte.',
        'Que faire devant un produit inconnu ?', ['Le goûter', 'Le cacher', 'Prévenir un adulte'], 2,
        'Un adulte doit identifier le produit et décider quoi faire.'),
    ]),
    _Cp1Chapter('T3 • Mathématiques', 'Résoudre des problèmes et consolider les mesures', [
      _Cp1Lesson('Résoudre un problème d’addition',
        'Pour résoudre un problème, je lis ou j’écoute l’énoncé, je repère les quantités, je cherche ce qu’on demande, je choisis l’opération puis je vérifie ma réponse.',
        'Kossi a 5 billes et en gagne 3. Il en a maintenant 5 + 3 = 8.',
        'Mina a 6 fleurs et en cueille 2 autres. Combien en a-t-elle ?', ['7', '8', '9'], 1,
        '6 + 2 = 8 fleurs.'),
      _Cp1Lesson('Comparer des longueurs et des masses',
        'Pour comparer deux longueurs, on place les objets au même point de départ. Pour comparer deux masses, on peut utiliser une balance. On emploie les mots plus long, plus court, plus lourd et plus léger.',
        'Un bâton de 30 cm est plus long qu’un bâton de 20 cm.',
        'Quel objet est le plus long ?', ['20 cm', '30 cm', 'Ils sont égaux'], 1,
        '30 cm est une longueur supérieure à 20 cm.'),
    ]),
    _Cp1Chapter('T3 • Français', 'Lire avec compréhension et réviser l’écriture', [
      _Cp1Lesson('Lire un petit texte et répondre',
        'Après la lecture, je cherche qui fait l’action, ce qui se passe et où cela se passe. Je peux relire le texte pour retrouver une information.',
        'Texte : « Ali va au marché avec sa mère. Ils achètent du riz. » Ali va au marché avec sa mère.',
        'Où Ali va-t-il ?', ['À l’école', 'Au marché', 'Au jardin'], 1,
        'Le texte dit qu’Ali va au marché.'),
      _Cp1Lesson('Écrire lisiblement une phrase',
        'Je m’assois correctement, je tiens mon crayon sans trop serrer et je respecte les lignes. Je forme les lettres dans le bon sens, je sépare les mots et je relis ma phrase.',
        'Je copie soigneusement : « Mon école est propre. »',
        'Que faut-il faire entre deux mots ?', ['Les coller', 'Laisser un espace', 'Changer les lettres'], 1,
        'On laisse un espace entre les mots pour faciliter la lecture.'),
    ]),
    _Cp1Chapter('T3 • Anglais', 'Réutiliser les expressions de la vie quotidienne', [
      _Cp1Lesson('Saluer et se présenter',
        'On peut dire « Hello » pour saluer, « Good morning » le matin, « My name is… » pour dire son nom et « Thank you » pour remercier.',
        'Hello! My name is Ama. = Bonjour ! Je m’appelle Ama.',
        'Quelle expression signifie « Merci » ?', ['Please', 'Thank you', 'Goodbye'], 1,
        'Thank you signifie merci.'),
      _Cp1Lesson('Comprendre des consignes simples',
        'Quelques consignes : stand up (lève-toi), sit down (assieds-toi), listen (écoute), look (regarde), open your book (ouvre ton livre). Il faut écouter puis exécuter calmement.',
        'Le professeur dit « Sit down » : les élèves s’assoient.',
        'Que signifie « Stand up » ?', ['Lève-toi', 'Assieds-toi', 'Écris'], 0,
        'Stand up signifie lève-toi.'),
    ]),
    _Cp1Chapter('T3 • Éveil scientifique', 'Observer et protéger son environnement', [
      _Cp1Lesson('Distinguer les éléments du milieu',
        'Dans notre environnement, on trouve des êtres vivants (personnes, animaux, plantes) et des éléments non vivants (eau, air, pierres, objets). On observe sans détruire.',
        'Un arbre est vivant ; une pierre n’est pas un être vivant.',
        'Lequel est un être vivant ?', ['Une pierre', 'Un arbre', 'Une bouteille'], 1,
        'Un arbre est un être vivant : il grandit et a besoin de ressources.'),
      _Cp1Lesson('Garder la cour et le quartier propres',
        'Les déchets doivent être déposés dans une poubelle ou dans un lieu de collecte adapté. On évite de jeter les sachets dans les caniveaux et on protège les points d’eau.',
        'Après la récréation, je ramasse mes papiers et je les mets dans la poubelle.',
        'Où faut-il mettre les déchets ?', ['Dans le caniveau', 'Dans la poubelle', 'Dans l’eau'], 1,
        'Les déchets vont dans une poubelle ou un lieu de collecte adapté.'),
    ]),
    _Cp1Chapter('T3 • Éducation sociale', 'Respect, solidarité et révision de fin d’année', [
      _Cp1Lesson('Respecter les autres et partager',
        'Respecter les autres, c’est écouter, parler poliment, attendre son tour et ne pas frapper. La solidarité consiste à aider une personne qui en a besoin.',
        'Je prête un crayon à un camarade qui n’en a pas et je le récupère calmement après le travail.',
        'Quel comportement montre le respect ?', ['Se moquer', 'Écouter son camarade', 'Pousser les autres'], 1,
        'Écouter son camarade est une marque de respect.'),
      _Cp1Lesson('Réviser les bonnes habitudes',
        'Pour bien terminer l’année, je continue à me laver les mains, à garder mes affaires propres, à respecter les règles et à demander de l’aide lorsque je ne comprends pas.',
        'Chaque jour, je prépare mon sac, je vérifie mes cahiers et j’arrive à l’école à l’heure.',
        'Que faire si une leçon est difficile ?', ['Abandonner', 'Demander une explication', 'Déchirer le cahier'], 1,
        'Demander une explication aide à progresser.'),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CP1 • Complément de l’année')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Parcours complémentaire des deuxième et troisième trimestres. '
                'Lis chaque leçon, observe l’exemple, puis réponds à la question. '
                'La correction explique la bonne réponse.',
                style: TextStyle(fontSize: 15, height: 1.45),
              ),
            ),
          ),
          const SizedBox(height: 8),
          ..._chapters.map((chapter) => Card(
            clipBehavior: Clip.antiAlias,
            child: ExpansionTile(
              title: Text(chapter.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(chapter.subtitle),
              children: chapter.lessons.map((lesson) => _LessonTile(lesson: lesson)).toList(),
            ),
          )),
          const SizedBox(height: 16),
          const Text(
            'Conseil : l’élève peut refaire les questions plusieurs fois et expliquer oralement comment il a trouvé la réponse.',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}

class _Cp1Chapter {
  final String title;
  final String subtitle;
  final List<_Cp1Lesson> lessons;
  const _Cp1Chapter(this.title, this.subtitle, this.lessons);
}

class _Cp1Lesson {
  final String title;
  final String content;
  final String example;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  const _Cp1Lesson(this.title, this.content, this.example, this.question,
      this.options, this.correctIndex, this.explanation);
}

class _LessonTile extends StatefulWidget {
  final _Cp1Lesson lesson;
  const _LessonTile({super.key, required this.lesson});

  @override
  State<_LessonTile> createState() => _LessonTileState();
}

class _LessonTileState extends State<_LessonTile> {
  int? _selected;
  bool _showCorrection = false;

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    final answered = _selected != null;
    final correct = _selected == lesson.correctIndex;
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
            groupValue: _selected,
            title: Text(lesson.options[index]),
            onChanged: (value) => setState(() {
              _selected = value;
              _showCorrection = false;
            }),
          )),
          Row(
            children: [
              Expanded(
                child: FilledButton.tonal(
                  onPressed: answered ? () => setState(() => _showCorrection = true) : null,
                  child: const Text('Vérifier ma réponse'),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () => setState(() {
                  _selected = null;
                  _showCorrection = false;
                }),
                child: const Text('Recommencer'),
              ),
            ],
          ),
          if (_showCorrection)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: correct ? const Color(0xFFE4F5E9) : const Color(0xFFFFF1DC),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${correct ? 'Bonne réponse !' : 'Essaie encore.'} ${lesson.explanation}',
                style: const TextStyle(height: 1.4),
              ),
            ),
          const Divider(height: 24),
        ],
      ),
    );
  }
}
