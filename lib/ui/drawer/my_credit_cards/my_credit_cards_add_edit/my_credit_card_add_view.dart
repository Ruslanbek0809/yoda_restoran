import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:stacked/stacked.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../models/models.dart';
import '../../../../shared/shared.dart';
import '../../../../utils/utils.dart';
import '../../../widgets/widgets.dart';
import 'my_credit_card_add_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class MyCreditCardAddView extends StatelessWidget {
  MyCreditCardAddView({Key? key}) : super(key: key);

  final GlobalKey<FormState> creditCardFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MyCreditCardAddViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: kcWhiteColor,
          elevation: 0.5,
          leadingWidth: 35.w,
          leading: Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: kcFontColor,
                size: 25.w,
              ),
              onPressed: model.navBackWithFalse,
            ),
          ),
          centerTitle: true,
          title: Text(LocaleKeys.card_info, style: kts22DarkText).tr(),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //*----------------- CREDIT CARD FORM ---------------------//
                    CreditCardForm(
                      formKey: creditCardFormKey,
                      obscureCvv: true,
                      obscureNumber: false,
                      cardNumber: model.cardNumber,
                      cvvCode: model.cvvCode,
                      isHolderNameVisible: true,
                      isCardNumberVisible: true,
                      isExpiryDateVisible: true,
                      enableCvv: false,
                      cardHolderName: model.cardHolderName,
                      expiryDate: model.expiryDate,
                      themeColor: kcPrimaryColor,
                      cardNumberDecoration: InputDecoration(
                        labelText: LocaleKeys.card_number.tr(),
                        hintText: 'XXXX XXXX XXXX XXXX',
                        hintStyle: kts16HelperText,
                        labelStyle: kts16HelperText,
                        focusedBorder: AppTheme().cardUnderlineInputBorder,
                        enabledBorder: AppTheme().cardUnderlineInputBorder,
                      ),
                      cardNumberValidator: model.updateCardNumberValidator,
                      expiryDateDecoration: InputDecoration(
                        labelText: LocaleKeys.card_date_deadline.tr(),
                        hintText: 'XX/XX',
                        hintStyle: kts16HelperText,
                        labelStyle: kts16HelperText,
                        focusedBorder: AppTheme().cardUnderlineInputBorder,
                        enabledBorder: AppTheme().cardUnderlineInputBorder,
                      ),
                      expiryDateValidator: model.updateExpiryDateValidator,
                      cvvCodeDecoration: InputDecoration(
                        labelText: 'CVC',
                        hintText: 'XXX',
                        hintStyle: kts16HelperText,
                        labelStyle: kts16HelperText,
                        focusedBorder: AppTheme().cardUnderlineInputBorder,
                        enabledBorder: AppTheme().cardUnderlineInputBorder,
                      ),
                      cvvValidator: model.updateCvvValidator,
                      cardHolderDecoration: InputDecoration(
                        labelText: LocaleKeys.card_holder.tr(),
                        hintStyle: kts16HelperText,
                        labelStyle: kts16HelperText,
                        focusedBorder: AppTheme().cardUnderlineInputBorder,
                        enabledBorder: AppTheme().cardUnderlineInputBorder,
                      ),
                      cardHolderValidator: model.updateCardHolderValidator,
                      onCreditCardModelChange: model.onCreditCardModelChange,
                    ),
                    //*----------------- BANK CARD LIST ---------------------//
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(top: 20.h),
                      itemCount: bankList.length,
                      itemBuilder: (context, pos) {
                        return RadioListTile<BankCard>(
                          value: bankList[pos],
                          groupValue: model.selectedBankCard,
                          onChanged: bankList[pos].bankId == 1
                              ? model.updateSelectedBankCard
                              : (value) {},
                          title: Text(
                            bankList[pos]
                                .bankName, //* Changes name of first element if location is enabled
                            style: model.selectedBankCard!.bankId ==
                                    bankList[pos].bankId
                                ? kts16Text
                                : kts16ContactText,
                          ).tr(),
                          activeColor: kcGreenColor,
                          controlAffinity: ListTileControlAffinity.leading,
                          toggleable: true,
                        );
                      },
                      separatorBuilder: (context, index) => Divider(
                        indent: 0.175.sw,
                        thickness: 0.5,
                        color: kcDividerSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //*----------------- CARD ADD BUTTON ---------------------//
            Container(
              color: kcWhiteColor,
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 50.h),
              child: SizedBox(
                width: 1.sw,
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: kcSecondaryLightColor,
                    backgroundColor: kcPrimaryColor, // ripple effect color
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: AppTheme().radius10),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  child: model.isBusy
                      ? ButtonLoading()
                      : Text(
                          LocaleKeys.add_card,
                          style: ktsButtonWhite18Text,
                        ).tr(),
                  onPressed: () async {
                    FocusScope.of(context)
                        .unfocus(); //* UNFOCUSES all textfield b4 data fetch

                    if (creditCardFormKey.currentState!.validate()) {
                      print('creditCardFormKey SUCCESS');
                      await model.onCreditCardSave();
                    } else
                      print('creditCardFormKey FAILED');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      viewModelBuilder: () => MyCreditCardAddViewModel(),
    );
  }
}
