import 'package:firebase_core/firebase_core.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/app/app.router.dart';
import 'package:yoda_res/services/services.dart';

class StartUpViewModel extends BaseViewModel {
  final log = getLogger('StartUpViewModel');
  final _apiRootService = locator<ApiRootService>();
  final _navService = locator<NavigationService>();
  final _pushNotificationService = locator<PushNotificationService>();
  final _hvDbService = locator<HvDbService>();

  Future<void> runStartupLogic() async {
    log.i('Started');

    /// FIREBASE initialization. This second Firebase.initializeApp() is used to initialize Firebase again in case network is down
    await Firebase.initializeApp().then((value) => _pushNotificationService
        .initialise()); // Here we initialise fcm using PushNotificationService

    await _apiRootService.initDio();
    await _hvDbService.initDB();

    log.i('Ended');
    _navService.replaceWith(Routes.homeView);
    // _navService.replaceWith(Routes.loginView);

    // if (_userService.hasLoggedInUser) {
    //   log.v('We have a user session on disk. Sync the user profile ...');
    //   await _userService.syncUserAccount();

    //   final currentUser = _userService.currentUser;
    //   log.v('User sync complete. User profile: $currentUser');

    //   if (!currentUser.hasAddress) {
    //     _navigationService.navigateTo(Routes.addressSelectionView);
    //   } else {
    //     log.v('We have a default address. Let\'s show them products!');
    //     _navigationService.replaceWith(Routes.homeView);
    //     // navigate to home view
    //   }
    // } else {
    //   log.v('No user on disk, navigate to the LoginView');
    //   _navigationService.replaceWith(Routes.loginView);
    // }
  }
}
