import 'package:flutter/material.dart';
import '../../data/models/models.dart';

/// Socle annuel de Seconde : cours transversaux et repères de spécialisation.
class SecondeCompletionScreen extends StatelessWidget {
  final SchoolTrack track;
  final String series;
  const SecondeCompletionScreen({super.key, required this.track, required this.series});
  static const _units = <_Unit>[
    _Unit('T1 • Français','Méthodes de lecture et étude du roman','Analyser un récit demande de distinguer auteur, narrateur et personnage, de repérer le point de vue, la chronologie et les procédés d’écriture. Une citation doit être courte, exacte et expliquée.','Pour commenter une citation, présenter l’idée, citer le passage puis expliquer son effet.','Qui raconte un récit ?',['Le narrateur','Toujours l’auteur réel','Le lecteur'],0,'Le narrateur est la voix qui raconte ; il ne se confond pas nécessairement avec l’auteur.'),
    _Unit('T1 • Mathématiques','Fonctions, intervalles et calcul algébrique','Une fonction associe à chaque nombre de son domaine une unique image. On note f(x) l’image de x. Les intervalles décrivent des ensembles de réels ; développer et factoriser permettent de transformer des expressions.','Si f(x)=2x+3, alors f(4)=11.','Pour f(x)=3x−2, quelle est l’image de 5 ?',['10','13','15'],1,'f(5)=3×5−2=13.'),
    _Unit('T1 • Anglais','Tenses, description and communication','Les temps verbaux situent les actions. Le present simple décrit habitudes et vérités ; le present continuous décrit une action en cours ; le past simple présente un fait terminé. Adapter le registre au destinataire.','She usually walks, but today she is taking a bus.','Choose the correct form: Listen! The baby …',['cries','is crying','cry'],1,'Listen! indique une action en cours : is crying.'),
    _Unit('T1 • SVT','Cellule, organisation du vivant et biomolécules','La cellule est l’unité structurale et fonctionnelle du vivant. La membrane délimite la cellule, le cytoplasme contient des structures et le noyau porte l’information génétique chez les cellules eucaryotes. Les biomolécules participent au fonctionnement cellulaire.','Les cellules végétales possèdent notamment une paroi et des chloroplastes.','Quelle structure contient l’essentiel de l’ADN dans une cellule eucaryote ?',['Le noyau','La paroi','La membrane seule'],0,'Le noyau contient les chromosomes et l’essentiel de l’ADN.'),
    _Unit('T1 • Physique-Chimie','Mesures, unités et constitution de la matière','Une mesure doit préciser une valeur et une unité. La matière est constituée d’atomes ; les molécules sont des assemblages d’atomes. Les changements d’état sont des transformations physiques.','La masse se mesure en kilogrammes et le volume en mètres cubes ou litres.','Quelle est l’unité SI de la masse ?',['Le kilogramme','Le litre','Le newton'],0,'L’unité SI de masse est le kilogramme (kg).'),
    _Unit('T1 • Histoire-Géographie','Humanisme, Renaissance et dynamiques territoriales','L’humanisme et la Renaissance renouvellent les arts, les sciences et la diffusion des savoirs en Europe. En géographie, analyser un territoire implique de décrire les populations, les activités, les réseaux et les inégalités spatiales.','Une carte thématique doit être lue avec son titre, sa légende et son échelle.','Quel phénomène favorise la diffusion des idées à la Renaissance ?',['L’imprimerie','La disparition des livres','La fermeture des écoles'],0,'L’imprimerie accélère la reproduction et la circulation des textes.'),
    _Unit('T2 • Français','Poésie, théâtre et outils de l’analyse littéraire','La poésie travaille les images, les rythmes, les sonorités et les formes. Le théâtre associe texte, dialogue, didascalies et représentation. Une analyse organise des observations en paragraphes cohérents et s’appuie sur des procédés précis.','Une métaphore rapproche deux réalités sans outil de comparaison.','Quelle figure rapproche deux éléments sans « comme » ?',['Métaphore','Comparaison','Énumération'],0,'La métaphore établit une assimilation directe.'),
    _Unit('T2 • Mathématiques','Équations, inéquations et géométrie analytique','Une équation se résout par transformations équivalentes. Une inéquation définit un ensemble de solutions. Dans un repère, les coordonnées localisent un point et permettent de calculer des déplacements et des distances simples.','2x+6=14 donne x=4.','Résous 4x−8=12.',['x=1','x=5','x=8'],1,'4x=20 donc x=5.'),
    _Unit('T2 • Anglais','Comparatives, superlatives and argumentation','Le comparatif compare deux éléments : taller than, more interesting than. Le superlatif exprime un degré extrême : the tallest, the most useful. Pour argumenter, présenter une opinion et la justifier avec because, although et however.','This book is more interesting than that one.','Choose the correct superlative: Mount Everest is … mountain.',['the highest','higher','high'],0,'The highest est le superlatif de high.'),
    _Unit('T2 • SVT','Nutrition, métabolisme et échanges','Les organismes échangent matière et énergie avec leur environnement. La digestion rend les nutriments absorbables ; la respiration cellulaire libère de l’énergie utilisable. Les végétaux chlorophylliens réalisent la photosynthèse.','Les nutriments passent de l’intestin grêle vers le sang.','Où se fait l’essentiel de l’absorption des nutriments ?',['Intestin grêle','Œsophage','Trachée'],0,'La paroi de l’intestin grêle permet l’absorption des nutriments.'),
    _Unit('T2 • Physique-Chimie','Solutions, concentration et transformations chimiques','Une solution est un mélange homogène constitué d’un solvant et d’un ou plusieurs solutés. La concentration massique est le quotient de la masse de soluté par le volume de solution. Une réaction chimique transforme les réactifs en produits.','10 g de sel dans 2 L de solution donnent 5 g/L.','La concentration massique de 12 g de soluté dans 3 L vaut…',['3 g/L','4 g/L','36 g/L'],1,'C = m/V = 12/3 = 4 g/L.'),
    _Unit('T2 • Histoire-Géographie','Population, mobilités et urbanisation','Les dynamiques démographiques combinent natalité, mortalité et migrations. L’urbanisation transforme les paysages et crée des besoins en logements, transports, eau et services. Les cartes et graphiques permettent de comparer les territoires.','Un solde migratoire positif signifie que les arrivées dépassent les départs.','Que signifie un solde migratoire positif ?',['Plus d’arrivées que de départs','Plus de départs que d’arrivées','Aucune migration'],0,'Le territoire gagne des habitants par les migrations.'),
    _Unit('T3 • Français','Argumentation, dissertation et expression écrite','Une dissertation répond à une question par une réflexion organisée : introduction, développement structuré et conclusion. Chaque paragraphe développe une idée, l’explique et l’illustre. La relecture vérifie la cohérence et la langue.','Une introduction présente le sujet, pose la problématique et annonce le plan.','Quel élément annonce les grandes parties du raisonnement ?',['L’annonce du plan','La signature','La bibliographie uniquement'],0,'L’annonce du plan indique l’organisation du développement.'),
    _Unit('T3 • Mathématiques','Statistiques, probabilités et fonctions','La moyenne résume une série de valeurs ; la médiane partage une série ordonnée en deux groupes de même effectif. Une probabilité est comprise entre 0 et 1. Les représentations graphiques aident à étudier une fonction.','Pour un dé équilibré, P(obtenir 6)=1/6.','Quelle est la probabilité d’obtenir un nombre pair sur un dé équilibré ?',['1/6','1/2','2/3'],1,'Les issues paires sont 2, 4 et 6 : 3 sur 6, soit 1/2.'),
    _Unit('T3 • Anglais','Conditionals, modal verbs and formal writing','Le first conditional décrit une conséquence future possible. Les modaux can, must, should et might expriment capacité, obligation, conseil et possibilité. Une lettre formelle respecte la structure et un registre poli.','If we work together, we will finish on time.','Choose the correct sentence.',['If it rains, we will stay inside.','If it will rain, we stay inside.','If it raining, we stayed inside.'],0,'La proposition introduite par if est au présent simple.'),
    _Unit('T3 • SVT','Écosystèmes, biodiversité et santé','Un écosystème associe des êtres vivants et leur milieu. Les interactions alimentaires et les facteurs physiques structurent son fonctionnement. La biodiversité contribue à la stabilité des milieux ; les activités humaines peuvent la préserver ou la menacer.','Une chaîne alimentaire montre des relations de nutrition entre organismes.','Quel facteur peut menacer la biodiversité ?',['Destruction des habitats','Protection des forêts','Restauration des mares'],0,'La destruction des habitats réduit les ressources et les lieux de vie des espèces.'),
    _Unit('T3 • Physique-Chimie','Mouvement, forces et énergie','La vitesse moyenne est v=d/t. Une force peut modifier la vitesse, la direction ou la forme d’un objet. L’énergie se conserve lors des transformations, même si elle change de forme et se dissipe en partie.','Un objet parcourt 60 m en 10 s : v=6 m/s.','Une voiture parcourt 120 km en 2 h. Sa vitesse moyenne est…',['40 km/h','60 km/h','240 km/h'],1,'v = 120 ÷ 2 = 60 km/h.'),
    _Unit('T3 • Histoire-Géographie','Mondialisation, développement et citoyenneté','La mondialisation met en relation les territoires par les échanges, les transports, les communications et les flux financiers. Le développement se mesure par des indicateurs multiples. Une analyse géographique relie échelles locale, nationale et mondiale.','Un port est une interface entre les échanges maritimes et les réseaux terrestres.','Quel réseau facilite les échanges mondiaux ?',['Réseaux de transport et de communication','Uniquement les sentiers isolés','Aucun réseau'],0,'Les transports et communications connectent les territoires.'),
  ];

