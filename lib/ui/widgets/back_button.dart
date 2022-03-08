import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoda_res/shared/shared.dart';

class BackButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: Icon(
        Platform.isIOS
            ? Icons.arrow_back_ios_new_rounded
            : Icons.arrow_back_rounded,
        size: 24.w,
        color: kcSecondaryDarkColor,
      ),
    );
  }
}
