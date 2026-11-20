import 'package:flutter/material.dart';
import '../../data/models/models.dart';

/// Tronc commun annuel de Première, à compléter par les contenus propres à chaque série.
class PremiereCompletionScreen extends StatelessWidget {
  final SchoolTrack track;
  final String series;
  const PremiereCompletionScreen({super.key, required this.track, required this.series});
  static const _units = <_Unit>[
    _Unit('T1 • Français','Argumentation et littérature d’idées','Un texte argumentatif défend une thèse avec des arguments et des exemples. L’analyse examine la stratégie de l’auteur, les procédés rhétoriques et le contexte. Une dissertation construit une réponse progressive à une problématique.','Un argument convaincant est expliqué et illustré par un exemple précis.','Quel élément soutient directement une thèse ?',['Un argument','Une date sans lien','Une répétition vide'],0,'L’argument justifie la position défendue.'),
    _Unit('T1 • Mathématiques','Second degré et fonctions polynomiales','Une fonction du second degré s’écrit ax²+bx+c avec a non nul. Sa courbe est une parabole. Le discriminant permet d’étudier les racines d’un trinôme ; le sommet donne un extremum.','Pour x²−5x+6, les racines sont 2 et 3.','Quelle est la forme générale d’un trinôme du second degré ?',['ax²+bx+c avec a≠0','ax+b uniquement','a/x uniquement'],0,'Le terme de degré 2 est indispensable et son coefficient est non nul.'),
    _Unit('T1 • Anglais','Advanced tenses and structured argument','Les temps permettent de distinguer action achevée, durée et antériorité. Le past perfect (had + participe passé) situe une action avant une autre action passée. Un paragraphe argumentatif développe une idée avec exemples et connecteurs.','When I arrived, the lesson had already started.','Choose the correct form: She … before we arrived.',['has left','had left','is leaving'],1,'Had left marque l’action antérieure à notre arrivée passée.'),
    _Unit('T1 • SVT','Information génétique et expression des caractères','L’ADN porte une information organisée en gènes sur les chromosomes. L’expression d’un gène conduit à la production de molécules qui participent aux caractères. Les mutations peuvent modifier la séquence de l’ADN.','Un gène est une portion d’ADN portant une information héréditaire.','Quelle molécule porte l’information génétique ?',['ADN','Amidon','Eau'],0,'L’ADN est le support moléculaire de l’information génétique.'),
    _Unit('T1 • Physique-Chimie','Réactions, quantité de matière et solutions','La mole est l’unité de quantité de matière. La relation n=m/M relie quantité, masse et masse molaire. Une équation chimique équilibrée respecte la conservation des atomes et de la charge.','Pour 18 g d’eau et M=18 g/mol, n=1 mol.','Quelle relation relie n, m et M ?',['n=m/M','n=m×M','n=M/m'],0,'La quantité de matière est la masse divisée par la masse molaire.'),
    _Unit('T1 • Histoire-Géographie','Transformations politiques et dynamiques mondiales','L’étude historique met en relation événements, acteurs, causes et conséquences. En géographie, les territoires sont marqués par des flux, des réseaux et des inégalités. Une composition doit mobiliser des connaissances précises et organiser les exemples.','Une étude de document commence par identifier sa nature, son auteur, sa date et son contexte.','Quel réflexe est essentiel avant d’interpréter un document ?',['Identifier sa source et son contexte','Ignorer sa date','Lire uniquement sa légende'],0,'La source et le contexte permettent d’évaluer la portée du document.'),
    _Unit('T2 • Français','Roman, théâtre et commentaire composé','Le commentaire composé organise l’analyse autour d’axes cohérents. Il relie les procédés d’écriture à leurs effets et au sens du texte. Au théâtre, dialogue, didascalies, conflit et double énonciation contribuent à la représentation.','Un axe de commentaire formule une idée d’analyse, pas une simple liste de procédés.','Que doit expliquer un commentaire littéraire ?',['Le sens et les effets des procédés','Uniquement la biographie de l’auteur','Seulement le nombre de lignes'],0,'Le commentaire interprète les choix d’écriture et leurs effets.'),
    _Unit('T2 • Mathématiques','Suites numériques et dérivation','Une suite associe un terme à chaque entier naturel de son domaine. Une suite arithmétique ajoute une constante ; une suite géométrique multiplie par une constante. La dérivée renseigne sur les variations d’une fonction.','Suite arithmétique de premier terme 3 et raison 2 : u4=9 si u0=3.','Une suite arithmétique vérifie u0=4 et r=3. Quelle est u2 ?',['7','10','13'],1,'u2 = u0 + 2r = 4 + 6 = 10.'),
    _Unit('T2 • Anglais','Relative clauses and reported speech','Les propositions relatives précisent un nom avec who, which ou that. Le discours rapporté reformule les paroles et peut entraîner un recul des temps. La précision grammaticale améliore les écrits académiques.','The student who won the prize is my friend.','Which word can introduce a relative clause about a person?',['who','whereas','because'],0,'Who peut introduire une relative dont l’antécédent est une personne.'),
    _Unit('T2 • SVT','Immunité et fonctionnement de l’organisme','Le système immunitaire reconnaît et combat des agents étrangers. Les barrières naturelles, l’inflammation et les réponses immunitaires spécifiques participent à la défense. La vaccination prépare une mémoire immunitaire.','Les lymphocytes participent à des réponses immunitaires spécifiques.','Quel est l’objectif de la vaccination ?',['Préparer une réponse immunitaire','Remplacer tous les organes','Empêcher toute respiration'],0,'La vaccination prépare le système immunitaire à reconnaître un agent pathogène.'),
    _Unit('T2 • Physique-Chimie','Mécanique, énergie et circuits','Le mouvement se décrit dans un référentiel. Une force est caractérisée par direction, sens, valeur et point d’application. L’énergie électrique peut être convertie en énergie mécanique, thermique ou lumineuse.','La résultante des forces permet d’étudier l’évolution du mouvement.','Quelle grandeur caractérise l’action mécanique d’un objet sur un autre ?',['Force','Masse volumique uniquement','Température'],0,'Une force modélise une action mécanique.'),
    _Unit('T2 • Histoire-Géographie','Économie, mondialisation et territoires','La mondialisation organise des flux de marchandises, capitaux, personnes et informations. Les territoires ne bénéficient pas tous des mêmes connexions. L’analyse doit changer d’échelle et comparer les acteurs et les effets.','Une façade maritime concentre souvent ports, industries et réseaux logistiques.','Quel flux est associé à la mondialisation ?',['Flux de marchandises','Uniquement les nuages','Aucun échange'],0,'Les échanges de marchandises constituent un flux majeur.'),
    _Unit('T3 • Français','Dissertation et maîtrise de l’expression','Une dissertation formule une problématique et construit une démonstration. Chaque partie répond à un aspect de la question et s’appuie sur des exemples pertinents. La conclusion répond au sujet sans introduire une nouvelle démonstration.','Un plan équilibré évite les répétitions et fait progresser le raisonnement.','Quel est le rôle de la conclusion ?',['Répondre au problème posé et faire le bilan','Ajouter un sujet sans rapport','Remplacer l’introduction'],0,'La conclusion synthétise la réponse apportée à la problématique.'),
    _Unit('T3 • Mathématiques','Probabilités, statistiques et synthèse','Une variable aléatoire associe une valeur numérique à chaque issue d’une expérience aléatoire. L’espérance donne une moyenne théorique. Les statistiques décrivent une série par moyenne, médiane, dispersion et représentations.','Pour deux issues équiprobables donnant 0 et 10, l’espérance vaut 5.','Une variable vaut 2 ou 8 avec probabilité 1/2 chacune. Son espérance vaut…',['4','5','10'],1,'E=2×1/2+8×1/2=5.'),
    _Unit('T3 • Anglais','Academic writing and conditional structures','Les conditionnels expriment des hypothèses réelles ou imaginaires. Le second conditional utilise if + past simple, would + base verbale. Un essai clair comporte une introduction, des paragraphes argumentés et une conclusion.','If I had more time, I would learn another language.','Choose the correct second conditional.',['If I have time, I would go.','If I had time, I would go.','If I would have time, I go.'],1,'Le second conditional utilise le past simple après if et would dans la principale.'),
    _Unit('T3 • SVT','Écosystèmes et enjeux environnementaux','Les écosystèmes reposent sur des interactions entre organismes et milieu. Les cycles de matière et les flux d’énergie structurent leur fonctionnement. Les activités humaines modifient les habitats, les ressources et le climat.','La biodiversité inclut diversité des espèces, diversité génétique et diversité des écosystèmes.','Quelle action contribue à préserver les écosystèmes ?',['Restaurer les habitats dégradés','Polluer les cours d’eau','Surexploiter les espèces'],0,'La restauration des habitats aide les populations et les interactions écologiques.'),
    _Unit('T3 • Physique-Chimie','Ondes, signaux et bilan expérimental','Une onde transporte de l’énergie sans transport global de matière. La fréquence se mesure en hertz et la période en secondes. Un compte rendu rigoureux distingue observation, interprétation et conclusion.','La fréquence et la période sont liées par f=1/T.','Une onde a une période de 0,02 s. Sa fréquence vaut…',['20 Hz','50 Hz','200 Hz'],1,'f=1/0,02=50 Hz.'),
    _Unit('T3 • Histoire-Géographie','Développement durable et préparation aux examens','Le développement durable articule économie, société et environnement. Une composition exige une problématique, un plan, des exemples localisés et une conclusion. Les documents doivent être cités et confrontés avec les connaissances.','Une bonne copie répond précisément au sujet et justifie les affirmations.','Quelles dimensions associe le développement durable ?',['Économique, sociale, environnementale','Uniquement financière','Uniquement politique'],0,'Les trois dimensions doivent être prises en compte ensemble.'),
  ];
  static int get unitCount => _units.length;
  static int get lessonCount => _units.length;
  static List<_Unit> seriesUnitsFor(String series) => switch (series) {
    'A4' => [
      _Unit('T1 • Série A4 • Littérature comparée','Littérature comparée','Comparer deux œuvres exige de dégager un thème commun, des choix d’écriture et des contextes différents.','Deux romans peuvent traiter l’exil avec des points de vue narratifs opposés.','Quel élément fonde une comparaison littéraire ?',["Un critère commun précis","Le seul nombre de pages","La couleur de la couverture"],0,'Un critère commun permet de comparer sans juxtaposer.'),
      _Unit('T2 • Série A4 • Philosophie politique','Philosophie politique','La réflexion politique interroge justice, liberté, État et légitimité du pouvoir. Une thèse doit être discutée par des arguments et des objections.','Distinguer liberté individuelle et liberté politique clarifie un débat.','Quel est l’objectif d’une objection philosophique ?',["Éprouver les limites d’une thèse","Répéter la thèse","Éviter de raisonner"],0,'L’objection examine la solidité et les limites du raisonnement.'),
      _Unit('T3 • Série A4 • Histoire des idées','Histoire des idées','Les idées littéraires et politiques s’inscrivent dans des contextes historiques. Relier auteur, époque, destinataires et débats évite les contresens.','Un texte engagé répond souvent à une situation historique précise.','Que faut-il contextualiser pour interpréter un texte ?',["Auteur, époque et enjeux","Uniquement la longueur","La police utilisée"],0,'Le contexte éclaire les enjeux et la portée du texte.'),
    ],
    'C' => [
      _Unit('T1 • Série C • Analyse mathématique','Analyse mathématique','Étudier une fonction consiste à déterminer domaine, limites, dérivée, variations et interprétation graphique. Les résultats doivent être justifiés.','Le signe de f\' indique les intervalles de croissance ou de décroissance.','Que renseigne le signe de la dérivée ?',["Les variations de la fonction","La couleur de la courbe","Le nom de la fonction"],0,'Une dérivée positive indique une croissance sur l’intervalle.'),
      _Unit('T2 • Série C • Mécanique et énergie','Mécanique et énergie','Un système mécanique s’étudie avec bilan des forces, lois du mouvement et conservation ou transfert d’énergie. Les unités doivent être cohérentes.','L’énergie cinétique dépend de la masse et du carré de la vitesse.','Quelle expression donne l’énergie cinétique ?',["Ec=1/2 mv²","Ec=mv","Ec=m/v"],0,'L’énergie cinétique est égale à la moitié de mv².'),
      _Unit('T3 • Série C • Électricité et circuits','Électricité et circuits','Les circuits se résolvent par les lois d’Ohm et des nœuds/mailles. La puissance et l’énergie permettent d’analyser les dispositifs électriques.','Pour une résistance, U=RI.','Quelle relation exprime la loi d’Ohm ?',["U=RI","U=R/I","U=I/R"],0,'La tension est le produit de la résistance par l’intensité.'),
    ],
    'D' => [
      _Unit('T1 • Série D • Génétique et hérédité','Génétique et hérédité','L’information génétique est portée par l’ADN. Les allèles et leur expression contribuent aux caractères ; les croisements se raisonnent avec des probabilités.','Un tableau de croisement organise les gamètes et les génotypes possibles.','Quel support porte les gènes ?',["ADN","Lipides","Eau"],0,'Les gènes sont des séquences d’ADN.'),
      _Unit('T2 • Série D • Physiologie humaine','Physiologie humaine','Les fonctions de nutrition, respiration, circulation et régulation maintiennent le fonctionnement de l’organisme. Les organes agissent en systèmes coordonnés.','Le sang transporte notamment dioxygène, nutriments et déchets.','Quel système transporte le sang ?',["Système cardiovasculaire","Système osseux","Système tégumentaire"],0,'Le cœur et les vaisseaux assurent la circulation sanguine.'),
      _Unit('T3 • Série D • Écologie et évolution','Écologie et évolution','Les populations évoluent sous l’effet de mutations, sélection, dérive et migrations. Les écosystèmes dépendent des interactions entre espèces et milieu.','Une pression du milieu peut modifier la fréquence de certains caractères.','Quel mécanisme favorise les caractères avantageux dans un milieu ?',["Sélection naturelle","Digestion","Évaporation"],0,'La sélection naturelle modifie la fréquence des caractères selon leur effet sur la reproduction.'),
    ],
    'G1' => [
      _Unit('T1 • Série G1 • Communication professionnelle','Communication professionnelle','Une communication administrative identifie destinataire, objet, niveau de langue et action attendue. La lettre professionnelle est concise, polie et structurée.','Un courriel efficace comporte un objet explicite et une demande précise.','Quel élément facilite le traitement d’un courriel professionnel ?',["Un objet précis","Un message sans sujet","Des abréviations ambiguës"],0,'L’objet annonce immédiatement le but du message.'),
      _Unit('T2 • Série G1 • Organisation du secrétariat','Organisation du secrétariat','Le classement documentaire peut être alphabétique, chronologique, numérique ou thématique. Un plan de classement facilite recherche, traçabilité et confidentialité.','Un dossier client peut être indexé par identifiant et date.','Quel est le but principal d’un plan de classement ?',["Retrouver rapidement les documents","Multiplier les copies","Rendre les archives anonymes"],0,'Le classement facilite le repérage et la conservation.'),
      _Unit('T3 • Série G1 • Gestion de réunion','Gestion de réunion','Une réunion se prépare par un ordre du jour, des participants, une durée et des documents. Le compte rendu restitue décisions, responsables et échéances.','Une décision doit être associée à une personne responsable et à une date.','Que doit préciser un compte rendu exploitable ?',["Décisions et responsables","Uniquement les présences","Des opinions sans suite"],0,'Les décisions et leurs responsables permettent le suivi.'),
    ],
    'G2' => [
      _Unit('T1 • Série G2 • Comptabilité : écritures et pièces','Comptabilité : écritures et pièces','Toute opération doit être justifiée par une pièce et enregistrée selon le principe de la partie double. Chaque écriture comporte comptes débités et crédités.','L’achat de fournitures payé en banque augmente une charge et diminue la banque.','Quel principe équilibre une écriture comptable ?',["Partie double","Simple estimation","Absence de justificatif"],0,'Le total des débits égale le total des crédits.'),
      _Unit('T2 • Série G2 • Travaux d’inventaire','Travaux d’inventaire','L’inventaire vérifie les actifs et passifs à la clôture. Amortissements, dépréciations et régularisations permettent de présenter une image fidèle.','L’amortissement répartit le coût d’un bien sur sa durée d’utilisation.','Pourquoi amortir une immobilisation ?',["Répartir son coût sur sa durée d’utilisation","Augmenter artificiellement la trésorerie","Supprimer la facture"],0,'L’amortissement traduit la consommation des avantages économiques.'),
      _Unit('T3 • Série G2 • Analyse financière','Analyse financière','Les ratios de liquidité, d’endettement et de rentabilité éclairent la situation d’une entreprise. Ils se lisent dans le temps et par comparaison sectorielle.','Un ratio isolé doit être interprété avec les autres données financières.','Pourquoi comparer les ratios sur plusieurs périodes ?',["Repérer les évolutions","Changer les chiffres","Éviter l’analyse"],0,'L’évolution montre les tendances et les risques éventuels.'),
    ],
    'G3' => [
      _Unit('T1 • Série G3 • Étude de marché','Étude de marché','L’étude de marché identifie clients, besoins, concurrents, prix et canaux. Les données primaires sont recueillies directement ; les données secondaires existent déjà.','Un questionnaire doit être neutre et adapté à la population étudiée.','Quelle donnée est primaire ?',["Réponse à une enquête menée par l’entreprise","Statistique publiée antérieurement","Article ancien"],0,'Une enquête réalisée directement produit des données primaires.'),
      _Unit('T2 • Série G3 • Techniques de vente','Techniques de vente','La vente suit souvent accueil, découverte du besoin, argumentation, traitement des objections et conclusion. L’écoute active évite une proposition inadaptée.','Reformuler le besoin aide à vérifier sa compréhension.','À quoi sert la découverte du besoin ?',["Adapter la proposition au client","Imposer le produit","Éviter les questions"],0,'Comprendre le besoin permet une offre pertinente.'),
      _Unit('T3 • Série G3 • Gestion commerciale','Gestion commerciale','Le suivi commercial s’appuie sur devis, commandes, factures, stocks et satisfaction client. Un tableau de bord suit ventes, marges et délais.','Le chiffre d’affaires ne correspond pas au bénéfice.','Quelle différence essentielle faut-il retenir ?',["Le bénéfice tient compte des charges","Le chiffre d’affaires est toujours le bénéfice","Les deux sont toujours nuls"],0,'Le bénéfice est calculé après prise en compte des charges.'),
    ],
    'G4' => [
      _Unit('T1 • Série G4 • Électrotechnique : machines','Électrotechnique : machines','Les machines électriques convertissent l’énergie. Le moteur transforme l’énergie électrique en énergie mécanique ; le générateur réalise la conversion inverse.','La plaque signalétique donne des valeurs nominales à respecter.','Quel est le rôle d’un moteur électrique ?',["Convertir l’énergie électrique en mécanique","Stocker uniquement l’eau","Mesurer la pression"],0,'Un moteur produit un mouvement à partir d’une alimentation électrique.'),
      _Unit('T2 • Série G4 • Installations et protection','Installations et protection','Une installation doit être dimensionnée et protégée contre surintensités et défauts d’isolement. Les dispositifs de protection sont choisis selon les conducteurs et les usages.','Le disjoncteur coupe le circuit en cas de défaut dépassant son seuil.','Quel dispositif protège contre les surintensités ?',["Disjoncteur","Interrupteur décoratif","Lampe"],0,'Le disjoncteur ouvre le circuit en cas de surintensité.'),
      _Unit('T3 • Série G4 • Maintenance électrique','Maintenance électrique','La maintenance préventive planifie contrôles et remplacements ; la maintenance corrective intervient après panne. La consignation sécurise les interventions.','Avant intervention, isoler et vérifier l’absence de tension.','Quel geste précède une intervention électrique ?',["Mettre en sécurité et vérifier l’absence de tension","Toucher directement les conducteurs","Travailler sans diagnostic"],0,'La mise en sécurité est indispensable pour prévenir l’électrisation.'),
    ],
    'F1' => [
      _Unit('T1 • Série F1 • Dessin industriel','Dessin industriel','Le dessin industriel utilise vues, coupes, cotation et tolérances pour transmettre une définition sans ambiguïté. Les normes garantissent une lecture commune.','Une coupe révèle des formes intérieures invisibles sur une vue extérieure.','À quoi sert une vue en coupe ?',["Montrer les formes intérieures","Changer la matière","Mesurer la température"],0,'La coupe rend visibles les détails internes.'),
      _Unit('T2 • Série F1 • Mécanique des solides','Mécanique des solides','L’équilibre d’un solide exige une résultante des forces et un moment résultant nuls. Les liaisons mécaniques limitent certains mouvements.','Un appui simple bloque un déplacement dans une direction selon le modèle.','Quelle condition traduit l’équilibre en translation ?',["Somme vectorielle des forces nulle","Vitesse toujours infinie","Masse nulle"],0,'À l’équilibre statique, la résultante des forces est nulle.'),
      _Unit('T3 • Série F1 • Fabrication et tolérances','Fabrication et tolérances','L’usinage enlève de la matière pour obtenir une forme et des dimensions. Les tolérances définissent les écarts admissibles et les ajustements.','Une tolérance trop serrée augmente souvent le coût de fabrication.','Pourquoi spécifier une tolérance ?',["Garantir la fonction et l’assemblage","Décorer le plan","Éviter toute mesure"],0,'Les tolérances assurent l’interchangeabilité et le fonctionnement.'),
    ],
    'F2' => [
      _Unit('T1 • Série F2 • Électronique analogique','Électronique analogique','Les composants analogiques traitent des signaux continus. Diodes, transistors et amplificateurs se choisissent selon polarisation, gain et limites électriques.','Un transistor bipolaire peut fonctionner en commutation ou en amplification.','Quel composant peut amplifier un signal ?',["Transistor","Fusible seul","Interrupteur ouvert"],0,'Le transistor peut amplifier un signal en régime adapté.'),
      _Unit('T2 • Série F2 • Électronique numérique','Électronique numérique','Un système numérique manipule des niveaux logiques. Les portes ET, OU et NON réalisent des fonctions booléennes qui peuvent être combinées.','La sortie ET vaut 1 seulement si toutes les entrées valent 1.','Quand une porte ET à deux entrées donne-t-elle 1 ?',["Quand les deux entrées valent 1","Quand les deux valent 0","Toujours"],0,'La conjonction exige que chaque entrée soit vraie.'),
      _Unit('T3 • Série F2 • Mesures et diagnostic','Mesures et diagnostic','L’oscilloscope visualise l’évolution d’une tension ; le multimètre mesure notamment tension, courant et résistance. Le choix du calibre et du branchement est essentiel.','Un ampèremètre se branche en série dans le circuit.','Comment brancher un ampèremètre ?',["En série","En parallèle sur une source sans précaution","À la place du fusible"],0,'L’ampèremètre mesure le courant traversant la branche.'),
    ],
    'F3' => [
      _Unit('T1 • Série F3 • Réseaux électriques','Réseaux électriques','Un réseau distribue l’énergie entre source, transformateurs, lignes et récepteurs. Les pertes par effet Joule dépendent de la résistance et du courant.','Élever la tension permet de réduire le courant pour une puissance donnée.','Pourquoi transporter l’électricité à haute tension ?',["Réduire les pertes par effet Joule","Augmenter les pertes","Supprimer les conducteurs"],0,'À puissance égale, une tension élevée réduit le courant et les pertes.'),
      _Unit('T2 • Série F3 • Schémas et appareillage','Schémas et appareillage','Un schéma électrique représente symboliquement les composants et leurs liaisons. Le choix des protections dépend du courant, du câble et du régime de neutre.','Le schéma unifilaire simplifie la représentation d’une installation.','Que représente un schéma électrique ?',["Les connexions et composants par symboles","Le plan d’une ville uniquement","La couleur des murs"],0,'Les symboles décrivent la structure et les connexions du circuit.'),
      _Unit('T3 • Série F3 • Diagnostic de panne','Diagnostic de panne','Le diagnostic part d’un symptôme, formule des hypothèses, effectue des mesures et vérifie la réparation. Toute recherche de défaut respecte les règles de sécurité.','Une mesure comparative aide à localiser une coupure.','Quelle démarche est la plus fiable ?',["Mesurer étape par étape en sécurité","Remplacer tout au hasard","Court-circuiter les protections"],0,'Un diagnostic méthodique réduit les risques et les erreurs.'),
    ],
    'F4' => [
      _Unit('T1 • Série F4 • Matériaux et résistance','Matériaux et résistance','Les matériaux de construction sont choisis selon résistance mécanique, durabilité, disponibilité et coût. Les essais caractérisent compression, traction et flexion.','Le béton résiste bien à la compression mais moins à la traction sans armature.','Pourquoi armer le béton ?',["Améliorer sa résistance en traction","Le rendre transparent","Supprimer sa masse"],0,'Les armatures reprennent une partie des efforts de traction.'),
      _Unit('T2 • Série F4 • Lecture de plans et métrés','Lecture de plans et métrés','Un plan coté donne dimensions, niveaux et détails. Le métré quantifie les ouvrages à partir des unités adaptées : m, m², m³ ou unité.','Une dalle se quantifie généralement en volume ou en surface selon le travail demandé.','Quelle unité convient au volume de béton ?',["m³","m²","kg/m² uniquement"],0,'Le volume se mesure en mètres cubes.'),
      _Unit('T3 • Série F4 • Organisation de chantier','Organisation de chantier','Un chantier se prépare par phasage, approvisionnement, contrôle qualité et prévention des risques. Le planning coordonne les tâches et les ressources.','Le contrôle des fondations précède les étapes qui les recouvrent.','Pourquoi contrôler avant de poursuivre un ouvrage ?',["Détecter tôt les défauts","Cacher les erreurs","Supprimer le suivi"],0,'Un contrôle précoce évite de rendre les défauts difficiles à corriger.'),
    ],
    'Ti/1' => [
      _Unit('T1 • Série Ti/1 • Technologie et procédés industriels','Technologie et procédés industriels','Un procédé industriel transforme une matière première en produit selon une gamme opératoire. Il faut identifier opérations, paramètres, contrôles et risques.','Une gamme précise l’ordre des opérations et les moyens nécessaires.','Que décrit une gamme de fabrication ?',["Les étapes ordonnées de production","Le prix des repas","La météo"],0,'La gamme organise les opérations de fabrication.'),
      _Unit('T2 • Série Ti/1 • Automatisme et capteurs','Automatisme et capteurs','Un automatisme reçoit des informations de capteurs, traite une logique de commande puis agit sur des actionneurs. La chaîne d’information pilote la chaîne d’énergie.','Un capteur de fin de course détecte une position.','Quel est le rôle d’un capteur ?',["Acquérir une information physique","Fournir toujours la puissance motrice","Remplacer le programme"],0,'Le capteur transforme une grandeur physique en information exploitable.'),
      _Unit('T3 • Série Ti/1 • Qualité, sécurité et maintenance','Qualité, sécurité et maintenance','La qualité vérifie la conformité aux exigences. La maintenance préventive réduit les pannes et la sécurité identifie dangers, risques et mesures de prévention.','Une fiche de contrôle trace les résultats d’une vérification.','Pourquoi conserver une fiche de contrôle ?',["Assurer la traçabilité","Effacer les défauts","Éviter les procédures"],0,'La traçabilité permet de suivre les contrôles et les actions correctives.'),
    ],
    _ => const <_Unit>[],
  };
  static List<Exercise> assessmentExercisesForTerm(int term, {String? subjectName, SchoolTrack? track, String? series}) {
    final result = <Exercise>[];
    for (var i = 0; i < _units.length; i++) {
      final unit = _units[i];
      if (!unit.title.startsWith('T$term •')) continue;
      if (subjectName != null && !_matches(unit.title, subjectName)) continue;
      result.add(Exercise(id: 'prem_t${term}_u${i}', lessonId: 'prem_t${term}_u${i}', question: unit.question, options: unit.options, correctIndex: unit.answer, explanation: unit.explanation));
    }
    if (track != null && series != null) {
      final extra = seriesUnitsFor(series);
      for (var i = 0; i < extra.length; i++) {
        final unit = extra[i];
        if (!unit.title.startsWith('T$term •')) continue;
        if (subjectName != null && !_matches(unit.title, subjectName)) continue;
        final safeSeries = series.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_');
        result.add(Exercise(id: 'prem_${safeSeries}_t${term}_u${i}', lessonId: 'prem_${safeSeries}_t${term}_u${i}', question: unit.question, options: unit.options, correctIndex: unit.answer, explanation: unit.explanation));
      }
    }
    return result;
  }
  static bool _matches(String title, String subject) {
    final t = title.toLowerCase();
    final s = subject.toLowerCase();
    if (t.contains(s) || s.contains(t)) return true;
    if (s.contains('français') || s.contains('francais') || s.contains('littérature')) return t.contains('français') || t.contains('littérature');
    if (s.contains('math')) return t.contains('math');
    if (s.contains('anglais') || s.contains('english')) return t.contains('anglais');
    if (s.contains('svt') || s.contains('science') || s.contains('biologie')) return t.contains('svt') || t.contains('génétique') || t.contains('physiologie') || t.contains('écologie') || t.contains('biodiversité');
    if (s.contains('physique') || s.contains('chimie') || s.contains('électricité') || s.contains('electrotechnique')) return t.contains('physique') || t.contains('électricité') || t.contains('électrotechnique') || t.contains('mécanique') || t.contains('énergie');
    if (s.contains('histoire') || s.contains('géographie') || s.contains('education') || s.contains('éducation') || s.contains('emc')) return t.contains('histoire-géographie');
    if (s.contains('philosoph')) return t.contains('philosoph');
    if (s.contains('comptab') || s.contains('finance') || s.contains('gestion')) return t.contains('comptab') || t.contains('financ') || t.contains('gestion') || t.contains('coûts') || t.contains('fiscal');
    if (s.contains('commerce') || s.contains('marketing') || s.contains('vente')) return t.contains('marketing') || t.contains('vente') || t.contains('commercial') || t.contains('client');
    if (s.contains('secrétariat') || s.contains('secretariat') || s.contains('communication') || s.contains('administration')) return t.contains('secrétariat') || t.contains('communication') || t.contains('administratif') || t.contains('réunion');
    if (s.contains('mécanique') || s.contains('dessin industriel') || s.contains('fabrication')) return t.contains('mécanique') || t.contains('dessin industriel') || t.contains('fabrication') || t.contains('résistance des matériaux');
    if (s.contains('électronique') || s.contains('electronique')) return t.contains('électronique') || t.contains('logique') || t.contains('amplificateur');
    if (s.contains('génie civil') || s.contains('btp') || s.contains('construction') || s.contains('bâtiment')) return t.contains('construction') || t.contains('chantier') || t.contains('structure') || t.contains('topographie');
    if (s.contains('automatisme') || s.contains('technologie') || s.contains('industriel')) return t.contains('automatisme') || t.contains('technologie') || t.contains('maintenance') || t.contains('qualité');
    return false;
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Complément Première • Série $series')),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      Card(child: Padding(padding: const EdgeInsets.all(16), child: Text('Parcours : ${track.label} • Série $series\n${unitCount} unités communes • ${lessonCount} leçons • 3 trimestres\nLes enseignements spécifiques de la série restent accessibles dans la liste des matières.', style: const TextStyle(fontWeight: FontWeight.w600)))),
      for (final unit in _units) _UnitTile(unit: unit),
      if (seriesUnitsFor(series).isNotEmpty) const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('ENSEIGNEMENTS SPÉCIFIQUES DE LA SÉRIE • 3 LEÇONS', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5))),
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
