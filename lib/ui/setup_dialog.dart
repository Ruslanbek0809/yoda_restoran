import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/ui/cart/order/order_view_model.dart';
import 'package:yoda_res/ui/drawer/addresses/addresses_view_model.dart';
import '../app/app.locator.dart';
import '../shared/styles.dart';
import 'cart/cart_view_model.dart';
import 'restaurant/meal/meal_view_model.dart';
import 'widgets/widgets.dart';
import '../utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

void setupDialog() {
  var dialogService = locator<DialogService>();

  final builders = {
    DialogType.mealCartClear: (context, sheetRequest, completer) =>
        MealDialogView(request: sheetRequest, completer: completer),
    DialogType.clearCart: (context, sheetRequest, completer) =>
        ClearCartDialogView(
          request: sheetRequest,
          completer: completer,
          cartViewModel: sheetRequest.data,
        ),
    DialogType.removeCartMeal: (context, sheetRequest, completer) =>
        RemoveCartMealDialogView(
          request: sheetRequest,
          completer: completer,
          cartMealDialogData: sheetRequest.data,
        ),
    DialogType.cancelWaitingOrder: (context, sheetRequest, completer) =>
        CancelWaitingOrderDialogView(
          request: sheetRequest,
          completer: completer,
        ),
    DialogType.cancelAcceptedOrder: (context, sheetRequest, completer) =>
        CancelAcceptedOrderDialogView(
          request: sheetRequest,
          completer: completer,
          content: sheetRequest.data,
        ),
    DialogType.notification: (context, sheetRequest, completer) =>
        NotificationDialogView(
          request: sheetRequest,
          completer: completer,
          notificationData: sheetRequest.data,
        ),
    DialogType.removeAddress: (context, sheetRequest, completer) =>
        RemoveAddressDialogView(
          request: sheetRequest,
          completer: completer,
          addressDialogData: sheetRequest.data,
        ),
  };

  dialogService.registerCustomDialogBuilders(builders);
}

//------------------ MEAL and RESTAURANT DIALOGS ---------------------//

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
              title: Text(request.title!, style: ktsDefault20BoldText).tr(),
              content: Text(
                request.description!,
                style: ktsDefault14DialogText,
              ).tr(),
              actions: <Widget>[
                CustomTextChildButton(
                  child: Text(
                    request.secondaryButtonTitle!,
                    style: ktsDefault18SemiBoldText,
                  ).tr(),
                  color: Colors.transparent,
                  onPressed: () async {
                    await model.navToCartView();
                    completer(DialogResponse());
                  },
                ),
                CustomTextChildButton(
                  child: Text(
                    request.mainButtonTitle!,
                    style: kts18Text,
                  ).tr(),
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
              ).tr(),
              titleTextStyle: ktsDefault20BoldText,
              content: Text(
                request.description!,
                textAlign: TextAlign.center,
                style: ktsDefault14DialogText,
              ).tr(),
              actions: <Widget>[
                CustomTextChildButton(
                  child: Text(
                    request.secondaryButtonTitle!,
                    style: ktsDefault18SemiBoldText,
                  ).tr(),
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
                    style: kts18Text,
                  ).tr(),
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

//------------------ CART DIALOGS ---------------------//

class ClearCartDialogView extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  final CartViewModel cartViewModel;
  const ClearCartDialogView({
    Key? key,
    required this.request,
    required this.completer,
    required this.cartViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CartViewModel>.reactive(
      viewModelBuilder: () => cartViewModel,
      disposeViewModel: false,
      builder: (context, model, child) {
        return (Platform.isIOS)
            ? CupertinoAlertDialog(
                title: Text(request.title!, style: ktsDefault20BoldText).tr(),
                actions: <Widget>[
                  CustomTextChildButton(
                    child: Text(
                      request.secondaryButtonTitle!,
                      style: kts18Text,
                    ).tr(),
                    color: Colors.transparent,
                    onPressed: () async {
                      await model.clearCart();
                      completer(DialogResponse());
                    },
                  ),
                  CustomTextChildButton(
                    child: Text(
                      request.mainButtonTitle!,
                      style: kts18Text,
                    ).tr(),
                    color: Colors.transparent,
                    onPressed: () async {
                      completer(DialogResponse());
                    },
                  ),
                ],
              )
            : AlertDialog(
                shape:
                    RoundedRectangleBorder(borderRadius: AppTheme().radius10),
                titlePadding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 8.h),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                actionsAlignment: MainAxisAlignment.center,
                title: Text(
                  request.title!,
                  textAlign: TextAlign.center,
                ).tr(),
                titleTextStyle: ktsDefault20BoldText,
                actions: <Widget>[
                  CustomTextChildButton(
                    child: Text(
                      request.secondaryButtonTitle!,
                      style: kts18Text,
                    ).tr(),
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
                      style: kts18Text,
                    ).tr(),
                    color: Colors.transparent,
                    onPressed: () async {
                      completer(DialogResponse());
                    },
                  ),
                ],
              );
      },
    );
  }
}

