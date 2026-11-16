import 'package:equatable/equatable.dart';

enum SchoolLevel {
  cp1, cp2, ce1, ce2, cm1, cm2,
  sixieme,
  cinquieme,
  quatrieme,
  troisieme,
  seconde,
  premiere,
  terminale,
}

extension SchoolLevelX on SchoolLevel {
  String get label {
    switch (this) {
      case SchoolLevel.cp1: return 'CP1';
      case SchoolLevel.cp2: return 'CP2';
      case SchoolLevel.ce1: return 'CE1';
      case SchoolLevel.ce2: return 'CE2';
      case SchoolLevel.cm1: return 'CM1';
      case SchoolLevel.cm2: return 'CM2';
      case SchoolLevel.sixieme:
        return '6ème';
      case SchoolLevel.cinquieme:
        return '5ème';
      case SchoolLevel.quatrieme:
        return '4ème';
      case SchoolLevel.troisieme:
        return '3ème';
      case SchoolLevel.seconde:
        return '2nde';
      case SchoolLevel.premiere:
        return '1ère';
      case SchoolLevel.terminale:
        return 'Terminale';
    }
  }
}

class Subject extends Equatable {
  final String id;
  final String name;
  final String iconName;
  final String colorHex;
  final SchoolLevel level;
  final int totalChapters;
  final int completedChapters;
  final double progress; // 0.0 → 1.0

  const Subject({
    required this.id,
    required this.name,
    required this.iconName,
    required this.colorHex,
    required this.level,
    required this.totalChapters,
    this.completedChapters = 0,
    this.progress = 0.0,
  });

  @override
  List<Object?> get props => [id, name, level];
}

class Chapter extends Equatable {
  final String id;
  final String subjectId;
  final String title;
  final int order;
  final bool isCompleted;
  final int totalLessons;
  final int completedLessons;

  const Chapter({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.order,
    this.isCompleted = false,
    this.totalLessons = 0,
    this.completedLessons = 0,
  });

  @override
  List<Object?> get props => [id, subjectId, title];
}

class Lesson extends Equatable {
  final String id;
  final String chapterId;
  final String title;
  final String content;
  final String summary;
  final int durationMinutes;
  final bool isCompleted;
  final List<String> keyPoints;

  const Lesson({
    required this.id,
    required this.chapterId,
    required this.title,
    required this.content,
    required this.summary,
    this.durationMinutes = 15,
    this.isCompleted = false,
    this.keyPoints = const [],
  });

  @override
  List<Object?> get props => [id, chapterId, title];
}

class Exercise extends Equatable {
  final String id;
  final String lessonId;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const Exercise({
    required this.id,
    required this.lessonId,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  @override
  List<Object?> get props => [id, lessonId];
}

class UserProgress extends Equatable {
  final String userId;
  final SchoolLevel level;
  final int totalXp;
  final int currentStreak;
  final int longestStreak;
  final Map<String, double> subjectProgress; // subjectId → progress

  const UserProgress({
    required this.userId,
    required this.level,
    this.totalXp = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.subjectProgress = const {},
  });

  @override
  List<Object?> get props => [userId, level, totalXp, currentStreak];
}
