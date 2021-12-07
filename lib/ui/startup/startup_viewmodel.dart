import 'package:stacked/stacked.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/services/services.dart';

class StartUpViewModel extends BaseViewModel {
  final log = getLogger('StartUpViewModel');
  final _apiRootService = locator<ApiRootService>();

  Future<void> runStartupLogic() async {
    await _apiRootService.initDio();
  }
  // final NavigationService _navigationService = NavigationService();

  // void navigateToReactiveEx() {
  //   print('navigateToReactiveEx called');
  //   _navigationService.navigateTo(Routes.reactiveExampleView);
  // }

  // void navigateToPartial() {
  //   print('navigateToPartial called');
  //   _navigationService.navigateTo(Routes.partialBuildsView);
  // }
}
