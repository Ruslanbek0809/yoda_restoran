import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/ui/home/main_category/main_category_view_model.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import '../../../models/models.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/utils.dart';

class MainCategoryItem extends ViewModelWidget<MainCategoryViewModel> {
  final MainCategory? mainCategory;
  final int pos;
  final int homeCatLength;
  MainCategoryItem({
    Key? key,
    this.mainCategory,
    required this.pos,
    required this.homeCatLength,
  }) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, MainCategoryViewModel model) {
    // Tween<double> _tween = Tween(begin: 1, end: 0.95);
//     final _tweenController = useAnimationController(
//       duration: const Duration(milliseconds: 100),
//     )..addStatusListener(
//         (status) {
// //// This listener was used to repeat animation once
//           if (status == AnimationStatus.completed) {
//             _tweenController.reverse();
//           }
//         },
//       );
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1, end: 0.95),
      duration: const Duration(milliseconds: 100),
      builder: (BuildContext _, double value, Widget? __) => Container(
        width: 75.w,
        height: 75.w,
        margin: EdgeInsets.only(
            top: 5.w,
            left: pos == 0 ? 10.w : 0.w), // margin on top of persistent header
        color: AppTheme.WHITE,
        child: GestureDetector(
          onTap: model.updateMainCategoryItem,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: YodaImage(
                  image: mainCategory!.image!,
                  fit: BoxFit.cover,
                  width: 50.w,
                  height: 50.w,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 3.w),
                padding: EdgeInsets.symmetric(
                    horizontal: model.isUpdated ? 5.w : 0.0,
                    vertical: model.isUpdated ? 2.h : 0.0),
                decoration: BoxDecoration(
                  borderRadius: AppTheme().radius15,
                  color: model.isUpdated ? AppTheme.MAIN : AppTheme.WHITE,
                ),
                child: Text(
                  mainCategory!.name!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color:
                        model.isUpdated ? AppTheme.WHITE : AppTheme.FONT_COLOR,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
