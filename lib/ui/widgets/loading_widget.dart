import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../shared/shared.dart';

class LoadingWidget extends StatelessWidget {
  final double? width;
  LoadingWidget({this.width});
  @override
  Widget build(BuildContext context) {
    return SpinKitChasingDots(
      size: width ?? 0.15.sw,
      color: kcPrimaryColor,
    );
  }
}
