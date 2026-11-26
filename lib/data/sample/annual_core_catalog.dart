import 'annual_core_english.dart' as english;
import 'annual_core_science.dart' as science;

/// Matières du programme principal ajoutées à la banque de cours, séparées
/// des leçons bonus et regroupées pour les écrans communs de ProfTogo.
final annualCoreSubjects = [
  ...english.annualEnglishSubjects,
  ...science.annualScienceSubjects,
];
final annualCoreChapters = [
  ...english.annualEnglishChapters,
  ...science.annualScienceChapters,
];
final annualCoreLessons = [
  ...english.annualEnglishLessons,
  ...science.annualScienceLessons,
];
final annualCoreExercises = [
  ...english.annualEnglishExercises,
  ...science.annualScienceExercises,
];
