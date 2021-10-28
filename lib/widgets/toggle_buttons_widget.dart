import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoda_res/utils/utils.dart';

class ToggleButtonWidget extends StatefulWidget {
  @override
  _ToggleButtonWidgetState createState() => _ToggleButtonWidgetState();
}

class _ToggleButtonWidgetState extends State<ToggleButtonWidget> {
  double halfWidth = 0.5.sw;
  bool isDelivery = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isDelivery = !isDelivery;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.MAIN_LIGHT,
          borderRadius: AppTheme().buttonBorderRadius,
        ),
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.w),
        child: Stack(
          children: [
            AnimatedAlign(
              alignment: Alignment(isDelivery ? -1 : 1, 0),
              duration: Duration(milliseconds: 300),
              child: Container(
                width: halfWidth,
                height: 45.w,
                decoration: BoxDecoration(
                  color: AppTheme.WHITE,
                  borderRadius: AppTheme().buttonBorderRadius,
                ),
              ),
            ),
            Align(
              alignment: Alignment(-1, 0),
              child: Container(
                width: halfWidth,
                padding: EdgeInsets.symmetric(vertical: 12.5.w),
                alignment: Alignment.center,
                child: Text(
                  'Eltip bermek',
                  style: TextStyle(
                    fontSize: 17.sp,
                    color: !isDelivery
                        ? AppTheme.FONT_GREY_COLOR
                        : AppTheme.FONT_COLOR,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(1, 0),
              child: Container(
                width: halfWidth,
                padding: EdgeInsets.symmetric(vertical: 12.5.w),
                alignment: Alignment.center,
                child: Text(
                  'Özüm aljak',
                  style: TextStyle(
                    fontSize: 17.sp,
                    color: isDelivery
                        ? AppTheme.FONT_GREY_COLOR
                        : AppTheme.FONT_COLOR,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
