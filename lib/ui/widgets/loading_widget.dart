import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:yoda_res/utils/utils.dart';

class LoadingWidget extends StatelessWidget {
  final double? width;
  LoadingWidget({this.width});
  @override
  Widget build(BuildContext context) {
    return SpinKitSpinningLines(
      size: width ?? 35.w,
      color: AppTheme.MAIN,
    );
  }
}
