import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../generated/locale_keys.g.dart';
import '../models/models.dart';
import '../shared/shared.dart';
import 'drawer/addresses/addresses_view_model.dart';
import 'rate_us_dialog_hook.dart';
import '../app/app.locator.dart';
import 'cart/cart_view_model.dart';
import 'rate_us_dialog_view_model.dart';
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
    DialogType.rateOrder: (context, sheetRequest, completer) =>
        RateOrderDialogView(
          request: sheetRequest,
          completer: completer,
          notificationModel: sheetRequest.data,
        ),
    DialogType.orderDelete: (context, sheetRequest, completer) =>
        OrderDeleteDialogView(
          request: sheetRequest,
          completer: completer,
        ),
    DialogType.creditCardDelete: (context, sheetRequest, completer) =>
        CreditCardDeleteDialogView(
          request: sheetRequest,
          completer: completer,
        ),
    DialogType.onlinePaymentFail: (context, sheetRequest, completer) =>
        ShowOnlinePaymentFailDialogView(
          request: sheetRequest,
          completer: completer,
          content: sheetRequest.data,
        ),
    DialogType.onlinePaymentSuccess: (context, sheetRequest, completer) =>
        ShowOnlinePaymentSuccessDialogView(
          request: sheetRequest,
          completer: completer,
          content: sheetRequest.data,
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
              title: Text(request.title!, style: kts18BoldText).tr(),
              content: Text(
                request.description!,
                style: ktsDefault14DialogText,
              ).tr(),
              actions: <Widget>[
                CustomTextChildButton(
                  child: Text(
                    request.secondaryButtonTitle!,
                    style: kts18BoldText,
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
              titleTextStyle: kts18BoldText,
              content: Text(
                request.description!,
                textAlign: TextAlign.center,
                style: ktsDefault14DialogText,
              ).tr(),
              actions: <Widget>[
                CustomTextChildButton(
                  child: Text(
                    request.secondaryButtonTitle!,
                    style: kts18BoldText,
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
                title: Text(request.title!, style: kts18BoldText).tr(),
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
                titleTextStyle: kts18BoldText,
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
                title: Text(request.title!, style: kts18BoldText).tr(),
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
                titleTextStyle: kts18BoldText,
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
    return (Platform.isIOS)
        ? CupertinoAlertDialog(
            title: Text(request.title!, style: kts18BoldText).tr(),
            actions: <Widget>[
              CustomTextChildButton(
                child: Text(
                  request.secondaryButtonTitle!,
                  style: kts18Text,
                ).tr(),
                color: Colors.transparent,
                onPressed: () async =>
                    await completer(DialogResponse(data: true)),
              ),
              CustomTextChildButton(
                child: Text(
                  request.mainButtonTitle!,
                  style: kts18BoldText,
                ).tr(),
                color: Colors.transparent,
                onPressed: () async =>
                    await completer(DialogResponse(data: false)),
              ),
            ],
          )
        : AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: AppTheme().radius10),
            titlePadding: EdgeInsets.fromLTRB(20.w, 24.h, 24.w, 8.h),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
            actionsAlignment: MainAxisAlignment.center,
            title: Text(
              request.title!,
              textAlign: TextAlign.center,
            ).tr(),
            titleTextStyle: kts18BoldText,
            actions: <Widget>[
              CustomTextChildButton(
                child: Text(
                  request.secondaryButtonTitle!,
                  style: kts18Text,
                ).tr(),
                color: Colors.transparent,
                onPressed: () async =>
                    await completer(DialogResponse(data: true)),
              ),
              SizedBox(width: 42.w),
              CustomTextChildButton(
                child: Text(
                  request.mainButtonTitle!,
                  style: kts18BoldText,
                ).tr(),
                color: Colors.transparent,
                onPressed: () async =>
                    await completer(DialogResponse(data: false)),
              ),
            ],
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
    return (Platform.isIOS)
        ? CupertinoAlertDialog(
            title: Text(request.title!, style: kts18BoldText).tr(),
            content: Text(content, style: kts18Text).tr(),
          )
        : AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: AppTheme().radius10),
            titlePadding: EdgeInsets.fromLTRB(20.w, 24.h, 24.w, 0.h),
            contentPadding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
            actionsAlignment: MainAxisAlignment.center,
            title: Text(
              request.title!,
              textAlign: TextAlign.center,
            ).tr(),
            titleTextStyle: kts18BoldText,
            content: Text(
              content,
              textAlign: TextAlign.center,
            ).tr(),
            contentTextStyle: kts18Text,
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
                //   color: kcPrimaryColor,
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
            shape: RoundedRectangleBorder(borderRadius: AppTheme().radius20),
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
                //   color: kcPrimaryColor,
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
                title: Text(request.title!, style: kts18BoldText).tr(),
                actions: <Widget>[
                  CustomTextChildButton(
                    child: Text(
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
                            msg: LocaleKeys.yourAddressDeletedSuccessfully,
                            margin: EdgeInsets.only(
                              left: 0.1.sw,
                              right: 0.1.sw,
                              bottom: 0.05.sh,
                            ),
                          );
                          await completer(DialogResponse(data: true));
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
                          await completer(DialogResponse(data: false));
                        },
                      );
                    },
                  ),
                  CustomTextChildButton(
                    child: Text(
                      request.mainButtonTitle!,
                      style: kts18Text,
                    ).tr(),
                    color: Colors.transparent,
                    onPressed: () async =>
                        await completer(DialogResponse(data: false)),
                  ),
                ],
              )
            : AlertDialog(
                shape:
                    RoundedRectangleBorder(borderRadius: AppTheme().radius10),
                titlePadding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 8.h),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                actionsAlignment: MainAxisAlignment.center,
                title: Column(
                  children: [
                    Text(
                      request.title!,
                      textAlign: TextAlign.center,
                    ).tr(),
                    if (model.busy(addressDialogData.address!.id))
                      Padding(
                        padding: EdgeInsets.only(top: 20.h),
                        child: SpinKitChasingDots(
                          size: 22,
                          color: kcPrimaryColor,
                        ),
                      ),
                  ],
                ),
                titleTextStyle: kts18BoldText,
                actions: <Widget>[
                  CustomTextChildButton(
                    child: Text(
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
                            msg: LocaleKeys.yourAddressDeletedSuccessfully,
                            margin: EdgeInsets.only(
                              left: 0.1.sw,
                              right: 0.1.sw,
                              bottom: 0.05.sh,
                            ),
                          );
                          await completer(DialogResponse(data: true));
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
                          await completer(DialogResponse(data: false));
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
                    onPressed: () async =>
                        await completer(DialogResponse(data: false)),
                  ),
                ],
              );
      },
    );
  }
}

