import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../home_view_model.dart';
import '../../widgets/widgets.dart';
import '../../../models/models.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/utils.dart';

class HomeExclusive extends ViewModelWidget<HomeViewModel> {
  final List<ExclusiveSingle> exlusiveSingles;
  const HomeExclusive({Key? key, required this.exlusiveSingles})
      : super(key: key);
  @override
  Widget build(BuildContext context, HomeViewModel model) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: exlusiveSingles.mapIndexed((_singleEx, pos) {
          return Padding(
            padding: EdgeInsets.fromLTRB(pos == 0 ? 16.w : 4.w, 6.h,
                pos == exlusiveSingles.length - 1 ? 16.w : 4.w, 0.h),
            child: GestureDetector(
              onTap: () => model.navToSingleExView(_singleEx),
              child: YodaImage(
                image: context.locale == context.supportedLocales[0]
                    ? _singleEx.image ?? 'assets/ph_restaurant.png'
                    : _singleEx.imageRu ?? 'assets/ph_restaurant.png',
                phImage: 'assets/ph_restaurant.png',
                fit: BoxFit.cover,
                width: 100.w,
                height: 100.w,
                borderRadius: Constants.BORDER_RADIUS_20,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
