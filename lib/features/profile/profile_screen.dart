import '../../shared/widgets/menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/school_level_provider.dart';
import '../../data/models/models.dart';
import '../auth/account_section.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final schoolLevel = ref.watch(schoolLevelProvider);
    final schoolTrack = ref.watch(schoolTrackProvider);
    final schoolSeries = ref.watch(schoolSeriesProvider);
    final availableSeries = seriesForTrack(schoolTrack);

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
          const SizedBox(height: 20),
          const AccountSection(),
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
          if (schoolLevel.index >= SchoolLevel.seconde.index) ...[
            const Text('Mon parcours au lycée',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<SchoolTrack>(
              value: schoolTrack,
              isExpanded: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.account_tree_outlined),
                labelText: 'Choisir mon parcours',
              ),
              items: SchoolTrack.values.map((track) => DropdownMenuItem(
                value: track, child: Text(track.label),
              )).toList(),
              onChanged: (track) {
                if (track != null) {
                  ref.read(schoolTrackProvider.notifier).setTrack(track);
                  final first = seriesForTrack(track).first;
                  ref.read(schoolSeriesProvider.notifier).setSeries(first);
                }
              },
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: availableSeries.contains(schoolSeries) ? schoolSeries : availableSeries.first,
              isExpanded: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.school_outlined),
                labelText: 'Choisir ma série',
              ),
              items: availableSeries.map((series) => DropdownMenuItem(
                value: series, child: Text('Série $series'),
              )).toList(),
              onChanged: (series) {
                if (series != null) ref.read(schoolSeriesProvider.notifier).setSeries(series);
              },
            ),
            const SizedBox(height: 10),
          ],
          Text(
            'Ta classe, ton parcours et ta série sont mémorisés sur cet appareil. Les matières et entraînements seront adaptés à ton choix.',
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
