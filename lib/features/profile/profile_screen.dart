import '../../shared/widgets/menu_button.dart';
import 'dart:async';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/school_level_provider.dart';
import '../../core/student_profile_cloud_service.dart';
import '../../core/progress_service.dart';
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
          const StudentPhotoSection(),
          const SizedBox(height: 12),
          Center(
            child: ValueListenableBuilder<String>(
              valueListenable: StudentNameSection.nameNotifier,
              builder: (context, name, _) => Text(
                name.trim().isEmpty ? 'Élève ProfTogo' : name.trim(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const StudentNameSection(),
          const AccountSection(),
          const StudentProfileCloudSync(),
          const SizedBox(height: 12),
          const StudentProgressSummary(),
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
            'Ta classe, ton parcours et ta série sont enregistrés dans ton profil et synchronisés avec ton compte lorsque tu es connecté. Les matières et entraînements seront adaptés à ton choix.',
            style: TextStyle(color: Theme.of(context).hintColor),
          ),
          const SizedBox(height: 24),
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


class StudentProgressSummary extends StatefulWidget {
  const StudentProgressSummary({super.key});

  @override
  State<StudentProgressSummary> createState() => _StudentProgressSummaryState();
}

class _StudentProgressSummaryState extends State<StudentProgressSummary> {
  late Future<ProgressSnapshot> _progressFuture;
  late final StreamSubscription<User?> _authSubscription;

  @override
  void initState() {
    super.initState();
    _progressFuture = ProgressService.load();
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((_) {
      if (!mounted) return;
      setState(() {
        _progressFuture = ProgressService.load();
      });
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProgressSnapshot>(
      future: _progressFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        if (!snapshot.hasData) {
          return const Card(
            child: ListTile(
              leading: Icon(Icons.trending_up),
              title: Text('Ma progression'),
              subtitle: Text('Progression momentanément indisponible.'),
            ),
          );
        }

        final progress = snapshot.data!;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Ma progression',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Actualiser ma progression',
                      onPressed: () => setState(() {
                        _progressFuture = ProgressService.load();
                      }),
                      icon: const Icon(Icons.refresh),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Icon(Icons.stars_outlined, size: 28),
                          const SizedBox(height: 6),
                          Text(
                            '${progress.xp} XP',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const Text('Points gagnés'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Icon(Icons.task_alt, size: 28),
                          const SizedBox(height: 6),
                          Text(
                            '${progress.correctExerciseIds.length}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const Text('Exercices validés'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Ces résultats regroupent les exercices validés sur cet appareil, tous niveaux confondus.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).hintColor, fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
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
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen(_syncProfile);
    _syncProfile(FirebaseAuth.instance.currentUser);
  }

  Future<void> _syncProfile(User? user) async {
    _ready = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      // Les anciennes préférences globales pouvaient appartenir à un autre élève.
      await prefs.remove('student_name');
      await prefs.remove('student_school_level');
      await prefs.remove('student_school_track');
      await prefs.remove('student_school_series');
      String levelName;
      String trackName;
      String seriesName;

      if (user == null) {
        levelName = prefs.getString(studentPreferenceKey('student_school_level')) ??
            SchoolLevel.sixieme.name;
        trackName = prefs.getString(studentPreferenceKey('student_school_track')) ??
            SchoolTrack.generalLiterary.name;
        seriesName = prefs.getString(studentPreferenceKey('student_school_series')) ?? 'A4';
      } else {
        final cloud = await StudentProfileCloudService.load();
        if (FirebaseAuth.instance.currentUser?.uid != user.uid) return;
        // Un nouveau compte ne doit jamais hériter des réglages locaux du
        // compte précédent. Le profil cloud de cet UID est la seule source.
        levelName = cloud?['level'] is String
            ? cloud!['level'] as String
            : SchoolLevel.sixieme.name;
        trackName = cloud?['track'] is String
            ? cloud!['track'] as String
            : SchoolTrack.generalLiterary.name;
        seriesName = cloud?['series'] is String
            ? cloud!['series'] as String
            : 'A4';
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

      if (user != null && FirebaseAuth.instance.currentUser?.uid == user.uid) {
        await StudentProfileCloudService.save(
          level: level.name,
          track: track.name,
          series: series,
        );
      }
      _ready = user == null || FirebaseAuth.instance.currentUser?.uid == user.uid;
    } catch (_) {
      _ready = true;
    }
  }

  Future<void> _saveProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (!_ready || uid == null) return;
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
  static final ValueNotifier<String> nameNotifier = ValueNotifier<String>('');

  const StudentNameSection({super.key});

  @override
  State<StudentNameSection> createState() => _StudentNameSectionState();
}

class _StudentNameSectionState extends State<StudentNameSection> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = true;
  bool _saving = false;
  String? _message;
  late final StreamSubscription<User?> _authSubscription;

  @override
  void initState() {
    super.initState();
    _loadName();
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((_) {
      if (!mounted) return;
      _controller.clear();
      StudentNameSection.nameNotifier.value = '';
      setState(() {
        _loading = true;
        _message = null;
      });
      _loadName();
    });
  }

  Future<void> _loadName() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    try {
      final prefs = await SharedPreferences.getInstance();
      var name = prefs.getString(studentPreferenceKey('student_name')) ?? '';
      if (uid != null) {
        final cloud = await StudentProfileCloudService.load();
        if (FirebaseAuth.instance.currentUser?.uid != uid) return;
        final cloudName = cloud?['name'];
        // Aucun nom d'un autre compte ou du mode invité n'est repris.
        name = cloudName is String ? cloudName : '';
        if (name.trim().isNotEmpty) {
          await prefs.setString(studentPreferenceKey('student_name'), name);
        }
      }
      if (!mounted || FirebaseAuth.instance.currentUser?.uid != uid) return;
      _controller.text = name;
      StudentNameSection.nameNotifier.value = name;
    } catch (_) {
      // Le profil reste accessible sans connexion réseau.
    } finally {
      if (mounted && FirebaseAuth.instance.currentUser?.uid == uid) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _saveName() async {
    final name = _controller.text.trim();
    if (name.isEmpty) {
      setState(() => _message = 'Écris ton nom avant d’enregistrer.');
      return;
    }
    final uid = FirebaseAuth.instance.currentUser?.uid;
    setState(() {
      _saving = true;
      _message = null;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(studentPreferenceKey('student_name'), name);
      if (FirebaseAuth.instance.currentUser?.uid != uid) return;
      StudentNameSection.nameNotifier.value = name;
      if (uid != null) {
        await StudentProfileCloudService.saveName(name);
        if (!mounted || FirebaseAuth.instance.currentUser?.uid != uid) return;
        setState(() => _message = 'Nom enregistré et synchronisé dans ton compte.');
      } else {
        if (!mounted) return;
        setState(() => _message = 'Nom enregistré sur cet appareil.');
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _message = 'Synchronisation momentanément indisponible.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _authSubscription.cancel();
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


class StudentPhotoSection extends StatefulWidget {
  const StudentPhotoSection({super.key});

  @override
  State<StudentPhotoSection> createState() => _StudentPhotoSectionState();
}

class _StudentPhotoSectionState extends State<StudentPhotoSection> {
  final ImagePicker _picker = ImagePicker();
  String? _photoBase64;
  bool _loading = true;
  bool _saving = false;
  String? _message;
  late final StreamSubscription<User?> _authSubscription;

  String _localKeyFor(String? uid) =>
      uid == null ? 'student_photo_local' : 'student_photo_$uid';

  @override
  void initState() {
    super.initState();
    _loadPhoto();
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((_) {
      if (!mounted) return;
      setState(() {
        _photoBase64 = null;
        _loading = true;
        _message = null;
      });
      _loadPhoto();
    });
  }

  Future<void> _loadPhoto() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final key = _localKeyFor(uid);
    try {
      final prefs = await SharedPreferences.getInstance();
      var photo = prefs.getString(key);
      if (uid != null) {
        try {
          final cloud = await StudentProfileCloudService.load();
          if (FirebaseAuth.instance.currentUser?.uid != uid) return;
          final cloudPhoto = cloud?['photoBase64'];
          if (cloudPhoto is String && cloudPhoto.isNotEmpty) {
            photo = cloudPhoto;
            await prefs.setString(key, photo);
          } else if (photo != null && photo.isNotEmpty) {
            await StudentProfileCloudService.savePhoto(photo);
          }
        } catch (_) {
          // Le cache de cet UID reste disponible hors connexion.
        }
      }
      if (!mounted || FirebaseAuth.instance.currentUser?.uid != uid) return;
      setState(() => _photoBase64 = photo);
    } catch (_) {
      // Le profil reste utilisable sans photo.
    } finally {
      if (mounted && FirebaseAuth.instance.currentUser?.uid == uid) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _choosePhoto() async {
    if (_saving || _loading) return;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final key = _localKeyFor(uid);
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 256,
        maxHeight: 256,
        imageQuality: 55,
      );
      if (picked == null || !mounted) return;
      if (FirebaseAuth.instance.currentUser?.uid != uid) return;
      final bytes = await picked.readAsBytes();
      final encoded = base64Encode(bytes);
      if (encoded.length > 350000) {
        setState(() => _message =
            'Cette photo est encore trop volumineuse. Choisis une image plus légère.');
        return;
      }
      setState(() {
        _saving = true;
        _message = 'Enregistrement de la photo…';
      });
      final prefs = await SharedPreferences.getInstance();
      if (FirebaseAuth.instance.currentUser?.uid != uid) return;
      await prefs.setString(key, encoded);
      if (uid != null) {
        try {
          if (FirebaseAuth.instance.currentUser?.uid != uid) return;
          await StudentProfileCloudService.savePhoto(encoded);
          if (!mounted || FirebaseAuth.instance.currentUser?.uid != uid) return;
          setState(() {
            _photoBase64 = encoded;
            _message = 'Photo enregistrée et synchronisée dans ton compte.';
          });
        } catch (_) {
          if (!mounted || FirebaseAuth.instance.currentUser?.uid != uid) return;
          setState(() {
            _photoBase64 = encoded;
            _message = 'Photo gardée sur cet appareil. Synchronisation cloud indisponible.';
          });
        }
      } else {
        if (!mounted) return;
        setState(() {
          _photoBase64 = encoded;
          _message = 'Photo enregistrée sur cet appareil.';
        });
      }
    } catch (_) {
      if (mounted && FirebaseAuth.instance.currentUser?.uid == uid) {
        setState(() => _message = 'Impossible de sélectionner cette photo. Réessaie.');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _removePhoto() async {
    if (_saving) return;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final key = _localKeyFor(uid);
    setState(() {
      _saving = true;
      _message = null;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
      if (uid != null && FirebaseAuth.instance.currentUser?.uid == uid) {
        await StudentProfileCloudService.deletePhoto();
      }
      if (!mounted || FirebaseAuth.instance.currentUser?.uid != uid) return;
      setState(() {
        _photoBase64 = null;
        _message = 'Photo supprimée.';
      });
    } catch (_) {
      if (mounted && FirebaseAuth.instance.currentUser?.uid == uid) {
        setState(() => _message =
            'Photo supprimée de cet appareil, mais sa suppression cloud a échoué.');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? image;
    if (_photoBase64 != null) {
      try {
        image = MemoryImage(base64Decode(_photoBase64!));
      } catch (_) {
        image = null;
      }
    }

    return Column(
      children: [
        CircleAvatar(
          radius: 52,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          backgroundImage: image,
          child: image == null
              ? const Icon(Icons.person, size: 52)
              : null,
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: _loading || _saving ? null : _choosePhoto,
          icon: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.photo_library_outlined),
          label: Text(_saving ? 'Patiente…' : 'Choisir une photo'),
        ),
        if (_photoBase64 != null)
          TextButton.icon(
            onPressed: _saving ? null : _removePhoto,
            icon: const Icon(Icons.delete_outline),
            label: const Text('Supprimer la photo'),
          ),
        if (_message != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _message!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
      ],
    );
  }
}
