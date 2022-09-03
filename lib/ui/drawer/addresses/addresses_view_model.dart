import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../app/app.router.dart';
import '../../../models/models.dart';
import '../../../services/services.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../utils/utils.dart';

class AddressesViewModel extends FutureViewModel {
  final log = getLogger('AddressesViewModel');

  final _navService = locator<NavigationService>();
  final _userService = locator<UserService>();
  final _dialogService = locator<DialogService>();

  List<Address>? _addresses = [];
  List<Address>? get addresses => _addresses;

  @override
  Future<void> futureToRun() async {
    _addresses = await _userService.getAddresses();
    log.v('_addresses!.length: ${_addresses!.length}');
  }

  /// DELETES selected address
  Future<void> onDeleteAddressPressed(
    Address address,
    Function()? onSuccess,
    Function()? onFail,
  ) async {
    log.v('onDeleteAddressPressed()');
    await runBusyFuture(
      _userService.deleteAddress(
        addressId: address.id,
        onSuccess: () => onSuccess!(),
        onFail: () => onFail!(),
      ),
      busyObject: address.id,
    );
  }

//------------------------ ADDRESS REMOVE DIALOG ----------------------------//

  /// SHOWS ADDRESS REMOVE Dialog
  Future showAddressRemoveDialog(
    AddressesViewModel addressesViewModel,
    Address address,
  ) async {
    log.i('showAddressRemoveDialog()');
    DialogResponse<dynamic>? respData = await _dialogService.showCustomDialog(
      variant: DialogType.removeAddress,
      title: LocaleKeys.wannaDeleteAddress,
      mainButtonTitle: LocaleKeys.no,
      secondaryButtonTitle: LocaleKeys.delete,
      showIconInMainButton: false,
      barrierDismissible: true,
      data: AddressDialogData(
        addressesViewModel: addressesViewModel,
        address: address,
      ),
    );

    if (respData != null && respData.data == true) {
      await initialise();
    }
  }

//------------------------ NAVIGATIONS ----------------------------//

  /// NAVIGATES to Home by removing all previous routes
  Future<void> navToHomeByRemovingAll() async =>
      await _navService.pushNamedAndRemoveUntil(Routes.homeView);

  Future<void> navToAddressAddView() async {
    dynamic _navResult;
    _navResult = await _navService.navigateTo(Routes.addressAddView) ?? false;
    if (_navResult) await initialise(); // Workaround
  }

  void navToAddressEditView(
      Address address, AddressesViewModel addressesViewModel) async {
    dynamic _navResult;
    _navResult = await _navService.navigateTo(
          Routes.addressEditView,
          arguments: AddressEditViewArguments(
            address: address,
            addressesViewModel: addressesViewModel,
          ),
        ) ??
        false;
    if (_navResult) await initialise(); // Workaround
  }
}
