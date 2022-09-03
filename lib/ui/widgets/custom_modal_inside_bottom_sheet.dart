import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../shared/shared.dart';

class CustomModalInsideBottomSheet extends StatelessWidget {
  final bool isOuterPaddingExist;
  final double? leftOuterPadding;
  final double? rightOuterPadding;
  const CustomModalInsideBottomSheet({
    Key? key,
    this.isOuterPaddingExist = false,
    this.leftOuterPadding,
    this.rightOuterPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4.h,
      alignment: Alignment.center,
      margin: EdgeInsets.only(
        top: 12.h,
        bottom: 12.h,
        left:
            isOuterPaddingExist ? 0.5.sw - 24 - leftOuterPadding! : 0.5.sw - 24,
        right: isOuterPaddingExist
            ? 0.5.sw - 24 - rightOuterPadding!
            : 0.5.sw - 24,
      ),
      decoration: BoxDecoration(
        color: kcSecondaryLightColor,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
