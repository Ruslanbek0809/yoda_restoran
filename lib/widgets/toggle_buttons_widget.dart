import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoda_res/utils/utils.dart';

class ToggleButtonWidget extends StatefulWidget {
  final Function(bool)? toggleCallback;
  ToggleButtonWidget({this.toggleCallback});
  @override
  _ToggleButtonWidgetState createState() => _ToggleButtonWidgetState();
}

class _ToggleButtonWidgetState extends State<ToggleButtonWidget> {
  bool isDelivery = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
        onTap: () {
          setState(() {
            isDelivery = !isDelivery;
            widget.toggleCallback!(isDelivery);
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.MAIN_LIGHT,
            borderRadius: AppTheme().radius15,
          ),
          height: 44.h,
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
          child: Stack(
            children: [
              AnimatedAlign(
                alignment: Alignment(isDelivery ? -1 : 1, 0),
                duration: Duration(milliseconds: 300),
                child: Container(
                  width: constraints.maxWidth / 2,
                  decoration: BoxDecoration(
                    color: AppTheme.WHITE,
                    borderRadius: AppTheme().radius15,
                  ),
                ),
              ),
              Align(
                alignment: Alignment(-1, 0),
                child: Container(
                  width: constraints.maxWidth / 2,
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
                  width: constraints.maxWidth / 2,
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
    });
  }
}
