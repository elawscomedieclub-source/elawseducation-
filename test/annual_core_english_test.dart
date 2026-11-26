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
    expect(annualCoreSubjects, hasLength(39));
    expect(annualCoreLessons, hasLength(201));
    expect(annualCoreExercises, hasLength(603));
    expect(annualCoreLessons.map((l) => l.id).toSet(), hasLength(201));
    expect(annualCoreExercises.map((e) => e.id).toSet(), hasLength(603));
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
    expect(annualPhysicsUnits, hasLength(14));
    expect(annualPhysicsLessons, hasLength(14));
    expect(annualPhysicsExercises, hasLength(42));
    expect(annualPhysicsSubjects.map((s) => s.level).toSet(), {
      SchoolLevel.sixieme, SchoolLevel.cinquieme, SchoolLevel.quatrieme, SchoolLevel.troisieme,
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
    expect(annualSecondaryMathUnits, hasLength(18));
    expect(annualSecondaryMathLessons, hasLength(18));
    expect(annualSecondaryMathExercises, hasLength(54));
    expect(annualSecondaryMathLessons.map((l) => l.id).toSet(), hasLength(18));
    expect(annualSecondaryMathExercises.map((e) => e.id).toSet(), hasLength(54));
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
    expect(annualSecondaryFrenchUnits, hasLength(18));
    expect(annualSecondaryFrenchLessons, hasLength(18));
    expect(annualSecondaryFrenchExercises, hasLength(54));
    expect(annualSecondaryFrenchLessons.map((l) => l.id).toSet(), hasLength(18));
    expect(annualSecondaryFrenchExercises.map((e) => e.id).toSet(), hasLength(54));
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
    expect(annualSecondarySvtUnits, hasLength(18));
    expect(annualSecondarySvtLessons, hasLength(18));
    expect(annualSecondarySvtExercises, hasLength(54));
    expect(annualSecondarySvtLessons.map((l) => l.id).toSet(), hasLength(18));
    expect(annualSecondarySvtExercises.map((e) => e.id).toSet(), hasLength(54));
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
    expect(annualSecondaryEnglishUnits, hasLength(18));
    expect(annualSecondaryEnglishChapters, hasLength(18));
    expect(annualSecondaryEnglishLessons, hasLength(18));
    expect(annualSecondaryEnglishExercises, hasLength(54));
    expect(annualCoreChapters.where((c) => c.id.startsWith('core_secondary_english_')).length, 0);
    expect(annualCoreLessons.where((l) => l.id.startsWith('core_en_6e_') || l.id.startsWith('core_en_5e_') || l.id.startsWith('core_en_4e_') || l.id.startsWith('core_en_3e_')).length, 18);
    expect(annualCoreExercises.where((e) => e.id.startsWith('core_en_6e_') || e.id.startsWith('core_en_5e_') || e.id.startsWith('core_en_4e_') || e.id.startsWith('core_en_3e_')).length, 54);
    expect(annualSecondaryEnglishLessons.map((l) => l.id).toSet(), hasLength(18));
    expect(annualSecondaryEnglishExercises.map((e) => e.id).toSet(), hasLength(54));
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

  

  

  

    test('secondary annual lessons are integrated into existing subject chapters', () {
    final lessons = <Lesson>[
      ...annualSecondaryMathLessons,
      ...annualSecondaryFrenchLessons,
      ...annualSecondaryEnglishLessons,
      ...annualSecondarySvtLessons,
    ];
    expect(lessons, hasLength(72));
    final demoChapterIds = demoChapters.map((chapter) => chapter.id).toSet();
    for (final lesson in lessons) {
      expect(demoChapterIds, contains(lesson.chapterId), reason: lesson.id);
    }
    final subjectPaths = <SchoolLevel, List<String>>{
      SchoolLevel.cinquieme: ['cinq_math', 'cinq_fr', 'cinq_ang', 'cinq_svt'],
      SchoolLevel.quatrieme: ['quatre_math', 'quatre_fr', 'quatre_ang', 'quatre_svt'],
      SchoolLevel.troisieme: ['trois_math', 'trois_fr', 'trois_ang', 'trois_svt'],
    };
    for (final entry in subjectPaths.entries) {
      for (final id in entry.value) {
        final subject = demoSubjects.firstWhere(
          (s) => s.id == id && s.level == entry.key,
        );
        final chapterCount = demoChapters.where((c) => c.subjectId == id).length;
        expect(subject.totalChapters, 7);
        expect(chapterCount, subject.totalChapters);
      }
    }
  });

test('6e existing subject chapters match their declared annual totals', () {
    for (final id in ['math', 'fr', 'anglais', 'svt', 'hist']) {
      final subject = demoSubjects.firstWhere(
        (s) => s.id == id && s.level == SchoolLevel.sixieme,
      );
      expect(demoChapters.where((chapter) => chapter.subjectId == id).length,
          subject.totalChapters);
    }
  });

  test('3e physics chapters complete the existing subject and are reachable', () {
    final demoCount = demoChapters.where((c) => c.subjectId == 'trois_pc').length;
    final coreChapters = annualPhysicsChapters.where((c) => c.subjectId == 'trois_pc').toList();
    expect(demoCount, 6);
    expect(coreChapters, hasLength(5));
    expect(coreChapters.map((c) => c.id).toSet(), hasLength(5));
    expect(coreChapters.map((c) => c.order).toSet(), {2, 3, 4, 5, 6});
    final annualSubject = annualPhysicsSubjects.firstWhere((s) => s.id == 'trois_pc' && s.level == SchoolLevel.troisieme);
    expect(annualSubject.totalChapters, 11);
    expect(demoCount + coreChapters.length, annualSubject.totalChapters);
    final chapterIds = coreChapters.map((chapter) => chapter.id).toSet();
    final lessons = annualPhysicsLessons.where((lesson) => chapterIds.contains(lesson.chapterId)).toList();
    expect(lessons, hasLength(5));
    final lessonIds = lessons.map((l) => l.id).toSet();
    expect(annualPhysicsExercises.where((e) => lessonIds.contains(e.lessonId)), hasLength(15));
  });

  test('demo and core subject cards are merged by school path', () {
    final merged = mergeSubjectsByPath(demoSubjects, annualCoreSubjects);
    final a4Svt = merged.where((subject) =>
        subject.id == 'seconde_svt' &&
        subject.level == SchoolLevel.seconde &&
        subject.track == SchoolTrack.generalLiterary &&
        subject.series == 'A4').toList();
    expect(a4Svt, hasLength(1));
    expect(a4Svt.single.totalChapters, 11);
    final threePc = merged.where((subject) => subject.id == 'trois_pc' && subject.level == SchoolLevel.troisieme).toList();
    expect(threePc, hasLength(1));
    expect(threePc.single.totalChapters, 11);
    final keys = merged.map((subject) =>
        '${subject.id}|${subject.level.name}|${subject.track?.name ?? ''}|${subject.series ?? ''}').toSet();
    expect(keys, hasLength(merged.length));
  });

  test('every annual core chapter, lesson and exercise is reachable from its parent', () {
    final subjectIds = {
      ...demoSubjects.map((subject) => subject.id),
      ...annualCoreSubjects.map((subject) => subject.id),
    };
    final chapters = [...demoChapters, ...annualCoreChapters];
    final chapterIds = chapters.map((chapter) => chapter.id).toSet();
    final lessons = [...demoLessons, ...annualCoreLessons];
    final lessonIds = lessons.map((lesson) => lesson.id).toSet();

    final orphanChapters = annualCoreChapters
        .where((chapter) => !subjectIds.contains(chapter.subjectId))
        .map((chapter) => '${chapter.id} -> ${chapter.subjectId}')
        .toList();
    final orphanLessons = annualCoreLessons
        .where((lesson) => !chapterIds.contains(lesson.chapterId))
        .map((lesson) => '${lesson.id} -> ${lesson.chapterId}')
        .toList();
    final orphanExercises = annualCoreExercises
        .where((exercise) => !lessonIds.contains(exercise.lessonId))
        .map((exercise) => '${exercise.id} -> ${exercise.lessonId}')
        .toList();

    expect(orphanChapters, isEmpty, reason: 'Core chapters must appear under an existing subject.');
    expect(orphanLessons, isEmpty, reason: 'Core lessons must appear inside an existing chapter.');
    expect(orphanExercises, isEmpty, reason: 'Core exercises must open their corresponding lesson.');
  });


}
