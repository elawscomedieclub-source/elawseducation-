import '../../shared/widgets/menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/school_level_provider.dart';
import '../../data/sample/sample_data.dart';
import '../../data/models/models.dart';
import 'subject_detail_screen.dart';
import 'primary_year_plan_screen.dart';
import 'composition_screen.dart';
import 'cp1_completion_screen.dart';

class SubjectsScreen extends ConsumerWidget {
  const SubjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLevel = ref.watch(schoolLevelProvider);
    final selectedTrack = ref.watch(schoolTrackProvider);
    final selectedSeries = ref.watch(schoolSeriesProvider);
    final subjects = demoSubjects
        .where((subject) => subjectMatchesPath(subject, selectedLevel, selectedTrack, selectedSeries))
        .toList();

    return Scaffold(
      appBar: AppBar(
        leading: const ProfTogoMenuButton(),
        title: const Text('Toutes les matières'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (selectedLevel == SchoolLevel.cp1)
            Card(
              color: const Color(0xFFE8F5EF),
              child: ListTile(
                leading: const Icon(Icons.menu_book_rounded, color: Color(0xFF006A4E), size: 30),
                title: const Text('Complément CP1 • Trimestres 2 et 3',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('10 chapitres • 20 leçons • exercices avec corrections'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Cp1CompletionScreen()),
                ),
              ),
            ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.assignment_turned_in, color: Color(0xFF006A4E), size: 30),
              title: const Text('Compositions trimestrielles', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Sujets d’entraînement avec note sur 20 et corrigés'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CompositionScreen(
                  level: selectedLevel, track: selectedTrack, series: selectedSeries,
                )),
              ),
            ),
          ),
          Card(
            color: const Color(0xFFE8F5EF),
            child: ListTile(
              leading: const Icon(Icons.calendar_month, color: Color(0xFF006A4E), size: 30),
              title: const Text('Progression annuelle', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(selectedLevel.index >= SchoolLevel.seconde.index
                  ? 'Voir les trois trimestres et les objectifs de la série $selectedSeries'
                  : 'Voir les trois trimestres de cette classe'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PrimaryYearPlanScreen(
                  level: selectedLevel, track: selectedTrack, series: selectedSeries,
                )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 12),
            child: Text(
              'Classe : ${selectedLevel.label}${selectedLevel.index >= SchoolLevel.seconde.index ? ' • ${selectedTrack.label} • Série ${selectedSeries}' : ''}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          if (subjects.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    const Icon(Icons.menu_book_outlined, size: 42, color: Color(0xFF006A4E)),
                    const SizedBox(height: 10),
                    Text('Programme ${selectedLevel.label}',
                        style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text(
                      'Les autres matières de cette classe seront ajoutées progressivement. '
                      'Le complément CP1 disponible ci-dessus reste accessible.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            ...subjects.map((subject) => Card(
              child: ListTile(
                leading: const Icon(Icons.menu_book, color: Color(0xFF006A4E)),
                title: Text(subject.name),
                subtitle: Text('Classe : ${subject.level.label}'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SubjectDetailScreen(subject: subject)),
                ),
              ),
            )),
        ],
      ),
    );
  }
}