class RateOrderDialogView extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  final NotificationModel notificationModel;
  const RateOrderDialogView({
    Key? key,
    required this.request,
    required this.completer,
    required this.notificationModel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // insetPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.0),
      alignment: Alignment.center,
      insetAnimationCurve: Curves.ease,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.all(Radius.circular(Constants.BORDER_RADIUS_20)),
        // borderRadius: BorderRadius.vertical(
        //   top: Radius.circular(Constants.BORDER_RADIUS_20),
        // ),
      ),
      child: ViewModelBuilder<RateUsDialogViewModel>.reactive(
        viewModelBuilder: () => RateUsDialogViewModel(notificationModel),
        builder: (context, model, child) => SingleChildScrollView(
          padding: EdgeInsets.only(

              /// To resize screen when OnKeyboard opened
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                child: Column(
                  children: [
                    // --------------- YODA RES Title -------------- //
                    Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: SvgPicture.asset(
                        'assets/title_yoda_restoran.svg',
                        width: 0.35.sw,
                      ),
                    ),
                    // --------------- RES NAME -------------- //
                    Padding(
                      padding: EdgeInsets.only(top: 25.h, bottom: 10.h),
                      child: Text(
                        notificationModel.title ?? 'Sultan Restoran',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: kts28DarkBoldText,
                        // style: kts30DarkBoldText,
                      ),
                    ),
                    // --------------- TEXT -------------- //
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Text(
                        LocaleKeys.ratingThanksForTheOrder,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: kts18DarkText,
                        // style: kts20DarkText,
                      ).tr(),
                    ),
                    // --------------- TEXT -------------- //
                    Padding(
                      padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                      child: Text(
                        LocaleKeys.ratingImportantForUs,
                        style: kts14Text,
                        // style: kts16Text,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ).tr(),
                    ),
                    // --------------- RATING -------------- //
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: RatingBar.builder(
                        initialRating: 0,
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        glow: false,
                        unratedColor: model.ratingError
                            ? kcPrimaryColor
                            // ? AppTheme.RED.withOpacity(0.85)
                            : kcPrimaryColor.withOpacity(0.4),
                        itemSize: 50,
                        itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                        itemBuilder: (context, _) => AnimatedCrossFade(
                          crossFadeState: model.ratingError
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          firstChild: Icon(
                            Icons.star,
                            // Icons.star_border,
                            // size: 26,
                            color: kcPrimaryColor,
                          ),
                          duration: const Duration(milliseconds: 200),
                          secondChild: Icon(
                            Icons.star,
                            color: kcPrimaryColor,
                          ),
                        ),
                        onRatingUpdate: model.updateRating,
                      ),
                    ),
                    // --------------- NOTES HOOK -------------- //
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      child: RateUsDialogHook(),
                    ),
                    //--------------- SEND Button -------------- //
                    Padding(
                      padding: EdgeInsets.only(top: 15.h, bottom: 15.h),
                      child: SizedBox(
                        width: 1.sw,
                        child: CustomTextChildButton(
                          color: model.rating == 0
                              ? kcSecondaryLightColor
                              : kcPrimaryColor,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: model.isBusy
                                ? ButtonLoading()
                                : Text(
                                    LocaleKeys.ratingSend,
                                    style: model.rating == 0
                                        ? ktsButton18ContactText
                                        : ktsButtonWhite18Text,
                                  ).tr(),
                          ),
                          onPressed: model.rating == 0
                              ? model.ratingVal
                              : model.isBusy
                                  ? () {}
                                  : () async => await model.onRatingSendPressed(
                                        () async {
                                          /// TODO: HiveRating
                                          await model
                                              .removeHiveRatingFromHiveRatings(
                                                  int.parse(
                                                      notificationModel.id!));

                                          /// TO initialise getOrders() API
                                          await completer(
                                              DialogResponse(data: true));
                                          await showDialog(
                                              context: context,
                                              barrierDismissible: true,
                                              builder: (context) {
                                                model.dismissDialogs();
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        AppTheme().radius20,
                                                  ),
                                                  title: Column(
                                                    children: [
                                                      Text(
                                                        notificationModel
                                                                .title ??
                                                            'Sultan Restoran',
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: kts22PrimaryText,
                                                      ),
                                                      SizedBox(height: 15.h),
                                                      RatingBar.builder(
                                                        initialRating:
                                                            model.rating,
                                                        direction:
                                                            Axis.horizontal,
                                                        itemCount: 5,
                                                        allowHalfRating: false,
                                                        ignoreGestures: true,
                                                        glow: false,
                                                        unratedColor:
                                                            kcPrimaryColor
                                                                .withOpacity(
                                                                    0.4),
                                                        itemSize: 45,
                                                        itemBuilder:
                                                            (context, _) =>
                                                                Icon(
                                                          Icons.star,
                                                          color: kcPrimaryColor,
                                                        ),
                                                        onRatingUpdate:
                                                            model.updateRating,
                                                      ),
                                                    ],
                                                  ),
                                                  content: Text(
                                                    LocaleKeys
                                                        .ratingConfirmation,
                                                    textAlign: TextAlign.center,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        kts18NotificationText,
                                                  ).tr(),
                                                );
                                              }).then((value) {
                                            if (model.timer.isActive)
                                              model.cancelTimer();
                                          });
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
                                          await completer(
                                              DialogResponse(data: false));
                                        },
                                      ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 2.h,
                right: 4.w,
                child: IconButton(
                  onPressed: () async {
                    await model.removeHiveRatingFromHiveRatings(
                        int.parse(notificationModel.id!));
                    await completer(DialogResponse(data: false));
                  },
                  icon: Icon(
                    Icons.clear_rounded,
                    color: kcSecondaryDarkColor,
                    size: 22.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//------------------ ORDER DELETE DIALOGS ---------------------//

class OrderDeleteDialogView extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  const OrderDeleteDialogView({
    Key? key,
    required this.request,
    required this.completer,
  });

  @override
  Widget build(BuildContext context) {
    return (Platform.isIOS)
        ? CupertinoAlertDialog(
            title: Text(request.title!, style: kts18BoldText).tr(),
            actions: <Widget>[
              CustomTextChildButton(
                child: Text(
                  request.secondaryButtonTitle!,
                  style: kts18Text,
                ).tr(),
                color: Colors.transparent,
                onPressed: () async =>
                    await completer(DialogResponse(data: true)),
              ),
              CustomTextChildButton(
                child: Text(
                  request.mainButtonTitle!,
                  style: kts18Text,
                ).tr(),
                color: Colors.transparent,
                onPressed: () async =>
                    await completer(DialogResponse(data: false)),
              ),
            ],
          )
        : AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: AppTheme().radius10),
            titlePadding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 8.h),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
            actionsAlignment: MainAxisAlignment.center,
            title: Text(
              request.title!,
              textAlign: TextAlign.center,
            ).tr(),
            titleTextStyle: kts18BoldText,
            actions: <Widget>[
              CustomTextChildButton(
                child: Text(
                  request.secondaryButtonTitle!,
                  style: kts18Text,
                ).tr(),
                color: Colors.transparent,
                onPressed: () async =>
                    await completer(DialogResponse(data: true)),
              ),
              SizedBox(width: 42.w),
              CustomTextChildButton(
                child: Text(
                  request.mainButtonTitle!,
                  style: kts18Text,
                ).tr(),
                color: Colors.transparent,
                onPressed: () async =>
                    await completer(DialogResponse(data: false)),
              ),
            ],
          );
  }
}
//------------------ CREDIT CARD DELETE DIALOGS ---------------------//

class CreditCardDeleteDialogView extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  const CreditCardDeleteDialogView({
    Key? key,
    required this.request,
    required this.completer,
  });

  @override
  Widget build(BuildContext context) {
    return (Platform.isIOS)
        ? CupertinoAlertDialog(
            title: Text(request.title!, style: kts18BoldText).tr(),
            actions: <Widget>[
              CustomTextChildButton(
                child: Text(
                  request.secondaryButtonTitle!,
                  style: kts18Text,
                ).tr(),
                color: Colors.transparent,
                onPressed: () async =>
                    await completer(DialogResponse(data: true)),
              ),
              CustomTextChildButton(
                child: Text(
                  request.mainButtonTitle!,
                  style: kts18Text,
                ).tr(),
                color: Colors.transparent,
                onPressed: () async =>
                    await completer(DialogResponse(data: false)),
              ),
            ],
          )
        : AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: AppTheme().radius10),
            titlePadding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 8.h),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
            actionsAlignment: MainAxisAlignment.center,
            title: Text(
              request.title!,
              textAlign: TextAlign.center,
            ).tr(),
            titleTextStyle: kts18BoldText,
            actions: <Widget>[
              CustomTextChildButton(
                child: Text(
                  request.secondaryButtonTitle!,
                  style: kts18Text,
                ).tr(),
                color: Colors.transparent,
                onPressed: () async =>
                    await completer(DialogResponse(data: true)),
              ),
              SizedBox(width: 42.w),
              CustomTextChildButton(
                child: Text(
                  request.mainButtonTitle!,
                  style: kts18Text,
                ).tr(),
                color: Colors.transparent,
                onPressed: () async =>
                    await completer(DialogResponse(data: false)),
              ),
            ],
          );
  }
}

//------------------ SHOW ONLINE PAYMENT DIALOGS ---------------------//

class ShowOnlinePaymentFailDialogView extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  final String content;
  const ShowOnlinePaymentFailDialogView({
    Key? key,
    required this.request,
    required this.completer,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return (Platform.isIOS)
        ? CupertinoAlertDialog(
            title: Text(request.title!, style: kts18BoldText).tr(),
            content: Text(content, style: kts18Text).tr(),
          )
        : AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: AppTheme().radius10),
            titlePadding: EdgeInsets.fromLTRB(20.w, 24.h, 24.w, 0.h),
            contentPadding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
            actionsAlignment: MainAxisAlignment.center,
            title: Text(
              request.title!,
              textAlign: TextAlign.center,
            ).tr(),
            titleTextStyle: kts18BoldText,
            content: Text(
              content,
              textAlign: TextAlign.center,
            ).tr(),
            contentTextStyle: kts18Text,
          );
  }
}
