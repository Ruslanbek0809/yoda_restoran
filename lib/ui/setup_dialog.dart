import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/shared/shared.dart';
import 'package:yoda_res/ui/drawer/addresses/addresses_view_model.dart';
import '../app/app.locator.dart';
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
    DialogType.rateUs: (context, sheetRequest, completer) => RateUsDialogView(
          request: sheetRequest,
          completer: completer,
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
              title: Text(request.title!, style: ktsDefault18BoldText).tr(),
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
              titleTextStyle: ktsDefault18BoldText,
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
                title: Text(request.title!, style: ktsDefault18BoldText).tr(),
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
                titleTextStyle: ktsDefault18BoldText,
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
                title: Text(request.title!, style: ktsDefault18BoldText).tr(),
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
                titleTextStyle: ktsDefault18BoldText,
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
            title: Text(request.title!, style: ktsDefault18BoldText).tr(),
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
            shape: RoundedRectangleBorder(borderRadius: AppTheme().radius10),
            titlePadding: EdgeInsets.fromLTRB(20.w, 24.h, 24.w, 8.h),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
            actionsAlignment: MainAxisAlignment.center,
            title: Text(
              request.title!,
              textAlign: TextAlign.center,
            ).tr(),
            titleTextStyle: ktsDefault18BoldText,
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
            title: Text(request.title!, style: ktsDefault18BoldText).tr(),
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
            titleTextStyle: ktsDefault18BoldText,
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
                title: Text(request.title!, style: ktsDefault18BoldText).tr(),
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
                titleTextStyle: ktsDefault18BoldText,
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

class RateUsDialogView extends StatefulWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  const RateUsDialogView({
    Key? key,
    required this.request,
    required this.completer,
  });
  @override
  _RateUsDialogViewState createState() => _RateUsDialogViewState();
}

class _RateUsDialogViewState extends State<RateUsDialogView>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  final GlobalKey<FormState> _rateFormKey = GlobalKey<FormState>();
  final TextEditingController _notesController = TextEditingController();
  final FocusNode _notesFocus = FocusNode();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _notesController.dispose();
    _notesFocus.dispose();
    super.dispose();
  }

  Future _onConfirmButtonPressed() async {
    setState(() {
      _isLoading = true;
    });
    if (_rateFormKey.currentState!.validate()) {
      printLog('_contactformKey validated');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      alignment: Alignment.bottomCenter,
      insetAnimationCurve: Curves.ease,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Constants.BORDER_RADIUS_20),
        ),
      ),
      child: Container(
        height: 0.95.sh,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(

              /// To resize screen when OnKeyboard opened
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                  key: _rateFormKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    children: [
                      // --------------- YODA RES Title -------------- //
                      Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: SvgPicture.asset(
                          'assets/rate_yoda_res.svg',
                          color: AppTheme.MAIN,
                          width: 0.35.sw,
                        ),
                      ),
                      // --------------- RES NAME -------------- //
                      Padding(
                        padding: EdgeInsets.only(top: 35.h, bottom: 10.h),
                        child: Text(
                          'Soltan Restoran',
                          style: TextStyle(
                            fontSize: 30.sp,
                            color: AppTheme.MAIN_DARK,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // --------------- TEXT -------------- //
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: Text(
                          'Sargyt edeniňiz üçin sag boluň!',
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: AppTheme.FONT_COLOR,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      // --------------- TEXT -------------- //
                      Padding(
                        padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                        child: Text(
                          'Işimiziň hilini ýokarlandyrmak üçin tagamlarymyza we hyzmatymyza berjek bahaňyz biziň üçin wajyp.',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppTheme.FONT_COLOR,
                          ),
                          textAlign: TextAlign.center,
                        ),
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
                          unratedColor: AppTheme.MAIN.withOpacity(0.4),
                          itemSize: 60,
                          itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: AppTheme.MAIN,
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                      ),
                      // --------------- COMMENT -------------- //
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        child: TextFormField(
                          controller: _notesController,
                          minLines: 8,
                          maxLines: null,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: AppTheme().radius10,
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: AppTheme.MAIN_LIGHT,
                            hintText: 'Teswir',
                            hintStyle: TextStyle(
                              fontSize: 16.sp,
                              color: AppTheme.TEXTFIELD_HINT_COLOR,
                            ),
                          ),
                          validator: (value) {
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 50.h),
                      //--------------- SEND Button -------------- //
                      SizedBox(
                        width: 1.sw,
                        child: CustomTextChildButton(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child:
                                // model.isBusy
                                //     ? ButtonLoading()
                                //     :
                                Text(
                              'Ugrat',
                              style: ktsButton18Text,
                            ),
                          ),
                          onPressed: () => showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: AppTheme().radius20,
                              ),
                              title: Column(
                                children: [
                                  SvgPicture.asset(
                                    'assets/success_rate_star.svg',
                                    color: AppTheme.MAIN,
                                    width: 120.w,
                                    height: 120.w,
                                  ),
                                  SizedBox(height: 15.h),
                                  Text(
                                    'Soltan Restoran',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppTheme.MAIN,
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  )
                                ],
                              ),
                              content: Text(
                                'Pikiriňizi paýlaşanyňyz üçin sag boluň!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.GREEN_COLOR,
                                ),
                              ),
                            ),
                          ),
                          // onPressed:
                          // model.isBusy
                          //     ? () {}
                          //     : () async {
                          //         if (model.selectedAddress!.id == -1 &&
                          //             model.isDelivery)
                          //           await showErrorFlashBar(
                          //             context: context,
                          //             msg: LocaleKeys.selectAddressPls,
                          //             margin: EdgeInsets.only(
                          //               left: 16.w,
                          //               right: 16.w,
                          //               bottom: 0.13.sh,
                          //             ),
                          //           );
                          //         else
                          //           await model.createOrder(
                          //             onFailForView: () async =>
                          //                 await showErrorFlashBar(
                          //               context: context,
                          //               margin: EdgeInsets.only(
                          //                 left: 16.w,
                          //                 right: 16.w,
                          //                 bottom: 0.13.sh,
                          //               ),
                          //             ),
                          //           );
                          //       },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
