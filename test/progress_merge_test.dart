import 'package:flutter_test/flutter_test.dart';
import 'package:proftogo/core/progress_service.dart';

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
  });
}
