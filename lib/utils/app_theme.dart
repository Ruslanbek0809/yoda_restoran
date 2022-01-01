import 'package:flutter/material.dart';

class AppTheme {
  /// Colors
  static const Color MAIN = Color(0xFFFF891D);
  static const Color MAIN_LIGHT = Color(0xFFF5F4F2);
  static const Color MAIN_DARK = Color(0xFF41413E);
  static const Color FONT_COLOR = Color(0xFF20201F);
  static const Color FONT_GREY_COLOR = Color(0xFF9F9D9A);
  static const Color STATUS_COLOR = Color(0xFF757575);
  static const Color BOTTOM_SHEET_FONT_COLOR = Color(0xFF787773);
  static const Color DRAWER_ICON = Color(0xFF9D9B98);
  static const Color DRAWER_DIVIDER = Color(0xFFCCCCCC);
  static const Color DRAWER_SECOND_DIVIDER_COLOR = Color(0xFFDDDDDD);
  static const Color MAIN_DIVIDER_COLOR = Color(0xFFFAF9F7);
  static const Color CONTACT_COLOR = Color(0xFF999999);
  static const Color FILL_COLOR = Color(0xFFF8F8F8);
  static const Color FILL_BORDER_COLOR = Color(0xFFBBBBBB);
  static const Color FILL_BORDER_SECOND_COLOR = Color(0xFFF1F0ED);
  static const Color TEXTFIELD_HINT_COLOR = Color(0xFF2C0909);
  static const Color BUTTON_BORDER_COLOR = Color(0xFF888888);
  static const Color TOGGLE_COLOR = Color(0xFFDDDDDB);
  static const Color DIALOG_TITLE_COLOR = Color(0xFF666666);
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
        color: MAIN_DARK.withOpacity(0.5),
        blurRadius: 3.0,
        offset: const Offset(1.1, 1.1),
      );

  BoxShadow get fillShadow => BoxShadow(
        offset: Offset(0, 1),
        color: Colors.black12,
        blurRadius: 3,
      );

  BoxShadow get searchShadow => BoxShadow(
        color: AppTheme.MAIN_DARK.withOpacity(0.125),
        blurRadius: 4.0,
        offset: const Offset(1.1, 1.1),
      );

  BoxShadow get bottomCartShadow => BoxShadow(
        color: AppTheme.MAIN_DARK.withOpacity(0.2),
        blurRadius: 4.0,
        offset: const Offset(0.0, 1.1),
      );

  /// Radiuses
  BorderRadius get radius20 => BorderRadius.circular(20.0);
  BorderRadius get radius15 => BorderRadius.circular(15.0);
  BorderRadius get radius12 => BorderRadius.circular(12.0);
  BorderRadius get radius10 => BorderRadius.circular(10.0);
  BorderRadius get radius5 => BorderRadius.circular(5.0);
}
