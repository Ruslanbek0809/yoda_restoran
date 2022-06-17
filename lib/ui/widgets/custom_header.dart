import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../shared/shared.dart';

class CustomHeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      height: 50.h,
      builder: (BuildContext context, RefreshStatus? mode) {
        if (mode == RefreshStatus.refreshing ||
            mode == RefreshStatus.canRefresh ||
            mode == RefreshStatus.completed)
          return SpinKitChasingDots(
            size: 27,
            color: kcPrimaryColor,
          );
        else
          return SizedBox();
      },
    );
  }
}
