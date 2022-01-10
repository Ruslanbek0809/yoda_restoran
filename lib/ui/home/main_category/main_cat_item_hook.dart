import 'package:flutter/material.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'main_cat_view_model.dart';
import '../../widgets/widgets.dart';
import '../../../models/models.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/utils.dart';

class MainCatItemHook extends HookViewModelWidget<MainCatViewModel> {
  final MainCategory mainCategory;
  MainCatItemHook({
    Key? key,
    required this.mainCategory,
  }) : super(key: key, reactive: true);

  @override
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
            await model.updateSelectedMainCats(mainCategory.id);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              YodaImage(
                image: mainCategory.image!,
                width: 60.h,
                height: 60.h,
                borderRadius: 10.0,
              ),
              Container(
                margin: EdgeInsets.only(top: 2.h),
                padding: EdgeInsets.symmetric(
                    horizontal:
                        model.isMainCatSelected(mainCategory.id) ? 7.w : 0.0,
                    vertical:
                        model.isMainCatSelected(mainCategory.id) ? 2.h : 0.0),
                decoration: BoxDecoration(
                  borderRadius: AppTheme().radius15,
                  color: model.isMainCatSelected(mainCategory.id)
                      ? AppTheme.GREEN_COLOR
                      : AppTheme.WHITE,
                ),
                child: Text(
                  mainCategory.name!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: model.isMainCatSelected(mainCategory.id)
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
