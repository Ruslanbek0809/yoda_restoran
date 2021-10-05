import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoda_res/utils/utils.dart';

class ToggleButton extends StatefulWidget {
  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  double height = 35.w;
  double halfWidth = 0.5.sw;
  bool isDelivery = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          GestureDetector(
            onTap: () {
              if (!isDelivery)
                setState(() {
                  isDelivery = true;
                });
            },
            child: Align(
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
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isDelivery = false;
              });
            },
            child: Align(
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
          ),
        ],
      ),
    );
  }
}