  /// Trois leçons de spécialisation, une par trimestre, selon la série choisie.
  static List<_Unit> seriesUnitsFor(String series) {
    final units = switch (series) {
      'A4' => [
        _Unit('T1 • A4 • Littérature','Lire et interpréter un texte argumentatif','Repérer la thèse, les arguments, les exemples et les marques de subjectivité. Distinguer convaincre par le raisonnement et persuader par les émotions.','Dans un éditorial, relever la thèse puis deux arguments qui la soutiennent.','Une thèse est…',['Une opinion défendue','Un personnage','Une date'],0,'La thèse est l’idée principale que l’auteur cherche à défendre.'),
        _Unit('T2 • A4 • Langues','Grammaire de la phrase complexe','Une proposition contient un verbe conjugué. Les propositions peuvent être juxtaposées, coordonnées ou subordonnées. Les connecteurs précisent les relations logiques.','Je révise parce que je prépare un examen : la subordonnée exprime la cause.','Quel mot introduit souvent une cause ?',['Parce que','Pourtant','Donc'],0,'Parce que introduit une proposition circonstancielle de cause.'),
        _Unit('T3 • A4 • Culture','Méthode du commentaire composé','Le commentaire organise des axes de lecture. Chaque paragraphe présente une idée, une citation précise et une interprétation liée au projet de lecture.','Associer une image, un champ lexical et un effet produit sur le lecteur.','Que doit apporter une citation dans un commentaire ?',['Une preuve analysée','Un remplissage','Une opinion sans lien'],0,'La citation sert de preuve et doit être expliquée.'),
      ],
      'C' => [
        _Unit('T1 • C • Mathématiques','Calcul littéral et équations','Développer consiste à appliquer la distributivité ; factoriser revient à mettre un facteur commun en évidence. Vérifier une solution en remplaçant l’inconnue dans l’égalité initiale.','3(x+2)=3x+6.','Développe 4(x−3).',['4x−12','4x−3','x−12'],0,'La distributivité donne 4×x − 4×3 = 4x−12.'),
        _Unit('T2 • C • Physique','Grandeurs électriques et loi d’Ohm','Dans un conducteur ohmique, la tension U, la résistance R et l’intensité I vérifient U=RI. Les unités sont le volt, l’ohm et l’ampère.','Pour R=5 Ω et I=2 A, U=10 V.','Avec R=4 Ω et I=3 A, U vaut…',['7 V','12 V','1,3 V'],1,'U=RI=4×3=12 V.'),
        _Unit('T3 • C • Sciences','Énergie et rendement','Une chaîne énergétique décrit les conversions entre formes d’énergie. Le rendement est le rapport entre énergie utile et énergie reçue ; il est inférieur ou égal à 1.','Une machine reçoit 100 J et fournit 80 J utiles : rendement 0,8 soit 80 %.','Une machine reçoit 200 J et fournit 50 J utiles. Son rendement est…',['25 %','50 %','400 %'],0,'η=50/200=0,25, soit 25 %.'),
      ],
      'D' => [
        _Unit('T1 • D • Biologie','Organisation et fonctionnement cellulaire','Les cellules spécialisées possèdent des structures adaptées à leur fonction. Les échanges à travers la membrane dépendent notamment des gradients de concentration et des propriétés membranaires.','Une cellule musculaire contient des structures permettant la contraction.','La membrane plasmique…',['Contrôle les échanges','Remplace le noyau','Fabrique la lumière'],0,'La membrane délimite la cellule et régule les échanges.'),
        _Unit('T2 • D • SVT','Reproduction et hérédité','La reproduction sexuée implique la formation de gamètes et leur fusion. La méiose réduit de moitié le nombre de chromosomes ; la fécondation rétablit le nombre caractéristique de l’espèce.','Chez l’humain, les gamètes contiennent 23 chromosomes.','La méiose produit des cellules…',['Haploïdes','Toujours diploïdes','Sans chromosomes'],0,'La méiose divise par deux le nombre de chromosomes.'),
        _Unit('T3 • D • Écologie','Écosystèmes et santé environnementale','Les populations interagissent entre elles et avec leur milieu. La pollution, la déforestation et la surexploitation modifient les équilibres écologiques ; la prévention repose sur des pratiques durables.','Protéger les berges limite l’érosion et préserve des habitats.','Quel geste protège la biodiversité ?',['Restaurer les habitats','Déverser des déchets','Détruire les zones humides'],0,'La restauration des habitats favorise le maintien des espèces.'),
      ],
      'G1' => [
        _Unit('T1 • G1 • Secrétariat','Accueil et communication professionnelle','L’accueil professionnel repose sur l’écoute, la courtoisie, la reformulation et la confidentialité. Un message doit être transmis avec exactitude et dans un format adapté.','Noter le nom, le contact, l’objet de l’appel et l’action attendue.','Quel principe est essentiel pour un dossier confidentiel ?',['La discrétion','La diffusion publique','La modification arbitraire'],0,'La confidentialité protège les informations de l’organisation.'),
        _Unit('T2 • G1 • Bureautique','Traitement de texte et mise en page','Un document professionnel utilise des styles cohérents, des titres hiérarchisés, des marges régulières et une relecture attentive. Les tableaux facilitent la présentation de données.','Créer un compte rendu avec titre, date, participants et décisions.','Quel outil assure une présentation homogène des titres ?',['Les styles','Les espaces répétés','Les majuscules partout'],0,'Les styles permettent d’uniformiser et de structurer le document.'),
        _Unit('T3 • G1 • Organisation','Préparer une réunion et rédiger un compte rendu','Une réunion efficace possède un objectif, un ordre du jour, des participants identifiés et une durée prévue. Le compte rendu restitue les décisions, responsables et échéances.','Pour chaque décision, noter qui fait quoi et pour quelle date.','Quel document annonce les points à traiter ?',['Ordre du jour','Facture','Bulletin de paie'],0,'L’ordre du jour organise les sujets de la réunion.'),
      ],
      'G2' => [
        _Unit('T1 • G2 • Comptabilité','Équilibre comptable et pièces justificatives','Toute opération doit être appuyée par une pièce justificative. La comptabilité en partie double enregistre chaque opération au débit d’un compte et au crédit d’un autre pour un même montant.','Un achat réglé en banque augmente une charge et diminue la trésorerie.','À quoi sert une pièce justificative ?',['Prouver une opération','Remplacer les comptes','Modifier le résultat'],0,'Elle apporte la preuve et la traçabilité de l’opération.'),
        _Unit('T2 • G2 • Gestion','Stocks et inventaire','Le suivi des stocks compare les entrées, sorties et quantités physiques. L’inventaire permet de détecter écarts, pertes et erreurs et d’évaluer les besoins de réapprovisionnement.','Stock final = stock initial + entrées − sorties.','Stock initial 40, entrées 15, sorties 22 : stock final ?',['33','47','77'],0,'40+15−22=33 unités.'),
        _Unit('T3 • G2 • Analyse','Lire un compte de résultat simplifié','Le compte de résultat compare produits et charges sur une période. Un résultat positif indique un bénéfice ; un résultat négatif indique une perte.','Produits 900 000 F, charges 750 000 F : résultat 150 000 F.','Produits 500 000 F et charges 530 000 F : résultat ?',['Bénéfice de 30 000 F','Perte de 30 000 F','Équilibre'],1,'500 000−530 000=−30 000 F : c’est une perte.'),
      ],
      'G3' => [
        _Unit('T1 • G3 • Commerce','Étude de marché et clientèle','Une étude de marché identifie les clients, leurs besoins, les concurrents et les conditions de vente. Un questionnaire doit être clair, neutre et adapté à la population interrogée.','Interroger plusieurs catégories de clients permet de comparer les attentes.','Quel est l’objectif principal d’une étude de marché ?',['Comprendre la demande','Fixer un prix au hasard','Éviter les clients'],0,'Elle aide à connaître la demande et à réduire l’incertitude commerciale.'),
        _Unit('T2 • G3 • Vente','Étapes de la négociation commerciale','La vente comprend la prise de contact, la découverte du besoin, la proposition, le traitement des objections et la conclusion. L’argumentation doit relier les caractéristiques du produit aux avantages pour le client.','Reformuler le besoin avant de proposer une solution.','Que faut-il faire avant de présenter une offre ?',['Découvrir le besoin','Imposer le produit','Clore immédiatement'],0,'La découverte du besoin permet une proposition pertinente.'),
        _Unit('T3 • G3 • Gestion','Suivi des ventes et fidélisation','Le suivi commercial analyse les ventes, les réclamations et la satisfaction. La fidélisation repose sur la qualité du service, le respect des engagements et une communication régulière.','Un registre des réclamations permet de repérer les problèmes récurrents.','Quel indicateur renseigne sur la satisfaction ?',['Avis et retours clients','Couleur du magasin','Nombre de fenêtres'],0,'Les retours clients renseignent directement sur leur expérience.'),
      ],
      'E' => [
        _Unit('T1 • E • Électricité','Circuits électriques et sécurité','Un circuit comporte une source, des conducteurs et des récepteurs. En série, le courant est identique dans les dipôles ; en dérivation, la tension est la même aux bornes des branches. Toute intervention exige une mise en sécurité.','Un fusible protège un circuit contre une surintensité.','Quel appareil protège contre une surintensité ?',['Fusible','Interrupteur décoratif','Lampe'],0,'Le fusible fond lorsque le courant dépasse sa valeur prévue.'),
        _Unit('T2 • E • Machines','Transformateurs et moteurs','Un transformateur modifie une tension alternative par induction électromagnétique. Un moteur électrique convertit l’énergie électrique en énergie mécanique ; son choix dépend de la puissance et de l’usage.','Un moteur entraîne une pompe pour déplacer de l’eau.','Un moteur électrique transforme principalement l’énergie…',['Électrique en mécanique','Thermique en chimique','Lumineuse en sonore'],0,'Le moteur fournit un mouvement à partir de l’énergie électrique.'),
        _Unit('T3 • E • Maintenance','Diagnostic et entretien électrique','Un diagnostic commence par l’observation, la consignation et des mesures adaptées. Il faut identifier la cause d’une panne avant de remplacer un composant et consigner l’intervention.','Vérifier continuité et tension avec un appareil adapté, après sécurisation.','Quelle étape précède une intervention sur une installation ?',['Mise en sécurité','Toucher les conducteurs','Court-circuiter le circuit'],0,'La sécurité et la consignation précèdent toute intervention.'),
      ],
      'F1' => [
        _Unit('T1 • F1 • Dessin','Lecture de dessin industriel','Un dessin technique utilise vues, coupes, traits normalisés et cotations pour transmettre la forme et les dimensions d’une pièce. La lecture commence par le cartouche et les vues principales.','Une coupe révèle des détails intérieurs masqués dans une vue extérieure.','À quoi sert une coupe ?',['Montrer l’intérieur d’une pièce','Indiquer le prix','Remplacer toutes les cotes'],0,'La coupe rend visibles les formes intérieures.'),
        _Unit('T2 • F1 • Mécanique','Efforts et équilibre des solides','Un solide est en équilibre si les actions mécaniques se compensent. L’étude identifie les forces, leurs points d’application, directions, sens et intensités.','Un objet immobile posé sur une table subit son poids et la réaction du support.','Pour un solide en équilibre soumis à deux forces, elles sont…',['De même direction et opposées','Toujours perpendiculaires','De même sens'],0,'Les deux forces se compensent : même direction, sens opposés et même intensité.'),
        _Unit('T3 • F1 • Fabrication','Tolérances et contrôle dimensionnel','Une tolérance définit l’écart admissible autour d’une dimension nominale. Le contrôle utilise des instruments adaptés et compare la mesure aux limites spécifiées.','Une cote 20 ±0,1 mm accepte de 19,9 à 20,1 mm.','Une cote 10 ±0,2 mm accepte quelle plage ?',['9,8 à 10,2 mm','9 à 11 mm','10,2 à 10,4 mm'],0,'La limite inférieure est 9,8 mm et la supérieure 10,2 mm.'),
      ],
      'F2' => [
        _Unit('T1 • F2 • Électronique','Composants et fonctions électroniques','Résistances, condensateurs, diodes et transistors remplissent des fonctions distinctes. L’identification des bornes et le respect des polarités évitent les erreurs de montage.','Une diode laisse passer le courant principalement dans un sens.','Quel composant redresse le courant ?',['Diode','Résistance seule','Fusible'],0,'La diode conduit dans un sens et bloque dans l’autre.'),
        _Unit('T2 • F2 • Logique','Algèbre de Boole et portes logiques','Les variables logiques prennent deux états : 0 ou 1. Les portes ET, OU et NON réalisent des opérations qui peuvent être décrites par des tables de vérité.','ET vaut 1 seulement si les deux entrées valent 1.','Pour une porte ET, A=1 et B=0 donnent…',['0','1','2'],0,'Les deux entrées doivent être à 1 pour obtenir 1.'),
        _Unit('T3 • F2 • Mesures','Mesure et diagnostic électronique','Un multimètre mesure notamment tension, résistance et courant selon le branchement choisi. Le diagnostic compare les valeurs mesurées aux valeurs attendues, en respectant les limites de l’appareil.','La résistance se mesure hors tension sur un circuit isolé.','Pour mesurer une résistance, le circuit doit être…',['Hors tension','En court-circuit','En surcharge'],0,'La mesure ohmique s’effectue hors tension pour protéger l’appareil et l’opérateur.'),
      ],
      'F3' => [
        _Unit('T1 • F3 • Réseaux','Distribution et protections électriques','Un réseau distribue l’énergie depuis une source vers les récepteurs. Les protections contre surintensités et défauts d’isolement doivent être adaptées aux conducteurs et aux usages.','Le disjoncteur coupe automatiquement en cas de défaut détecté.','Quel appareil coupe un circuit en cas de surintensité ?',['Disjoncteur','Voltmètre','Transformateur de mesure uniquement'],0,'Le disjoncteur protège le circuit en interrompant le courant.'),
        _Unit('T2 • F3 • Schémas','Schémas unifilaires et multifilaires','Le schéma unifilaire représente un circuit avec une ligne simplifiée ; le multifilaire détaille les conducteurs. Les symboles normalisés facilitent l’installation et la maintenance.','Repérer alimentation, protection, commande et récepteur.','Quel schéma détaille séparément les conducteurs ?',['Multifilaire','Unifilaire','Plan de situation'],0,'Le schéma multifilaire représente les conducteurs séparément.'),
        _Unit('T3 • F3 • Dépannage','Recherche méthodique de panne','La recherche de panne suit une démarche structurée : recueillir les symptômes, sécuriser, contrôler l’alimentation, tester les éléments et vérifier le fonctionnement après réparation.','Une lampe éteinte peut provenir de la source, du câblage ou de la lampe.','Quelle démarche est la plus fiable ?',['Contrôler méthodiquement','Changer tous les éléments au hasard','Ignorer la protection'],0,'Une démarche ordonnée évite les remplacements inutiles et les risques.'),
      ],
      'F4' => [
        _Unit('T1 • F4 • Matériaux','Matériaux de construction et propriétés','Les matériaux se choisissent selon résistance, durabilité, disponibilité, coût et conditions d’utilisation. Le béton résiste bien à la compression ; l’acier résiste à la traction et complète le béton armé.','Le béton armé associe béton et armatures en acier.','Quel matériau améliore la résistance du béton en traction ?',['Acier','Sable seul','Eau seule'],0,'Les armatures d’acier reprennent une part importante des efforts de traction.'),
        _Unit('T2 • F4 • Plans','Lecture de plans et métrés','Un plan comporte échelle, cotes, symboles et légende. Le métré calcule les quantités nécessaires à partir des dimensions : surfaces, volumes et longueurs.','Surface d’un sol rectangulaire : longueur × largeur.','Une pièce de 5 m sur 4 m a une surface de…',['9 m²','20 m²','40 m²'],1,'5×4=20 m².'),
        _Unit('T3 • F4 • Chantier','Organisation et sécurité du chantier','Le chantier organise équipes, matériaux, matériel, délais et contrôles. Les risques doivent être identifiés ; les équipements de protection et la signalisation préviennent les accidents.','Prévoir les circulations et stocker les matériaux sans bloquer les accès.','Quel est le but des équipements de protection individuelle ?',['Réduire les risques pour les travailleurs','Décorer le chantier','Remplacer la formation'],0,'Les EPI protègent contre les risques identifiés.'),
      ],
      'Ti/1' => [
        _Unit('T1 • Ti/1 • Technologie','Systèmes techniques et chaîne d’énergie','Un système technique reçoit des informations et de l’énergie, puis agit sur son environnement. La chaîne d’énergie comprend généralement alimenter, distribuer, convertir et transmettre.','Dans un ventilateur, le moteur convertit l’énergie électrique en mouvement.','Quel élément réalise la conversion électrique-mécanique ?',['Moteur','Interrupteur seul','Capteur de température'],0,'Le moteur convertit l’énergie électrique en énergie mécanique.'),
        _Unit('T2 • Ti/1 • Automatisme','Capteurs, actionneurs et commande','Un capteur transforme une grandeur physique en information exploitable. Un actionneur réalise une action ; l’automate traite les entrées selon un programme pour commander les sorties.','Un capteur de niveau peut déclencher une pompe via une commande.','Quel composant détecte une grandeur physique ?',['Capteur','Actionneur uniquement','Fusible'],0,'Le capteur détecte et transmet une information.'),
        _Unit('T3 • Ti/1 • Qualité','Maintenance préventive et qualité','La maintenance préventive intervient avant la panne selon un calendrier ou l’état de l’équipement. La qualité vérifie la conformité ; la sécurité reste une exigence à chaque étape.','Un carnet d’entretien conserve dates, contrôles et interventions.','Quel est l’objectif de la maintenance préventive ?',['Réduire le risque de panne','Attendre systématiquement la casse','Supprimer les contrôles'],0,'Elle limite les défaillances et améliore la disponibilité des équipements.'),
      ],
      _ => const <_Unit>[],
    };
    return units;
  }

