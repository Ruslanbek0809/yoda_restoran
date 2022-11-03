import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/shared.dart';
import '../../../widgets/widgets.dart';
import '../../../../utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'so_credit_cards_view_model.dart';

class SOConfirmationBottomSheetView extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse<bool>) completer;
  SOConfirmationBottomSheetView({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  final GlobalKey<FormState> creditCardFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SOCreditCardsViewModel>.reactive(
      builder: (context, model, child) => DraggableScrollableSheet(
          initialChildSize: 0.8,
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
                        // --------------- BOTTOM SHEET DRAGGER -------------- //
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: SvgPicture.asset(
                            'assets/bottom_sheet_dragger.svg',
                            color: kcSecondaryLightColor,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(Constants.BORDER_RADIUS_20),
                            ),
                            color: kcWhiteColor,
                          ),
                          padding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 10.h),
                          child: //------------------ CREDIT CARD FORM ---------------------//
                              CreditCardForm(
                            formKey: creditCardFormKey,
                            obscureCvv: true,
                            obscureNumber: false,
                            cardNumber: model.cardNumber,
                            cvvCode: model.cvvCode,
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
                              hintStyle: kts16HelperText,
                              labelStyle: kts16HelperText,
                              focusedBorder:
                                  AppTheme().cardUnderlineInputBorder,
                              enabledBorder:
                                  AppTheme().cardUnderlineInputBorder,
                              labelText: LocaleKeys.card_date_deadline.tr(),
                              hintText: 'XX/XX',
                            ),
                            expiryDateValidator:
                                model.updateExpiryDateValidator,
                            cvvCodeDecoration: InputDecoration(
                              labelText: '',
                              hintText: '',
                              // labelText: 'CVC',
                              // hintText: 'XXX',
                              hintStyle: TextStyle(
                                  fontSize: 16.sp, color: kcWhiteColor),
                              labelStyle: TextStyle(
                                  fontSize: 16.sp, color: kcWhiteColor),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                            cvvValidator: model.updateCvvValidator,
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
                        ),
                      ],
                    ),
                  ),
                  //--------------- ADD ADDRESS BUTTON -------------- //
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(color: kcWhiteColor),
                      padding: EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 25.h),
                      child: CustomTextChildButton(
                        borderRadius: AppTheme().radius15,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child:
                              // model.isLoading
                              //     ? ButtonLoading()
                              //     :
                              Text(
                            LocaleKeys.addNewAddressButton,
                            style: ktsButton18Text,
                          ).tr(),
                        ),
                        onPressed: () async {
                          FocusScope.of(context)
                              .unfocus(); // UNFOCUSES all textfield b4 data fetch
                          // if (!_addressformKey.currentState!.validate()) return;
                          // _addressformKey.currentState!.save();
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
      viewModelBuilder: () => SOCreditCardsViewModel(),
    );
  }
}
