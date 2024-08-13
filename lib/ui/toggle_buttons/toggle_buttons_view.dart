import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';

import '../../generated/locale_keys.g.dart';
import '../../models/models.dart';
import '../../shared/shared.dart';
import '../../utils/utils.dart';
import 'toggle_buttons_view_model.dart';

class ToggleButtonView extends StatelessWidget {
  final Restaurant restaurant;
  const ToggleButtonView({required this.restaurant, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ToggleButtonViewModel>.reactive(
      // If restaurant's selfPickUp is TRUE and delivery is FALSE then toggle's initial value must be selfPickUp TRUE
      onViewModelReady: (model) =>
          restaurant.selfPickUp! && !restaurant.delivery!
              ? model.updateToggleToSelfPickUp()
              : !restaurant.selfPickUp! && restaurant.delivery!
                  ? model.updateToggleToDelivery()
                  : () {},
      viewModelBuilder: () => ToggleButtonViewModel(),
      builder: (context, model, child) => LayoutBuilder(
          builder: (context, constraints) => GestureDetector(
                onTap: () async {
                  await HapticFeedback.lightImpact();
                  // If restaurant's both options are TRUE, then it can SWITCH between it
                  if (restaurant.selfPickUp! && restaurant.delivery!)
                    model.switchToggleButton();

                  if (!restaurant.selfPickUp! && restaurant.delivery!)
                    await model.showCustomFlashBar(
                      context: context,
                      msg: LocaleKeys.toggleDeliveryOnly,
                    );

                  if (restaurant.selfPickUp! && !restaurant.delivery!)
                    await model.showCustomFlashBar(
                      context: context,
                      msg: LocaleKeys.toggleSelfPickUpOnly,
                    );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: kcSecondaryLightColor,
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
                            color: kcWhiteColor,
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
                                  ? kcFontColor
                                  : kcSecondaryFontColor,
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
                                  ? kcSecondaryFontColor
                                  : kcFontColor,
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
