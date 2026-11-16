import '../../shared/widgets/menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/school_level_provider.dart';
import '../../data/sample/sample_data.dart';
import 'subject_detail_screen.dart';

class SubjectsScreen extends ConsumerWidget {
  const SubjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLevel = ref.watch(schoolLevelProvider);
    final subjects = demoSubjects
        .where((subject) => subject.level == selectedLevel)
        .toList();

    return Scaffold(
      appBar: AppBar(
        leading: const ProfTogoMenuButton(),
        title: const Text('Toutes les matières'),
      ),
      body: subjects.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.menu_book_outlined, size: 54,
                        color: Color(0xFF006A4E)),
                    const SizedBox(height: 16),
                    Text(
                      'Programme ' + selectedLevel.label,
                      style: const TextStyle(
                          fontSize: 21, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Les cours de cette classe sont en préparation. '
                      'Ils seront ajoutés progressivement. Tu peux choisir '
                      'une autre classe dans Mon profil.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Classe : ' + selectedLevel.label,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ...subjects.map((subject) => Card(
                      child: ListTile(
                        leading: const Icon(Icons.menu_book,
                            color: Color(0xFF006A4E)),
                        title: Text(subject.name),
                        subtitle: Text('Classe : ' + subject.level.label),
                        trailing:
                            const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                SubjectDetailScreen(subject: subject),
                          ),
                        ),
                      ),
                    )),
              ],
            ),
    );
  }
}
