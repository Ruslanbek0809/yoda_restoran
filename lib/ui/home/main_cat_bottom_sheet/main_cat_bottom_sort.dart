import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import 'package:yoda_res/shared/app_colors.dart';
import 'package:yoda_res/shared/styles.dart';
import 'package:yoda_res/ui/home/main_cat_bottom_sheet/main_cat_bottom_view_model.dart';
import 'package:yoda_res/ui/widgets/button_loading.dart';
import '../../../utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';

class MainCatSortBottom extends StatelessWidget {
  const MainCatSortBottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainCatBottomViewModel>.reactive(
      onModelReady: (model) => model.assignTempCats(),
      viewModelBuilder: () => MainCatBottomViewModel(),
      builder: (context, model, child) => Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          decoration: BoxDecoration(
              color: AppTheme.WHITE,
              border:
                  Border.all(color: AppTheme.BUTTON_BORDER_COLOR, width: 0.1),
              boxShadow: [AppTheme().bottomCartShadow]),
          padding: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 25.w),
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: kcPrimaryColor,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: AppTheme().radius15),
              padding: EdgeInsets.symmetric(vertical: 14.h),
            ),
            child: model.isBusy
                ? ButtonLoading()
                : Text(
                    LocaleKeys.confirmSortButton,
                    style: ktsButton18Text,
                  ).tr(),
            onPressed: () async {
              /// If model.selectedSort IS NOT DEFAULT
              if (model.selectedSort != mainCatSortList[0])
                await model.fireFilterAPI();
              model.navBack();
            },
          ),
        ),
      ),
    );
  }
}
