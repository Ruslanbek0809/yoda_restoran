import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/utils.dart';

class CustomIconButton extends StatelessWidget {
  final IconData iconData;
  final Function onTap;
  const CustomIconButton({
    required this.iconData,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.WHITE,
      shape: CircleBorder(),
      elevation: 5,
      child: InkWell(
        customBorder: CircleBorder(),
        onTap: onTap as void Function()?,
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: Icon(
            iconData,
            size: 27.w,
            color: AppTheme.BLACK,
          ),
        ),
      ),
    );
  }
}
