import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import '../generated/locale_keys.g.dart';
import '../library/onboarding/onboarding.dart';
import '../shared/shared.dart';
import '../models/hive_models/hive_models.dart';
import '../models/models.dart';
import '../ui/widgets/widgets.dart';
import 'utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:async';

import 'package:path_provider/path_provider.dart' as pathProvider;

/// Method to round trailing zero based on its type.

// toStringAsFixed guarantees the specified number of fractional
// digits, so the regular expression is simpler than it would need to
// be for more general cases.
String formatNum(num value) =>
    value.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '');

String formatNumRating(num value) =>
    value.toStringAsFixed(1).replaceFirst(RegExp(r'\.?0*$'), '');

/// PARSES and FORMATS discountBegin and discountEnd in Hm format only
extension DateTimeHmFormatter on String {
  String formateDateTimeHmOnly() {
    DateTime _tempDate = DateFormat('HH:mm').parse(this);
    return DateFormat.Hm().format(_tempDate);
  }
}

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
  "my_credit_cards",
  "about_us"
];

/// BANK list
final List<BankCard> bankList = [
  BankCard(
    bankId: 1,
    bankName: LocaleKeys.halk_bank_and_others,
  ),
  BankCard(
    bankId: 2,
    bankName: LocaleKeys.rysgal_bank,
  ),
  BankCard(
    bankId: 3,
    bankName: LocaleKeys.senagat_bank,
  ),
  BankCard(
    bankId: 4,
    bankName: LocaleKeys.dyi_bank,
  ),
];

List<FilterSort> mainCatSortList = [
  FilterSort(1, LocaleKeys.defaultt),
  FilterSort(2, LocaleKeys.byName),
  FilterSort(3, LocaleKeys.byRatings),
];

/// Enum for FormValidation
enum FormValidation { phoneInvalid, valid }

/// Enum for bottomCartController
enum BottomCartStatus { idle, forward, reverse }

/// Enum for create bank order service
enum CreateBankOrderEnum { idle, fail, reorderFail }

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
  creditCardConfirmation,
  sendCodeConfirmation,
}

/// Enum for dialog types
enum DialogType {
  mealCartClear,
  clearCart,
  removeCartMeal,
  cancelWaitingOrder,
  notification,
  removeAddress,
  rateOrder,
  orderDelete,
  creditCardDelete,
  userLogout,
  userDelete,
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
  Duration duration = const Duration(milliseconds: 2000),
  required EdgeInsets margin,
}) async {
  await showFlash(
    context: context,
    duration: duration,
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
      duration: Duration(seconds: 3),
    ),
  );
}

/// Device Type
String getDeviceType() {
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
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
            color: kcFontColor,
            fontSize: 16.sp,
          ),
        ),
        actions: <Widget>[
          CustomTextButton(
            text: defaultActionText,
            color: Colors.transparent,
            textStyle: TextStyle(
              color: kcFontColor,
              fontSize: 17.sp,
              fontWeight: FontWeight.bold,
            ),
            onPressed: () => Navigator.of(context).pop(true),
          ),
          CustomTextButton(
            text: cancelActionText,
            color: Colors.transparent,
            textStyle: TextStyle(
              color: kcFontColor,
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
            color: kcFontColor,
            fontSize: 17.sp,
            fontWeight: FontWeight.bold,
          ),
          onPressed: () => Navigator.of(context).pop(true),
        ),
        CupertinoDialogAction(
          child: Text(cancelActionText),
          textStyle: TextStyle(
            color: kcFontColor,
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

//------------------ FB BACKGROUND ---------------------//

Future<void> fbBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Got a message whilst in the onBackgroundMessage!');
  print('Message data: ${message.data}');

  if (message.notification != null) {
    print('Message also contained a notification: ${message.notification}');
    print(
        'Message also contained a notification\' title: ${message.notification!.title}');
    print(
        'Message also contained a notification\' body: ${message.notification!.body}');
  }
  print('Handling a background message ${message.messageId}');

  //* ------------------ HIVE RATING PART ---------------------//

  /// HIVE DIR
  Directory directory = await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  /// CHECKS whether it this adapter with this type registered or NOT
  if (!Hive.isAdapterRegistered(5))
    // HIVE registerAdapter
    Hive.registerAdapter<HiveRating>(HiveRatingAdapter());

  /// CHECKS whether hive box with this name is already OPEN or NOT
  if (!Hive.isBoxOpen(Constants.hiveRatingBox))
    // HIVE openBox
    await Hive.openBox<HiveRating>(Constants.hiveRatingBox);

  // Convert message.data to notification model
  final noti = NotificationModel.fromJson(message.data);
  print('notificationData JSON title: ${noti.title}, status: ${noti.status}');

  if (noti.status == '4') {
    print('BACKGROUND NOTIFICATION INSIDE STATUS 4');

    Box<HiveRating> _hiveRatingBox =
        Hive.box<HiveRating>(Constants.hiveRatingBox);
    List<HiveRating> _hiveRatingList = _hiveRatingBox.values.toList();

    /// CHECHKS whether order with this id exists in hiveRatingBox
    int _indexHiveRatingNotification = _hiveRatingList
        .indexWhere((_hiveRatingOrder) => _hiveRatingOrder.id == noti.id);

    print(
        'METHOD: addRatingNotification() EXIST INDEX _indexHiveRatingOrder: $_indexHiveRatingNotification');

    /// IF this order EXISTS
    if (_indexHiveRatingNotification != -1) {
      await _hiveRatingBox.deleteAt(_indexHiveRatingNotification);
      _hiveRatingList.removeAt(_indexHiveRatingNotification);
    }

    /// ADDS this order to hiveRatingBox
    final HiveRating _hiveRatingNotification = HiveRating(
      id: noti.id,
      option: noti.option,
      resId: noti.resId,
      title: noti.title,
      status: noti.status,
      selfPickUp: noti.selfPickUp,
    );
    await _hiveRatingBox.add(_hiveRatingNotification);

    // /// TO CHECK WHETHER IT WORKS
    // _hiveRatingList = _hiveRatingBox.values.toList();
    // _indexHiveRatingNotification = _hiveRatingList
    //     .indexWhere((_hiveRatingOrder) => _hiveRatingOrder.id == noti.id);
    // print(
    //     'TO CHECK => METHOD: addRatingNotification() EXIST INDEX _indexHiveRatingNotification: $_indexHiveRatingNotification');
  }
}
