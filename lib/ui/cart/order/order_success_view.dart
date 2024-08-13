import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../shared/shared.dart';
import '../../../utils/utils.dart';
import 'order_view_model.dart';

class OrderSuccessView extends StatelessWidget {
  const OrderSuccessView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OrderViewModel>.reactive(
      builder: (context, model, child) => PopScope(
        canPop: false,
        onPopInvoked: (value) {
          model.navToHomeByRemovingAll(); // Workaround
        },
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                height: 35.h,
                child: SvgPicture.asset(
                  'assets/title_yoda_restoran_start.svg',
                  width: 0.6.sw,
                ),
              ),
              Lottie.asset(
                'assets/success_check.json',
                height: 0.4.sh,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  LocaleKeys.yourOrderWasPassedToRes,
                  textAlign: TextAlign.center,
                  style: kts20BoldText,
                ).tr(),
              ),
              // SizedBox(height: 10.h),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 16.w),
              //   child: Text(
              //     LocaleKeys.toConfirmOrderWairForCallFromRes,
              //     textAlign: TextAlign.center,
              //     style: kts16HelperText,
              //   ).tr(),
              // ),
              SizedBox(height: 60.h),
              SizedBox(
                width: 1.sw,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: kcSecondaryDarkColor,
                      foregroundColor:
                          kcSecondaryLightColor, // ripple effect color
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: AppTheme().radius10),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                    child: Text(
                      LocaleKeys.homeScreen,
                      style: ktsButtonWhite18Text,
                    ).tr(),
                    onPressed: model.navToHomeByRemovingAll,
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              TextButton(
                child: Text(
                  LocaleKeys.orders,
                  style: kts18Text,
                ).tr(),
                onPressed: model.navToOrdersByRemovingAll,
              ),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => OrderViewModel(),
    );
  }
}
