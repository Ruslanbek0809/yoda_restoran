import 'package:flutter/material.dart';
import '../utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final Color? color;
  final Function onPressed;
  CustomTextButton(
      {required this.text,
      this.color = AppTheme.MAIN,
      required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        primary: color,
        onSurface: color,
        shadowColor: color,
        backgroundColor: color,
        elevation: 0,
        shape:
            RoundedRectangleBorder(borderRadius: AppTheme().buttonBorderRadius),
        // padding: EdgeInsets.symmetric(vertical: 10.w)
        // minimumSize: Size(width!, height!),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppTheme.WHITE,
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: onPressed as void Function(),
    );
  }
}
