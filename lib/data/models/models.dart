import 'package:equatable/equatable.dart';

enum SchoolTrack { generalLiterary, scientific, technicalTertiary, technicalIndustrial }
extension SchoolTrackX on SchoolTrack {
  String get label => switch (this) {
    SchoolTrack.generalLiterary => 'Lycée général / littéraire',
    SchoolTrack.scientific => 'Lycée scientifique',
    SchoolTrack.technicalTertiary => 'Lycée technique – tertiaire',
    SchoolTrack.technicalIndustrial => 'Lycée technique – industriel',
  };
}
const technicalTertiarySeries = ['G1', 'G2', 'G3'];
const technicalIndustrialSeries = ['E', 'F1', 'F2', 'F3', 'F4', 'Ti/1'];

enum SchoolLevel { cp1, cp2, ce1, ce2, cm1, cm2, sixieme, cinquieme, quatrieme, troisieme, seconde, premiere, terminale }
extension SchoolLevelX on SchoolLevel {
  String get label => switch (this) {
    SchoolLevel.cp1 => 'CP1', SchoolLevel.cp2 => 'CP2', SchoolLevel.ce1 => 'CE1', SchoolLevel.ce2 => 'CE2', SchoolLevel.cm1 => 'CM1', SchoolLevel.cm2 => 'CM2',
    SchoolLevel.sixieme => '6ème', SchoolLevel.cinquieme => '5ème', SchoolLevel.quatrieme => '4ème', SchoolLevel.troisieme => '3ème', SchoolLevel.seconde => '2nde', SchoolLevel.premiere => '1ère', SchoolLevel.terminale => 'Terminale',
  };
}

const allSchoolLevels = SchoolLevel.values;
class Subject extends Equatable {
  final String id, name, iconName, colorHex; final SchoolLevel level; final SchoolTrack? track; final String? series; final int totalChapters, completedChapters; final double progress;
  const Subject({required this.id, required this.name, required this.iconName, required this.colorHex, required this.level, this.track, this.series, required this.totalChapters, this.completedChapters = 0, this.progress = 0.0});
  @override List<Object?> get props => [id, name, level, track, series];
}
class Chapter extends Equatable {
  final String id, subjectId, title; final int order; final bool isCompleted; final int totalLessons, completedLessons, term;
  const Chapter({required this.id, required this.subjectId, required this.title, required this.order, this.isCompleted = false, this.totalLessons = 0, this.completedLessons = 0, this.term = 1});
  @override List<Object?> get props => [id, subjectId, title, term];
}
class Lesson extends Equatable {
  final String id, chapterId, title, content, summary; final int durationMinutes; final bool isCompleted; final List<String> keyPoints;
  const Lesson({required this.id, required this.chapterId, required this.title, required this.content, required this.summary, this.durationMinutes = 15, this.isCompleted = false, this.keyPoints = const []});
  @override List<Object?> get props => [id, chapterId, title];
}
class Exercise extends Equatable {
  final String id, lessonId, question; final List<String> options; final int correctIndex; final String explanation;
  const Exercise({required this.id, required this.lessonId, required this.question, required this.options, required this.correctIndex, required this.explanation});
  @override List<Object?> get props => [id, lessonId];
}
class UserProgress extends Equatable {
  final String userId; final SchoolLevel level; final int totalXp, currentStreak, longestStreak; final Map<String, double> subjectProgress;
  const UserProgress({required this.userId, required this.level, this.totalXp = 0, this.currentStreak = 0, this.longestStreak = 0, this.subjectProgress = const {}});
  @override List<Object?> get props => [userId, level, totalXp, currentStreak];
}

bool subjectMatchesPath(Subject subject, SchoolLevel level, SchoolTrack track, String series) {
  if (subject.level != level) return false;
  if (subject.track == null) return true;
  if (subject.track != track) return false;
  return subject.series == null || subject.series == series;
}
