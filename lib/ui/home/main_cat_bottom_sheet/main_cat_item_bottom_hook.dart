import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import '../../../models/models.dart';
import '../main_category/main_cat_view_model.dart';
import '../../widgets/widgets.dart';
import '../../../utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainCategoryItemBottomHook extends HookViewModelWidget<MainCatViewModel> {
  final MainCategory? mainCategory;
  MainCategoryItemBottomHook({
    Key? key,
    this.mainCategory,
  }) : super(key: key, reactive: true);

  Widget buildViewModelWidget(BuildContext context, MainCatViewModel model) {
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
      child: GestureDetector(
        onTap: () async {
          await _tweenController.forward();

          model.updateSelectedMainCats(mainCategory!.id);
        },
        child: Column(
          children: [
            YodaImage(
              image: mainCategory!.image!,
              width: 70.w,
              height: 70.w,
              borderRadius: 10.0,
            ),
            Container(
              margin: EdgeInsets.only(top: 7.w),
              padding: EdgeInsets.symmetric(
                  horizontal: model.isMainCategorySelected(mainCategory!.id)
                      ? 7.w
                      : 0.0,
                  vertical: model.isMainCategorySelected(mainCategory!.id)
                      ? 2.h
                      : 0.0),
              decoration: BoxDecoration(
                borderRadius: AppTheme().radius15,
                color: model.isMainCategorySelected(mainCategory!.id)
                    ? AppTheme.GREEN_COLOR
                    : Colors.transparent,
              ),
              child: Text(
                mainCategory!.name!,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14.sp,
                  // fontWeight: model.isMainCategorySelected(mainCategory!.id)
                  //     ? FontWeight.w400
                  //     : FontWeight.w600,
                  color: model.isMainCategorySelected(mainCategory!.id)
                      ? AppTheme.WHITE
                      : AppTheme.FONT_COLOR,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
