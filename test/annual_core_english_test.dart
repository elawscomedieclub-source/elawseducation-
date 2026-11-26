import 'package:flutter_test/flutter_test.dart';
import 'package:proftogo/data/models/models.dart';
import 'package:proftogo/data/sample/annual_core_english.dart';
import 'package:proftogo/data/sample/annual_core_science.dart';
import 'package:proftogo/data/sample/annual_core_catalog.dart';
import 'package:proftogo/data/sample/annual_core_math.dart';
import 'package:proftogo/data/sample/annual_core_physics.dart';
import 'package:proftogo/data/sample/annual_core_history_civics.dart';
import 'package:proftogo/data/sample/annual_core_secondary_math.dart';
import 'package:proftogo/data/sample/annual_core_secondary_french.dart';
import 'package:proftogo/data/sample/annual_core_secondary_svt.dart';
import 'package:proftogo/data/sample/annual_core_lycee_history_civics.dart';
import 'package:proftogo/data/sample/annual_core_seconde_physics.dart';
import 'package:proftogo/data/sample/annual_core_secondary_english.dart';
import 'package:proftogo/data/sample/annual_core_seconde_svt.dart';
import 'package:proftogo/data/sample/annual_core_seconde_math.dart';
import 'package:proftogo/data/sample/sample_data.dart';

