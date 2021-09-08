import 'package:flutter/material.dart';
import 'package:yoda_res/utils/utils.dart';

class ListTab {
  /// Create a new [ListTab]
  const ListTab(
      {Key? key,
      this.icon,
      required this.tabLabel,
      required this.innerLabel,
      this.borderRadius = const BorderRadius.all(const Radius.circular(10.0)),
      this.activeBackgroundColor = AppTheme.MAIN,
      this.inactiveBackgroundColor = AppTheme.MAIN_LIGHT,
      this.showIconOnList = false,
      this.borderColor = Colors.transparent});

  /// Trailing widget for a tab, typically an [Icon].
  final Widget? icon;

  /// Tab label to be shown in the tab, must be non-null.
  final Widget tabLabel;

  /// Inner label to be shown in the inner part, must be non-null.
  final Widget innerLabel;

  /// [BorderRadius] for the a tab at the bottom tab view.
  /// This won't affect the tab in the scrollable list.
  final BorderRadiusGeometry borderRadius;

  /// Color to be used when the tab is selected.
  final Color activeBackgroundColor;

  /// Color to be used when tab is not selected
  final Color inactiveBackgroundColor;

  /// If true, the [icon] will also be shown to the user in the scrollable list.
  final bool showIconOnList;

  /// Color of the [Border] property of the inner tab [Container].
  final Color borderColor;
}
