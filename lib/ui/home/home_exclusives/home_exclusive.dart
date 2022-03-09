import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/ui/home/home_view_model.dart';
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
                image: _singleEx.image!,
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
