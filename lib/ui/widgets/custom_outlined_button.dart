import 'package:flutter/material.dart';
import 'package:yoda_res/utils/utils.dart';

class CustomOutlinedButton extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? color;
  final String? text;
  final double? borderRadius;
  final bool isLoading;
  final Function? onPressed;
  CustomOutlinedButton(
      {this.height,
      this.width,
      this.color,
      this.text,
      this.borderRadius,
      this.isLoading = false,
      this.onPressed});
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        primary: color ?? AppTheme.MAIN,
        onSurface: color ?? AppTheme.MAIN,
        shadowColor: color ?? AppTheme.MAIN,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: borderRadius as BorderRadiusGeometry? ??
                AppTheme().radius15),
        // minimumSize: Size(width!, height!),
      ),
      onPressed: onPressed as void Function()?,
      child: isLoading
          ? Padding(
              padding: const EdgeInsets.all(5.0),
              child: CircularProgressIndicator(backgroundColor: AppTheme.WHITE),
            )
          : Text(
              text!,
              style: TextStyle(
                color: AppTheme.WHITE,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }
}
