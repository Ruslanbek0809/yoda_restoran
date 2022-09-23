// import 'package:flutter/material.dart';
// import 'package:flutter_credit_card/credit_card_brand.dart';
// import 'package:flutter_credit_card/flutter_credit_card.dart';
// import 'package:stacked/stacked.dart';
// import '../../../../generated/locale_keys.g.dart';
// import '../../../../shared/shared.dart';
// import '../../../../utils/utils.dart';
// import '../../../widgets/widgets.dart';
// import 'my_credit_card_add_view_model.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:easy_localization/easy_localization.dart';

// class MyCreditCardAddView extends StatelessWidget {
//   MyCreditCardAddView({Key? key}) : super(key: key);

//   final GlobalKey<FormState> creditCardFormKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<MyCreditCardAddViewModel>.reactive(
//       builder: (context, model, child) => Scaffold(
//         resizeToAvoidBottomInset: true,
//         appBar: AppBar(
//           backgroundColor: kcWhiteColor,
//           elevation: 0.5,
//           leadingWidth: 35.w,
//           leading: Padding(
//             padding: EdgeInsets.only(left: 10.w),
//             child: IconButton(
//               icon: Icon(
//                 Icons.arrow_back_rounded,
//                 color: kcFontColor,
//                 size: 25.w,
//               ),
//               onPressed: model.navBackWithFalse,
//             ),
//           ),
//           centerTitle: true,
//           title: Text(LocaleKeys.bank_card, style: kts22DarkText).tr(),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               //------------------ CREDIT CARD UI ---------------------//
//               CreditCardWidget(
//                 cardNumber: model.cardNumber,
//                 expiryDate: model.expiryDate,
//                 cardHolderName: model.cardHolderName,
//                 cvvCode: model.cvvCode,
//                 bankName: 'Rysgal Bank',
//                 showBackView: model.isCvvFocused,
//                 labelCardHolder: LocaleKeys.card_holder.tr(),
//                 // textStyle: const TextStyle(
//                 //   color: Colors.white,
//                 //   // fontFamily: 'halter',
//                 //   fontSize: 16,
//                 //   package: 'flutter_credit_card',
//                 // ),
//                 obscureCardNumber: true,
//                 obscureCardCvv: true,
//                 isHolderNameVisible: true,
//                 cardBgColor: kcPrimaryColor,
//                 isSwipeGestureEnabled: true,
//                 onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
//                 // customCardTypeIcons: <CustomCardTypeIcon>[
//                 //   CustomCardTypeIcon(
//                 //     cardType: CardType.mastercard,
//                 //     cardImage: Image.asset(
//                 //       'assets/mastercard.png',
//                 //       height: 48,
//                 //       width: 48,
//                 //     ),
//                 //   ),
//                 // ],
//               ),
//               //------------------ CREDIT CARD FORM ---------------------//
//               CreditCardForm(
//                 formKey: creditCardFormKey,
//                 obscureCvv: true,
//                 obscureNumber: true,
//                 cardNumber: model.cardNumber,
//                 cvvCode: model.cvvCode,
//                 isHolderNameVisible: true,
//                 isCardNumberVisible: true,
//                 isExpiryDateVisible: true,
//                 cardHolderName: model.cardHolderName,
//                 expiryDate: model.expiryDate,
//                 themeColor: kcPrimaryColor,
//                 cardNumberDecoration: InputDecoration(
//                   labelText: LocaleKeys.card_number.tr(),
//                   hintText: 'XXXX XXXX XXXX XXXX',
//                   hintStyle: kts16HelperText,
//                   labelStyle: kts16HelperText,
//                   focusedBorder: AppTheme().cardOutlineInputBorder,
//                   enabledBorder: AppTheme().cardOutlineInputBorder,
//                 ),
//                 expiryDateDecoration: InputDecoration(
//                   hintStyle: kts16HelperText,
//                   labelStyle: kts16HelperText,
//                   focusedBorder: AppTheme().cardOutlineInputBorder,
//                   enabledBorder: AppTheme().cardOutlineInputBorder,
//                   labelText: LocaleKeys.card_date_deadline.tr(),
//                   hintText: 'XX/XX',
//                 ),
//                 cvvCodeDecoration: InputDecoration(
//                   hintStyle: kts16HelperText,
//                   labelStyle: kts16HelperText,
//                   focusedBorder: AppTheme().cardOutlineInputBorder,
//                   enabledBorder: AppTheme().cardOutlineInputBorder,
//                   labelText: 'CVV',
//                   hintText: 'XXX',
//                 ),
//                 cardHolderDecoration: InputDecoration(
//                   hintStyle: kts16HelperText,
//                   labelStyle: kts16HelperText,
//                   focusedBorder: AppTheme().cardOutlineInputBorder,
//                   enabledBorder: AppTheme().cardOutlineInputBorder,
//                   labelText: LocaleKeys.card_holder.tr(),
//                 ),
//                 onCreditCardModelChange: model.onCreditCardModelChange,
//               ),
//               //------------------ CARD ADD BUTTON ---------------------//
//               Container(
//                 color: kcWhiteColor,
//                 padding: EdgeInsets.fromLTRB(16.w, 75.h, 16.w, 50.h),
//                 child: SizedBox(
//                   width: 1.sw,
//                   child: TextButton(
//                     style: TextButton.styleFrom(
//                       backgroundColor: kcPrimaryColor,
//                       primary: kcSecondaryLightColor, // ripple effect color
//                       elevation: 0,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: AppTheme().radius10),
//                       padding: EdgeInsets.symmetric(vertical: 14.h),
//                     ),
//                     child: model.isBusy
//                         ? ButtonLoading()
//                         : Text(
//                             LocaleKeys.add_card,
//                             style: ktsButton18Text,
//                           ).tr(),
//                     onPressed: () async {
//                       if (creditCardFormKey.currentState!.validate()) {
//                         print('valid!');
//                       } else {
//                         print('invalid!');
//                       }
//                       // FocusScope.of(context)
//                       //     .unfocus(); // UNFOCUSES all textfield b4 data fetch
//                       // if (!_addEditAddressformKey.currentState!.validate())
//                       //   return;
//                       // _addEditAddressformKey.currentState!.save();
//                       // await model.onAddAddressPressed(
//                       //   () => model.navBack(),
//                       //   () => model.navBack(),
//                       // );
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       viewModelBuilder: () => MyCreditCardAddViewModel(),
//     );
//   }
// }
