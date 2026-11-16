import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../features/home/home_screen.dart';
import '../../features/subjects/subjects_screen.dart';
import '../../features/progress/progress_screen.dart';
import '../../features/voice/voice_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../core/theme/app_colors.dart';

class MainScaffold extends StatefulWidget { const MainScaffold({super.key}); @override State<MainScaffold> createState() => _MainScaffoldState(); }
class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;
  final _screens = const [HomeScreen(), SubjectsScreen(), VoiceScreen(), ProgressScreen(), ProfileScreen()];
  @override Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(body: IndexedStack(index: _currentIndex, children: _screens), bottomNavigationBar: Container(
      decoration: BoxDecoration(border: Border(top: BorderSide(color: isDark ? AppColors.outlineVariantDark : AppColors.outlineVariant, width: 1))),
      child: BottomNavigationBar(currentIndex: _currentIndex, onTap: (index) => setState(() => _currentIndex = index), type: BottomNavigationBarType.fixed, selectedFontSize: 12, unselectedFontSize: 11,
        items: [
          BottomNavigationBarItem(icon: Icon(PhosphorIconsRegular.house), activeIcon: Icon(PhosphorIconsFill.house), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(PhosphorIconsRegular.bookOpen), activeIcon: Icon(PhosphorIconsFill.bookOpen), label: 'Matières'),
          BottomNavigationBarItem(icon: Icon(PhosphorIconsRegular.microphone), activeIcon: Icon(PhosphorIconsFill.microphone), label: 'Vocal'),
          BottomNavigationBarItem(icon: Icon(PhosphorIconsRegular.chartLineUp), activeIcon: Icon(PhosphorIconsFill.chartLineUp), label: 'Progrès'),
          BottomNavigationBarItem(icon: Icon(PhosphorIconsRegular.user), activeIcon: Icon(PhosphorIconsFill.user), label: 'Profil'),
        ]),
    ));
  }
}
