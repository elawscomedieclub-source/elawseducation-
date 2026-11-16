import '../../shared/widgets/menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/school_level_provider.dart';
import '../../data/sample/sample_data.dart';
import '../subjects/subject_detail_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLevel = ref.watch(schoolLevelProvider);
    final subjects = demoSubjects
        .where((subject) => subject.level == selectedLevel)
        .toList();

    return Scaffold(
      appBar: AppBar(
        leading: const ProfTogoMenuButton(),
        title: const Text('ProfTogo',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Bienvenue sur ProfTogo !')),
            ),
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF006A4E),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('BONJOUR, ÉLÈVE !',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 8),
                const Text(
                  'Prêt à apprendre quelque chose de nouveau ?',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text('Ta classe : ' + selectedLevel.label,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                const Text('Continue tes efforts : chaque leçon compte.',
                    style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text('Ta progression',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(children: [
            _stat('⭐', '0 XP', 'Points'),
            _stat('🔥', '1 jour', 'Série'),
            _stat('📚', '0', 'Leçons'),
          ]),
          const SizedBox(height: 24),
          const Text('Matières à découvrir',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          if (subjects.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Text(
                  'Les cours de ' + selectedLevel.label +
                  ' sont en préparation. Consulte régulièrement ProfTogo '
                  'pour découvrir les nouvelles leçons.',
                ),
              ),
            )
          else
            ...subjects.map((subject) => Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFE8F5F0),
                      child: Icon(Icons.menu_book,
                          color: Color(0xFF006A4E)),
                    ),
                    title: Text(subject.name),
                    subtitle: Text(
                        (subject.progress * 100).round().toString() +
                        ' % terminé'),
                    trailing: const Icon(Icons.chevron_right),
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

  static Widget _stat(String icon, String value, String label) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(children: [
            Text(icon),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(fontSize: 11)),
          ]),
        ),
      ),
    );
  }
}
