import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/shared/app_colors.dart';
import 'package:yoda_res/utils/utils.dart';
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
          Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: CarouselSlider(
              carouselController: model.carouselController,
              options: CarouselOptions(
                  autoPlay: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 1250),
                  autoPlayInterval: const Duration(seconds: 3),
                  aspectRatio: 2,
                  viewportFraction:
                      0.92, // The fraction of the viewport that each page should occupy
                  enlargeCenterPage: false, // To enlarge when slider in center
                  enlargeStrategy: CenterPageEnlargeStrategy.scale,
                  onPageChanged: (index, reason) {
                    model.updateActiveIndex(index);
                  }),
              items: sliders
                  .map(
                    (slider) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: GestureDetector(
                        onTap: () async {},
                        child: YodaImage(
                          image: slider.image!,
                          phImage: 'assets/ph_slider.png',
                          fit: BoxFit.cover,
                          width: 1.sw,
                          height: 0.6.sw,
                          borderRadius: 20.0,
                        ),
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
          ),
          Padding(
            padding: EdgeInsets.only(top: 7.h),
            child: AnimatedSmoothIndicator(
              count: sliders.length,
              activeIndex: model.activeIndex,
              effect: ScrollingDotsEffect(
                activeDotColor: kcActiveDotColor,
                dotColor: kcDividerSecondaryColor,
                maxVisibleDots: 5,
                radius: 6.h,
                spacing: 6,
                dotHeight: 6.h,
                dotWidth: 6.h,
                activeDotScale: 1.2,
              ),
            ),
          )
        ],
      ),
      viewModelBuilder: () => SliderViewModel(),
    );
  }
}
