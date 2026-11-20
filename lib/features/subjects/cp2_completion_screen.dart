import 'package:flutter/material.dart';
import '../../data/models/models.dart';

/// Complément CP2 : parcours progressif des trois trimestres.
/// Fichier séparé pour préserver intégralement les ressources historiques.
class Cp2CompletionScreen extends StatelessWidget {
  const Cp2CompletionScreen({super.key});

  static int get unitCount => _units.length;
  static int get lessonCount => _units.fold(0, (sum, unit) => sum + unit.lessons.length);

  /// Convertit les leçons du complément CP2 en questions utilisables
  /// par le moteur de compositions trimestrielles.
  static List<Exercise> assessmentExercisesForTerm(int term, {String? subjectName}) {
    bool matchesSubject(String title) {
      if (subjectName == null) return true;
      final name = subjectName.toLowerCase();
      final unit = title.toLowerCase();
      if (name.contains('français') || name.contains('francais')) return unit.contains('français') || unit.contains('francais');
      if (name.contains('math')) return unit.contains('mathématiques') || unit.contains('mathematiques');
      if (name.contains('anglais') || name.contains('english')) return unit.contains('anglais');
      if (name.contains('scientifique') || name.contains('science')) return unit.contains('éveil scientifique') || unit.contains('eveil scientifique');
      if (name.contains('social') || name.contains('civique') || name.contains('morale')) return unit.contains('éducation sociale') || unit.contains('education sociale');
      return false;
    }
    final prefix = 'T$term •';
    final evaluationTitle = switch (term) {
      1 => 'CP2 • Évaluation du 1er trimestre',
      2 => 'CP2 • Évaluation du 2e trimestre',
      _ => 'CP2 • Évaluation du 3e trimestre et préparation au CE1',
    };
    final result = <Exercise>[];
    for (var unitIndex = 0; unitIndex < _units.length; unitIndex++) {
      final unit = _units[unitIndex];
      if ((!unit.title.startsWith(prefix) && unit.title != evaluationTitle) || !matchesSubject(unit.title)) continue;
      for (var lessonIndex = 0; lessonIndex < unit.lessons.length; lessonIndex++) {
        final lesson = unit.lessons[lessonIndex];
        result.add(Exercise(
          id: 'cp2_t${term}_u${unitIndex}_l${lessonIndex}',
          lessonId: 'cp2_t${term}_u${unitIndex}_l${lessonIndex}',
          question: lesson.question,
          options: lesson.options,
          correctIndex: lesson.correctIndex,
          explanation: lesson.explanation,
        ));
      }
    }
    return result;
  }

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

