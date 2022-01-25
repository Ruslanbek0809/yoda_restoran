import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/app/app.router.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/services/services.dart';

class AddressesViewModel extends FutureViewModel {
  final log = getLogger('AddressesViewModel');

  final _navService = locator<NavigationService>();
  final _userService = locator<UserService>();

  List<Address>? _addresses = [];
  List<Address>? get addresses => _addresses;

  @override
  Future<void> futureToRun() async {
    _addresses = await _userService.getAddresses();
    log.v('_addresses!.length: ${_addresses!.length}');
  }
//------------------------ NAVIGATIONS ----------------------------//

  /// NAVIGATES to Home by removing all previous routes
  Future<void> navToHomeByRemovingAll() async =>
      await _navService.pushNamedAndRemoveUntil(Routes.homeView);

  Future<void> navToAddEditAddressView() async {
    dynamic _navResult;
    _navResult =
        await _navService.navigateTo(Routes.addressAddEditView) ?? true;
    if (_navResult) await initialise(); // Workaround
  }
}
