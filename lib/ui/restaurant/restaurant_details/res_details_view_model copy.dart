// import 'dart:async';

// import 'package:easy_localization/easy_localization.dart';
// import 'package:flash/flash.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:stacked/stacked.dart';
// import 'package:stacked_services/stacked_services.dart';

// import '../../../app/app.locator.dart';
// import '../../../app/app.logger.dart';
// import '../../../app/app.router.dart';
// import '../../../generated/locale_keys.g.dart';
// import '../../../models/hive_models/hive_models.dart';
// import '../../../models/models.dart';
// import '../../../services/services.dart';
// import '../../../shared/shared.dart';
// import '../../../utils/utils.dart';

// class ResDetailsViewModel extends FutureViewModel {
//   final log = getLogger('ResDetailsViewModel');
//   final Restaurant? restaurant;
//   ResDetailsViewModel(this.restaurant);

//   final _api = locator<ApiService>();
//   final _navService = locator<NavigationService>();
//   final _bottomCartService = locator<BottomCartService>();
//   final _hiveDbService = locator<HiveDbService>();
//   final _userService = locator<UserService>();
//   final _geolocatorService = locator<GeolocatorService>();

//   Position? get locationPosition => _geolocatorService.locationPosition;

//   int _activeTab = 0;
//   bool _isTabPressed = false;
//   bool _isShrink = false;
//   bool _isTitleShrink = false;

//   int get activeTab => _activeTab;
//   bool get isTabPressed => _isTabPressed;
//   bool get isShrink => _isShrink;
//   bool get isTitleShrink => _isTitleShrink;

//   HiveRestaurant? get cartRes => _hiveDbService.cartRes;

//   BottomCartStatus get bottomCartStatus => _bottomCartService
//       .bottomCartStatus; // Here we just receive bottomCartStatus from _bottomCartService for realtime reactivity
//   bool get isUpdateQuantity =>
//       _bottomCartService.isUpdateQuantity; // custom loading of res bottom cart

//   //*_isCustomError and updateCustomError func are used to show error flash bar once. Workaround
//   bool _isCustomError = false;
//   bool get isCustomError => _isCustomError;
//   List<ResCategory> _resCategories = [];
//   List<ResCategory> get resCategories => _resCategories;

//   // List<ResCategory>? get resCategories => _resService.resCategories;

//   //*Function to change ACTIVE TAB
//   void updateActiveTab(int tabIndex) {
//     _activeTab = tabIndex;
//     notifyListeners();
//   }

//   //*Function to change ACTIVE TAB
//   void updateLastScrollStatus(bool isReallyShrink, bool isTitleShrink) {
//     _isShrink = isReallyShrink;
//     _isTitleShrink = isTitleShrink;
//     notifyListeners();
//   }

//   // Function to create ripple like effect when Tab pressed
//   void updateOnTapRipple() {
//     if (_isTabPressed) {
//       Timer(Duration(milliseconds: 1200), () {
//         _isTabPressed = false;
//         log.i('_isTabPressed: $_isTabPressed');
//         notifyListeners();
//       });
//     } else {
//       _isTabPressed = true;
//       log.i('_isTabPressed: $_isTabPressed');
//       notifyListeners();
//     }
//   }

//   @override
//   Future<void> futureToRun() async => await getResCatsWithMeals();

//   // // FETCHS Restaurant categories with their meals
//   Future getResCatsWithMeals(
//       //   {
//       //   // Function()? onFailForView,
//       // }
//       ) async {
//     log.i('');
//     await _api.getResCatsWithMeals(
//       restaurantId: restaurant!.id!,
//       onSuccess: (result) async {
//         _resCategories = result;
//       },
//       onFail: () {
//         _isCustomError = true;
//         // _snackBarService.showCustomSnackBar(
//         //   variant: SnackBarType.restaurantDetailsError,
//         //   message: 'This is a snack bar',
//         //   // title: 'The title',
//         //   duration: Duration(seconds: 2),
//         // );
//       },
//     );

//     log.i('_resCategories.length: ${_resCategories.length}');
//   }

//   //*Workaround to show error flash bar once
//   void updateCustomError() {
//     log.i('updateCustomError()');

//     _isCustomError = false;
//   }

// //*----------------------- RESTAURANT BOTTOM SHEET ----------------------------//