  static int get unitCount => _units.length;
  static int get lessonCount => _units.length;
  static List<Exercise> assessmentExercisesForTerm(int term, {String? subjectName}) {
    final result = <Exercise>[];
    for (var i = 0; i < _units.length; i++) {
      final unit = _units[i];
      if (!unit.title.startsWith('T$term •')) continue;
      if (subjectName != null && !_matches(unit.title, subjectName)) continue;
      result.add(Exercise(id: 'sec_t${term}_u${i}', lessonId: 'sec_t${term}_u${i}', question: unit.question, options: unit.options, correctIndex: unit.answer, explanation: unit.explanation));
    }
    return result;
  }
  static bool _matches(String title, String subject) {
    final t = title.toLowerCase(), s = subject.toLowerCase();
    if (s.contains('français') || s.contains('francais') || s.contains('littérature')) return t.contains('français');
    if (s.contains('math')) return t.contains('mathématiques');
    if (s.contains('anglais') || s.contains('english')) return t.contains('anglais');
    if (s.contains('svt') || s.contains('science') || s.contains('biologie')) return t.contains('svt');
    if (s.contains('physique') || s.contains('chimie')) return t.contains('physique-chimie');
    if (s.contains('histoire') || s.contains('géographie') || s.contains('education') || s.contains('éducation') || s.contains('emc')) return t.contains('histoire-géographie');
    return false;
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Complément Seconde • Série $series')),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      Card(child: Padding(padding: const EdgeInsets.all(16), child: Text('Parcours : ${track.label} • Série $series\n${unitCount} unités communes • ${lessonCount} leçons • 3 trimestres\nLes cours communs sont complétés par les matières propres à la série dans la liste des matières.', style: const TextStyle(fontWeight: FontWeight.w600)))),
      for (final unit in _units) _UnitTile(unit: unit),
      if (seriesUnitsFor(series).isNotEmpty) const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('COURS COMPLÉMENTAIRES DE LA SÉRIE', style: TextStyle(fontWeight: FontWeight.bold))),
      for (final unit in seriesUnitsFor(series)) _UnitTile(unit: unit),
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
