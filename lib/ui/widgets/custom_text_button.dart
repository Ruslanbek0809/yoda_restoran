import 'package:flutter/material.dart';
import 'package:yoda_res/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final Color color;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final Function onPressed;
  CustomTextButton(
      {required this.text,
      this.color = AppTheme.MAIN,
      this.textStyle,
      this.padding,
      this.borderRadius,
      required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: color,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? AppTheme().radius15),
        padding: padding ?? EdgeInsets.all(0.0),
        // primary: color,
        // onSurface: color,
        // shadowColor: color,
        // minimumSize: Size(width!, height!),
      ),
      child: Text(
        text,
        style: textStyle ??
            TextStyle(
              color: AppTheme.WHITE,
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
            ),
      ),
      onPressed: onPressed as void Function(),
    );
  }
}
