import 'package:flutter/material.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:yoda_res/ui/home/main_category/main_category_view_model.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import '../../../models/models.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/utils.dart';

class MainCategoryItem extends HookViewModelWidget<MainCategoryViewModel> {
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
  Widget buildViewModelWidget(
      BuildContext context, MainCategoryViewModel model) {
    Tween<double> _tween = Tween(begin: 1, end: 0.95);
    final _tweenController = useAnimationController(
      duration: const Duration(milliseconds: 100),
    );
    return ScaleTransition(
      scale: _tween.animate(CurvedAnimation(
          parent: _tweenController
            ..addStatusListener((status) {
//// This listener was used to repeat animation once
              if (status == AnimationStatus.completed) {
                _tweenController.reverse();
              }
            }),
          curve: Curves.bounceInOut)),
      child: Container(
        width: 75.w,
        height: 75.w,
        margin: EdgeInsets.only(
            top: 5.w,
            left: pos == 0 ? 10.w : 0.w), // margin on top of persistent header
        color: AppTheme.WHITE,
        child: GestureDetector(
          onTap: () {
            _tweenController.forward();
            model.updateMainCategoryItem(mainCategory!.id);
          },
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
                    horizontal: model.isMainCategorySelected(mainCategory!.id)
                        ? 5.w
                        : 0.0,
                    vertical: model.isMainCategorySelected(mainCategory!.id)
                        ? 2.h
                        : 0.0),
                decoration: BoxDecoration(
                  borderRadius: AppTheme().radius15,
                  color: model.isMainCategorySelected(mainCategory!.id)
                      ? AppTheme.MAIN
                      : AppTheme.WHITE,
                ),
                child: Text(
                  mainCategory!.name!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: model.isMainCategorySelected(mainCategory!.id)
                        ? AppTheme.WHITE
                        : AppTheme.FONT_COLOR,
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
