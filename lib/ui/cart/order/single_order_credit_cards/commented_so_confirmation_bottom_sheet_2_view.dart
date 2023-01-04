// import 'package:flutter/material.dart';
// import 'package:flutter_credit_card/flutter_credit_card.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:stacked/stacked.dart';
// import 'package:easy_localization/easy_localization.dart';
// import '../../../../generated/locale_keys.g.dart';
// import '../../../../models/models.dart';
// import '../../../../shared/shared.dart';
// import '../../../../utils/utils.dart';
// import '../../../widgets/widgets.dart';
// import 'so_credit_cards_view_model.dart';

// class SOConfirmationBottomSheet2View extends StatelessWidget {
//   final ScrollController scrollController;
//   final double offset;
//   SOConfirmationBottomSheet2View({
//     Key? key,
//     required this.scrollController,
//     required this.offset,
//   }) : super(key: key);

//   final GlobalKey<FormState> creditCardFormKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<SOCreditCardsViewModel>.reactive(
//       // onModelReady: (model) => model.getOnModelReady(),
//       viewModelBuilder: () => SOCreditCardsViewModel(),
//       builder: (context, model, child) => Container(
//         decoration: BoxDecoration(
//           color: kcWhiteColor,
//           borderRadius: BorderRadius.vertical(
//             top: Radius.circular(Constants.BORDER_RADIUS_20),
//           ),
//         ),
//         child: ListView(
//           controller: scrollController,
//           shrinkWrap: true,
//           children: [
//             //*-------------- CUSTOM BOTTOM SHEET MODAL WIDGET -------------- //
//             CustomModalInsideBottomSheet(isBottomZero: true),

//             Padding(
//               padding: EdgeInsets.fromLTRB(8.w, 0.h, 0.w, 20.h),
//               child: Column(
//                 children: [
//                   //*----------------- CREDIT CARD FORM ---------------------//
//                   CreditCardForm(
//                     formKey: creditCardFormKey,
//                     obscureCvv: true,
//                     obscureNumber: false,
//                     cardNumber: model.cardNumber,
//                     cvvCode: model.cvcCode,
//                     isHolderNameVisible: true,
//                     isCardNumberVisible: true,
//                     isExpiryDateVisible: true,
//                     cardHolderName: model.cardHolderName,
//                     expiryDate: model.expiryDate,
//                     themeColor: kcPrimaryColor,
//                     cardNumberDecoration: InputDecoration(
//                       labelText: LocaleKeys.card_number.tr(),
//                       hintText: 'XXXX XXXX XXXX XXXX',
//                       hintStyle: kts16HelperText,
//                       labelStyle: kts16HelperText,
//                       focusedBorder: AppTheme().cardUnderlineInputBorder,
//                       enabledBorder: AppTheme().cardUnderlineInputBorder,
//                     ),
//                     cardNumberValidator: model.updateCardNumberValidator,
//                     expiryDateDecoration: InputDecoration(
//                       hintStyle: kts16HelperText,
//                       labelStyle: kts16HelperText,
//                       focusedBorder: AppTheme().cardUnderlineInputBorder,
//                       enabledBorder: AppTheme().cardUnderlineInputBorder,
//                       labelText: LocaleKeys.card_date_deadline.tr(),
//                       hintText: 'XX/XX',
//                     ),
//                     expiryDateValidator: model.updateExpiryDateValidator,
//                     cvvCodeDecoration: InputDecoration(
//                       labelText: '',
//                       hintText: '',
//                       // labelText: 'CVC',
//                       // hintText: 'XXX',
//                       hintStyle:
//                           TextStyle(fontSize: 16.sp, color: kcWhiteColor),
//                       labelStyle:
//                           TextStyle(fontSize: 16.sp, color: kcWhiteColor),
//                       border: InputBorder.none,
//                       focusedBorder: InputBorder.none,
//                       enabledBorder: InputBorder.none,
//                       errorBorder: InputBorder.none,
//                       disabledBorder: InputBorder.none,
//                     ),
//                     cvvValidator: model.updateCVCValidator,
//                     cardHolderDecoration: InputDecoration(
//                       hintStyle: kts16HelperText,
//                       labelStyle: kts16HelperText,
//                       focusedBorder: AppTheme().cardUnderlineInputBorder,
//                       enabledBorder: AppTheme().cardUnderlineInputBorder,
//                       labelText: LocaleKeys.card_holder.tr(),
//                     ),
//                     cardHolderValidator: model.updateCardHolderValidator,
//                     onCreditCardModelChange: model.onCreditCardModelChange,
//                   ),
//                   //*----------------- BANK CARD LIST ---------------------//
//                   ListView.separated(
//                     shrinkWrap: true,
//                     physics: NeverScrollableScrollPhysics(),
//                     padding: EdgeInsets.only(top: 20.h),
//                     itemCount: bankList.length,
//                     itemBuilder: (context, pos) {
//                       return RadioListTile<BankCard>(
//                         value: bankList[pos],
//                         groupValue: model.selectedBankCard,
//                         onChanged: model.updateSelectedBankCard,
//                         title: Text(
//                           bankList[pos]
//                               .bankName, // Changes name of first element if location is enabled
//                           style: kts16Text,
//                         ).tr(),
//                         activeColor: kcGreenColor,
//                         controlAffinity: ListTileControlAffinity.leading,
//                         toggleable: true,
//                       );
//                     },
//                     separatorBuilder: (context, index) => Divider(
//                       indent: 0.175.sw,
//                       thickness: 0.5,
//                       color: kcDividerSecondaryColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             //*  --------------- CREDIT CARD CONFIRM BUTTON -------------- //
//             Container(
//               decoration: BoxDecoration(
//                 color: kcWhiteColor,
//                 border: Border(
//                   top: BorderSide(
//                     width: 0.1,
//                     color: kcButtonBorderColor,
//                   ),
//                 ),
//               ),
//               padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 22.h),
//               child: CustomTextChildButton(
//                 color: kcOnlinePaymentColor,
//                 padding: EdgeInsets.symmetric(vertical: 14.h),
//                 child: model.isBusy
//                     ? ButtonLoading()
//                     : Text(
//                         LocaleKeys.confirm,
//                         style: ktsButtonWhite18Text,
//                       ).tr(),
//                 onPressed: model.isBusy ? () {} : () async {},
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
