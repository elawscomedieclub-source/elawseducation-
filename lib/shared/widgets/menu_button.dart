import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

final GlobalKey<ScaffoldState> profTogoScaffoldKey = GlobalKey<ScaffoldState>();

class ProfTogoMenuButton extends StatelessWidget {
  const ProfTogoMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
      child: IconButton(
        tooltip: 'Ouvrir le menu',
        icon: const Icon(Icons.menu_rounded, size: 23),
        style: IconButton.styleFrom(
          fixedSize: const Size(42, 42),
          backgroundColor: isDark ? AppColors.surfaceVariantDark : AppColors.primaryContainer,
          foregroundColor: isDark ? AppColors.primaryDark : AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: () => profTogoScaffoldKey.currentState?.openDrawer(),
      ),
    );
  }
}
