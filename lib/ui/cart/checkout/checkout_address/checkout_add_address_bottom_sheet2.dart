// import 'package:flutter/material.dart';
// import 'package:stacked/stacked.dart';
// import '../../../../generated/locale_keys.g.dart';
// import '../../../../shared/shared.dart';
// import 'add_address_bottom_sheet_hook.dart';
// import '../../../widgets/widgets.dart';
// import '../../../../utils/utils.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'checkout_address_view_model.dart';
// import 'package:easy_localization/easy_localization.dart';

// class CheckoutAddAddressBottomSheet2View extends StatelessWidget {
//   final ScrollController scrollController;
//   final double offset;
//   CheckoutAddAddressBottomSheet2View({
//     Key? key,
//     required this.scrollController,
//     required this.offset,
//   }) : super(key: key);

//   final GlobalKey<FormState> _addressformKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<CheckoutAddressViewModel>.reactive(
//       builder: (context, model, child) => Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.vertical(
//             top: Radius.circular(Constants.BORDER_RADIUS_20),
//           ),
//           color: kcWhiteColor,
//         ),
//         child: ListView(
//           controller: scrollController,
//           shrinkWrap: true,
//           children: [
//             // // --------------- BOTTOM SHEET DRAGGER -------------- //
//             // Padding(
//             //   padding: EdgeInsets.symmetric(vertical: 8.h),
//             //   child: SvgPicture.asset(
//             //     'assets/bottom_sheet_dragger.svg',
//             //     color: kcSecondaryLightColor,
//             //     // height: 6.h,
//             //   ),
//             // ),
//             // --------------- CUSTOM BOTTOM SHEET MODAL WIDGET -------------- //
//             CustomModalInsideBottomSheet(),

//             Padding(
//               padding: EdgeInsets.fromLTRB(16.w, 15.h, 16.w, 10.h),
//               child: Form(
//                 key: _addressformKey,
//                 autovalidateMode: AutovalidateMode.disabled,
//                 child: AddAddressBottomSheetHook(),
//               ),
//             ),
//             //--------------- ADD ADDRESS BUTTON -------------- //
//             Padding(
//               padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 22.h),
//               child: CustomTextChildButton(
//                 borderRadius: AppTheme().radius15,
//                 padding: EdgeInsets.symmetric(vertical: 14.h),
//                 child: AnimatedSwitcher(
//                   duration: const Duration(milliseconds: 300),
//                   child: model.isLoading
//                       ? ButtonLoading()
//                       : Text(
//                           LocaleKeys.addNewAddressButton,
//                           style: ktsButtonWhite18Text,
//                         ).tr(),
//                 ),
//                 onPressed: !model.isLoading
//                     ? () async {
//                         FocusScope.of(context)
//                             .unfocus(); // UNFOCUSES all textfield b4 data fetch
//                         if (!_addressformKey.currentState!.validate()) return;
//                         _addressformKey.currentState!.save();
//                         await model.onAddAddressPressed(() async {
//                           Navigator.pop(context);
//                           await showErrorFlashBar(
//                             context: context,
//                             msg: LocaleKeys.addAddedSuccessfully,
//                             margin: EdgeInsets.only(
//                               left: 16.w,
//                               right: 16.w,
//                               bottom: 0.05.sh,
//                             ),
//                           );
//                         }, () async {
//                           await showErrorFlashBar(
//                             context: context,
//                             margin: EdgeInsets.only(
//                               left: 16.w,
//                               right: 16.w,
//                               bottom: 0.05.sh,
//                             ),
//                           );
//                         });
//                       }
//                     : () {},
//               ),
//             )
//           ],
//         ),
//       ),
//       viewModelBuilder: () => CheckoutAddressViewModel(),
//     );
//   }
// }