class RemoveCartMealDialogView extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  final CartMealDialogData cartMealDialogData;
  const RemoveCartMealDialogView({
    Key? key,
    required this.request,
    required this.completer,
    required this.cartMealDialogData,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CartViewModel>.reactive(
      viewModelBuilder: () => cartMealDialogData.cartViewModel!,
      disposeViewModel: false,
      builder: (context, model, child) {
        return (Platform.isIOS)
            ? CupertinoAlertDialog(
                title: Text(request.title!, style: ktsDefault20BoldText).tr(),
                actions: <Widget>[
                  CustomTextChildButton(
                    child: Text(
                      request.secondaryButtonTitle!,
                      style: kts18Text,
                    ).tr(),
                    color: Colors.transparent,
                    onPressed: () async {
                      await model.updateCartMealInCart(
                        cartMealDialogData.cartMeal!,
                        cartMealDialogData.cartMeal!.quantity! - 1,
                      );
                      completer(DialogResponse());
                    },
                  ),
                  CustomTextChildButton(
                    child: Text(
                      request.mainButtonTitle!,
                      style: kts18Text,
                    ).tr(),
                    color: Colors.transparent,
                    onPressed: () async {
                      completer(DialogResponse());
                    },
                  ),
                ],
              )
            : AlertDialog(
                shape:
                    RoundedRectangleBorder(borderRadius: AppTheme().radius10),
                titlePadding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 8.h),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                actionsAlignment: MainAxisAlignment.center,
                title: Text(
                  request.title!,
                  textAlign: TextAlign.center,
                ).tr(),
                titleTextStyle: ktsDefault20BoldText,
                actions: <Widget>[
                  CustomTextChildButton(
                    child: Text(
                      request.secondaryButtonTitle!,
                      style: kts18Text,
                    ).tr(),
                    color: Colors.transparent,
                    onPressed: () async {
                      await model.updateCartMealInCart(
                        cartMealDialogData.cartMeal!,
                        cartMealDialogData.cartMeal!.quantity! - 1,
                      );
                      completer(DialogResponse());
                    },
                  ),
                  SizedBox(width: 42.w),
                  CustomTextChildButton(
                    child: Text(
                      request.mainButtonTitle!,
                      style: kts18Text,
                    ).tr(),
                    color: Colors.transparent,
                    onPressed: () async {
                      completer(DialogResponse());
                    },
                  ),
                ],
              );
      },
    );
  }
}

//------------------ ORDER DIALOGS ---------------------//

