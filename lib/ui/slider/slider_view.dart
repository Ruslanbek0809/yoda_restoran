import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
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
      builder: (context, model, child) => Expanded(
        child: CarouselSlider(
          options: CarouselOptions(
            autoPlay: false,
            aspectRatio: 2,
            viewportFraction:
                1.0, // The fraction of the viewport that each page should occupy
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.scale,
          ),
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
      ),
      viewModelBuilder: () => SliderViewModel(),
    );
  }
}
