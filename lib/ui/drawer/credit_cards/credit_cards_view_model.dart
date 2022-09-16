import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../app/app.router.dart';
import '../../../models/models.dart';
import '../../../services/services.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../utils/utils.dart';

class CreditCardsViewModel extends FutureViewModel {
  final log = getLogger('CreditCardsViewModel');

  final _navService = locator<NavigationService>();
  final _userService = locator<UserService>();
  final _dialogService = locator<DialogService>();

  List<Address>? _addresses = [];
  List<Address>? get addresses => _addresses;

  @override
  Future<void> futureToRun() async {
    // _addresses = await _userService.getAddresses();
    // log.v('_addresses!.length: ${_addresses!.length}');
  }

}
