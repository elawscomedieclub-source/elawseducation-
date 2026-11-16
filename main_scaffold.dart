import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../features/home/home_screen.dart';
import '../../features/subjects/subjects_screen.dart';
import '../../features/progress/progress_screen.dart';
import '../../features/voice/voice_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../core/theme/app_colors.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final _screens = const [
    HomeScreen(),
    SubjectsScreen(),
    VoiceScreen(),
    ProgressScreen(),
    ProfileScreen(),
  ];

  void _goTo(int index) {
    setState(() => _currentIndex = index);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProfTogo', style: TextStyle(fontWeight: FontWeight.w800)),
        centerTitle: false,
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                color: AppColors.primary,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      child: Text('PT', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w900)),
                    ),
                    SizedBox(height: 12),
                    Text('ProfTogo', style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold)),
                    Text('Apprendre, comprendre, réussir', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
              _drawerItem(context, PhosphorIconsRegular.house, 'Accueil', 0),
              _drawerItem(context, Icons.school, 'Classes et matières', 1),
              _drawerItem(context, Icons.menu_book, 'Cours et leçons', 1),
              _drawerItem(context, Icons.edit_note, 'Exercices', 1),
              _drawerItem(context, PhosphorIconsRegular.microphone, 'Professeur vocal', 2),
              _drawerItem(context, PhosphorIconsRegular.chartLineUp, 'Ma progression', 3),
              const Divider(height: 20),
              _drawerItem(context, PhosphorIconsRegular.user, 'Mon profil', 4),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('ProfTogo • Version 1.0', style: Theme.of(context).textTheme.bodySmall),
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(
            color: isDark ? AppColors.outlineVariantDark : AppColors.outlineVariant,
            width: 1,
          )),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 11,
          items: [
            BottomNavigationBarItem(icon: Icon(PhosphorIconsRegular.house), activeIcon: Icon(PhosphorIconsFill.house), label: 'Accueil'),
            BottomNavigationBarItem(icon: Icon(PhosphorIconsRegular.bookOpen), activeIcon: Icon(PhosphorIconsFill.bookOpen), label: 'Matières'),
            BottomNavigationBarItem(icon: Icon(PhosphorIconsRegular.microphone), activeIcon: Icon(PhosphorIconsFill.microphone), label: 'Vocal'),
            BottomNavigationBarItem(icon: Icon(PhosphorIconsRegular.chartLineUp), activeIcon: Icon(PhosphorIconsFill.chartLineUp), label: 'Progrès'),
            BottomNavigationBarItem(icon: Icon(PhosphorIconsRegular.user), activeIcon: Icon(PhosphorIconsFill.user), label: 'Profil'),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(BuildContext context, IconData icon, String label, int index) {
    final selected = _currentIndex == index;
    return ListTile(
      leading: Icon(icon, color: selected ? AppColors.primary : null),
      title: Text(label, style: TextStyle(fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
      selected: selected,
      selectedTileColor: AppColors.primary.withOpacity(.08),
      onTap: () => _goTo(index),
    );
  }
}
