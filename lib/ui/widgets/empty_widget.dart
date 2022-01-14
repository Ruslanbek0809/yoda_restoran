import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yoda_res/shared/shared.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyWidget extends StatelessWidget {
  final String? text;
  final String? svg;
  const EmptyWidget({this.text, this.svg, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text!, style: kts18Text),
        SvgPicture.asset(
          svg!,
          width: 1.sw,
          height: 0.6.sh,
        ),
      ],
    );
  }
}