    _Unit('T1 • Français – approfondissement', 'Lecture expressive et ponctuation', [
      _Lesson('Former des phrases correctes',
        'Une phrase commence par une majuscule et se termine par un signe de ponctuation. Les mots doivent être placés dans un ordre qui permet de comprendre le message.',
        '« Le maître explique la leçon. » est une phrase complète.',
        'Quel signe termine une phrase déclarative ?', ['Un point', 'Une virgule seule', 'Un deux-points'], 0,
        'Une phrase déclarative se termine généralement par un point.'),
      _Lesson('Classer les mots par ordre alphabétique',
        'Pour ranger des mots, je compare leurs premières lettres. Si elles sont identiques, je compare les lettres suivantes.',
        'Ami vient avant ballon parce que A vient avant B.',
        'Quel mot vient en premier ?', ['École', 'Banane', 'Maison'], 1,
        'Banane commence par B, avant É et M.'),
    ]),
    _Unit('T1 • Mathématiques – approfondissement', 'Comparer, ranger et mesurer', [
      _Lesson('Comparer et ranger des nombres',
        'Pour comparer deux nombres à deux chiffres, je regarde d’abord les dizaines. Si elles sont égales, je compare les unités. Les signes sont <, > et =.',
        '36 < 42 car 3 dizaines sont moins que 4 dizaines.',
        'Quel signe convient : 57 … 53 ?', ['<', '>', '='], 1,
        '57 est supérieur à 53 : le signe est >.'),
      _Lesson('Mesurer des longueurs avec une règle',
        'Je place le zéro de la règle au début de l’objet. Je lis le nombre indiqué à l’autre extrémité. Je peux exprimer une longueur en centimètres.',
        'Un crayon qui va de 0 à 12 mesure 12 cm.',
        'Quelle unité convient pour mesurer un cahier ?', ['Le centimètre', 'Le kilogramme', 'Le litre'], 0,
        'Le centimètre sert à mesurer une longueur.'),
    ]),
    _Unit('T2 • Français – approfondissement', 'Accord, verbes et vocabulaire', [
      _Lesson('Reconnaître le verbe dans une phrase',
        'Le verbe indique souvent une action ou un état. Pour le trouver, je demande ce que fait le personnage.',
        'Dans « Afi danse », danse est le verbe.',
        'Quel est le verbe dans « Kossi mange une mangue » ?', ['Kossi', 'mange', 'mangue'], 1,
        'Mange indique l’action : c’est le verbe.'),
      _Lesson('Employer le singulier et le pluriel',
        'Un nom au singulier désigne généralement une seule chose. Au pluriel, il en désigne plusieurs. On ajoute souvent s, mais il faut observer le déterminant.',
        'Un livre devient des livres.',
        'Quel groupe est au pluriel ?', ['La fleur', 'Un élève', 'Les cahiers'], 2,
        'Les cahiers désigne plusieurs cahiers.'),
    ]),
    _Unit('T2 • Mathématiques – approfondissement', 'Calcul posé et monnaie', [
      _Lesson('Additionner avec une retenue simple',
        'Je range les unités sous les unités et les dizaines sous les dizaines. Si les unités font dix ou plus, je garde les unités et je reporte une dizaine.',
        '28 + 15 : 8 + 5 = 13, j’écris 3 et je reporte 1 dizaine ; résultat 43.',
        'Combien font 27 + 16 ?', ['33', '43', '53'], 1,
        '27 + 16 = 43.'),
      _Lesson('Reconnaître et utiliser la monnaie',
        'La monnaie permet d’acheter et de vendre. Je compte les pièces ou billets et je peux calculer le prix total de plusieurs objets.',
        'Un objet coûte 100 F et un autre 50 F : total 150 F CFA.',
        'Un cahier coûte 200 F et un crayon 50 F. Quel est le total ?', ['150 F', '250 F', '300 F'], 1,
        '200 + 50 = 250 F CFA.'),
    ]),
    _Unit('T2 • Anglais – approfondissement', 'Nombres et consignes de classe', [
      _Lesson('Compter de one à ten',
        'Les nombres anglais de one à ten sont : one, two, three, four, five, six, seven, eight, nine, ten. Je les prononce et je les associe à des quantités.',
        'Three books signifie trois livres.',
        'Que signifie five ?', ['Deux', 'Cinq', 'Dix'], 1,
        'Five signifie cinq.'),
      _Lesson('Comprendre les consignes simples',
        'À l’école, listen signifie écouter, stand up signifie se lever, sit down signifie s’asseoir et open your book signifie ouvrir ton livre.',
        'The teacher says: Stand up. Les élèves se lèvent.',
        'Que signifie sit down ?', ['Assieds-toi', 'Cours', 'Écris'], 0,
        'Sit down signifie assieds-toi.'),
    ]),
    _Unit('T2 • Éveil scientifique – approfondissement', 'Les animaux et les cinq sens', [
      _Lesson('Distinguer animaux domestiques et sauvages',
        'Certains animaux vivent auprès des humains et sont élevés ou soignés par eux. D’autres vivent librement dans la nature. Il faut respecter les animaux et ne pas les provoquer.',
        'La chèvre est souvent domestique ; le lion est un animal sauvage.',
        'Lequel est généralement un animal domestique ?', ['Le lion', 'La chèvre', 'Le crocodile'], 1,
        'La chèvre est souvent élevée par les familles.'),
      _Lesson('Protéger les organes des sens',
        'Les sens nous aident à découvrir notre environnement. Je protège mes yeux, mes oreilles, mon nez, ma langue et ma peau en évitant les objets dangereux et les produits inconnus.',
        'Je ne mets jamais un objet pointu dans mon oreille.',
        'Quel geste protège les oreilles ?', ['Y introduire un bâton', 'Éviter les objets dans l’oreille', 'Écouter toujours un son très fort'], 1,
        'Il ne faut rien introduire dans l’oreille ni écouter des sons trop forts.'),
    ]),
    _Unit('T3 • Français – approfondissement', 'Rédaction et révision', [
      _Lesson('Raconter un événement dans l’ordre',
        'Pour raconter, je présente le début, les actions et la fin. Des mots comme d’abord, ensuite et enfin aident à organiser le récit.',
        'D’abord je me lave, ensuite je m’habille, enfin je pars à l’école.',
        'Quel mot peut annoncer la dernière action ?', ['D’abord', 'Enfin', 'Hier seulement'], 1,
        'Enfin annonce la dernière étape du récit.'),
      _Lesson('Poser une question correctement',
        'Une phrase interrogative sert à demander une information. À l’écrit, elle se termine par un point d’interrogation.',
        'Où habites-tu ? est une question.',
        'Quel signe termine une question écrite ?', ['.', '?', '!'], 1,
        'Le point d’interrogation marque une question.'),
    ]),
    _Unit('T3 • Mathématiques – approfondissement', 'Heure, calendrier et géométrie', [
      _Lesson('Lire les heures entières',
        'Une horloge possède une petite aiguille pour les heures et une grande aiguille pour les minutes. Quand la grande aiguille est sur 12, il est une heure exacte indiquée par la petite aiguille.',
        'La petite aiguille sur 7 et la grande sur 12 indiquent 7 heures.',
        'Quand la grande aiguille est sur 12 et la petite sur 4, quelle heure est-il ?', ['4 h', '12 h', '8 h'], 0,
        'Il est 4 heures.'),
      _Lesson('Reconnaître les figures géométriques',
        'Un triangle possède trois côtés. Un carré possède quatre côtés égaux et quatre angles droits. Un rectangle possède quatre angles droits et ses côtés opposés sont égaux.',
        'Une porte a souvent la forme d’un rectangle.',
        'Quelle figure possède trois côtés ?', ['Carré', 'Triangle', 'Rectangle'], 1,
        'Le triangle possède trois côtés.'),
    ]),
    _Unit('T3 • Anglais – approfondissement', 'Couleurs et objets familiers', [
      _Lesson('Nommer quelques couleurs',
        'En anglais, red signifie rouge, blue bleu, green vert, yellow jaune et black noir. Je peux montrer un objet et dire sa couleur.',
        'The book is blue. = Le livre est bleu.',
        'Que signifie green ?', ['Vert', 'Rouge', 'Jaune'], 0,
        'Green signifie vert.'),
    ]),
    _Unit('T3 • Éveil scientifique – approfondissement', 'Environnement et météo', [
      _Lesson('Observer le temps qu’il fait',
        'Le temps peut être ensoleillé, nuageux, pluvieux ou venteux. Observer le ciel aide à choisir ses activités et à se protéger.',
        'Quand il pleut, j’utilise un abri ou un parapluie.',
        'Que peut-on utiliser pour se protéger de la pluie ?', ['Un parapluie', 'Une règle', 'Une assiette'], 0,
        'Un parapluie aide à rester à l’abri de la pluie.'),
    ]),
    _Unit('T3 • Éducation sociale – approfondissement', 'Vie communautaire et respect', [
      _Lesson('Respecter les biens communs',
        'Les biens communs appartiennent à tous ou servent à tous : école, points d’eau, routes et espaces publics. Je les utilise correctement et je ne les dégrade pas.',
        'Je ferme le robinet public après avoir pris de l’eau.',
        'Pourquoi faut-il protéger les biens communs ?', ['Ils servent à la communauté', 'Ils ne servent à personne', 'Pour les casser'], 0,
        'Les biens communs sont utiles à toute la communauté.'),
    ]),

