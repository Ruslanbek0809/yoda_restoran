import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../shared/shared.dart';

class EmptyWidget extends StatelessWidget {
  final String? text;
  final String? svg;
  const EmptyWidget({
    this.text,
    this.svg,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(child: SvgPicture.asset(svg!)),
        SizedBox(height: 0.075.sh),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            text!,
            style: kts18ErrorEmptyText,
            textAlign: TextAlign.center,
          ).tr(),
        ),
      ],
    );
  }
}
