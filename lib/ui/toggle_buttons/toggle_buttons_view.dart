import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import 'package:yoda_res/models/models.dart';
import '../../utils/utils.dart';

import 'toggle_buttons_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class ToggleButtonView extends StatelessWidget {
  final Restaurant restaurant;
  const ToggleButtonView({required this.restaurant, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ToggleButtonViewModel>.reactive(
      // If in a restaurant selfPickUp TRUE and delivery is FALSE then toggle's initial value must be selfPickUp TRUE
      onModelReady: (model) =>
          model.isDelivery && (restaurant.selfPickUp! && !restaurant.delivery!)
              ? model.updateToggleToSelfPickUp()
              : (!model.isDelivery &&
                          (!restaurant.selfPickUp! && restaurant.delivery!)) ||
                      (!model.isDelivery &&
                          (restaurant.selfPickUp! && restaurant.delivery!))
                  ? model.updateToggleToDelivery()
                  : () {},
      viewModelBuilder: () => ToggleButtonViewModel(),
      builder: (context, model, child) => LayoutBuilder(
          builder: (context, constraints) => GestureDetector(
                onTap: () async {
                  // If restaurant's both options are TRUE, then it can SWITCH between it
                  if (restaurant.selfPickUp! && restaurant.delivery!)
                    model.switchToggleButton();

                  if (!restaurant.selfPickUp! && restaurant.delivery!)
                    await showErrorFlashBar(
                      context: context,
                      msg: LocaleKeys.toggleDeliveryOnly,
                      margin: EdgeInsets.only(
                        left: 16.w,
                        right: 16.w,
                        bottom: 0.12.sh,
                      ),
                    );

                  if (restaurant.selfPickUp! && !restaurant.delivery!)
                    await showErrorFlashBar(
                      context: context,
                      msg: LocaleKeys.toggleSelfPickUpOnly,
                      margin: EdgeInsets.only(
                        left: 16.w,
                        right: 16.w,
                        bottom: 0.12.sh,
                      ),
                    );
                },
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
                          width: constraints.maxWidth / 2.2,
                          decoration: BoxDecoration(
                            color: AppTheme.WHITE,
                            borderRadius: AppTheme().radius15,
                            boxShadow: [AppTheme().toggleShadow],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment(-1, 0),
                        child: Container(
                          width: constraints.maxWidth / 2.1,
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
                          width: constraints.maxWidth / 2.1,
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
    );
  }
}
