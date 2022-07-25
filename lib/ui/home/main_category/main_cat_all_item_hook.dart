import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import 'package:yoda_res/shared/shared.dart';
import '../../widgets/widgets.dart';
import '../main_cat_bottom_sheet/main_cat_bottom_sheet_view.dart';
import 'main_cat_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';

class MainCatAllItemHook extends HookViewModelWidget<MainCatViewModel> {
  MainCatAllItemHook({
    Key? key,
  }) : super(key: key, reactive: true);

  @override
  Widget buildViewModelWidget(BuildContext context, MainCatViewModel model) {
    Tween<double> _tween = Tween(begin: 1, end: 0.9);
    final _tweenController = useAnimationController(
      duration: const Duration(milliseconds: 75),
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
        CurvedAnimation(parent: _tweenController, curve: Curves.bounceInOut),
      ),
      child: Container(
        margin: EdgeInsets.only(left: 12.w, right: 12.w),
        color: AppTheme.WHITE,
        child: GestureDetector(
          onTap: () async {
            await _tweenController.forward();
            //------------------ MAIN CAT BOTTOM SHEET ---------------------//
            //------------------ CUSTOM PACKAGE ---------------------//
            await showFlexibleBottomSheet(
              minHeight: 0,
              initHeight: 0.975,
              maxHeight: 0.975,
              context: context,
              duration: Duration(milliseconds: 250),
              bottomSheetColor: Colors.transparent,
              builder: (context, scrollController, offset) {
                return CustomBarBottomSheet(
                  child: MainCatBottomSheetView(
                    scrollController: scrollController,
                    offset: offset,
                  ),
                );
              },
              anchors: [0, 0.975],
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 60.h,
                  height: 60.h,
                  child: Padding(
                    padding: EdgeInsets.all(6.h),
                    child: Material(
                      shape: CircleBorder(),
                      color: AppTheme.MAIN_LIGHT,
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: AppTheme.FONT_COLOR,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: FittedBox(
                  child: Text(
                    LocaleKeys.all,
                    style: kts14Text,
                  ).tr(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
