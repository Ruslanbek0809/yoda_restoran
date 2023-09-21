import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/shared/app_colors.dart';
import 'package:yoda_res/ui/home/home_view_model.dart';

import '../../../shared/shared.dart';

enum MediaType { image, video, text }

class MomentModel {
  MomentModel({
    required this.type,
    this.caption,
    this.color,
    this.url,
    required this.duration,
    required this.createdAt,
  });
  final MediaType type;
  final String? caption;
  final String? color;
  final String? url;
  final int duration;
  final DateTime createdAt;
}

MediaType translateType(String? type) {
  if (type == "image") {
    return MediaType.image;
  }

  if (type == "video") {
    return MediaType.video;
  }

  return MediaType.text;
}

List<MomentModel> moments = [
  MomentModel(
    type: translateType('text'),
    caption:
        'Hello world!\nHave a look at some great Ghanaian delicacies. I\'m sorry if your mouth waters. \n\nTap!',
    color: '#FF891D',
    duration: 5,
    createdAt: DateTime.now().subtract(Duration(minutes: 30)),
  ),
  MomentModel(
    type: translateType('image'),
    url:
        'https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg',
    duration: 5,
    createdAt: DateTime.now().subtract(Duration(hours: 13)),
  ),
  MomentModel(
    type: translateType('video'),
    url:
        'https://raw.githubusercontent.com/blackmann/storyexample/master/assets/small.mp4',
    duration: 5,
    createdAt: DateTime.now().subtract(Duration(days: 6)),
  ),
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
            right: 12.r,
            top: 12.r,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Moments',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: kcSecondaryDarkColor,
                ),
              ),
              InkWell(
                onTap: model.navToMomentsAllView,
                child: Row(
                  children: [
                    Text(
                      'View all',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: kts14SemiBoldText,
                    ),
                    SizedBox(width: 5.w),
                    Icon(
                      Icons.arrow_forward,
                      size: 16.sp,
                    ),
                  ],
                ),
              ),
            ],
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
                      onTap: () async =>
                          await model.navToMomentStoryView(moments),
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
