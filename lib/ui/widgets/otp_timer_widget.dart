import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import '../../shared/styles.dart';
import '../../utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';

class OtpTimerWidget extends StatelessWidget {
  final AnimationController controller;

  OtpTimerWidget(this.controller);

  String get timerString {
    Duration duration = controller.duration! * controller.value;
    if (duration.inHours > 0) {
      return '${duration.inHours}:${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    }
    return '${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  Duration get duration {
    Duration duration = controller.duration!;
    return duration;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.access_time,
              color: AppTheme.MAIN,
            ),
            SizedBox(width: 5.w),
            Text(
              LocaleKeys.sendCodeIn,
              style: kts16PrimaryText,
            ).tr(args: [timerString]),
          ],
        );
      },
    );
  }
}
