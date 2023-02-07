import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../models/models.dart';
import '../../../../shared/shared.dart';
import '../../../widgets/widgets.dart';
import '../../../../utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'so_credit_cards_view_model.dart';
import 'so_payment_success_fail_bottom_sheet.dart';
import 'so_send_code_bottom_sheet_hook.dart';

class SOSendCodeConfirmationBottomSheetView extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse<bool>) completer;
  final SOSendCodeConfirmationBottomSheetData
      soSendCodeConfirmationBottomSheetData;
  SOSendCodeConfirmationBottomSheetView({
    Key? key,
    required this.request,
    required this.completer,
    required this.soSendCodeConfirmationBottomSheetData,
  }) : super(key: key);

  final GlobalKey<FormState> _sendCodeformKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SOCreditCardsViewModel>.reactive(
      viewModelBuilder: () => SOCreditCardsViewModel(
        soBottomSheetData:
            soSendCodeConfirmationBottomSheetData.soBottomSheetData,
      ),
      builder: (context, model, child) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(Constants.BORDER_RADIUS_20)),
              color: kcWhiteColor,
            ),
            child: ScrollableColumn(
              controller: scrollController,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //* --------------- CUSTOM BOTTOM SHEET MODAL WIDGET -------------- //
                CustomModalInsideBottomSheet(),

                //* ------------------ SEND CODE INFO ---------------------//
                context.locale == context.supportedLocales[0]
                    ? Padding(
                        padding:
                            EdgeInsets.only(top: 12.h, left: 22.w, right: 22.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              soSendCodeConfirmationBottomSheetData
                                      .paymentCreateBankOrder.phone ??
                                  '',
                              style: kts18BoldText,
                            ),
                            Text(
                              LocaleKeys.online_payment_send_code_info,
                              style: kts16Text,
                              textAlign: TextAlign.center,
                            ).tr(),
                          ],
                        ),
                      )
                    : Padding(
                        padding:
                            EdgeInsets.only(top: 12.h, left: 22.w, right: 22.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              LocaleKeys.online_payment_send_code_info,
                              style: kts16Text,
                              textAlign: TextAlign.center,
                            ).tr(),
                            Text(
                              soSendCodeConfirmationBottomSheetData
                                      .paymentCreateBankOrder.phone ??
                                  '',
                              style: kts18BoldText,
                            ),
                          ],
                        ),
                      ),
                //* --------------- SEND CODE TEXTFIELD -------------- //
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(Constants.BORDER_RADIUS_20),
                    ),
                    color: kcWhiteColor,
                  ),
                  margin: EdgeInsets.only(top: 8.h),
                  padding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 10.h),
                  child: Form(
                    key: _sendCodeformKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: SOSendCodeBottomSheetHook(),
                  ),
                ),
                if (model.isSendCodeError)
                  Padding(
                    padding: EdgeInsets.only(left: 16.w, top: 5.h),
                    child: Text(
                      LocaleKeys.sendCodeErrorAttempt,
                      style: kts16ErrorText,
                    ).tr(args: [model.sendCodeErrorAttemptCount.toString()]),
                  ),
                Spacer(),
                //* --------------- SEND CODE CONFIRM BUTTON -------------- //
                Container(
                  width: 1.sw,
                  decoration: BoxDecoration(
                    color: kcWhiteColor,
                    border: Border(
                      top: BorderSide(
                        width: 0.1,
                        color: kcButtonBorderColor,
                      ),
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 25.h),
                  child: CustomTextChildButton(
                    color: kcOnlinePaymentColor,
                    borderRadius: AppTheme().radius15,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: model.isLoading
                          ? ButtonLoading()
                          : Text(
                              LocaleKeys.confirm,
                              style: ktsButtonWhite18Text,
                            ).tr(),
                    ),
                    onPressed: !model.isLoading
                        ? () async {
                            FocusScope.of(context)
                                .unfocus(); // UNFOCUSES all textfield b4 data fetch

                            if (!_sendCodeformKey.currentState!.validate())
                              return;
                            _sendCodeformKey.currentState!.save();
                            model.log.v('_sendCodeformKey SUCCESS');

                            await model.onOtpVerifyButtonPressed(
                              paymentCreateBankOrder:
                                  soSendCodeConfirmationBottomSheetData
                                      .paymentCreateBankOrder,
                              onSuccessForView: () async {
                                await model.checkOnlinePaymentOrderStatus(
                                  orderId: soSendCodeConfirmationBottomSheetData
                                          .paymentCreateBankOrder.orderId ??
                                      '',
                                  onSuccessForView: () async {
                                    model.navBack();
                                    await showFlexibleBottomSheet(
                                      initHeight: 0.95,
                                      maxHeight: 0.95,
                                      duration: Duration(milliseconds: 250),
                                      context: context,
                                      bottomSheetColor: Colors.transparent,
                                      builder: (context, scrollController,
                                              offset) =>
                                          SingleOrderPaymentSuccessFailBottomSheetView(
                                        scrollController: scrollController,
                                        offset: offset,
                                        isPaymentSuccess: true,
                                        errorText: '',
                                        soBottomSheetData:
                                            soSendCodeConfirmationBottomSheetData
                                                .soBottomSheetData,
                                      ),
                                    );
                                  },
                                  onFailForView: () async {
                                    //* If NO MONEY /INVALID CVC /OTHER ERROR in SEND CODE BOTTOM SHEET
                                    model.navBack();
                                    await showFlexibleBottomSheet(
                                      initHeight: 0.95,
                                      maxHeight: 0.95,
                                      duration: Duration(milliseconds: 250),
                                      context: context,
                                      bottomSheetColor: Colors.transparent,
                                      builder: (context, scrollController,
                                              offset) =>
                                          SingleOrderPaymentSuccessFailBottomSheetView(
                                        scrollController: scrollController,
                                        offset: offset,
                                        isPaymentSuccess: false,
                                        errorText: model.smsErrorEnum ==
                                                SmsErrorEnum.cvcFail
                                            ? LocaleKeys
                                                .online_payment_wrong_card_info
                                            : model.smsErrorEnum ==
                                                    SmsErrorEnum.notEnoughFail
                                                ? LocaleKeys
                                                    .online_payment_no_enough_money
                                                : '',
                                        soBottomSheetData:
                                            soSendCodeConfirmationBottomSheetData
                                                .soBottomSheetData,
                                      ),
                                    );
                                  },
                                );
                              },
                              onFailForView: () async {
                                //* If OPERATION CANCELED after 3 WRONG SEND CODE ATTEMPTS
                                if (model.sendCodeErrorAttemptCount == -1) {
                                  model.navBack();
                                  await showFlexibleBottomSheet(
                                    initHeight: 0.95,
                                    maxHeight: 0.95,
                                    duration: Duration(milliseconds: 250),
                                    context: context,
                                    bottomSheetColor: Colors.transparent,
                                    builder: (context, scrollController,
                                            offset) =>
                                        SingleOrderPaymentSuccessFailBottomSheetView(
                                      scrollController: scrollController,
                                      offset: offset,
                                      isPaymentSuccess: false,
                                      errorText: LocaleKeys
                                          .online_payment_operation_cancelled,
                                      soBottomSheetData:
                                          soSendCodeConfirmationBottomSheetData
                                              .soBottomSheetData,
                                    ),
                                  );
                                } else if (model.sendCodeErrorAttemptCount ==
                                    0) {
                                  await model.showCustomFlashBar(
                                    context: context,
                                    margin: EdgeInsets.only(
                                      left: 16.w,
                                      right: 16.w,
                                      bottom: 0.05.sh,
                                    ),
                                  );
                                }
                              },
                            );
                          }
                        : () {},
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
