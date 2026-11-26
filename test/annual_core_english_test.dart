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
    expect(annualCoreSubjects, hasLength(34));
    expect(annualCoreLessons, hasLength(111));
    expect(annualCoreExercises, hasLength(333));
    expect(annualCoreLessons.map((l) => l.id).toSet(), hasLength(111));
    expect(annualCoreExercises.map((e) => e.id).toSet(), hasLength(333));
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
    expect(annualSecondaryMathUnits, hasLength(6));
    expect(annualSecondaryMathLessons, hasLength(6));
    expect(annualSecondaryMathExercises, hasLength(18));
    expect(annualSecondaryMathLessons.map((l) => l.id).toSet(), hasLength(6));
    expect(annualSecondaryMathExercises.map((e) => e.id).toSet(), hasLength(18));
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
    expect(annualSecondaryFrenchUnits, hasLength(6));
    expect(annualSecondaryFrenchLessons, hasLength(6));
    expect(annualSecondaryFrenchExercises, hasLength(18));
    expect(annualSecondaryFrenchLessons.map((l) => l.id).toSet(), hasLength(6));
    expect(annualSecondaryFrenchExercises.map((e) => e.id).toSet(), hasLength(18));
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
    expect(annualSecondarySvtUnits, hasLength(7));
    expect(annualSecondarySvtLessons, hasLength(7));
    expect(annualSecondarySvtExercises, hasLength(21));
    expect(annualSecondarySvtLessons.map((l) => l.id).toSet(), hasLength(7));
    expect(annualSecondarySvtExercises.map((e) => e.id).toSet(), hasLength(21));
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
    expect(annualSecondePhysicsSubject.totalChapters, 8);
    expect(annualSecondePhysicsLessons.map((l) => l.id).toSet(), hasLength(8));
    expect(annualSecondePhysicsExercises.map((e) => e.id).toSet(), hasLength(24));
    for (final unit in annualSecondePhysicsUnits) {
      expect(unit.content.trim(), isNotEmpty);
      expect(unit.exercises, hasLength(3));
      for (final question in unit.exercises) {
        expect(question.options.length, greaterThanOrEqualTo(3));
        expect(question.correctIndex, inInclusiveRange(0, question.options.length - 1));
        expect(question.explanation.trim(), isNotEmpty);
      }
    }
  });

}
