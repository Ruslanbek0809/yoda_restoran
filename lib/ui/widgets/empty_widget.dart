import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyWidget extends StatelessWidget {
  final String? text;
  final String? svg;
  final double? leftPadding;
  const EmptyWidget({
    this.text,
    this.svg,
    this.leftPadding,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        Positioned(
          left: leftPadding,
          child: SvgPicture.asset(svg!),
        ),
      ],
    );
  }
}
