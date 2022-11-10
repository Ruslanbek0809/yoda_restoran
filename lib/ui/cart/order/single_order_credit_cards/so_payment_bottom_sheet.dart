// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:stacked/stacked.dart';
// import '../../../../models/models.dart';
// import '../../../widgets/widgets.dart';
// import '../../../../shared/shared.dart';
// import '../../../../utils/utils.dart';
// import 'so_credit_cards_view_model.dart';

// class SOPaymentBottomSheetView extends StatefulWidget {
//   final ScrollController scrollController;
//   final double offset;
//   final PaymentRegister paymentRegister;
//   const SOPaymentBottomSheetView({
//     Key? key,
//     required this.scrollController,
//     required this.offset,
//     required this.paymentRegister,
//   }) : super(key: key);

//   @override
//   State<SOPaymentBottomSheetView> createState() =>
//       _SOPaymentBottomSheetViewState();
// }

// class _SOPaymentBottomSheetViewState extends State<SOPaymentBottomSheetView> {
//   final GlobalKey webViewKey = GlobalKey();

//   InAppWebViewController? webViewController;

//   InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
//     crossPlatform: InAppWebViewOptions(
//       useShouldOverrideUrlLoading: true,
//       mediaPlaybackRequiresUserGesture: false,
//     ),
//     android: AndroidInAppWebViewOptions(
//       useHybridComposition: true,
//     ),
//     ios: IOSInAppWebViewOptions(
//       allowsInlineMediaPlayback: true,
//     ),
//   );

//   late PullToRefreshController pullToRefreshController;

//   String url = "";

//   double progress = 0;

//   final urlController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();

//     pullToRefreshController = PullToRefreshController(
//       options: PullToRefreshOptions(
//         color: kcPrimaryColor,
//       ),
//       onRefresh: () async {
//         if (Platform.isAndroid) {
//           webViewController?.reload();
//         } else if (Platform.isIOS) {
//           webViewController?.loadUrl(
//               urlRequest: URLRequest(url: await webViewController?.getUrl()));
//         }
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<SOCreditCardsViewModel>.reactive(
//       viewModelBuilder: () => SOCreditCardsViewModel(),
//       builder: (context, model, child) => Container(
//         decoration: BoxDecoration(
//           color: kcWhiteColor,
//           borderRadius: BorderRadius.vertical(
//             top: Radius.circular(Constants.BORDER_RADIUS_20),
//           ),
//         ),
//         child: Column(
//           children: [
//             // --------------- CUSTOM BOTTOM SHEET MODAL WIDGET -------------- //
//             CustomModalInsideBottomSheet(),

//             // --------------- CREDIT CARD CONFIRMATION -------------- //
//             Expanded(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16.w),
//                 child: Stack(
//                   children: [
//                     InAppWebView(
//                       key: webViewKey,
//                       // initialData: InAppWebViewInitialData(),
//                       initialUrlRequest: URLRequest(
//                         url: Uri.parse(widget.paymentRegister.formUrl!),
//                       ),
//                       initialOptions: options,
//                       pullToRefreshController: pullToRefreshController,
//                       onWebViewCreated: (controller) {
//                         webViewController = controller;
//                       },
//                       onLoadStart: (controller, url) {
//                         setState(() {
//                           this.url = url.toString();
//                           urlController.text = this.url;
//                         });
//                       },
//                       androidOnPermissionRequest:
//                           (controller, origin, resources) async {
//                         return PermissionRequestResponse(
//                             resources: resources,
//                             action: PermissionRequestResponseAction.GRANT);
//                       },
//                       onProgressChanged: (controller, progress) {
//                         if (progress == 100) {
//                           pullToRefreshController.endRefreshing();
//                         }
//                         setState(() {
//                           this.progress = progress / 100;
//                           urlController.text = this.url;
//                         });
//                       },
//                       onUpdateVisitedHistory:
//                           (controller, url, androidIsReload) {
//                         setState(() {
//                           this.url = url.toString();
//                           urlController.text = this.url;
//                         });
//                       },
//                       onConsoleMessage: (controller, consoleMessage) {
//                         model.log.v(consoleMessage);
//                       },
//                     ),
//                     progress < 1.0
//                         ? LinearProgressIndicator(
//                             value: progress,
//                             backgroundColor: kcPrimaryColor.withOpacity(0.3),
//                             color: kcPrimaryColor,
//                           )
//                         : SizedBox(),
//                   ],
//                 ),
//               ),
//             ),

//             // //--------------- CREDIT CARD CHOOSE BUTTON -------------- //
//             // Container(
//             //   decoration: BoxDecoration(
//             //     color: kcWhiteColor,
//             //     border: Border(
//             //       top: BorderSide(
//             //         width: 0.1,
//             //         color: kcButtonBorderColor,
//             //       ),
//             //     ),
//             //   ),
//             //   padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 22.h),
//             //   child: TextButton(
//             //     style: TextButton.styleFrom(
//             //       backgroundColor: kcOnlinePaymentColor,
//             //       primary: kcSecondaryLightColor, // ripple effect color
//             //       elevation: 0,
//             //       shape:
//             //           RoundedRectangleBorder(borderRadius: AppTheme().radius15),
//             //       padding: EdgeInsets.symmetric(vertical: 14.h),
//             //     ),
//             //     child: Text(
//             //       LocaleKeys.selectCreditCard,
//             //       style: TextStyle(
//             //         color: kcWhiteColor,
//             //         fontSize: 18.sp,
//             //         fontWeight: FontWeight.w400,
//             //       ),
//             //     ).tr(),
//             //     // onPressed: () async => await showFlexibleBottomSheet(
//             //     //   isExpand: false,
//             //     //   initHeight: 0.95,
//             //     //   maxHeight: 0.95,
//             //     //   duration: Duration(milliseconds: 250),
//             //     //   context: context,
//             //     //   bottomSheetColor: Colors.transparent,
//             //     //   builder: (context, scrollController, offset) =>
//             //     //       SOConfirmationBottomSheetView(
//             //     //     scrollController: scrollController,
//             //     //     offset: offset,
//             //     //   ),
//             //     // ),
//             //     onPressed: () async {
//             //     },
//             //   ),
//             // )
//           ],
//         ),
//       ),
//     );
//   }
// }
