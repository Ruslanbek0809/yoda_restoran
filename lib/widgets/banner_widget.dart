import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoda_res/utils/utils.dart';
import 'widgets.dart';

class BannerWidget extends StatelessWidget {
  final List<String> imgList;
  const BannerWidget({
    required this.imgList,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: false,
          aspectRatio: 2.5,
          // viewportFraction:
          //     1.0, // The fraction of the viewport that each page should occupy
          enlargeCenterPage: true,
          enlargeStrategy: CenterPageEnlargeStrategy.scale,
        ),
        items: imgList
            .map(
              (item) => YodaImage(
                image: item,
                width: 1.sw,
                borderRadius: Constants.BORDER_RADIUS_MAIN,
              ),
            )
            .toList(),
      ),
    );
  }
}
