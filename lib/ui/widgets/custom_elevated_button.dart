import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/utils.dart';

class CustomElevatedButton extends StatelessWidget {
  final double height;
  final double width;
  final Color color;
  final String text;
  final double borderRadius;
  final bool isLoading;
  final double elevation;
  final Function onPressed;
  CustomElevatedButton(
      {required this.height,
      required this.width,
      this.color = AppTheme.MAIN,
      required this.text,
      required this.borderRadius,
      this.isLoading = false,
      this.elevation = 3,
      required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: color,
        onPrimary: color,
        onSurface: color,
        shadowColor: color,
        elevation: elevation,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)),
        minimumSize: Size(width, height),
      ),
      onPressed: onPressed as void Function(),
      child: isLoading
          ? Padding(
              padding: EdgeInsets.all(5.w),
              child: CircularProgressIndicator(backgroundColor: AppTheme.WHITE),
            )
          : Text(
              text,
              style: TextStyle(
                color: AppTheme.WHITE,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }
}