    _Unit('CP2 • Évaluation du 1er trimestre', 'Bilan de français et de mathématiques', [
      _Lesson('Bilan de lecture et d’écriture', 'Lis attentivement une phrase, comprends son sens, puis écris une réponse courte en respectant les espaces et le point final.', 'Le garçon joue dans la cour. Question : Où joue le garçon ? Réponse : Dans la cour.', 'Quelle réponse correspond à la phrase ?', ['Le garçon dort.', 'Le garçon joue dans la cour.', 'La fille chante.'], 1, 'La réponse reprend l’information donnée dans la phrase.'),
      _Lesson('Bilan de numération et de calcul', 'Lis, écris, compares et décomposes les nombres étudiés. Pour calculer, aligne les unités et les dizaines.', '34 = 3 dizaines et 4 unités. 23 + 15 = 38.', 'Combien font 26 + 13 ?', ['39', '38', '49'], 0, '26 + 13 = 39 : 6 unités + 3 unités = 9 unités et 2 dizaines + 1 dizaine = 3 dizaines.'),
    ]),
    _Unit('CP2 • Évaluation du 2e trimestre', 'Bilan des apprentissages et résolution de problèmes', [
      _Lesson('Bilan de langue et d’expression', 'Une phrase commence par une majuscule et se termine par un signe de ponctuation. Le verbe indique souvent l’action.', 'Awa prépare le repas. Le verbe est prépare.', 'Dans « Les enfants chantent », quel est le verbe ?', ['enfants', 'chantent', 'les'], 1, 'Chantent indique l’action réalisée par les enfants.'),
      _Lesson('Bilan de calcul et de mesures', 'Résous un problème en repérant les données, l’opération utile et la réponse. Utilise une règle pour mesurer une longueur en centimètres.', 'J’ai 20 F et je reçois 15 F. Je possède 20 + 15 = 35 F.', 'Une corde mesure 12 cm. On ajoute 5 cm. Quelle est sa longueur ?', ['7 cm', '17 cm', '60 cm'], 1, '12 + 5 = 17 cm.'),
    ]),
    _Unit('CP2 • Évaluation du 3e trimestre et préparation au CE1', 'Révision générale des compétences essentielles', [
      _Lesson('Compréhension, grammaire et production écrite', 'Pour raconter, présente les personnages, les actions et leur ordre. Relis ton texte pour vérifier les majuscules, les espaces et la ponctuation.', 'D’abord, Kossi se lève. Ensuite, il se lave. Enfin, il va à l’école.', 'Quel mot peut annoncer la dernière action ?', ['D’abord', 'Ensuite', 'Enfin'], 2, 'Enfin annonce la dernière étape d’une suite d’actions.'),
      _Lesson('Problèmes, géométrie et repères', 'Choisis l’opération adaptée à la situation. Reconnais les figures simples et utilise les repères de temps et d’espace.', 'Il y a 18 mangues. On en donne 6 : 18 − 6 = 12.', 'Une classe compte 14 filles et 11 garçons. Combien y a-t-il d’élèves ?', ['3', '25', '24'], 1, '14 + 11 = 25 élèves.'),
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
