import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../app/app.router.dart';
import '../../../services/services.dart';

class AboutUsViewModel extends FutureViewModel {
  final log = getLogger('AboutUsViewModel');

  final _userService = locator<UserService>();
  final _navService = locator<NavigationService>();

  // List<Address>? _addresses = [];
  // List<Address>? get addresses => _addresses;

  @override
  Future<void> futureToRun() async {
    // _addresses =
    await _userService.getAboutUs();
    // log.v('_addresses!.length: ${_addresses!.length}');
  }

//------------------------ NAVIGATIONS ----------------------------//

  /// NAVIGATES to Home by removing all previous routes
  Future<void> navToHomeByRemovingAll() async =>
      await _navService.pushNamedAndRemoveUntil(Routes.homeView);
}