class CancelWaitingOrderDialogView extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  const CancelWaitingOrderDialogView({
    Key? key,
    required this.request,
    required this.completer,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OrderViewModel>.reactive(
      viewModelBuilder: () => OrderViewModel(),
      builder: (context, model, child) {
        return (Platform.isIOS)
            ? CupertinoAlertDialog(
                title: Text(request.title!, style: ktsDefault20BoldText).tr(),
                actions: <Widget>[
                  CustomTextChildButton(
                    child: Text(
                      request.secondaryButtonTitle!,
                      style: kts18Text,
                    ).tr(),
                    color: Colors.transparent,
                    onPressed: () async {
                      completer(DialogResponse(data: true));
                    },
                  ),
                  CustomTextChildButton(
                    child: Text(
                      request.mainButtonTitle!,
                      style: ktsDefault18SemiBoldText,
                    ).tr(),
                    color: Colors.transparent,
                    onPressed: () async {
                      completer(DialogResponse(data: false));
                    },
                  ),
                ],
              )
            : AlertDialog(
                shape:
                    RoundedRectangleBorder(borderRadius: AppTheme().radius10),
                titlePadding: EdgeInsets.fromLTRB(20.w, 24.h, 24.w, 8.h),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                actionsAlignment: MainAxisAlignment.center,
                title: Text(
                  request.title!,
                  textAlign: TextAlign.center,
                ).tr(),
                titleTextStyle: ktsDefault20BoldText,
                actions: <Widget>[
                  CustomTextChildButton(
                    child: Text(
                      request.secondaryButtonTitle!,
                      style: kts18Text,
                    ).tr(),
                    color: Colors.transparent,
                    onPressed: () async {
                      completer(DialogResponse(data: true));
                    },
                  ),
                  SizedBox(width: 42.w),
                  CustomTextChildButton(
                    child: Text(
                      request.mainButtonTitle!,
                      style: ktsDefault18SemiBoldText,
                    ).tr(),
                    color: Colors.transparent,
                    onPressed: () async {
                      completer(DialogResponse(data: false));
                    },
                  ),
                ],
              );
      },
    );
  }
}

class CancelAcceptedOrderDialogView extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  final String content;
  const CancelAcceptedOrderDialogView({
    Key? key,
    required this.request,
    required this.completer,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OrderViewModel>.reactive(
      viewModelBuilder: () => OrderViewModel(),
      builder: (context, model, child) {
        return (Platform.isIOS)
            ? CupertinoAlertDialog(
                title: Text(request.title!, style: ktsDefault20BoldText).tr(),
                content: Text(content, style: kts18Text).tr(),
              )
            : AlertDialog(
                shape:
                    RoundedRectangleBorder(borderRadius: AppTheme().radius10),
                titlePadding: EdgeInsets.fromLTRB(20.w, 24.h, 24.w, 0.h),
                contentPadding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
                actionsAlignment: MainAxisAlignment.center,
                title: Text(
                  request.title!,
                  textAlign: TextAlign.center,
                ).tr(),
                titleTextStyle: ktsDefault20BoldText,
                content: Text(
                  content,
                  textAlign: TextAlign.center,
                ).tr(),
                contentTextStyle: kts18Text,
              );
      },
    );
  }
}

//------------------ NOTIFICATION DIALOGS ---------------------//

