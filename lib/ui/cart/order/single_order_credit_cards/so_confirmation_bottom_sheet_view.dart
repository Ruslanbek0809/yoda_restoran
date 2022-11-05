import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
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

class SOConfirmationBottomSheetView extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse<bool>) completer;
  final SOCreditCardsConfirmationBottomSheetData
      soCreditCardsConfirmationBottomSheetData;
  SOConfirmationBottomSheetView({
    Key? key,
    required this.request,
    required this.completer,
    required this.soCreditCardsConfirmationBottomSheetData,
  }) : super(key: key);

  final GlobalKey<FormState> creditCardFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SOCreditCardsViewModel>.reactive(
      viewModelBuilder: () => SOCreditCardsViewModel(),
      onModelReady: (model) =>
          !soCreditCardsConfirmationBottomSheetData.isNewCreditCard!
              ? model.assignHiveCreditCardToTemp(
                  soCreditCardsConfirmationBottomSheetData.hiveCreditCard!)
              : null,
      builder: (context, model, child) => DraggableScrollableSheet(
          initialChildSize:
              soCreditCardsConfirmationBottomSheetData.isNewCreditCard!
                  ? 0.875
                  : 0.61,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(Constants.BORDER_RADIUS_20)),
                color: kcWhiteColor,
              ),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    controller: scrollController,
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // --------------- CUSTOM BOTTOM SHEET MODAL WIDGET -------------- //
                        CustomModalInsideBottomSheet(isBottomZero: true),

                        //------------------ CREDIT CARD FORM and BANK CARD LIST ---------------------//
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(Constants.BORDER_RADIUS_20),
                            ),
                            color: kcWhiteColor,
                          ),
                          padding: EdgeInsets.fromLTRB(8.w, 0.h, 0.w, 20.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //------------------ CREDIT CARD FORM ---------------------//
                              CreditCardForm(
                                formKey: creditCardFormKey,
                                obscureCvv: true,
                                obscureNumber: false,
                                cardNumber: model.cardNumber,
                                cvvCode: model.cvcCode,
                                isHolderNameVisible: true,
                                isCardNumberVisible: true,
                                isExpiryDateVisible: true,
                                cardHolderName: model.cardHolderName,
                                expiryDate: model.expiryDate,
                                themeColor: kcPrimaryColor,
                                cardNumberDecoration: InputDecoration(
                                  labelText: LocaleKeys.card_number.tr(),
                                  hintText: 'XXXX XXXX XXXX XXXX',
                                  hintStyle: kts16HelperText,
                                  labelStyle: kts16HelperText,
                                  focusedBorder:
                                      AppTheme().cardUnderlineInputBorder,
                                  enabledBorder:
                                      AppTheme().cardUnderlineInputBorder,
                                ),
                                cardNumberValidator:
                                    model.updateCardNumberValidator,
                                expiryDateDecoration: InputDecoration(
                                  labelText: LocaleKeys.card_date_deadline.tr(),
                                  hintText: 'XX/XX',
                                  hintStyle: kts16HelperText,
                                  labelStyle: kts16HelperText,
                                  focusedBorder:
                                      AppTheme().cardUnderlineInputBorder,
                                  enabledBorder:
                                      AppTheme().cardUnderlineInputBorder,
                                ),
                                expiryDateValidator:
                                    model.updateExpiryDateValidator,
                                cvvCodeDecoration: InputDecoration(
                                  labelText: LocaleKeys.cvc_kod.tr(),
                                  hintText: 'XXX',
                                  hintStyle: kts16HelperText,
                                  labelStyle: kts16HelperText,
                                  focusedBorder:
                                      AppTheme().cardUnderlineInputBorder,
                                  enabledBorder:
                                      AppTheme().cardUnderlineInputBorder,
                                ),
                                cvvValidator: model.updateCVCValidator,
                                cardHolderDecoration: InputDecoration(
                                  hintStyle: kts16HelperText,
                                  labelStyle: kts16HelperText,
                                  focusedBorder:
                                      AppTheme().cardUnderlineInputBorder,
                                  enabledBorder:
                                      AppTheme().cardUnderlineInputBorder,
                                  labelText: LocaleKeys.card_holder.tr(),
                                ),
                                cardHolderValidator:
                                    model.updateCardHolderValidator,
                                onCreditCardModelChange:
                                    model.onCreditCardModelChange,
                              ),
                              //------------------ CVC CODE INFO ---------------------//
                              if (soCreditCardsConfirmationBottomSheetData
                                  .isNewCreditCard!)
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 16.w, top: 4.h),
                                  child: Text(
                                    LocaleKeys.cvc_kod_not_saved,
                                    style: kts12ContactText,
                                  ).tr(),
                                ),
                              //------------------ BANK CARD LIST with NEW CREDIT CARD ---------------------//
                              if (soCreditCardsConfirmationBottomSheetData
                                  .isNewCreditCard!)
                                Padding(
                                  padding: EdgeInsets.only(top: 20.h),
                                  child: Divider(
                                    indent: 0.175.sw,
                                    thickness: 0.5,
                                    color: kcDividerSecondaryColor,
                                  ),
                                ),
                              if (soCreditCardsConfirmationBottomSheetData
                                  .isNewCreditCard!)
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: bankList.length,
                                  itemBuilder: (context, pos) {
                                    return RadioListTile<BankCard>(
                                      value: bankList[pos],
                                      groupValue: model.selectedBankCard,
                                      onChanged: model.updateSelectedBankCard,
                                      title: Text(
                                        bankList[pos]
                                            .bankName, // Changes name of first element if location is enabled
                                        style: kts16Text,
                                      ).tr(),
                                      activeColor: kcGreenColor,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      toggleable: true,
                                    );
                                  },
                                  separatorBuilder: (context, index) => Divider(
                                    indent: 0.175.sw,
                                    thickness: 0.5,
                                    color: kcDividerSecondaryColor,
                                  ),
                                ),
                              //------------------ HIVE CREDIT CARD BANK INFO ---------------------//
                              if (!soCreditCardsConfirmationBottomSheetData
                                  .isNewCreditCard!)
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 16.w, top: 20.h),
                                  child: Text(
                                    LocaleKeys.bank,
                                    style: kts14ContactText,
                                  ).tr(),
                                ),
                              if (!soCreditCardsConfirmationBottomSheetData
                                  .isNewCreditCard!)
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 16.w, top: 2.h),
                                  child: Text(
                                    model.selectedBankCard!.bankName,
                                    style: kts18Text,
                                  ).tr(),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  //--------------- CREDIT CARD CONFIRM BUTTON -------------- //
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
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
                                  style: ktsButton18Text,
                                ).tr(),
                        ),
                        onPressed: () async {
                          FocusScope.of(context)
                              .unfocus(); // UNFOCUSES all textfield b4 data fetch

                          if (!creditCardFormKey.currentState!.validate())
                            return;
                          creditCardFormKey.currentState!.save();
                          model.log.v('creditCardFormKey SUCCESS');

                          await model
                              .showCustomSendCodeConfirmationBottomSheet();
                          // await model.onAddAddressPressed(() async {
                          //   await completer(SheetResponse(data: true));
                          //   await showErrorFlashBar(
                          //     context: context,
                          //     msg: LocaleKeys.addAddedSuccessfully,
                          //     margin: EdgeInsets.only(
                          //       left: 16.w,
                          //       right: 16.w,
                          //       bottom: 0.05.sh,
                          //     ),
                          //   );
                          // }, () async {
                          //   await showErrorFlashBar(
                          //     context: context,
                          //     margin: EdgeInsets.only(
                          //       left: 16.w,
                          //       right: 16.w,
                          //       bottom: 0.05.sh,
                          //     ),
                          //   );
                          // });
                        },
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
