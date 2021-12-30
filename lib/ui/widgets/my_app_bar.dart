import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget child;

  const MyAppbar({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      padding: EdgeInsets.only(top: 20.h),
      child: child,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(86.h);
}
