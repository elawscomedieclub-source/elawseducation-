import 'package:flutter/material.dart';

final GlobalKey<ScaffoldState> profTogoScaffoldKey = GlobalKey<ScaffoldState>();

class ProfTogoMenuButton extends StatelessWidget {
  const ProfTogoMenuButton({super.key});
  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: 'Ouvrir le menu',
    icon: const Icon(Icons.menu),
    onPressed: () => profTogoScaffoldKey.currentState?.openDrawer(),
  );
}
