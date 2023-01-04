import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'main_cat_bottom_view_model.dart';
import '../../../models/models.dart';
import '../../../shared/shared.dart';
import '../../widgets/widgets.dart';
import '../../../utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainCategoryItemBottomHook
    extends HookViewModelWidget<MainCatBottomViewModel> {
  final MainCategory? mainCategory;
  MainCategoryItemBottomHook({
    Key? key,
    this.mainCategory,
  }) : super(key: key);

  Widget buildViewModelWidget(
      BuildContext context, MainCatBottomViewModel model) {
    Tween<double> _tween = Tween(begin: 1, end: 0.9);
    final _tweenController = useAnimationController(
      duration: const Duration(milliseconds: 75),
    );

    //*To dispose a status listener attached to _tweenController
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
          model.updateTempSelectedMainCats(mainCategory!.id);
        },
        child: Column(
          children: [
            YodaImage(
              image: mainCategory!.image!,
              width: 70.w,
              height: 70.w,
              borderRadius: 10.0,
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              margin: EdgeInsets.only(top: 3.h),
              padding: EdgeInsets.symmetric(
                  horizontal:
                      model.isTempMainCatSelected(mainCategory!.id) ? 7.w : 0.0,
                  vertical: model.isTempMainCatSelected(mainCategory!.id)
                      ? 2.h
                      : 0.0),
              decoration: BoxDecoration(
                borderRadius: AppTheme().radius15,
                color: model.isTempMainCatSelected(mainCategory!.id)
                    ? kcGreenColor
                    : Colors.transparent,
              ),
              child: FittedBox(
                child: Text(
                  mainCategory!.name!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: model.isTempMainCatSelected(mainCategory!.id)
                        ? kcWhiteColor
                        : kcFontColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
