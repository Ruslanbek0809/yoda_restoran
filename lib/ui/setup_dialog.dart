import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/shared/styles.dart';
import 'package:yoda_res/ui/cart/cart_view_model.dart';
import 'package:yoda_res/ui/restaurant/meal/meal_view_model.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import 'package:yoda_res/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void setupDialog() {
  var dialogService = locator<DialogService>();

  final builders = {
    DialogType.mealCartClear: (context, sheetRequest, completer) =>
        MealDialogView(request: sheetRequest, completer: completer),
    DialogType.clearCart: (context, sheetRequest, completer) =>
        ClearCartDialogView(request: sheetRequest, completer: completer),
  };

  dialogService.registerCustomDialogBuilders(builders);
}

class MealDialogView extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  const MealDialogView(
      {Key? key, required this.request, required this.completer});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MealViewModel>.reactive(
      builder: (context, model, child) => (Platform.isIOS)
          ? CupertinoAlertDialog(
              title: Text(request.title!),
              content: Text(request.description!),
              actions: <Widget>[
                CustomTextChildButton(
                  child: Text(
                    request.secondaryButtonTitle!,
                    style: ktsDefault18BoldText,
                  ),
                  color: Colors.transparent,
                  onPressed: () async {
                    await model.navToCartView();
                    completer(DialogResponse());
                  },
                ),
                CustomTextChildButton(
                  child: Text(
                    request.mainButtonTitle!,
                    style: ktsDefault18Text,
                  ),
                  color: Colors.transparent,
                  onPressed: () async {
                    await model.clearCart();
                    completer(DialogResponse());
                  },
                ),
              ],
            )
          : AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: AppTheme().radius10),
              titlePadding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 10.h),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
              actionsAlignment: MainAxisAlignment.center,
              title: Text(
                request.title!,
                textAlign: TextAlign.center,
              ),
              titleTextStyle: ktsDefault20BoldText,
              content: Text(
                request.description!,
                textAlign: TextAlign.center,
                style: ktsDefault14DialogText,
              ),
              actions: <Widget>[
                CustomTextChildButton(
                  child: Text(
                    request.secondaryButtonTitle!,
                    style: ktsDefault18BoldText,
                  ),
                  color: Colors.transparent,
                  onPressed: () async {
                    await model.navToCartView();
                    completer(DialogResponse());
                  },
                ),
                SizedBox(width: 8.w),
                CustomTextChildButton(
                  child: Text(
                    request.mainButtonTitle!,
                    style: ktsDefault18Text,
                  ),
                  color: Colors.transparent,
                  onPressed: () async {
                    await model.clearCart();
                    completer(DialogResponse());
                  },
                ),
              ],
            ),
      viewModelBuilder: () => MealViewModel(),
    );
  }
}

class ClearCartDialogView extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  const ClearCartDialogView(
      {Key? key, required this.request, required this.completer});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CartViewModel>.reactive(
      builder: (context, model, child) => (Platform.isIOS)
          ? CupertinoAlertDialog(
              title: Text(request.title!),
              content: Text(request.description!),
              actions: <Widget>[
                CustomTextChildButton(
                  child: Text(
                    request.secondaryButtonTitle!,
                    style: ktsDefault18Text,
                  ),
                  color: Colors.transparent,
                  onPressed: () async {
                    await model.clearCart();
                    completer(DialogResponse());
                  },
                ),
                CustomTextChildButton(
                  child: Text(
                    request.mainButtonTitle!,
                    style: ktsDefault18Text,
                  ),
                  color: Colors.transparent,
                  onPressed: () async {
                    completer(DialogResponse());
                  },
                ),
              ],
            )
          : AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: AppTheme().radius10),
              titlePadding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 15.h),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
              actionsAlignment: MainAxisAlignment.center,
              title: Text(
                request.title!,
                textAlign: TextAlign.center,
              ),
              titleTextStyle: ktsDefault20BoldText,
              actions: <Widget>[
                CustomTextChildButton(
                  child: Text(
                    request.secondaryButtonTitle!,
                    style: ktsDefault18Text,
                  ),
                  color: Colors.transparent,
                  onPressed: () async {
                    await model.clearCart();
                    completer(DialogResponse());
                  },
                ),
                SizedBox(width: 42.w),
                CustomTextChildButton(
                  child: Text(
                    request.mainButtonTitle!,
                    style: ktsDefault18Text,
                  ),
                  color: Colors.transparent,
                  onPressed: () async {
                    completer(DialogResponse());
                  },
                ),
              ],
            ),
      viewModelBuilder: () => CartViewModel(),
    );
  }
}



// class MealDialog extends ViewModelWidget<MealViewModel> {
//   final DialogRequest request;
//   final Function(DialogResponse) completer;
//   const MealDialog({Key? key, required this.request, required this.completer})
//       : super(key: key, reactive: true);

//   @override
//   Widget build(BuildContext context, MealViewModel model) {
//     if (Platform.isIOS)
//       return CupertinoAlertDialog(
//         title: Text(request.title!),
//         content: Text(request.description!),
//         actions: <Widget>[
//           CustomTextChildButton(
//             child: Text(
//               request.secondaryButtonTitle!,
//               style: ktsDefault18BoldText,
//             ),
//             color: Colors.transparent,
//             onPressed: () => completer(DialogResponse()),
//           ),
//           CustomTextChildButton(
//             child: Text(
//               request.mainButtonTitle!,
//               style: ktsDefault18Text,
//             ),
//             color: Colors.transparent,
//             onPressed: () async {
//               await model.clearCart();
//               completer(DialogResponse());
//             },
//           ),
//         ],
//       );
//     return AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: AppTheme().radius10),
//       titlePadding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 10.h),
//       contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
//       actionsAlignment: MainAxisAlignment.center,
//       title: Text(
//         request.title!,
//         textAlign: TextAlign.center,
//       ),
//       titleTextStyle: ktsDefault20BoldText,
//       content: Text(
//         request.description!,
//         textAlign: TextAlign.center,
//         style: ktsDefault14DialogText,
//       ),
//       actions: <Widget>[
//         CustomTextChildButton(
//           child: Text(
//             request.secondaryButtonTitle!,
//             style: ktsDefault18BoldText,
//           ),
//           color: Colors.transparent,
//           onPressed: () => completer(DialogResponse()),
//         ),
//         SizedBox(width: 8.w),
//         CustomTextChildButton(
//           child: Text(
//             request.mainButtonTitle!,
//             style: ktsDefault18Text,
//           ),
//           color: Colors.transparent,
//           onPressed: () => completer(DialogResponse()),
//         ),
//       ],
//     );
//   }
// }
