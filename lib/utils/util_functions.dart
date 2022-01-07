import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../ui/widgets/widgets.dart';
import 'utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Method to round trailing zero based on its type
RegExp regex = RegExp(r"([.]*0)(?!.*\d)");
// String s = num.toString().replaceAll(regex), "");

final List<String> drawerLogoutList = ["login", "about"];

final List<String> drawerLoggedInList = [
  "profile",
  "orders",
  "addresses",
  "about"
];

List<RestaurantUI> restaurants = [
  RestaurantUI(
    1,
    'Sushi',
    'Sushi we başgalar',
    'assets/sushi.png',
  ),
  RestaurantUI(2, 'Hotdost', 'Hotdog we başgalar', 'assets/hotdost.jpg'),
  RestaurantUI(3, 'Burger Zone', 'Burger we başgalar', 'assets/burgerzone.jpg'),
  RestaurantUI(4, 'Palawkom', 'Palaw we başgalar', 'assets/palawkom.jpg'),
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

List<AddressUI> addresses = [
  AddressUI(1, 'A.Nowaýy, 164'),
  AddressUI(2, 'N.Andalyp 32'),
];

List<CategoryFilter> mainCatSortList = [
  CategoryFilter(1, 'Adaty'),
  CategoryFilter(2, 'Reýtingi boýunça'),
  CategoryFilter(3, 'Çalt'),
  CategoryFilter(4, 'Gymmatdan arzana'),
  CategoryFilter(5, 'Arzandan gymmada'),
];

List<PaymentType> paymentTypes = [
  PaymentType(1, 'Nagt'),
  PaymentType(2, 'Terminal'),
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
  checkout,
  paymentType,
  selectAddress,
  addAddress,
}

/// Enum for dialog types
enum DialogType {
  mealCartClear,
  clearCart,
  cancelWaitingOrder,
  cancelAcceptedOrder
}

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

/// Keyboard Actions
// KeyboardActionsConfig buildKeyboardActionsConfig(
//     BuildContext context, List<FocusNode> list) {
//   String currentLang =
//       Provider.of<LangProvider>(context, listen: false).currentLang;
//   return KeyboardActionsConfig(
//     keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
//     keyboardBarColor: Colors.grey[200],
//     nextFocus: true,
//     actions: list
//         .map((e) => KeyboardActionsItem(focusNode: e, toolbarButtons: [
//               (node) {
//                 return GestureDetector(
//                   onTap: () => node.unfocus(),
//                   child: Container(
//                     padding: EdgeInsets.all(8.0),
//                     child: Text(
//                       i18n(currentLang, ki18nKbrdClose),
//                       style: TextStyle(
//                           color: AppTheme.textColor,
//                           fontWeight: FontWeight.w800),
//                     ),
//                   ),
//                 );
//               },
//             ]))
//         .toList(),
//   );
// }

List<FoodCategory> foodCategoryList = [
  FoodCategory(0, 'Ertirlikler'),
  FoodCategory(1, 'Işdäaçarlar'),
  FoodCategory(2, 'Desertler'),
  FoodCategory(3, 'Steak'),
  FoodCategory(4, 'Burgerlar'),
  FoodCategory(5, 'Bbashgalar'),
  FoodCategory(6, 'Yene bashgalar'),
  FoodCategory(7, 'Sonkylar'),
  FoodCategory(8, 'We sonkylar'),
  FoodCategory(9, 'FInallll'),
];

List<MealUI> mealList = [
  MealUI(0, 'Sandwich', 120, 'g', 25, 'assets/breakfast_sandwich.jpg', [
    AdditionalFoodModel('Peýnir', 10, false),
    AdditionalFoodModel('Ýumurtga', 10, false),
    AdditionalFoodModel('Bet zat', 15, false),
  ]),
  MealUI(1, 'Egg', 120, 'g', 10, 'assets/breakfast_egg.jpg', [
    AdditionalFoodModel('Peýnir', 10, false),
    AdditionalFoodModel('Ýumurtga', 10, false),
    AdditionalFoodModel('Bet zat', 15, false),
  ]),
  MealUI(2, 'Sandwich', 300, 'ml', 15, 'assets/breakfast_latte.jpg', [
    AdditionalFoodModel('Peýnir', 10, false),
    AdditionalFoodModel('Ýumurtga', 10, false),
    AdditionalFoodModel('Bet zat', 15, false),
  ]),
  MealUI(3, 'Burger', 150, 'g', 25, 'assets/burgerzone.jpg', [
    AdditionalFoodModel('Peýnir', 10, false),
    AdditionalFoodModel('Ýumurtga', 10, false),
    AdditionalFoodModel('Bet zat', 15, false),
  ]),
];




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