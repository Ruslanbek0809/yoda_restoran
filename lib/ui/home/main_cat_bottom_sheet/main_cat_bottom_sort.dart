import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:yoda_res/shared/styles.dart';
import 'package:yoda_res/ui/widgets/button_loading.dart';
import '../main_category/main_cat_view_model.dart';
import '../../../utils/utils.dart';

class MainCatSortBottom extends HookViewModelWidget<MainCatViewModel> {
  const MainCatSortBottom({Key? key}) : super(key: key, reactive: true);

  @override
  Widget buildViewModelWidget(BuildContext context, MainCatViewModel model) {
    final mainFilterAnimationController = useAnimationController(
      duration: const Duration(milliseconds: 150),
    );
    final mainFilterAnimationValue =
        IntTween(begin: 0, end: 100).animate(mainFilterAnimationController);

    /// mainFilterAnimationController trigger
    // if (model.mainFilterAnimationStatus != MainFilterAnimationStatus.idle)
    //   switch (mainFilterAnimationController.status) {
    //     case AnimationStatus.completed:
    //       if (model.mainFilterAnimationStatus ==
    //           MainFilterAnimationStatus.reverse)
    //         mainFilterAnimationController.reverse();
    //       break;
    //     case AnimationStatus.dismissed:
    //       if (model.mainFilterAnimationStatus ==
    //           MainFilterAnimationStatus.forward)
    //         mainFilterAnimationController.forward();
    //       break;
    //     default:
    //       break;
    //   }
    // model.log.i(
    //     'model.mainFilterAnimationStatus: ${model.mainFilterAnimationStatus}');

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
            color: AppTheme.WHITE,
            border: Border.all(color: AppTheme.BUTTON_BORDER_COLOR, width: 0.1),
            boxShadow: [AppTheme().bottomCartShadow]),
        padding: EdgeInsets.fromLTRB(15.w, 10.w, 15.w, 25.w),
        child: Center(
          child: Row(
            children: <Widget>[
              Expanded(
                flex: mainFilterAnimationValue.value,
                child: SizedBox(
                  width: 0.0,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: AppTheme.MAIN_LIGHT,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: AppTheme().radius15),
                      padding: EdgeInsets.symmetric(vertical: 17.w),
                    ),
                    child: FittedBox(
                      child: Text(
                        'Arassala',
                        style: TextStyle(
                          color: AppTheme.FONT_COLOR,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
              SizedBox(width: 12.5.w),
              Expanded(
                flex: 100,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: AppTheme.MAIN,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: AppTheme().radius15),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  child: model.isBusy
                      ? ButtonLoading()
                      : Text('Tassykla', style: ktsButton18Text),
                  onPressed: () async {
                    if (model.tempSelectedMainCats.isNotEmpty)
                      await model.updateAllSelectedTempMainCats();
                    model.navBack();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
