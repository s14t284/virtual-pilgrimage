import 'package:flutter/material.dart';

class RankingTabBars extends StatelessWidget with PreferredSizeWidget {
  const RankingTabBars({required this.tabBars, super.key});

  final List<TabBar> tabBars;

  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[];
    for (final tb in tabBars) {
      widgets
        ..add(const SizedBox(height: 8))
        ..add(tb);
    }
    return Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: widgets);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kBottomNavigationBarHeight * 2.5);
}
