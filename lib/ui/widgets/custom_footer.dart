import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../shared/shared.dart';

class CustomFooterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomFooter(
      height: 50.h,
      builder: (BuildContext context, LoadStatus? mode) {
        if (mode == LoadStatus.loading || mode == LoadStatus.canLoading)
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
