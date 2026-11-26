import 'annual_core_english.dart' as english;
import 'annual_core_science.dart' as science;
import 'annual_core_math.dart' as math;
import 'annual_core_physics.dart' as physics;

/// Matières du programme principal ajoutées à la banque de cours, séparées
/// des leçons bonus et regroupées pour les écrans communs de ProfTogo.
final annualCoreSubjects = [
  ...english.annualEnglishSubjects,
  ...science.annualScienceSubjects,
  ...math.annualMathSubjects,
  ...physics.annualPhysicsSubjects,
];
final annualCoreChapters = [
  ...english.annualEnglishChapters,
  ...science.annualScienceChapters,
  ...math.annualMathChapters,
  ...physics.annualPhysicsChapters,
];
final annualCoreLessons = [
  ...english.annualEnglishLessons,
  ...science.annualScienceLessons,
  ...math.annualMathLessons,
  ...physics.annualPhysicsLessons,
];
final annualCoreExercises = [
  ...english.annualEnglishExercises,
  ...science.annualScienceExercises,
  ...math.annualMathExercises,
  ...physics.annualPhysicsExercises,
];
