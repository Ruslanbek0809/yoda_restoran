import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class ColoredTabBar extends Container implements PreferredSizeWidget {
  ColoredTabBar({required this.tabBar, required this.isShrink});

  final TabBar tabBar;
  final bool isShrink;

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.WHITE,
          boxShadow: isShrink ? [AppTheme().tabBarShadow] : [],
        ),
        child: Row(children: [
          Flexible(child: tabBar)
        ]), // Here to fix tab issue, done workaround
      );
}
