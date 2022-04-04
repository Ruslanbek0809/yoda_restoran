import 'package:geolocator/geolocator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/services/services.dart';
import '../../app/app.locator.dart';
import '../../app/app.logger.dart';
import '../../app/app.router.dart';
import '../../models/models.dart';

class ResViewModel extends BaseViewModel {
  final log = getLogger('ResViewModel');

  final _navService = locator<NavigationService>();
  final _userService = locator<UserService>();
  final _geolocatorService = locator<GeolocatorService>();

  Position? get locationPosition => _geolocatorService.locationPosition;

  bool get hasLoggedInUser => _userService.hasLoggedInUser;

  bool _isFavorited = false;
  bool get isFavorited => _isFavorited;

  /// NAVIGATES to LoginView if not logged in yet
  // Future<void> navToLoginView() async => await _navService.navigateTo(
  //       Routes.loginView,
  //       arguments: LoginViewArguments(
  //         isCartView: false,
  //       ), // Workaround. isCartView is used to navigate to new View by condition in OtpVM
  //     );

  /// CHECKS and ASSIGNS initial res fav state
  void checkResFav(int resId) =>
      _isFavorited = _userService.currentUser!.favs.contains(resId);

  /// UPDATES res fav state
  Future<void> updateResFav(int resId) async {
    if (hasLoggedInUser) {
      log.v(
          'updateResFav() USER FOUND with his/her phone and favs: ${_userService.currentUser!.mobile} and ${_userService.currentUser!.favs}');
      _isFavorited =
          !_isFavorited; // The reason for fav update before actual patch func is not to keep user from waiting for update patch time
      log.i('_isFavorited: $_isFavorited');
      notifyListeners();

      await _userService.patchUserFavs(
        resId,
        _isFavorited,
        () {
          log.i('FAIL fav update');
          _isFavorited = !_isFavorited; // Update it back.
          notifyListeners();
        },
      );
    } else {
      log.v('updateResFav() USER NOTTTTT FOUND');
      await _navService.navigateTo(
        Routes.loginView,
        arguments: LoginViewArguments(isCartView: false),
      ); // Workaround. isCartView is used to navigate to new View by condition in OtpVM
    }
  }

  //------------------ NAVIGATION ---------------------//

  void navToResDetailsView(Restaurant restaurant) => _navService.navigateTo(
        Routes.resDetailsView,
        arguments: ResDetailsViewArguments(restaurant: restaurant),
      );
}
