import 'package:geolocator/geolocator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.router.dart';
import '../../../models/models.dart';
import '../../../services/services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';

class PromResViewModel extends BaseViewModel {
  final log = getLogger('PromResViewModel');

  final _navService = locator<NavigationService>();
  final _userService = locator<UserService>();
  final _geolocatorService = locator<GeolocatorService>();

  Position? get locationPosition => _geolocatorService.locationPosition;

  bool get hasLoggedInUser => _userService.hasLoggedInUser;

  //* ADDS id of current res to favoritesBox
  Future<void> addRestaurantToFav(int resId) async {
    if (hasLoggedInUser) {
      log.v('addRestaurantToFav() USER FOUND with resId: $resId');

      await _userService.addRestaurantToFav(resId);
    } else {
      log.v('addRestaurantToFav() USER NOTTTTT FOUND');
      await _navService.navigateTo(
        Routes.loginView,
        arguments: LoginViewArguments(isCartView: false),
      ); // Workaround. isCartView is used to navigate to new View by condition in OtpVM
    }
  }

  //* REMOVES id of current res from favoritesBox
  Future<void> removeRestaurantFromFav(int resId) async {
    if (hasLoggedInUser) {
      log.v('removeRestaurantFromFav() USER FOUND with resId: $resId');

      await _userService.removeRestaurantFromFav(resId);
    } else {
      log.v('removeRestaurantFromFav() USER NOTTTTT FOUND');
      await _navService.navigateTo(
        Routes.loginView,
        arguments: LoginViewArguments(isCartView: false),
      ); // Workaround. isCartView is used to navigate to new View by condition in OtpVM
    }
  }

  void navToResDetailsView(Restaurant restaurant) => _navService.navigateTo(
        Routes.resDetailsView,
        arguments: ResDetailsViewArguments(restaurant: restaurant),
      );
}
