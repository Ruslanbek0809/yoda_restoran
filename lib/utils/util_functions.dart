import 'dart:io';

import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import 'package:yoda_res/library/onboarding/onboarding.dart';
import 'package:yoda_res/shared/shared.dart';
import '../models/models.dart';
import '../ui/widgets/widgets.dart';
import 'utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:async';

/// Method to round trailing zero based on its type.

// toStringAsFixed guarantees the specified number of fractional
// digits, so the regular expression is simpler than it would need to
// be for more general cases.
String formatNum(num value) =>
    value.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '');

final List<EachIntroWidget> onBoardingList = [
  EachIntroWidget(
    subTitle: 'Söýgüli restoranlaryňyzyň tagamlaryny sargyt ediň',
    imageUrl: 'assets/onboard1.jpg',
  ),
  EachIntroWidget(
    subTitle:
        'Sargydyňyz kabul edilenden eltip berilýänçä her ädimden habarly boluň',
    imageUrl: 'assets/onboard2.jpg',
  ),
  EachIntroWidget(
    subTitle:
        'Ýörite promokod bilen restoranlardan sargydyňyza arzanladyş alyň',
    imageUrl: 'assets/onboard3.jpg',
  ),
];

final List<String> drawerLogoutList = ["login", "about_us"];

final List<String> drawerLoggedInList = [
  "profile",
  "orders",
  "addresses",
  "about_us"
];

List<Discount> discounts = [
  Discount(1, 'assets/discount1.png'),
  Discount(2, 'assets/discount2.png'),
  Discount(3, 'assets/discount3.png'),
  Discount(4, 'assets/discount4.png'),
  Discount(5, 'assets/discount1.png'),
  Discount(6, 'assets/discount2.png'),
  Discount(7, 'assets/discount3.png'),
  Discount(8, 'assets/discount4.png'),
];

List<CategoryFilter> mainCatSortList = [
  CategoryFilter(1, LocaleKeys.defaultt),
  CategoryFilter(2, LocaleKeys.byName),
  CategoryFilter(3, LocaleKeys.byRatings),
];

List<PaymentTypee> paymentTypes = [
  PaymentTypee(1, 'Nagt'),
  PaymentTypee(2, 'Terminal'),
];

/// Enum for FormValidation
enum FormValidation { phoneInvalid, valid }

/// Enum for bottomCartController
enum BottomCartStatus { idle, forward, reverse }

/// Enum for sortAnimationController
enum MainFilterAnimationStatus { idle, forward, reverse }

/// Enum for bottom sheet types
enum BottomSheetType {
  mainCategory,
  restaurantInfo,
  meal,
  cartMoreMeal,
  checkout,
  paymentType,
  selectAddress,
  addAddress,
}

/// Enum for dialog types
enum DialogType {
  mealCartClear,
  clearCart,
  removeCartMeal,
  cancelWaitingOrder,
  cancelAcceptedOrder,
  notification,
  removeAddress,
}

/// Enum for snackbar types
enum SnackBarType {
  restaurantDetailsError,
}

/// Enum for connectivity
enum ConnectivityStatus { Idle, WiFi, Cellular, Offline }

/// Platform Types
final bool isIos = Platform.isIOS;
final bool isAndroid = Platform.isAndroid;

/// Logging
const kLOG_TAG = '[Belent Online]';
const kLOG_ENABLE = true;
void printLog(dynamic data) {
  if (kLOG_ENABLE) {
    // final now = DateTime.now().toUtc().toString().split(' ').last;
    // debugPrint('[$now]$kLOG_TAG${data.toString()}');
    debugPrint('${data.toString()}');
  }
}

