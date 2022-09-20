import 'package:flutter/material.dart';

import '../shared/shared.dart';

class AppTheme {
  static const Color GREEN_COLOR = Color(0xFF76C03F);
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

  BoxShadow get buttonShadow => BoxShadow(
        color: kcSecondaryDarkColor.withOpacity(0.5),
        blurRadius: 3.0,
        offset: const Offset(1.1, 1.1),
      );

  BoxShadow get fillShadow => BoxShadow(
        offset: Offset(0, 1),
        color: Colors.black12,
        blurRadius: 3,
      );

  BoxShadow get searchShadow => BoxShadow(
        color: kcSecondaryDarkColor.withOpacity(0.125),
        blurRadius: 4.0,
        offset: const Offset(1.1, 1.1),
      );

  BoxShadow get toggleShadow => BoxShadow(
        color: kcSecondaryDarkColor.withOpacity(0.075),
        blurRadius: 2.0,
        offset: const Offset(1, 1),
      );

  BoxShadow get bottomCartShadow => BoxShadow(
        color: kcSecondaryDarkColor.withOpacity(0.2),
        blurRadius: 4.0,
        offset: const Offset(0.0, 1.1),
      );

  BoxShadow get tabBarShadow => BoxShadow(
        color: kcSecondaryDarkColor.withOpacity(0.045),
        blurRadius: 20,
        spreadRadius: 5,
        offset: const Offset(0, 20),
      );

  BoxShadow get resBottomShadow => BoxShadow(
        color: kcSecondaryDarkColor.withOpacity(0.2),
        blurRadius: 2.0,
        offset: const Offset(0.0, 1.1),
      );

  /// OutlineInputBorder
  OutlineInputBorder get cardOutlineInputBorder => OutlineInputBorder(
        borderRadius: radius10,
        borderSide: BorderSide(
          color: kcDividerColor,
          width: 1,
        ),
      );

  /// Radiuses
  BorderRadius get radius20 => BorderRadius.circular(20.0);
  BorderRadius get radius15 => BorderRadius.circular(15.0);
  BorderRadius get radius16 => BorderRadius.circular(16.0);
  BorderRadius get radius12 => BorderRadius.circular(12.0);
  BorderRadius get radius10 => BorderRadius.circular(10.0);
  BorderRadius get radius5 => BorderRadius.circular(5.0);
}
