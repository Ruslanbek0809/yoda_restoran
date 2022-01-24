import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';

class OnBoardingViewModel extends BaseViewModel {
  final log = getLogger('OnBoardingViewModel');

  final _navService = locator<NavigationService>();

//------------------------ NAVIGATION ----------------------------//
  void navBack() => _navService.back();
}
