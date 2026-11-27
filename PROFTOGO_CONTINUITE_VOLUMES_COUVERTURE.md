# ProfTogo — Contrôle de continuité, volumes et priorités

Date : 27 novembre 2026  
Statut : document de pilotage interne ; les chiffres sont ceux déclarés dans la documentation du dépôt et doivent être recalculés depuis les données réelles pour une certification technique.

## 1. Référence de volume à préserver

La documentation du projet indique actuellement :

| Banque | Matières | Chapitres | Leçons | Exercices / questions |
|---|---:|---:|---:|---:|
| Banque principale | 165 | 280 | 793 | 2 328 |
| Banque bonus | — | — | 313 | 1 000 |
| **Total documenté** | **165** | **280** | **1 106** | **3 328** |

Ces valeurs constituent un repère de continuité documentaire. Elles ne doivent pas être présentées comme un comptage vérifié automatiquement tant qu'un rapport n'a pas extrait les données de la banque et éliminé les doublons.

## 2. Règles anti-régression

À chaque évolution du contenu ou du modèle :

1. Créer une sauvegarde ou conserver un commit de référence.
2. Recalculer les nombres depuis les fichiers de données réels.
3. Comparer les totaux avant/après, niveau par niveau et banque par banque.
4. En cas de diminution, afficher la liste des identifiants supprimés ou modifiés et la raison.
5. Ne jamais compenser une suppression par des doublons artificiels.
6. Ne compter une nouvelle leçon ou question qu'après son ajout réel et son identifiant unique.
7. Conserver un historique de correction des items retirés ou remplacés.

## 3. Rapport de couverture attendu

Le rapport de couverture doit séparer les dimensions suivantes :

- niveau : CP1 à Terminale ;
- trimestre : T1, T2, T3 ;
- matière ;
- chapitre et leçon ;
- compétence attendue ;
- type d'exercice : rappel, application, raisonnement, transfert ;
- parcours ou série, lorsque cela s'applique ;
- statut de source : source identifiée, source officielle vérifiée, à valider ;
- statut pédagogique : brouillon, contrôle automatique, relu par enseignant, à réviser.

Une ligne « matière présente » ne suffit pas à déclarer la matière complète. La couverture doit être évaluée par compétence et par période.

## 4. Ordre des prochaines vérifications

### Priorité 1 — Intégrité technique
- Vérifier que les 13 niveaux sont présents.
- Vérifier les identifiants uniques des leçons et questions.
- Vérifier que chaque question possède un énoncé et une réponse attendue.
- Vérifier les corrections et explications.
- Vérifier que les contenus bonus sont inclus dans la progression sans être comptés deux fois.

### Priorité 2 — Progression annuelle
- Contrôler les leçons affectées à T1/T2/T3.
- Comparer les répartitions aux progressions officielles disponibles.
- Repérer les leçons sans trimestre ou les matières surchargées.
- Faire confirmer les écarts par des enseignants togolais.

### Priorité 3 — Parcours du lycée
- Contrôler séparément les séries générales A4, C et D.
- Contrôler séparément les filières techniques et professionnelles.
- Ne pas afficher une série comme complète si une matière ou un trimestre reste à vérifier.

### Priorité 4 — Qualité pédagogique
- Contrôler les réponses et les barèmes.
- Identifier les doublons exacts et quasi-doublons.
- Vérifier la progression de difficulté.
- Relier les erreurs fréquentes à une remédiation précise.

## 5. Transparence dans l'application

L'interface doit distinguer :
- « Ressources disponibles » : contenu présent dans la banque ;
- « Couverture vérifiée » : compétences comparées à une progression de référence ;
- « Relu par enseignant » : revue humaine documentée ;
- « Programme officiel / homologué » : uniquement si la source et la validation institutionnelle sont établies.

Ne pas confondre volume, couverture, qualité et homologation.

## 6. Décision de continuité

Les contenus existants restent la base. Toute amélioration doit compléter, corriger ou organiser cette base sans effacer les fonctions déjà en place. Les prochaines modifications de code doivent s'accompagner d'un rapport avant/après et de tests ciblés, puis d'une compilation Android et Web réussie avant d'annoncer la publication.
