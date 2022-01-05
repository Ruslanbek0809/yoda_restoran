import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/app/app.router.dart';

class OrderViewModel extends BaseViewModel {
  final log = getLogger('OrderViewModel');

  // final _navService = locator<NavigationService>();

  // /// NAVIGATES until it removes to given route
  // Future<void> navByRemovingUntil() async =>
  //     await _navService.pushNamedAndRemoveUntil(Routes.homeView);
}
