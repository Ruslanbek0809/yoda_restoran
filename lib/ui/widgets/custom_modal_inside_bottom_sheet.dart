import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoda_res/shared/shared.dart';

class CustomModalInsideBottomSheet extends StatelessWidget {
  const CustomModalInsideBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4.h,
      alignment: Alignment.center,
      margin: EdgeInsets.only(
        top: 14.h,
        bottom: 12.h,
        left: 0.5.sw - 24,
        right: 0.5.sw - 24,
      ),
      decoration: BoxDecoration(
        color: kcSecondaryLightColor,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
