import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/shared/app_colors.dart';
import 'package:yoda_res/ui/home/home_view_model.dart';

List<String> moments = [
  'https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg',
  'https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif',
];

class MomentsView extends ViewModelWidget<HomeViewModel> {
  @override
  Widget build(BuildContext context, HomeViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 16.r,
            top: 12.r,
          ),
          child: Text(
            'Moments',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: kcSecondaryDarkColor,
            ),
          ),
        ),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(
            top: 6.r,
            left: 16.r,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: moments
                // .take(10)
                .map(
                  (moment) => Padding(
                    padding: EdgeInsets.only(right: 12.r),
                    child: GestureDetector(
                      onTap: model.navToMomentStoryView,
                      child: CachedNetworkImage(
                        imageUrl: 'assets/ph_product.png',
                        fit: BoxFit.cover,
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          backgroundColor: kcDividerSecondaryColor,
                          radius: 30.5,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: imageProvider,
                          ),
                        ),
                        placeholder: (context, url) => CircleAvatar(
                          backgroundColor: kcDividerSecondaryColor,
                          radius: 30.5,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                AssetImage('assets/ph_product.png'),
                          ),
                        ),
                        errorWidget: (context, url, error) => CircleAvatar(
                          backgroundColor: kcDividerSecondaryColor,
                          radius: 30.5,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                AssetImage('assets/ph_product.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
