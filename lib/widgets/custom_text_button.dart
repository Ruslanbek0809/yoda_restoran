import 'package:flutter/material.dart';
import '../utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function onPressed;
  CustomTextButton(
      {required this.text,
      this.color = AppTheme.MAIN,
      required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: onPressed as void Function(),
    );
  }
}