void main() {
  test('primary English course covers CP1 through CM2 as core lessons', () {
    expect(annualEnglishSubjects.map((s) => s.level).toSet(), {
      SchoolLevel.cp1, SchoolLevel.cp2, SchoolLevel.ce1,
      SchoolLevel.ce2, SchoolLevel.cm1, SchoolLevel.cm2,
    });
    expect(annualEnglishUnits, hasLength(18));
    expect(annualEnglishLessons, hasLength(18));
    expect(annualEnglishChapters, hasLength(18));
    expect(annualEnglishExercises, hasLength(54));
  });

  test('core English units have unique IDs and complete questions', () {
    expect(annualEnglishLessons.map((l) => l.id).toSet(), hasLength(18));
    expect(annualEnglishExercises.map((e) => e.id).toSet(), hasLength(54));
    for (final lesson in annualEnglishLessons) {
      expect(lesson.title.trim(), isNotEmpty);
      expect(lesson.content.trim(), isNotEmpty);
      expect(lesson.summary.trim(), isNotEmpty);
      final questions = annualEnglishExercises.where((e) => e.lessonId == lesson.id);
      expect(questions, hasLength(3));
      for (final question in questions) {
        expect(question.options.length, greaterThanOrEqualTo(3));
        expect(question.correctIndex, inInclusiveRange(0, question.options.length - 1));
        expect(question.explanation.trim(), isNotEmpty);
      }
    }
  });
  test('primary science and technology lessons are part of the core catalog', () {
    expect(annualScienceUnits, hasLength(12));
    expect(annualScienceLessons, hasLength(12));
    expect(annualScienceExercises, hasLength(36));
    expect(annualCoreSubjects, hasLength(38));
    expect(annualCoreLessons, hasLength(162));
    expect(annualCoreExercises, hasLength(486));
    expect(annualCoreLessons.map((l) => l.id).toSet(), hasLength(162));
    expect(annualCoreExercises.map((e) => e.id).toSet(), hasLength(486));
  });

  test('Seconde C and D physics and chemistry are included as core lessons', () {
    expect(annualSecondeCdPhysicsUnits, hasLength(8));
    expect(annualSecondeCdPhysicsChapters, hasLength(8));
    expect(annualSecondeCdPhysicsLessons, hasLength(8));
    expect(annualSecondeCdPhysicsExercises, hasLength(24));
    expect(annualSecondeCdPhysicsLessons.map((l) => l.id).toSet(), hasLength(8));
    expect(annualSecondeCdPhysicsExercises.map((e) => e.id).toSet(), hasLength(24));
    for (final unit in annualSecondeCdPhysicsUnits) {
      expect(unit.content.trim(), isNotEmpty);
      expect(unit.exercises, hasLength(3));
      for (final question in unit.exercises) {
        expect(question.options.length, greaterThanOrEqualTo(3));
        expect(question.correctIndex, inInclusiveRange(0, question.options.length - 1));
        expect(question.explanation.trim(), isNotEmpty);
      }
    }
  });

  test('primary mathematics units have complete exercises', () {
    expect(annualMathUnits, hasLength(18));
    expect(annualMathLessons, hasLength(18));
    expect(annualMathExercises, hasLength(54));
    for (final lesson in annualMathLessons) {
      expect(lesson.content.trim(), isNotEmpty);
      final questions = annualMathExercises.where((e) => e.lessonId == lesson.id);
      expect(questions, hasLength(3));
      for (final question in questions) {
        expect(question.options.length, greaterThanOrEqualTo(3));
        expect(question.correctIndex, inInclusiveRange(0, question.options.length - 1));
        expect(question.explanation.trim(), isNotEmpty);
      }
    }
  });

  test('Seconde mathematics adds geometry, variation, algorithms and trigonometry', () {
    expect(annualSecondeMathUnits, hasLength(11));
    expect(annualSecondeMathLessons, hasLength(11));
    expect(annualSecondeMathChapters, hasLength(11));
    expect(annualSecondeMathExercises, hasLength(33));
    expect(annualSecondeMathLessons.map((l) => l.id).toSet(), hasLength(11));
    expect(annualSecondeMathExercises.map((e) => e.id).toSet(), hasLength(33));
    for (final unit in annualSecondeMathUnits) {
      expect(unit.content.trim(), isNotEmpty);
      expect(unit.exercises, hasLength(3));
      for (final question in unit.exercises) {
        expect(question.options.length, greaterThanOrEqualTo(3));
        expect(question.correctIndex, inInclusiveRange(0, question.options.length - 1));
        expect(question.explanation.trim(), isNotEmpty);
      }
    }
  });

  test('secondary physics and chemistry courses are regular lessons', () {
    expect(annualPhysicsUnits, hasLength(12));
    expect(annualPhysicsLessons, hasLength(12));
    expect(annualPhysicsExercises, hasLength(36));
    expect(annualPhysicsSubjects.map((s) => s.level).toSet(), {
      SchoolLevel.sixieme, SchoolLevel.cinquieme, SchoolLevel.quatrieme,
    });
    for (final lesson in annualPhysicsLessons) {
      expect(lesson.content.trim(), isNotEmpty);
      final questions = annualPhysicsExercises.where((e) => e.lessonId == lesson.id);
      expect(questions, hasLength(3));
      for (final question in questions) {
        expect(question.options.length, greaterThanOrEqualTo(3));
        expect(question.correctIndex, inInclusiveRange(0, question.options.length - 1));
        expect(question.explanation.trim(), isNotEmpty);
      }
    }
  });

  test('history, geography and civics are standard middle-school courses', () {
    expect(annualHistoryCivicsUnits, hasLength(12));
    expect(annualHistoryCivicsLessons, hasLength(12));
    expect(annualHistoryCivicsExercises, hasLength(36));
    expect(annualHistoryCivicsSubjects, hasLength(6));
    expect(annualHistoryCivicsLessons.map((l) => l.id).toSet(), hasLength(12));
    expect(annualHistoryCivicsExercises.map((e) => e.id).toSet(), hasLength(36));
    for (final unit in annualHistoryCivicsUnits) {
      expect(unit.content.trim(), isNotEmpty);
      expect(unit.exercises, hasLength(3));
      for (final question in unit.exercises) {
        expect(question.options.length, greaterThanOrEqualTo(3));
        expect(question.correctIndex, inInclusiveRange(0, question.options.length - 1));
        expect(question.explanation.trim(), isNotEmpty);
      }
    }
  });

  test('middle-school mathematics lessons cover fractions, geometry and functions', () {
    expect(annualSecondaryMathUnits, hasLength(10));
    expect(annualSecondaryMathLessons, hasLength(10));
    expect(annualSecondaryMathExercises, hasLength(30));
    expect(annualSecondaryMathLessons.map((l) => l.id).toSet(), hasLength(10));
    expect(annualSecondaryMathExercises.map((e) => e.id).toSet(), hasLength(30));
    for (final unit in annualSecondaryMathUnits) {
      expect(unit.content.trim(), isNotEmpty);
      expect(unit.exercises, hasLength(3));
      for (final question in unit.exercises) {
        expect(question.options.length, greaterThanOrEqualTo(3));
        expect(question.correctIndex, inInclusiveRange(0, question.options.length - 1));
        expect(question.explanation.trim(), isNotEmpty);
      }
    }
  });

  test('middle-school French lessons include grammar, reading and writing', () {
    expect(annualSecondaryFrenchUnits, hasLength(10));
    expect(annualSecondaryFrenchLessons, hasLength(10));
    expect(annualSecondaryFrenchExercises, hasLength(30));
    expect(annualSecondaryFrenchLessons.map((l) => l.id).toSet(), hasLength(10));
    expect(annualSecondaryFrenchExercises.map((e) => e.id).toSet(), hasLength(30));
    for (final unit in annualSecondaryFrenchUnits) {
      expect(unit.content.trim(), isNotEmpty);
      expect(unit.exercises, hasLength(3));
      for (final question in unit.exercises) {
        expect(question.options.length, greaterThanOrEqualTo(3));
        expect(question.correctIndex, inInclusiveRange(0, question.options.length - 1));
        expect(question.explanation.trim(), isNotEmpty);
      }
    }
  });

  test('middle-school SVT lessons cover environment, geology and health', () {
    expect(annualSecondarySvtUnits, hasLength(11));
    expect(annualSecondarySvtLessons, hasLength(11));
    expect(annualSecondarySvtExercises, hasLength(33));
    expect(annualSecondarySvtLessons.map((l) => l.id).toSet(), hasLength(11));
    expect(annualSecondarySvtExercises.map((e) => e.id).toSet(), hasLength(33));
    for (final unit in annualSecondarySvtUnits) {
      expect(unit.content.trim(), isNotEmpty);
      expect(unit.exercises, hasLength(3));
      for (final question in unit.exercises) {
        expect(question.options.length, greaterThanOrEqualTo(3));
        expect(question.correctIndex, inInclusiveRange(0, question.options.length - 1));
        expect(question.explanation.trim(), isNotEmpty);
      }
    }
  });

  test('high-school history and civics units are complete and core', () {
    expect(annualLyceeHistoryCivicsUnits, hasLength(12));
    expect(annualLyceeHistoryCivicsLessons, hasLength(12));
    expect(annualLyceeHistoryCivicsExercises, hasLength(36));
    expect(annualLyceeHistoryCivicsSubjects, hasLength(6));
    expect(annualLyceeHistoryCivicsLessons.map((l) => l.id).toSet(), hasLength(12));
    expect(annualLyceeHistoryCivicsExercises.map((e) => e.id).toSet(), hasLength(36));
    for (final unit in annualLyceeHistoryCivicsUnits) {
      expect(unit.content.trim(), isNotEmpty);
      expect(unit.exercises, hasLength(3));
      for (final question in unit.exercises) {
        expect(question.options.length, greaterThanOrEqualTo(3));
        expect(question.correctIndex, inInclusiveRange(0, question.options.length - 1));
        expect(question.explanation.trim(), isNotEmpty);
      }
    }
  });

  test('seconde physics and chemistry course covers the annual foundations', () {
    expect(annualSecondePhysicsUnits, hasLength(8));
    expect(annualSecondePhysicsLessons, hasLength(8));
    expect(annualSecondePhysicsExercises, hasLength(24));
    expect(annualSecondeCdPhysicsUnits, hasLength(8));
    expect(annualSecondeCdPhysicsLessons, hasLength(8));
    expect(annualSecondeCdPhysicsExercises, hasLength(24));
    expect(annualSecondePhysicsSubject.totalChapters, 8);
    expect(annualSecondeCdPhysicsSubject.totalChapters, 8);
    expect(annualSecondePhysicsSubject.track, SchoolTrack.generalLiterary);
    expect(annualSecondePhysicsSubject.series, 'A4');
    expect(annualSecondeCdPhysicsSubject.track, SchoolTrack.scientific);
    expect(subjectMatchesPath(annualSecondePhysicsSubject, SchoolLevel.seconde, SchoolTrack.generalLiterary, 'A4'), isTrue);
    expect(subjectMatchesPath(annualSecondePhysicsSubject, SchoolLevel.seconde, SchoolTrack.scientific, 'C'), isFalse);
    expect(subjectMatchesPath(annualSecondeCdPhysicsSubject, SchoolLevel.seconde, SchoolTrack.scientific, 'D'), isTrue);
    expect(subjectMatchesPath(annualSecondeCdPhysicsSubject, SchoolLevel.seconde, SchoolTrack.generalLiterary, 'A4'), isFalse);
    expect(annualSecondePhysicsLessons.map((l) => l.id).toSet(), hasLength(8));
    expect(annualSecondePhysicsExercises.map((e) => e.id).toSet(), hasLength(24));
    expect(annualSecondeCdPhysicsLessons.map((l) => l.id).toSet(), hasLength(8));
    expect(annualSecondeCdPhysicsExercises.map((e) => e.id).toSet(), hasLength(24));
    for (final unit in annualSecondePhysicsUnits) {
      expect(unit.content.trim(), isNotEmpty);
      expect(unit.exercises, hasLength(3));
      for (final question in unit.exercises) {
        expect(question.options.length, greaterThanOrEqualTo(3));
        expect(question.correctIndex, inInclusiveRange(0, question.options.length - 1));
        expect(question.explanation.trim(), isNotEmpty);
      }
    }

    for (final unit in annualSecondeCdPhysicsUnits) {
      expect(unit.content.trim(), isNotEmpty);
      expect(unit.exercises, hasLength(3));
      for (final question in unit.exercises) {
        expect(question.options.length, greaterThanOrEqualTo(3));
        expect(question.correctIndex, inInclusiveRange(0, question.options.length - 1));
        expect(question.explanation.trim(), isNotEmpty);
      }
    }
  });

  test('Seconde SVT lessons are filtered by A4 versus C/D series', () {
    expect(annualSecondeSvtUnits, hasLength(16));
    expect(annualSecondeSvtLessons, hasLength(16));
    expect(annualSecondeSvtExercises, hasLength(48));
    expect(annualSecondeCdSvtSubject.totalChapters, 6);
    expect(annualSecondeCdSvtSubject.track, SchoolTrack.scientific);
    final a4Subject = demoSubjects.firstWhere((s) => s.id == 'seconde_svt');
    expect(a4Subject.track, SchoolTrack.generalLiterary);
    expect(a4Subject.series, 'A4');
    expect(subjectMatchesPath(a4Subject, SchoolLevel.seconde, SchoolTrack.generalLiterary, 'A4'), isTrue);
    expect(subjectMatchesPath(a4Subject, SchoolLevel.seconde, SchoolTrack.scientific, 'C'), isFalse);
    expect(subjectMatchesPath(annualSecondeCdSvtSubject, SchoolLevel.seconde, SchoolTrack.scientific, 'D'), isTrue);
    expect(subjectMatchesPath(annualSecondeCdSvtSubject, SchoolLevel.seconde, SchoolTrack.generalLiterary, 'A4'), isFalse);
    expect(annualSecondeSvtLessons.map((l) => l.id).toSet(), hasLength(16));
    expect(annualSecondeSvtExercises.map((e) => e.id).toSet(), hasLength(48));
    for (final unit in annualSecondeSvtUnits) {
      expect(unit.content.trim(), isNotEmpty);
      expect(unit.exercises, hasLength(3));
      for (final question in unit.exercises) {
        expect(question.options.length, greaterThanOrEqualTo(3));
        expect(question.correctIndex, inInclusiveRange(0, question.options.length - 1));
        expect(question.explanation.trim(), isNotEmpty);
      }
    }
  });

  test('middle-school English lessons have complete grammar and communication practice', () {
    expect(annualSecondaryEnglishUnits, hasLength(10));
    expect(annualSecondaryEnglishLessons, hasLength(10));
    expect(annualSecondaryEnglishExercises, hasLength(30));
    expect(annualSecondaryEnglishLessons.map((l) => l.id).toSet(), hasLength(10));
    expect(annualSecondaryEnglishExercises.map((e) => e.id).toSet(), hasLength(30));
    for (final unit in annualSecondaryEnglishUnits) {
      expect(unit.content.trim(), isNotEmpty);
      expect(unit.exercises, hasLength(3));
      for (final question in unit.exercises) {
        expect(question.options.length, greaterThanOrEqualTo(3));
        expect(question.correctIndex, inInclusiveRange(0, question.options.length - 1));
        expect(question.explanation.trim(), isNotEmpty);
      }
    }
  });

  test('5e core units complete the seven-chapter subject plans and are reachable', () {
    final subjectIds = demoSubjects
        .where((subject) => subject.level == SchoolLevel.cinquieme)
        .map((subject) => subject.id)
        .toSet();
    expect(subjectIds, containsAll(['cinq_math', 'cinq_fr', 'cinq_ang', 'cinq_svt']));
    final fiveCoreChapters = annualCoreChapters
        .where((chapter) => chapter.id.startsWith('core_secondary_') &&
            ['cinq_math', 'cinq_fr', 'cinq_ang', 'cinq_svt'].contains(chapter.subjectId))
        .toList();
    expect(fiveCoreChapters, hasLength(24));
    expect(fiveCoreChapters.map((chapter) => chapter.id).toSet(), hasLength(24));
    for (final id in ['cinq_math', 'cinq_fr', 'cinq_ang', 'cinq_svt']) {
      expect(fiveCoreChapters.where((chapter) => chapter.subjectId == id).map((chapter) => chapter.order).toSet(),
          {1, 2, 3, 4, 5, 6});
    }
  });

}
