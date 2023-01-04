import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../shared/app_colors.dart';
import '../../../shared/styles.dart';
import '../../../utils/utils.dart';
import '../../widgets/button_loading.dart';
import 'main_cat_bottom_view_model.dart';

class MainCatSortBottom extends ViewModelWidget<MainCatBottomViewModel> {
  const MainCatSortBottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, MainCatBottomViewModel model) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
            color: kcWhiteColor,
            border: Border.all(color: kcButtonBorderColor, width: 0.1),
            boxShadow: [AppTheme().bottomCartShadow]),
        padding: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 25.w),
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: kcPrimaryColor,
            foregroundColor: kcSecondaryLightColor, // ripple effect color
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: AppTheme().radius15),
            padding: EdgeInsets.symmetric(vertical: 14.h),
          ),
          child: model.isBusy
              ? ButtonLoading()
              : Text(
                  LocaleKeys.confirmSortButton,
                  style: ktsButtonWhite18Text,
                ).tr(),
          onPressed: () async {
            //*If model.selectedSort IS NOT DEFAULT
            if (model.tempSelectedMainCats.isNotEmpty ||
                model.selectedSort != mainCatSortList[0] ||
                model.isByOpenRestaurantsChecked) await model.fireFilterAPI();
            model.navBack();
          },
        ),
      ),
    );
  }
}
