import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/models/hive_models/hive_models.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../app/app.router.dart';
import '../../../models/models.dart';
import '../../../services/services.dart';
import '../../../utils/utils.dart';

class ExSingleViewModel extends FutureViewModel {
  final log = getLogger('ExSingleViewModel');
  final ExclusiveSingle? exclusiveSingle;
  ExSingleViewModel(this.exclusiveSingle);

  final _api = locator<ApiService>();
  final _navService = locator<NavigationService>();
  final _bottomCartService = locator<BottomCartService>();
  final _hiveDbService = locator<HiveDbService>();
  final _geolocatorService = locator<GeolocatorService>();

  Position? get locationPosition => _geolocatorService.locationPosition;

  HiveRestaurant? get cartRes => _hiveDbService.cartRes;
  BottomCartStatus get bottomCartStatus => _bottomCartService
      .bottomCartStatus; // Here we just receive bottomCartStatus from _bottomCartService for realtime reactivity

  /// _isCustomError and updateCustomError func are used to show error flash bar once. Workaround
  bool _isCustomError = false;
  bool get isCustomError => _isCustomError;
  List<ResCategory>? _resCategories = [];
  List<ResCategory>? get resCategories => _resCategories;

  // // FETCHS Restaurant categories with their meals
  Future getResCatsWithMeals({Function()? onFailForView}) async {
    log.i('');
    await _api.getResCatsWithMeals(
      restaurantId: exclusiveSingle!.id!,
      onSuccess: (result) async {
        _resCategories = result;
      },
      onFail: () {
        _isCustomError = true;
        // _snackBarService.showCustomSnackBar(
        //   variant: SnackBarType.restaurantDetailsError,
        //   message: 'This is a snack bar',
        //   // title: 'The title',
        //   duration: Duration(seconds: 2),
        // );
      },
    );

    log.i('_resCategories length: ${_resCategories!.length}');
  }

  /// Workaround to show error flash bar once
  void updateCustomError() {
    log.i('updateCustomError()');

    _isCustomError = false;
  }

//------------------------ NAVIGATIONS ----------------------------//

  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [_bottomCartService, _hiveDbService];

  @override
  Future<void> futureToRun() async => await getResCatsWithMeals();
}
