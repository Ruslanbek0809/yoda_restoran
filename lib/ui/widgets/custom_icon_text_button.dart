import 'package:flutter/material.dart';
import '../../shared/app_colors.dart';
import '../../utils/utils.dart';

class CustomIconTextButton extends StatelessWidget {
  final Widget text;
  final Color backgroundColor;
  final Widget icon;
  final Function onPressed;
  CustomIconTextButton(
      {required this.text,
      this.backgroundColor = kcPrimaryColor,
      required this.icon,
      required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        primary: kcSecondaryLightColor, // ripple effect color
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppTheme().radius10),
        padding: EdgeInsets.all(0.0),
      ),
      icon: icon,
      label: text,
      onPressed: onPressed as void Function(),
    );
  }
}
