import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';
import '../../features/home/home_screen.dart';
import '../../features/subjects/subjects_screen.dart';
import '../../features/progress/progress_screen.dart';
import '../../features/voice/voice_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../core/theme/app_colors.dart';
import 'menu_button.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});
  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;
  final _screens = const [HomeScreen(), SubjectsScreen(), VoiceScreen(), ProgressScreen(), ProfileScreen()];

  void _goTo(int index) {
    Navigator.of(context).pop();
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      key: profTogoScaffoldKey,
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                color: const Color(0xFF006A4E),
                child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  CircleAvatar(radius: 26, backgroundColor: Colors.white, child: Icon(Icons.auto_stories_rounded, color: Color(0xFF006A4E), size: 30)),
                  SizedBox(height: 12),
                  Text('PROFTOGO', style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w900, letterSpacing: 1.1)),
                  Text('APPRENDRE • PROGRESSER • RÉUSSIR', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: .5)),
                ]),
              ),
              _menuItem(Icons.home_outlined, 'Accueil', 0),
              _menuItem(Icons.menu_book_outlined, 'Matières et cours', 1),
              _menuItem(Icons.mic_none, 'Professeur vocal', 2),
              _menuItem(Icons.insights_outlined, 'Ma progression', 3),
              _menuItem(Icons.person_outline, 'Mon profil', 4),
              const Divider(),
              const ListTile(leading: Icon(Icons.info_outline), title: Text('À propos de PROFTOGO'), subtitle: Text('Application éducative pour le Togo')),
              const Spacer(),
              const Padding(padding: EdgeInsets.all(12), child: Text('APPRENDRE • COMPRENDRE • RÉUSSIR', style: TextStyle(color: Colors.grey, fontSize: 12))),
            ],
          ),
        ),
      ),
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(border: Border(top: BorderSide(color: isDark ? AppColors.outlineVariantDark : AppColors.outlineVariant, width: 1))),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: const Color(0xFF7B8982),
          selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900),
          unselectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
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

  Widget _menuItem(IconData icon, String label, int index) => ListTile(
    leading: Icon(icon),
    title: Text(label),
    selected: _currentIndex == index,
    selectedColor: const Color(0xFF006A4E),
    onTap: () => _goTo(index),
  );
}
