import '../../shared/widgets/menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/school_level_provider.dart';
import '../../data/models/models.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final schoolLevel = ref.watch(schoolLevelProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const ProfTogoMenuButton(),
        title: const Text('Mon profil'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const CircleAvatar(radius: 42, child: Icon(Icons.person, size: 42)),
          const SizedBox(height: 12),
          const Center(
            child: Text('Élève ProfTogo',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 24),
          const Text('Mon niveau scolaire',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<SchoolLevel>(
            value: schoolLevel,
            isExpanded: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.school_outlined),
              labelText: 'Choisir ma classe',
            ),
            items: allSchoolLevels.map((level) {
              return DropdownMenuItem<SchoolLevel>(
                value: level,
                child: Text(level.label),
              );
            }).toList(),
            onChanged: (level) {
              if (level != null) {
                ref.read(schoolLevelProvider.notifier).setLevel(level);
              }
            },
          ),
          const SizedBox(height: 10),
          Text(
            'Ta classe est mémorisée sur cet appareil. Les cours disponibles '
            'seront affichés selon le niveau sélectionné.',
            style: TextStyle(color: Theme.of(context).hintColor),
          ),
          const SizedBox(height: 24),
          const ListTile(
            leading: Icon(Icons.flag),
            title: Text('Mon objectif'),
            subtitle: Text('Apprendre chaque jour'),
          ),
          SwitchListTile(
            value: mode == ThemeMode.dark,
            title: const Text('Mode sombre'),
            secondary: const Icon(Icons.dark_mode),
            onChanged: (_) =>
                ref.read(themeModeProvider.notifier).toggle(),
          ),
          const AboutListTile(
            icon: Icon(Icons.info_outline),
            applicationName: 'ProfTogo',
            applicationVersion: '1.0.0',
            aboutBoxChildren: [
              Text('Une application éducative pour les élèves du Togo.')
            ],
          ),
        ],
      ),
    );
  }
}
