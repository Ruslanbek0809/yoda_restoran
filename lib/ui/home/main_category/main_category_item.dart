import 'package:flutter/material.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:yoda_res/ui/home/main_category/main_category_view_model.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import '../../../models/models.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/utils.dart';

class MainCategoryItem extends HookViewModelWidget<MainCategoryViewModel> {
  final MainCategory mainCategory;
  // final List<MainCategory> mainCategories;
  MainCategoryItem({
    Key? key,
    required this.mainCategory,
    // required this.mainCategories,
  }) : super(key: key, reactive: true);

  @override
  Widget buildViewModelWidget(
      BuildContext context, MainCategoryViewModel model) {
    Tween<double> _tween = Tween(begin: 1, end: 0.95);
    final _tweenController = useAnimationController(
      duration: const Duration(milliseconds: 100),
    );

    /// To dispose a status listener attached to _tweenController
    useEffect(() {
      void _listenerStatus(AnimationStatus status) {
        // This listener was used to repeat animation once
        if (status == AnimationStatus.completed) {
          _tweenController.reverse();
        }
      }

      _tweenController..addStatusListener(_listenerStatus);
      return () => _tweenController.removeStatusListener(_listenerStatus);
    }, [_tweenController]);

    return ScaleTransition(
      scale: _tween.animate(
        CurvedAnimation(
          parent: _tweenController,
          curve: Curves.bounceInOut,
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(
            top: 5.h,
            left: model.mainCats!.indexOf(mainCategory) == 0
                ? 12.w
                : 5.w), // margin on top of persistent header
        color: AppTheme.WHITE,
        child: GestureDetector(
          onTap: () async {
            await _tweenController.forward();
            model.updateMainCategoryItem(mainCategory.id);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              YodaImage(
                image: mainCategory.image!,
                width: 70.w,
                height: 70.w,
                borderRadius: 10.0,
              ),
              Container(
                margin: EdgeInsets.only(top: 2.h),
                padding: EdgeInsets.symmetric(
                    horizontal: model.isMainCategorySelected(mainCategory.id)
                        ? 7.w
                        : 0.0,
                    vertical: model.isMainCategorySelected(mainCategory.id)
                        ? 2.h
                        : 0.0),
                decoration: BoxDecoration(
                  borderRadius: AppTheme().radius15,
                  color: model.isMainCategorySelected(mainCategory.id)
                      ? AppTheme.MAIN
                      : AppTheme.WHITE,
                ),
                child: Text(
                  mainCategory.name!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: model.isMainCategorySelected(mainCategory.id)
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
