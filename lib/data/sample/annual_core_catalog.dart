import 'annual_core_english.dart' as english;
import 'annual_core_science.dart' as science;
import 'annual_core_math.dart' as math;
import 'annual_core_physics.dart' as physics;
import 'annual_core_history_civics.dart' as historyCivics;
import 'annual_core_secondary_math.dart' as secondaryMath;
import 'annual_core_secondary_french.dart' as secondaryFrench;
import 'annual_core_secondary_svt.dart' as secondarySvt;
import 'annual_core_lycee_history_civics.dart' as lyceeHistoryCivics;
import 'annual_core_seconde_physics.dart' as secondePhysics;
import 'annual_core_seconde_svt.dart' as secondeSvt;
import 'annual_core_secondary_english.dart' as secondaryEnglish;
import 'annual_core_seconde_math.dart' as secondeMath;

/// Matières du programme principal ajoutées à la banque de cours, séparées
/// des leçons bonus et regroupées pour les écrans communs de ProfTogo.
final annualCoreSubjects = [
  ...english.annualEnglishSubjects,
  ...science.annualScienceSubjects,
  ...math.annualMathSubjects,
  ...physics.annualPhysicsSubjects,
  ...historyCivics.annualHistoryCivicsSubjects,
  ...lyceeHistoryCivics.annualLyceeHistoryCivicsSubjects,
  secondePhysics.annualSecondePhysicsSubject,
  secondePhysics.annualSecondeCdPhysicsSubject,
  secondeSvt.annualSecondeA4SvtSubject,
  secondeSvt.annualSecondeCdSvtSubject,
  secondeMath.annualSecondeMathSubject,
];
final annualCoreChapters = [
  ...english.annualEnglishChapters,
  ...science.annualScienceChapters,
  ...math.annualMathChapters,
  ...physics.annualPhysicsChapters,
  ...historyCivics.annualHistoryCivicsChapters,
  ...secondaryMath.annualSecondaryMathChapters,
  ...secondaryFrench.annualSecondaryFrenchChapters,
  ...secondarySvt.annualSecondarySvtChapters,
  ...lyceeHistoryCivics.annualLyceeHistoryCivicsChapters,
  ...secondePhysics.annualSecondePhysicsChapters,
  ...secondePhysics.annualSecondeCdPhysicsChapters,
  ...secondeSvt.annualSecondeSvtChapters,
  ...secondeMath.annualSecondeMathChapters,
];
final annualCoreLessons = [
  ...english.annualEnglishLessons,
  ...science.annualScienceLessons,
  ...math.annualMathLessons,
  ...physics.annualPhysicsLessons,
  ...historyCivics.annualHistoryCivicsLessons,
  ...secondaryMath.annualSecondaryMathLessons,
  ...secondaryFrench.annualSecondaryFrenchLessons,
  ...secondarySvt.annualSecondarySvtLessons,
  ...lyceeHistoryCivics.annualLyceeHistoryCivicsLessons,
  ...secondePhysics.annualSecondePhysicsLessons,
  ...secondePhysics.annualSecondeCdPhysicsLessons,
  ...secondeSvt.annualSecondeSvtLessons,
  ...secondeMath.annualSecondeMathLessons,
];
final annualCoreExercises = [
  ...english.annualEnglishExercises,
  ...science.annualScienceExercises,
  ...math.annualMathExercises,
  ...physics.annualPhysicsExercises,
  ...historyCivics.annualHistoryCivicsExercises,
  ...secondaryMath.annualSecondaryMathExercises,
  ...secondaryFrench.annualSecondaryFrenchExercises,
  ...secondarySvt.annualSecondarySvtExercises,
  ...lyceeHistoryCivics.annualLyceeHistoryCivicsExercises,
  ...secondePhysics.annualSecondePhysicsExercises,
  ...secondePhysics.annualSecondeCdPhysicsExercises,
  ...secondeSvt.annualSecondeSvtExercises,
  ...secondeMath.annualSecondeMathExercises,
];