//   //*SHOWS RestaurantDetailsInfoBottomSheet
//   // Future showCustomBottomSheet(Restaurant restaurant) async {
//   //   log.i('');
//   //   await _bottomSheetService.showCustomSheet(
//   //     variant: BottomSheetType.restaurantInfo,
//   //     enableDrag: true,
//   //     isScrollControlled: true,
//   //     data: restaurant,
//   //   );
//   // }

// //*----------------------- FAVOURITE PART ----------------------------//

//   bool _isFavorited = false;
//   bool get isFavorited => _isFavorited;

//   bool get hasLoggedInUser => _userService.hasLoggedInUser;

//   //*CHECKS and ASSIGNS initial res fav state
//   void checkResFav(int resId) =>
//       _isFavorited = _userService.currentUser!.favs.contains(resId);

//   //*UPDATES res fav state
//   Future<void> updateResFav(int resId) async {
//     if (hasLoggedInUser) {
//       log.v(
//           'updateResFav() USER FOUND with his/her phone and favs: ${_userService.currentUser!.mobile} and ${_userService.currentUser!.favs}');
//       _isFavorited =
//           !_isFavorited; // The reason for fav update before actual patch func is not to keep user from waiting for update patch time
//       log.i('_isFavorited: $_isFavorited');
//       notifyListeners();

//       await _userService.patchUserFavs(
//         resId,
//         _isFavorited,
//         () {
//           log.i('FAIL fav update');
//           _isFavorited = !_isFavorited; // Update it back.
//           notifyListeners();
//         },
//       );
//     } else {
//       log.v('updateResFav() USER NOTTTTT FOUND');
//       await _navService.navigateTo(
//         Routes.loginView,
//         arguments: LoginViewArguments(isCartView: true),
//       ); // Workaround. isCartView is used to navigate to new View by condition in OtpVM
//     }
//   }

//   FlashController? _flashController;

//   /// CREATED custom flash bar instead of one global flash bar because multiple stack flash bar issue
//   Future<void> showCustomFlashBar({
//     required BuildContext context,
//     String msg = LocaleKeys.errorOccured,
//     Duration duration = const Duration(seconds: 2),
//   }) async {
//     if (_flashController?.isDisposed == false)
//       await _flashController?.dismiss();
//     _flashController = FlashController<dynamic>(
//       context,
//       duration: duration,
//       builder: (context, controller) {
//         return Flash(
//           controller: controller,
//           barrierDismissible: true,
//           margin: EdgeInsets.only(
//             left: 16.w,
//             right: 16.w,
//             bottom: 0.05.sh,
//           ),
//           position: FlashPosition.bottom,
//           behavior: FlashBehavior.floating,
//           boxShadows: kElevationToShadow[0],
//           borderRadius: AppTheme().radius16,
//           backgroundColor: kcSecondaryDarkColor,
//           child: FlashBar(
//             icon: Padding(
//               padding: EdgeInsets.only(left: 24.w, right: 12.w),
//               child: SvgPicture.asset(
//                 'assets/warning.svg',
//                 width: 20.w,
//                 height: 20.h,
//               ),
//             ),
//             content: Text(msg, style: kts16ButtonText).tr(),
//           ),
//         );
//       },
//     );
//     await _flashController?.show();
//   }
// //*----------------------- NAVIGATIONS ----------------------------//

//   Future<void> navToCartView() async {
//     // dynamic _navResult;
//     // _navResult =
//     await _navService.navigateTo(Routes.cartView);
//     // ?? true;
//     // if (_navResult) await initialise(); // Workaround
//   }

//   void navToResSearchView() async {
//     // dynamic _navResult;
//     // _navResult =
//     await _navService.navigateTo(Routes.restaurantSearchView,
//         arguments: RestaurantSearchViewArguments(restaurant: restaurant!));
//     // ?? true;
//     // if (_navResult) await initialise(); // Workaround
//   }

//   //*NAVIGATES to LoginView if not logged in yet
//   // Future<void> navToLoginView() async => await _navService.navigateTo(
//   //       Routes.loginView,
//   //       arguments: LoginViewArguments(
//   //         isCartView: true,
//   //       ), // Workaround.
//   //     );

//   @override
//   List<ListenableServiceMixin> get listenableServices =>
//       [_bottomCartService, _hiveDbService];
// }
