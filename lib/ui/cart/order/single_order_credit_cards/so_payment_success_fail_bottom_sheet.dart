import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/models/models.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/shared.dart';
import '../../../../utils/utils.dart';
import '../../../widgets/widgets.dart';
import 'so_credit_cards_view_model.dart';

class SingleOrderPaymentSuccessFailBottomSheetView extends StatelessWidget {
  final ScrollController scrollController;
  final double offset;
  final bool isPaymentSuccess;
  final String errorText;
  final SOBottomSheetData soBottomSheetData;
  SingleOrderPaymentSuccessFailBottomSheetView({
    Key? key,
    required this.scrollController,
    required this.offset,
    required this.isPaymentSuccess,
    required this.errorText,
    required this.soBottomSheetData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SOCreditCardsViewModel>.reactive(
      onModelReady: (model) async => isPaymentSuccess
          ? await model.getInitialOrdersWhenOnlinePaymentIsSuccess()
          : {},
      viewModelBuilder: () =>
          SOCreditCardsViewModel(soBottomSheetData: soBottomSheetData),
      builder: (context, model, child) => Container(
        decoration: BoxDecoration(
          color: kcWhiteColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Constants.BORDER_RADIUS_20),
          ),
        ),
        child: Column(
          children: [
            // --------------- CUSTOM BOTTOM SHEET MODAL WIDGET -------------- //
            CustomModalInsideBottomSheet(),

            // --------------- ONLINE PAYMENT SUCCESS/FAIL -------------- //
            // --------------- ONLINE PAYMENT SUCCESS -------------- //
            if (isPaymentSuccess == true)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 0.1.sh),
                      child: SvgPicture.asset(
                        'assets/title_yoda_restoran_start.svg',
                        width: 0.6.sw,
                      ),
                    ),
                    Spacer(),
                    SvgPicture.asset(
                      'assets/online_payment_success.svg',
                      width: 100.sp,
                    ),
                    SizedBox(height: 0.1.sh),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        LocaleKeys.online_payment_success,
                        textAlign: TextAlign.center,
                        style: kts20BoldText,
                      ).tr(),
                    ),
                    Spacer(),
                    SizedBox(
                      width: 1.sw,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.w),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: kcSecondaryLightColor,
                            backgroundColor:
                                kcSecondaryDarkColor, // ripple effect color
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: AppTheme().radius10),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                          ),
                          child: Text(
                            LocaleKeys.orders,
                            style: ktsButtonWhite18Text,
                          ).tr(),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    SizedBox(height: 0.1.sh),
                  ],
                ),
              ),
            // --------------- ONLINE PAYMENT FAIL -------------- //
            if (isPaymentSuccess == false)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 0.1.sh),
                      child: SvgPicture.asset(
                        'assets/title_yoda_restoran_start.svg',
                        width: 0.6.sw,
                      ),
                    ),
                    Spacer(),
                    SvgPicture.asset(
                      'assets/online_payment_fail.svg',
                      width: 100.sp,
                    ),
                    SizedBox(height: 0.1.sh),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        LocaleKeys.online_payment_fail,
                        textAlign: TextAlign.center,
                        style: kts20BoldText,
                      ).tr(),
                    ),
                    SizedBox(height: 12.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        !isPaymentSuccess
                            ? errorText
                            : LocaleKeys.online_payment_fail_info,
                        textAlign: TextAlign.center,
                        style: kts14SecondaryDarkText,
                      ).tr(),
                    ),
                    Spacer(),
                    TextButton(
                      child: model.isChangeOnlineToCashLoading
                          ? ButtonLoading(color: kcPrimaryColor)
                          : Text(
                              LocaleKeys.cash_payment,
                              style: kts18Text,
                            ).tr(),
                      onPressed: () async {
                        await model.onChangeOnlineToCashButtonPressed(
                          onSuccessForView: () async {
                            await showErrorFlashBar(
                              msg: LocaleKeys
                                  .payment_type_changed_from_online_to_cash
                                  .tr(),
                              context: context,
                              margin: EdgeInsets.only(
                                left: 16.w,
                                right: 16.w,
                                bottom: 0.05.sh,
                              ),
                            );
                            model.navBack();
                          },
                          onFailForView: () async {
                            await showErrorFlashBar(
                              context: context,
                              margin: EdgeInsets.only(
                                left: 16.w,
                                right: 16.w,
                                bottom: 0.05.sh,
                              ),
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(height: 0.1.sh),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
