import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stacked/stacked.dart';
import '../../models/slider.dart';
import '../widgets/widgets.dart';

import 'slider_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SliderView extends StatelessWidget {
  final List<SliderModel> sliders;
  const SliderView({
    required this.sliders,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SliderViewModel>.reactive(
      builder: (context, model, child) => Column(
        children: [
          CarouselSlider(
            carouselController: model.carouselController,
            options: CarouselOptions(
                autoPlay: false,
                aspectRatio: 2,
                viewportFraction:
                    0.8, // The fraction of the viewport that each page should occupy
                enlargeCenterPage: true, // To enlarge when slider in center
                enlargeStrategy: CenterPageEnlargeStrategy.scale,
                onPageChanged: (index, reason) {
                  model.updateActiveIndex(index);
                }),
            items: sliders
                .map(
                  (slider) => GestureDetector(
                    onTap: () async {},
                    child: YodaImage(
                      image: slider.image!,
                      phImage: 'assets/ph_slider.png',
                      fit: BoxFit.fill,
                      width: 1.sw,
                      height: 0.625.sw,
                      borderRadius: 0.0,
                    ),
                  ),

                  /// Used with Stack
                  // Positioned.fill(
                  //   child: Material(
                  //     color: Colors.transparent,
                  //     child: InkWell(
                  //       onTap: () async {},
                  //     ),
                  //   ),
                  // ),
                )
                .toList(),
          ),
          AnimatedSmoothIndicator(
            count: sliders.length,
            activeIndex: model.activeIndex,
            effect: ScrollingDotsEffect(
              activeStrokeWidth: 2.6,
              activeDotScale: 1.3,
              maxVisibleDots: 5,
              radius: 8,
              spacing: 10,
              dotHeight: 12,
              dotWidth: 12,
            ),
          )
        ],
      ),
      viewModelBuilder: () => SliderViewModel(),
    );
  }
}
