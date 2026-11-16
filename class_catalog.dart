import '../models/models.dart';

/// Catalogue de classes et de matières de ProfTogo.
/// Les matières sont une structure de navigation; chaque leçon doit être
/// complétée/validée avec les documents pédagogiques homologués du Togo.
class SchoolClassInfo {
  final String id;
  final String label;
  final SchoolLevel level;
  final String series;
  final List<String> subjects;

  const SchoolClassInfo({
    required this.id,
    required this.label,
    required this.level,
    this.series = '',
    required this.subjects,
  });
}

class ClassCatalog {
  static const List<SchoolClassInfo> classes = [
    SchoolClassInfo(id:'cp1', label:'CP1', level:SchoolLevel.cp1, subjects:['Langue et communication','Mathématiques','Éducation sociale','Éducation artistique','Éducation musicale','EPS']),
    SchoolClassInfo(id:'cp2', label:'CP2', level:SchoolLevel.cp2, subjects:['Langue et communication','Mathématiques','Éducation sociale','Éducation artistique','Éducation musicale','EPS']),
    SchoolClassInfo(id:'ce1', label:'CE1', level:SchoolLevel.ce1, subjects:['Langue et communication','Mathématiques','Sciences et technologie','Sciences humaines','Éducation artistique','EPS']),
    SchoolClassInfo(id:'ce2', label:'CE2', level:SchoolLevel.ce2, subjects:['Langue et communication','Mathématiques','Sciences et technologie','Sciences humaines','Éducation artistique','EPS']),
    SchoolClassInfo(id:'cm1', label:'CM1', level:SchoolLevel.cm1, subjects:['Langue et communication','Mathématiques','Sciences et technologie','Sciences humaines','Éducation sociale','Éducation artistique','EPS']),
    SchoolClassInfo(id:'cm2', label:'CM2', level:SchoolLevel.cm2, subjects:['Langue et communication','Mathématiques','Sciences et technologie','Sciences humaines','Éducation sociale','Éducation artistique','EPS']),
    SchoolClassInfo(id:'6e', label:'6ème', level:SchoolLevel.sixieme, subjects:['Mathématiques','Français','Anglais','SVT','Histoire-Géographie','Physique-Chimie','Éducation civique et morale','Technologie']),
    SchoolClassInfo(id:'5e', label:'5ème', level:SchoolLevel.cinquieme, subjects:['Mathématiques','Français','Anglais','SVT','Histoire-Géographie','Physique-Chimie','Éducation civique et morale','Technologie']),
    SchoolClassInfo(id:'4e', label:'4ème', level:SchoolLevel.quatrieme, subjects:['Mathématiques','Français','Anglais','SVT','Histoire-Géographie','Physique-Chimie','Éducation civique et morale','Technologie']),
    SchoolClassInfo(id:'3e', label:'3ème', level:SchoolLevel.troisieme, subjects:['Mathématiques','Français','Anglais','SVT','Histoire-Géographie','Physique-Chimie','Éducation civique et morale','Technologie']),
    SchoolClassInfo(id:'2a4', label:'Seconde A4', level:SchoolLevel.seconde, series:'A4', subjects:['Français','Anglais','Allemand','Mathématiques','Histoire-Géographie','Philosophie','SVT','Physique-Chimie','Éducation civique et morale','Technologie']),
    SchoolClassInfo(id:'2cd', label:'Seconde C/D', level:SchoolLevel.seconde, series:'C/D', subjects:['Français','Anglais','Allemand','Mathématiques','Histoire-Géographie','Philosophie','SVT','Physique-Chimie','Éducation civique et morale','Technologie']),
    SchoolClassInfo(id:'1a4', label:'Première A4', level:SchoolLevel.premiere, series:'A4', subjects:['Français','Anglais','Allemand / Espagnol','Mathématiques','Histoire-Géographie','Philosophie','SVT','Physique-Chimie','Éducation civique et morale','Technologie']),
    SchoolClassInfo(id:'1c', label:'Première C', level:SchoolLevel.premiere, series:'C', subjects:['Français','Anglais','Mathématiques','Histoire-Géographie','Philosophie','SVT','Physique-Chimie','Éducation civique et morale','Technologie']),
    SchoolClassInfo(id:'1d', label:'Première D', level:SchoolLevel.premiere, series:'D', subjects:['Français','Anglais','Mathématiques','Histoire-Géographie','Philosophie','SVT','Physique-Chimie','Éducation civique et morale','Technologie']),
    SchoolClassInfo(id:'ta4', label:'Terminale A4', level:SchoolLevel.terminale, series:'A4', subjects:['Français','Anglais','Allemand / Espagnol','Mathématiques','Histoire-Géographie','Philosophie','SVT','Physique-Chimie','Éducation civique et morale','Technologie']),
    SchoolClassInfo(id:'tc', label:'Terminale C', level:SchoolLevel.terminale, series:'C', subjects:['Français','Anglais','Mathématiques','Histoire-Géographie','Philosophie','SVT','Physique-Chimie','Éducation civique et morale','Technologie']),
    SchoolClassInfo(id:'td', label:'Terminale D', level:SchoolLevel.terminale, series:'D', subjects:['Français','Anglais','Mathématiques','Histoire-Géographie','Philosophie','SVT','Physique-Chimie','Éducation civique et morale','Technologie']),
  ];

  static List<Subject> subjectsFor(SchoolClassInfo schoolClass) {
    const colors = ['#006A4E','#D21034','#0288D1','#2E7D32','#F9A825','#7B1FA2','#00838F'];
    return List.generate(schoolClass.subjects.length, (i) {
      final name = schoolClass.subjects[i];
      final slug = name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
      return Subject(
        id: '${slug}-${schoolClass.id}',
        name: name,
        iconName: 'book',
        colorHex: colors[i % colors.length],
        level: schoolClass.level,
        totalChapters: (name == 'Mathématiques' && schoolClass.level == SchoolLevel.sixieme) ? 6 : 4,
        completedChapters: 0,
        progress: 0,
      );
    });
  }
}
