import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import 'package:yoda_res/shared/app_colors.dart';
import 'package:yoda_res/shared/styles.dart';
import 'package:yoda_res/ui/home/main_cat_bottom_sheet/main_cat_bottom_view_model.dart';
import 'package:yoda_res/ui/widgets/button_loading.dart';
import '../../../utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';

class MainCatSortBottom extends HookViewModelWidget<MainCatBottomViewModel> {
  const MainCatSortBottom({Key? key}) : super(key: key, reactive: true);

  @override
  Widget buildViewModelWidget(
      BuildContext context, MainCatBottomViewModel model) {
    // final mainFilterAnimationController = useAnimationController(
    //   duration: const Duration(milliseconds: 150),
    // );
    // final mainFilterAnimationValue =
    //     IntTween(begin: 0, end: 100).animate(mainFilterAnimationController);

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
        padding: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 25.w),
        child:

            /// DEPRECATED after 2.3.0+35
            // Center(
            //   child: Row(
            //     children: <Widget>[
            //       Expanded(
            //         flex: mainFilterAnimationValue.value,
            //         child: SizedBox(
            //           width: 0.0,
            //           child: TextButton(
            //             style: TextButton.styleFrom(
            //               backgroundColor: AppTheme.MAIN_LIGHT,
            //               elevation: 0,
            //               shape: RoundedRectangleBorder(
            //                   borderRadius: AppTheme().radius15),
            //               padding: EdgeInsets.symmetric(vertical: 17.w),
            //             ),
            //             child: FittedBox(
            //               child: Text(
            //                 LocaleKeys.clear,
            //                 style: TextStyle(
            //                   color: AppTheme.FONT_COLOR,
            //                   fontSize: 18.sp,
            //                   fontWeight: FontWeight.w400,
            //                 ),
            //               ).tr(),
            //             ),
            //             onPressed: () {},
            //           ),
            //         ),
            //       ),
            //       SizedBox(width: 12.5.w),
            //       Expanded(
            //         flex: 100,
            //         child:
            TextButton(
          style: TextButton.styleFrom(
            backgroundColor: model.tempSelectedMainCats.isNotEmpty
                ? kcPrimaryColor
                : kcSecondaryLightColor,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: AppTheme().radius15),
            padding: EdgeInsets.symmetric(vertical: 14.h),
          ),
          child: model.isBusy
              ? ButtonLoading()
              : Text(
                  model.tempSelectedMainCats.isNotEmpty
                      ? LocaleKeys.confirmSortButton
                      : LocaleKeys.chooseMainCat,
                  style: model.tempSelectedMainCats.isNotEmpty
                      ? ktsButton18Text
                      : ktsButton18ContactText,
                ).tr(),
          onPressed: model.tempSelectedMainCats.isNotEmpty
              ? () async {
                  await model.updateAllSelectedTempMainCats();
                  model.navBack();
                }
              : null,
        ),
        //       )
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