Future<void> showErrorFlashBar({
  required BuildContext context,
  String msg = LocaleKeys.errorOccured,
  required EdgeInsets margin,
}) async {
  await showFlash(
    context: context,
    duration: Duration(milliseconds: 2000),
    builder: (context, controller) {
      return Flash(
        backgroundColor: kcSecondaryDarkColor,
        controller: controller,
        borderRadius: AppTheme().radius15,
        boxShadows: kElevationToShadow[0],
        position: FlashPosition.bottom,
        barrierDismissible: true,
        behavior: FlashBehavior.floating,
        margin: margin,
        child: FlashBar(
          icon: Padding(
            padding: EdgeInsets.only(left: 24.w, right: 12.w),
            child: SvgPicture.asset(
              'assets/warning.svg',
              width: 20.w,
              height: 20.h,
            ),
          ),
          content: Text(msg, style: kts16ButtonText).tr(),
        ),
      );
    },
  );
}

Future<void> showDateRangeErrorFlashBar({
  required BuildContext context,
  Text? msg,
  required EdgeInsets margin,
}) async {
  await showFlash(
    context: context,
    duration: Duration(milliseconds: 3000),
    builder: (context, controller) {
      return Flash(
        backgroundColor: kcSecondaryDarkColor,
        controller: controller,
        borderRadius: AppTheme().radius15,
        boxShadows: kElevationToShadow[0],
        position: FlashPosition.bottom,
        barrierDismissible: true,
        behavior: FlashBehavior.floating,
        margin: margin,
        child: FlashBar(
          icon: Padding(
            padding: EdgeInsets.only(left: 24.w, right: 12.w),
            child: SvgPicture.asset(
              'assets/warning.svg',
              width: 20.w,
              height: 20.h,
            ),
          ),
          content: msg!,
        ),
      );
    },
  );
}

// SnackBar Widget
snackBar(String? message, BuildContext context) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message!),
      duration: Duration(seconds: 2),
    ),
  );
}

/// Device Type
String getDeviceType() {
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance!.window);
  printLog('getDeviceType(): ${data.size.shortestSide}');
  return data.size.shortestSide < 600 ? Constants.PHONE : Constants.TABLET;
}

/// Hex Color
class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T f(E e, int i)) {
    var i = 0;
    return this.map((e) => f(e, i++));
  }
}

fieldFocusChange(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}

Future<dynamic> showAlertDialog({
  required BuildContext context,
  required String title,
  String content = '',
  required String cancelActionText,
  required String defaultActionText,
}) async {
  if (!Platform.isIOS) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: TextStyle(
            color: AppTheme.FONT_COLOR,
            fontSize: 16.sp,
          ),
        ),
        actions: <Widget>[
          CustomTextButton(
            text: defaultActionText,
            color: Colors.transparent,
            textStyle: TextStyle(
              color: AppTheme.FONT_COLOR,
              fontSize: 17.sp,
              fontWeight: FontWeight.bold,
            ),
            onPressed: () => Navigator.of(context).pop(true),
          ),
          CustomTextButton(
            text: cancelActionText,
            color: Colors.transparent,
            textStyle: TextStyle(
              color: AppTheme.FONT_COLOR,
              fontSize: 17.sp,
            ),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
    );
  }

  return showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text(defaultActionText),
          textStyle: TextStyle(
            color: AppTheme.FONT_COLOR,
            fontSize: 17.sp,
            fontWeight: FontWeight.bold,
          ),
          onPressed: () => Navigator.of(context).pop(true),
        ),
        CupertinoDialogAction(
          child: Text(cancelActionText),
          textStyle: TextStyle(
            color: AppTheme.FONT_COLOR,
            fontSize: 17.sp,
          ),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ],
    ),
  );
}

/// DEBOUNCE for search

class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

// late AnimationController _buttonController;

// _buttonController = AnimationController(
//     duration: const Duration(milliseconds: 2000), vsync: this);

// Future _playAnimation() async {
//   try {
//     await _buttonController.forward();
//   } on TickerCanceled {
//     printLog('[_playAnimation] error');
//   }
// }

// Future _stopAnimation() async {
//   try {
//     await _buttonController.reverse();
//   } on TickerCanceled {
//     printLog('[_stopAnimation] error');
//   }
// }

// StaggerAnimationButtonWidget(
//   titleButton: 'Dowam',
//   buttonController: _buttonController.view as AnimationController,
//   onTap: _onContinueButtonPressed,
// ),
