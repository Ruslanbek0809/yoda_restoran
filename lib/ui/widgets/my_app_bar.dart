import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget child;

  const MyAppbar({required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: preferredSize.height,
      child: child,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(76.h);
}
