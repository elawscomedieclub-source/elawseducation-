import 'annual_core_english.dart' as english;
import 'annual_core_science.dart' as science;
import 'annual_core_math.dart' as math;
import 'annual_core_physics.dart' as physics;
import 'annual_core_history_civics.dart' as historyCivics;
import 'annual_core_secondary_math.dart' as secondaryMath;
import 'annual_core_secondary_french.dart' as secondaryFrench;
import 'annual_core_secondary_svt.dart' as secondarySvt;
import 'annual_core_secondary_svt_6e_extension.dart' as svt6eExtension;
import '../models/models.dart';
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
  // Les chapitres de 6e complètent les matières déjà affichées dans l’application.
  Subject(id:'math',name:'Mathématiques — programme annuel de 6e',iconName:'calculator',colorHex:'1976D2',level:SchoolLevel.sixieme,totalChapters:23),
  Subject(id:'fr',name:'Français — programme annuel de 6e',iconName:'book-open',colorHex:'8E24AA',level:SchoolLevel.sixieme,totalChapters:19),
  Subject(id:'anglais',name:'Anglais — programme annuel de 6e',iconName:'translate',colorHex:'00897B',level:SchoolLevel.sixieme,totalChapters:19),
  Subject(id:'svt',name:'SVT — programme annuel de 6e',iconName:'leaf',colorHex:'558B2F',level:SchoolLevel.sixieme,totalChapters:20),
  Subject(id:'hist',name:'Histoire-Géographie — programme annuel de 6e',iconName:'globe',colorHex:'0288D1',level:SchoolLevel.sixieme,totalChapters:10),
];
final annualCoreChapters = [
  ...english.annualEnglishChapters,
  ...science.annualScienceChapters,
  ...math.annualMathChapters,
  ...physics.annualPhysicsChapters,
  ...historyCivics.annualHistoryCivicsChapters,
  ...secondaryMath.annualSecondaryMathChapters.where((chapter) => chapter.id.startsWith('core_secondary_math_6e_unit_')),
  ...secondaryFrench.annualSecondaryFrenchChapters.where((chapter) => chapter.id.startsWith('core_secondary_french_6e_unit_')),
  ...secondarySvt.annualSecondarySvtChapters
      .where((chapter) => chapter.id.startsWith('core_secondary_svt_6e_unit_'))
      .map((chapter) => Chapter(
        id: chapter.id,
        subjectId: chapter.subjectId,
        title: chapter.title,
        order: chapter.order,
        term: termForAnnualUnit(chapter.order, 13),
        totalLessons: chapter.totalLessons,
        completedLessons: chapter.completedLessons,
        isCompleted: chapter.isCompleted,
      )),
  ...svt6eExtension.annualSecondarySvt6eExtensionChapters,
  ...secondaryEnglish.annualSecondaryEnglishChapters.where((chapter) => chapter.id.startsWith('core_secondary_english_6e_unit_')),
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
  ...svt6eExtension.annualSecondarySvt6eExtensionLessons,
  ...secondaryEnglish.annualSecondaryEnglishLessons,
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
  ...svt6eExtension.annualSecondarySvt6eExtensionExercises,
  ...secondaryEnglish.annualSecondaryEnglishExercises,
  ...lyceeHistoryCivics.annualLyceeHistoryCivicsExercises,
  ...secondePhysics.annualSecondePhysicsExercises,
  ...secondePhysics.annualSecondeCdPhysicsExercises,
  ...secondeSvt.annualSecondeSvtExercises,
  ...secondeMath.annualSecondeMathExercises,
];
