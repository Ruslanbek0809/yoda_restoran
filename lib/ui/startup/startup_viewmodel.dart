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

  Future<void> runStartupLogic() async {
    await _apiRootService.initDio();

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

    // _navService.replaceWith(Routes.)
    // void navigateToReactiveEx() {
    //   print('navigateToReactiveEx called');
    //   _navigationService.navigateTo(Routes.reactiveExampleView);
    // }

    // void navigateToPartial() {
    //   print('navigateToPartial called');
    //   _navigationService.navigateTo(Routes.partialBuildsView);
    // }
  }
}
