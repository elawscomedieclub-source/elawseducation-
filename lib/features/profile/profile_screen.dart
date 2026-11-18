import '../../shared/widgets/menu_button.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/school_level_provider.dart';
import '../../core/student_profile_cloud_service.dart';
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
          const StudentNameSection(),
          const StudentProfileCloudSync(),
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

class StudentProfileCloudSync extends ConsumerStatefulWidget {
  const StudentProfileCloudSync({super.key});

  @override
  ConsumerState<StudentProfileCloudSync> createState() =>
      _StudentProfileCloudSyncState();
}

class _StudentProfileCloudSyncState
    extends ConsumerState<StudentProfileCloudSync> {
  bool _ready = false;
  late final StreamSubscription<User?> _authSubscription;

  @override
  void initState() {
    super.initState();
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      _ready = false;
      if (user != null) _syncProfile();
    });
    if (FirebaseAuth.instance.currentUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _syncProfile());
    }
  }

  Future<void> _syncProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localLevel = prefs.getString('student_school_level') ??
          SchoolLevel.sixieme.name;
      final localTrack = prefs.getString('student_school_track') ??
          SchoolTrack.generalLiterary.name;
      final localSeries = prefs.getString('student_school_series') ?? 'A4';

      final cloud = await StudentProfileCloudService.load();
      var levelName = localLevel;
      var trackName = localTrack;
      var seriesName = localSeries;

      if (cloud != null) {
        levelName = cloud['level'] is String ? cloud['level'] as String : localLevel;
        trackName = cloud['track'] is String ? cloud['track'] as String : localTrack;
        seriesName = cloud['series'] is String ? cloud['series'] as String : localSeries;
      }

      final level = SchoolLevel.values.firstWhere(
        (item) => item.name == levelName,
        orElse: () => SchoolLevel.sixieme,
      );
      final track = SchoolTrack.values.firstWhere(
        (item) => item.name == trackName,
        orElse: () => SchoolTrack.generalLiterary,
      );
      final available = seriesForTrack(track);
      final series = available.contains(seriesName) ? seriesName : available.first;

      await ref.read(schoolLevelProvider.notifier).setLevel(level);
      await ref.read(schoolTrackProvider.notifier).setTrack(track);
      await ref.read(schoolSeriesProvider.notifier).setSeries(series);

      if (cloud == null) {
        await StudentProfileCloudService.save(
          level: level.name,
          track: track.name,
          series: series,
        );
      }
      _ready = true;
    } catch (_) {
      _ready = true;
    }
  }

  Future<void> _saveProfile() async {
    if (!_ready || FirebaseAuth.instance.currentUser == null) return;
    try {
      await StudentProfileCloudService.save(
        level: ref.read(schoolLevelProvider).name,
        track: ref.read(schoolTrackProvider).name,
        series: ref.read(schoolSeriesProvider),
      );
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<SchoolLevel>(schoolLevelProvider, (_, __) => _saveProfile());
    ref.listen<SchoolTrack>(schoolTrackProvider, (_, __) => _saveProfile());
    ref.listen<String>(schoolSeriesProvider, (_, __) => _saveProfile());
    return const SizedBox.shrink();
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}


class StudentNameSection extends StatefulWidget {
  const StudentNameSection({super.key});

  @override
  State<StudentNameSection> createState() => _StudentNameSectionState();
}

class _StudentNameSectionState extends State<StudentNameSection> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = true;
  bool _saving = false;
  String? _message;

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  Future<void> _loadName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var name = prefs.getString('student_name') ?? '';
      if (FirebaseAuth.instance.currentUser != null) {
        final cloud = await StudentProfileCloudService.load();
        final cloudName = cloud?['name'];
        if (cloudName is String && cloudName.trim().isNotEmpty) {
          name = cloudName;
          await prefs.setString('student_name', name);
        }
      }
      if (!mounted) return;
      _controller.text = name;
    } catch (_) {
      // Keep the profile usable with the name stored on this device.
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _saveName() async {
    final name = _controller.text.trim();
    if (name.isEmpty) {
      setState(() => _message = 'Écris ton nom avant d’enregistrer.');
      return;
    }
    setState(() {
      _saving = true;
      _message = null;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('student_name', name);
      if (FirebaseAuth.instance.currentUser != null) {
        await StudentProfileCloudService.saveName(name);
        if (!mounted) return;
        setState(() => _message = 'Nom enregistré et synchronisé.');
      } else {
        if (!mounted) return;
        setState(() => _message = 'Nom enregistré sur cet appareil. Connecte-toi pour le sauvegarder dans le cloud.');
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _message = 'Nom gardé sur cet appareil, synchronisation cloud indisponible.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Mon nom', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              enabled: !_loading && !_saving,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
                labelText: 'Nom et prénom',
                hintText: 'Ex. : Kossi Mensah',
              ),
              onSubmitted: (_) => _saveName(),
            ),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: _loading || _saving ? null : _saveName,
              icon: _saving
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.save_outlined),
              label: Text(_saving ? 'Enregistrement…' : 'Enregistrer mon nom'),
            ),
            if (_message != null) ...[
              const SizedBox(height: 8),
              Text(_message!, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            ],
          ],
        ),
      ),
    );
  }
}
