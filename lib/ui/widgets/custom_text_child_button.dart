import 'package:flutter/material.dart';
import '../../shared/shared.dart';
import '../../utils/utils.dart';

class CustomTextChildButton extends StatelessWidget {
  final Widget child;
  final Color color;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final Function onPressed;
  CustomTextChildButton({
    required this.child,
    this.color = kcPrimaryColor,
    this.padding,
    this.borderRadius,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          backgroundColor: color,
          foregroundColor: kcSecondaryLightColor, // ripple effect color
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? AppTheme().radius15,
          ),
          padding: padding ?? EdgeInsets.all(0.0)
          // shadowColor: color,
          // minimumSize: Size(width!, height!),
          ),
      child: child,
      onPressed: onPressed as void Function(),
    );
  }
}
