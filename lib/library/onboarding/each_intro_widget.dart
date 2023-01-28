import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../shared/shared.dart';
import '../../ui/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EachIntroWidget extends StatelessWidget {
  final String imageUrl;
  final String subTitle;

  EachIntroWidget({required this.imageUrl, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        YodaImage(
          image: imageUrl,
          fit: BoxFit.fill,
          width: 1.sw,
          height: 1.sh,
        ),
        Positioned(
          top: 0.1.sh,
          left: 0,
          right: 0,
          child: SvgPicture.asset('assets/title_yoda_restoran_onboarding.svg'),
        ),
        Positioned(
          bottom: 0.225.sh,
          width: 1.sw,
          child: Text(
            subTitle,
            maxLines: 3,
            textAlign: TextAlign.center,
            style: kts22BoldWhiteText,
          ),
        ),
      ],
    );
  }
}
