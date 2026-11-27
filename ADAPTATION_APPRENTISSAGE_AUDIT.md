# ProfTogo — audit du coach d’apprentissage adaptatif

**Mise à jour : 27 novembre 2026**

Ce document décrit le comportement réellement présent dans le code et les améliorations à poursuivre. Il ne transforme pas une fonctionnalité prévue en fonctionnalité déjà disponible.

## Fonctionnalités actuellement présentes dans le dépôt

Le service `LearnerAdaptationService` (`lib/core/learner_adaptation_service.dart`) formule un conseil à partir de tentatives d’exercices récentes et des difficultés que l’élève a volontairement signalées.

- Fenêtre d’analyse : 30 jours.
- Historique utilisé pour le conseil : au plus 20 tentatives récentes.
- Une leçon peut être recommandée à revoir après plusieurs erreurs récentes sur cette même leçon.
- Une série de réussites peut conduire à proposer un exercice plus difficile.
- Un taux de réussite récent élevé peut déclencher un conseil de consolidation et de révision espacée.
- Les difficultés déclarées sont limitées à trois catégories : lecture, compréhension et méthode.
- Les tentatives et les caches de progression sont séparés par compte Firebase ou par profil invité.
- L’historique local est limité à 200 tentatives ; les conseils ne reposent pas sur une ancienne difficulté ignorée depuis longtemps.

Les tests de `test/learner_adaptation_service_test.dart` vérifient notamment l’ordre chronologique, l’exclusion des tentatives trop anciennes, la reprise après une période d’inactivité, les erreurs répétées et les trois aides déclarées.

## Principes à préserver

1. **Ne pas juger l’élève.** Les réponses sont des signaux pédagogiques, pas une mesure de son intelligence, de sa personnalité ou de son potentiel.
2. **Ne pas diagnostiquer.** Une difficulté de lecture ou de compréhension déclarée ne doit jamais être présentée comme un trouble médical ou psychologique.
3. **Expliquer le conseil.** L’application doit indiquer la raison pédagogique : erreurs répétées, réussite régulière, besoin de revoir une notion ou reprise après pause.
4. **Laisser l’élève garder le contrôle.** Il doit pouvoir ignorer une suggestion, choisir une autre matière ou demander une leçon plus facile.
5. **Protéger les données.** Ne pas mélanger l’historique de deux comptes, ni le compte connecté et le mode invité. Ne collecter que les informations nécessaires à l’apprentissage.
6. **Éviter les conclusions sur un seul exercice.** Une réponse erronée isolée ne suffit pas pour conclure qu’une notion n’est pas maîtrisée.
7. **Ne pas récompenser uniquement la vitesse.** La progression doit valoriser la compréhension, les démarches, la correction des erreurs et la régularité.

## Améliorations à réaliser par étapes

### Étape A — Diagnostic pédagogique explicite
- Distinguer les erreurs de calcul, de lecture de consigne, de vocabulaire, de raisonnement et de méthode lorsque les exercices possèdent des étiquettes fiables.
- Afficher les compétences à revoir avec des exemples d’erreurs anonymisés et une explication accessible.
- Si une compétence n’est pas étiquetée, utiliser la leçon comme regroupement provisoire et le signaler comme tel.

### Étape B — Parcours de remédiation
- Pour chaque notion fragile : mini-rappel, exemple résolu, exercice guidé, puis exercice autonome.
- Réduire la difficulté après des erreurs répétées ; la réaugmenter progressivement après des réussites confirmées.
- Reposer plus tard une question de révision, plutôt que répéter immédiatement la même question.
- Prévoir une voie de reprise sans pénalité ni honte après une longue pause.

### Étape C — Vérification de la maîtrise
- Définir la maîtrise à partir de plusieurs exercices distincts et de compétences identifiées, pas d’un simple pourcentage global.
- Distinguer « en cours d’apprentissage », « à revoir » et « acquis récemment ».
- Ne pas annoncer qu’un chapitre est maîtrisé si les exercices disponibles ne couvrent qu’une partie de ses objectifs.

### Étape D — Adaptation par niveau
- Adapter le vocabulaire, la longueur des consignes et les étapes d’aide au niveau CP1–Terminale.
- Pour le primaire, privilégier consignes courtes, lecture audio quand elle est disponible, exemples concrets et progression pas à pas.
- Pour le collège et le lycée, proposer davantage de raisonnement, de justification et de transfert, en respectant la série et le programme réellement suivi.

## Contrôles de qualité avant de déclarer une étape terminée

- Les tests unitaires passent.
- L’historique est correctement isolé par UID et mode invité.
- Les dates futures et les tentatives hors fenêtre ne faussent pas les conseils.
- Les suggestions sont compréhensibles, non culpabilisantes et peuvent être ignorées.
- Les exercices ciblés existent réellement et ont des corrigés validés.
- Les conseils ne prétendent pas connaître des informations que l’élève n’a pas fournies.
- Les tests manuels sont effectués sur Android, y compris après déconnexion, reconnexion et changement de compte.

## État de validation

Le coach de base et ses tests sont présents dans le dépôt. Les étapes A à D ci-dessus constituent un plan d’amélioration, pas une déclaration que toutes les adaptations avancées sont déjà implémentées. L’efficacité pédagogique réelle doit être vérifiée avec des enseignants et des élèves, sans exposer inutilement leurs données personnelles.
