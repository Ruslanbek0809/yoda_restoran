import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import '../../utils/utils.dart';

import 'toggle_buttons_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class ToggleButtonView extends StatelessWidget {
  const ToggleButtonView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ToggleButtonViewModel>.reactive(
      builder: (context, model, child) => LayoutBuilder(
          builder: (context, constraints) => GestureDetector(
                onTap: model.updateToggleButton,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.MAIN_LIGHT,
                    borderRadius: AppTheme().radius15,
                  ),
                  height: 44.h,
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Stack(
                    children: [
                      AnimatedAlign(
                        alignment: Alignment(model.isDelivery ? -1 : 1, 0),
                        duration: Duration(milliseconds: 300),
                        child: Container(
                          width: constraints.maxWidth / 2,
                          decoration: BoxDecoration(
                            color: AppTheme.WHITE,
                            borderRadius: AppTheme().radius15,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment(-1, 0),
                        child: Container(
                          width: constraints.maxWidth / 2,
                          alignment: Alignment.center,
                          child: Text(
                            LocaleKeys.delivery,
                            style: TextStyle(
                              fontSize: 17.sp,
                              color: model.isDelivery
                                  ? AppTheme.FONT_COLOR
                                  : AppTheme.FONT_GREY_COLOR,
                            ),
                          ).tr(),
                        ),
                      ),
                      Align(
                        alignment: Alignment(1, 0),
                        child: Container(
                          width: constraints.maxWidth / 2,
                          alignment: Alignment.center,
                          child: Text(
                            LocaleKeys.selfPickUp,
                            style: TextStyle(
                              fontSize: 17.sp,
                              color: model.isDelivery
                                  ? AppTheme.FONT_GREY_COLOR
                                  : AppTheme.FONT_COLOR,
                            ),
                          ).tr(),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
      viewModelBuilder: () => ToggleButtonViewModel(),
    );
  }
}
