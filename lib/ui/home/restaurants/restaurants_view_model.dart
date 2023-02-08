import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../models/hive_models/hive_models.dart';
import '../../../models/models.dart';
import '../../../services/services.dart';
import '../../../utils/utils.dart';

class RestauranstViewModel extends FutureViewModel {
  final log = getLogger('RestauranstViewModel');

  final _api = locator<ApiService>();
  final _navService = locator<NavigationService>();
  final _bottomCartService = locator<BottomCartService>();
  final _hiveDbService = locator<HiveDbService>();

  HiveRestaurant? get cartRes => _hiveDbService.cartRes;

  BottomCartStatus get bottomCartStatus => _bottomCartService
      .bottomCartStatus; // Here we just receive bottomCartStatus from _bottomCartService for realtime reactivity

  List<ResCategory> _resCategories = [];
  List<ResCategory> get resCategories => _resCategories;

  // @override
  // Future<void> futureToRun() async => await getResCatsWithMeals();
  @override
  Future<void> futureToRun() async => await Future.delayed(Duration.zero);

  // // FETCHS Restaurant categories with their meals
  // Future getResCatsWithMeals(
  //     //   {
  //     //   // Function()? onFailForView,
  //     // }
  //     ) async {
  //   log.i('');
  //   await _api.getResCatsWithMeals(
  //     restaurantId: restaurant!.id!,
  //     onSuccess: (result) async {
  //       _resCategories = result;
  //     },
  //     onFail: () {
  //       _isCustomError = true;
  //       // _snackBarService.showCustomSnackBar(
  //       //   variant: SnackBarType.restaurantDetailsError,
  //       //   message: 'This is a snack bar',
  //       //   // title: 'The title',
  //       //   duration: Duration(seconds: 2),
  //       // );
  //     },
  //   );

  //   log.i('_resCategories.length: ${_resCategories.length}');
  // }
//*----------------------- NAVIGATIONS ----------------------------//

  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [_bottomCartService, _hiveDbService];
}
