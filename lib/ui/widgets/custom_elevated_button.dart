import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../shared/app_colors.dart';

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
      this.color = kcPrimaryColor,
      required this.text,
      required this.borderRadius,
      this.isLoading = false,
      this.elevation = 3,
      required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: color,
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
              child: CircularProgressIndicator(backgroundColor: kcWhiteColor),
            )
          : Text(
              text,
              style: TextStyle(
                color: kcWhiteColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }
}
