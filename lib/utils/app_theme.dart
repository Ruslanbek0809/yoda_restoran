import 'package:flutter/material.dart';

class AppTheme {
  /// Colors
  static const Color MAIN = Color(0xFFFF7910);
  static const Color MAIN_LIGHT = Color(0xFFF1F0ED);
  static const Color MAIN_DARK = Color(0xFF41413E);
  static const Color DRAWER = Color(0xFF9D9B98);
  static const Color DRAWER_DIVIDER = Color(0xFFCCCCCC);
  static const Color GREEN = Color(0xFF76C03F);
  static const Color RED = Color(0xFFE64F3A);
  static const Color BLACK = Color(0xFF000000);
  static const Color WHITE = Color(0xFFFFFFFF);

  /// Vertical & Horizontal Spaces
  static const double _VerticalSpaceExtraSmall = 4.0;
  static const double _VerticalSpaceSmall = 8.0;
  static const double _VerticalSpaceMedium = 16.0;
  static const double _VerticalSpaceLarge = 24.0;
  static const double _VerticalSpaceExtraLarge = 48;

  static const double _HorizontalSpaceExtraSmall = 4;
  static const double _HorizontalSpaceSmall = 8.0;
  static const double _HorizontalSpaceMedium = 16.0;
  static const double _HorizontalSpaceLarge = 24.0;
  static const double _HorizontalSpaceExtraLarge = 48.0;

  static SizedBox verticalSpaceExtraSmall() =>
      verticalSpace(_VerticalSpaceExtraSmall);
  static SizedBox verticalSpaceSmall() => verticalSpace(_VerticalSpaceSmall);
  static SizedBox verticalSpaceMedium() => verticalSpace(_VerticalSpaceMedium);
  static SizedBox verticalSpaceLarge() => verticalSpace(_VerticalSpaceLarge);
  static SizedBox verticalSpaceExtraLarge() =>
      verticalSpace(_VerticalSpaceExtraLarge);

  static SizedBox verticalSpace(double height) => SizedBox(height: height);

  static SizedBox horizontalSpaceExtraSmall() =>
      horizontalSpace(_HorizontalSpaceExtraSmall);
  static SizedBox horizontalSpaceSmall() =>
      horizontalSpace(_HorizontalSpaceSmall);
  static SizedBox horizontalSpaceMedium() =>
      horizontalSpace(_HorizontalSpaceMedium);
  static SizedBox horizontalSpaceLarge() =>
      horizontalSpace(_HorizontalSpaceLarge);
  static SizedBox horizontalSpaceExtraLarge() =>
      horizontalSpace(_HorizontalSpaceExtraLarge);

  static SizedBox horizontalSpace(double width) => SizedBox(width: width);

  /// Shadows
  // BoxShadow get mainShadow => BoxShadow(
  //     color: MAIN_LIGHT.withOpacity(0.25),
  //     offset: const Offset(1.1, 1.1),
  //     blurRadius: 6.0);

  BoxShadow get buttonShadow => BoxShadow(
        color: MAIN_LIGHT.withOpacity(0.5),
        offset: const Offset(1.1, 1.1),
      );

  BoxShadow get searchShadow => BoxShadow(
        color: AppTheme.MAIN_DARK.withOpacity(0.15),
        blurRadius: 5.0,
        offset: const Offset(1.1, 1.1),
      );

  // BoxShadow get buttonShadow => BoxShadow(
  //       color: MAIN,
  //       blurRadius: 4,
  //       offset: Offset(1, 1),
  //     );

  BoxShadow get smallShadow => BoxShadow(
        color: MAIN.withOpacity(0.4),
        spreadRadius: 4,
        blurRadius: 5,
        offset: Offset(0, 3),
      );

  /// Radiuses
  BorderRadius get mainBorderRadius => BorderRadius.circular(20.0);
  BorderRadius get buttonBorderRadius => BorderRadius.circular(15.0);
  BorderRadius get iconRadius => BorderRadius.circular(10.0);
  BorderRadius get containerRadius => BorderRadius.circular(10.0);
}
