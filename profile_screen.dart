import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../data/sample/sample_data.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final progress = SampleData.demoProgress;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Mon profil')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Avatar + info
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor: AppColors.primary.withOpacity(0.15),
                  child: Icon(PhosphorIconsFill.student, size: 44, color: AppColors.primary),
                ),
                const SizedBox(height: 12),
                Text(
                  'Élève Démo',
                  style: theme.textTheme.headlineMedium,
                ),
                Text(
                  'Classe de ${progress.level.label}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Theme
          Text('Apparence', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(value: ThemeMode.light, label: Text('Clair'), icon: Icon(Icons.light_mode)),
              ButtonSegment(value: ThemeMode.dark, label: Text('Sombre'), icon: Icon(Icons.dark_mode)),
              ButtonSegment(value: ThemeMode.system, label: Text('Auto'), icon: Icon(Icons.brightness_auto)),
            ],
            selected: {themeMode},
            onSelectionChanged: (s) {
              ref.read(themeModeProvider.notifier).setTheme(s.first);
            },
          ),
          const SizedBox(height: 28),

          // Stats
          ListTile(
            leading: Icon(PhosphorIconsRegular.trophy, color: AppColors.secondary),
            title: const Text('XP total'),
            trailing: Text('${progress.totalXp}', style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
          ListTile(
            leading: Icon(PhosphorIconsRegular.flame, color: AppColors.accent),
            title: const Text('Série actuelle'),
            trailing: Text('${progress.currentStreak} jours', style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
          ListTile(
            leading: Icon(PhosphorIconsRegular.chartLineUp, color: AppColors.primary),
            title: const Text('Meilleure série'),
            trailing: Text('${progress.longestStreak} jours', style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
          const Divider(height: 32),

          // Actions
          ListTile(
            leading: Icon(PhosphorIconsRegular.gear),
            title: const Text('Paramètres'),
            trailing: Icon(PhosphorIconsRegular.caretRight),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(PhosphorIconsRegular.info),
            title: const Text('À propos de ProfTogo'),
            trailing: Icon(PhosphorIconsRegular.caretRight),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'ProfTogo',
                applicationVersion: '1.0.0',
                applicationLegalese: 'Application éducative pour les élèves togolais\n6ème → Terminale',
              );
            },
          ),
        ],
      ),
    );
  }
}