class NotificationDialogView extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  final NotificationDialogData notificationData;
  const NotificationDialogView({
    Key? key,
    required this.request,
    required this.completer,
    required this.notificationData,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OrderViewModel>.reactive(
      viewModelBuilder: () => OrderViewModel(),
      builder: (context, model, child) {
        return (Platform.isIOS)
            ? CupertinoAlertDialog(
                title: Column(
                  children: [
                    Lottie.asset(
                      notificationData.lottie,
                      height: 85.h,
                      width: 85.w,
                    ),
                    // SvgPicture.asset(
                    //   notificationData.svg,
                    //   color: AppTheme.MAIN,
                    //   width: 90.w,
                    //   height: 90.w,
                    // ),
                    SizedBox(height: 15.h),
                    Text(
                      notificationData.restaurant,
                      textAlign: TextAlign.center,
                      style: kts22PrimaryText,
                    )
                  ],
                ),
                content: Text(
                  notificationData.content,
                  textAlign: TextAlign.center,
                  style: kts18NotificationText,
                ),
              )
            : AlertDialog(
                shape:
                    RoundedRectangleBorder(borderRadius: AppTheme().radius20),
                titlePadding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 0.h),
                contentPadding: EdgeInsets.fromLTRB(20.w, 6.h, 20.w, 24.h),
                actionsAlignment: MainAxisAlignment.center,
                title: Column(
                  children: [
                    Lottie.asset(
                      notificationData.lottie,
                      height: 0.2.sh,
                    ),
                    // SvgPicture.asset(
                    //   notificationData.lottie,
                    //   color: AppTheme.MAIN,
                    //   width: 90.w,
                    //   height: 90.w,
                    // ),
                    SizedBox(height: 15.h),
                    Text(
                      notificationData.restaurant,
                      textAlign: TextAlign.center,
                      style: kts22PrimaryText,
                    )
                  ],
                ),
                content: Text(
                  notificationData.content,
                  textAlign: TextAlign.center,
                ),
                contentTextStyle: kts18NotificationText,
              );
      },
    );
  }
}
//------------------ ADDRESS DIALOGS ---------------------//

class RemoveAddressDialogView extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  final AddressDialogData addressDialogData;
  const RemoveAddressDialogView({
    Key? key,
    required this.request,
    required this.completer,
    required this.addressDialogData,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddressesViewModel>.reactive(
      viewModelBuilder: () => addressDialogData.addressesViewModel!,
      disposeViewModel: false,
      builder: (context, model, child) {
        return (Platform.isIOS)
            ? CupertinoAlertDialog(
                title: Text(request.title!, style: ktsDefault20BoldText).tr(),
                actions: <Widget>[
                  CustomTextChildButton(
                    child: Text(
                      request.secondaryButtonTitle!,
                      style: kts18Text,
                    ).tr(),
                    color: Colors.transparent,
                    onPressed: () async {
                      completer(DialogResponse());
                    },
                  ),
                  CustomTextChildButton(
                    child: Text(
                      request.mainButtonTitle!,
                      style: kts18Text,
                    ).tr(),
                    color: Colors.transparent,
                    onPressed: () async {
                      completer(DialogResponse());
                    },
                  ),
                ],
              )
            : AlertDialog(
                shape:
                    RoundedRectangleBorder(borderRadius: AppTheme().radius10),
                titlePadding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 8.h),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                actionsAlignment: MainAxisAlignment.center,
                title: Text(
                  request.title!,
                  textAlign: TextAlign.center,
                ).tr(),
                titleTextStyle: ktsDefault20BoldText,
                actions: <Widget>[
                  CustomTextChildButton(
                    child:
                        //  model.busy(addressDialogData.address!.id) ?
                        Text(
                      request.secondaryButtonTitle!,
                      style: kts18Text,
                    ).tr(),
                    color: Colors.transparent,
                    onPressed: () async {
                      await model.onDeleteAddressPressed(
                        addressDialogData.address!,
                        () async {
                          showErrorFlashBar(
                            context: context,
                            msg: 'Address deleted successfully', // TODO: Lang
                            margin: EdgeInsets.only(
                              left: 0.1.sw,
                              right: 0.1.sw,
                              bottom: 0.05.sh,
                            ),
                          );
                          completer(DialogResponse());
                        },
                        () async {
                          showErrorFlashBar(
                            context: context,
                            margin: EdgeInsets.only(
                              left: 0.1.sw,
                              right: 0.1.sw,
                              bottom: 0.05.sh,
                            ),
                          );
                          completer(DialogResponse());
                        },
                      );
                    },
                  ),
                  SizedBox(width: 42.w),
                  CustomTextChildButton(
                    child: Text(
                      request.mainButtonTitle!,
                      style: kts18Text,
                    ).tr(),
                    color: Colors.transparent,
                    onPressed: () async {
                      completer(DialogResponse());
                    },
                  ),
                ],
              );
      },
    );
  }
}
