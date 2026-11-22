import 'package:flutter_test/flutter_test.dart';
import 'package:proftogo/core/progress_service.dart';
import 'package:proftogo/core/school_level_provider.dart';

void main() {
  group('Fusion de la progression ProfTogo', () {
    test('fusionne les exercices uniques de deux appareils sans perdre les acquis', () {
      final local = ProgressSnapshot(
        answeredExerciseIds: {'ex1', 'ex2'},
        correctExerciseIds: {'ex1'},
        xp: 10,
      );
      final cloud = ProgressSnapshot(
        answeredExerciseIds: {'ex2', 'ex3'},
        correctExerciseIds: {'ex2', 'ex3'},
        xp: 20,
      );

      final merged = ProgressService.mergeSnapshots(local, cloud);

      expect(merged.answeredExerciseIds, {'ex1', 'ex2', 'ex3'});
      expect(merged.correctExerciseIds, {'ex1', 'ex2', 'ex3'});
      expect(merged.xp, 30);
    });

    test('calcule les XP à partir des exercices uniques validés', () {
      final local = ProgressSnapshot(
        answeredExerciseIds: {'ex1'},
        correctExerciseIds: {'ex1'},
        xp: 999,
      );
      const cloud = ProgressSnapshot(
        answeredExerciseIds: {},
        correctExerciseIds: {},
        xp: 0,
      );

      final merged = ProgressService.mergeSnapshots(local, cloud);

      expect(merged.xp, 10);
    });

    test('tout exercice validé figure aussi dans les exercices répondus', () {
      final local = ProgressSnapshot(
        answeredExerciseIds: {},
        correctExerciseIds: {'ex1', 'ex2'},
        xp: 20,
      );
      const cloud = ProgressSnapshot(
        answeredExerciseIds: {},
        correctExerciseIds: {},
        xp: 0,
      );

      final merged = ProgressService.mergeSnapshots(local, cloud);

      expect(merged.answeredExerciseIds, containsAll({'ex1', 'ex2'}));
    });

    test('les caches locaux sont différents pour chaque UID et pour le mode invité', () {
      final first = ProgressService.localStorageKey('progress', 'studentA');
      final second = ProgressService.localStorageKey('progress', 'studentB');
      final guest = ProgressService.localStorageKey('progress', null);

      expect(first, isNot(second));
      expect(first, isNot(guest));
      expect(second, isNot(guest));
    });

    test('les préférences de classe sont isolées entre les comptes et les invités', () {
      final first = studentPreferenceKeyForUid('school_level', 'studentA');
      final second = studentPreferenceKeyForUid('school_level', 'studentB');
      final guest = studentPreferenceKeyForUid('school_level', null);

      expect(first, 'school_level_user_studentA');
      expect(second, 'school_level_user_studentB');
      expect(guest, 'school_level_guest');
      expect(first, isNot(second));
      expect(first, isNot(guest));
    });
  });
}
