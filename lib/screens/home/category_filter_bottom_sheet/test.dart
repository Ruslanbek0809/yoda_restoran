import 'package:flutter/material.dart';
import 'package:yoda_res/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryFilterButtonWidget extends StatefulWidget {
  @override
  _CategoryFilterButtonWidgetState createState() =>
      _CategoryFilterButtonWidgetState();
}

class _CategoryFilterButtonWidgetState extends State<CategoryFilterButtonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: Duration(milliseconds: 100), vsync: this);
    _animation = IntTween(begin: 0, end: 100).animate(_animationController);
    _animation.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: <Widget>[
          Expanded(
            flex: _animation.value,
            child: SizedBox(
              width: 0.0,
              child: OutlinedButton(
                child: FittedBox(child: Text("Left")),
                onPressed: () {},
              ),
            ),
          ),
          Expanded(
            flex: 100,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: AppTheme.MAIN,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: AppTheme().buttonBorderRadius),
                padding: EdgeInsets.symmetric(vertical: 17.w),
                // primary: color,
                // onSurface: color,
                // shadowColor: color,
                // minimumSize: Size(width!, height!),
              ),
              child: Text(
                "Right",
                style: TextStyle(
                  color: AppTheme.WHITE,
                  fontSize: 18.sp,
                ),
              ),
              onPressed: () {
                if (_animationController.value == 0.0) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
