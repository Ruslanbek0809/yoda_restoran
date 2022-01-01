import 'package:stacked/stacked.dart';
import '../app/app.locator.dart';
import '../app/app.logger.dart';
import '../models/models.dart';
import 'services.dart';
import '../utils/util_functions.dart';

class CheckoutService with ReactiveServiceMixin {
  final log = getLogger('CheckoutService');

  CheckoutService() {
    // 3
    listenToReactiveValues([_selectedPaymentType, _selectedAddress]);
  }

  final _api = locator<ApiService>();
  final _userService = locator<UserService>();
  final _hiveDbService = locator<HiveDbService>();

  ReactiveValue<PaymentType> _selectedPaymentType =
      ReactiveValue<PaymentType>(paymentTypes[0]);

  PaymentType? get selectedPaymentType => _selectedPaymentType.value;

  ReactiveValue<Address> _selectedAddress =
      ReactiveValue<Address>(Address(id: -1));

  Address? get selectedAddress => _selectedAddress.value;

  Promocode? _promocode;

  Promocode? get promocode => _promocode;

  List<Address>? _addresses = [];
  List<Address>? get addresses => _addresses;

  /// SAVES paymentType
  void savesPaymentType(PaymentType selectedPaymentType) =>
      _selectedPaymentType.value = selectedPaymentType;

  /// SEARCHES promocodes and GETS first
  Future<void> searchPromocode(String searchText) async {
    log.v('searchText: $searchText, resId: ${_hiveDbService.cartRes!.id!}');

    _promocode =
        await _api.searchPromocode(searchText, _hiveDbService.cartRes!.id!);
  }

  /// GETS all addresses
  Future<void> getAddresses() async {
    _addresses = await _userService.getAddresses();
    log.v('_addresses!.length: ${_addresses!.length}');
  }

  /// SAVES selectedAddress
  void saveSelectedAddress(Address selectedAddress) =>
      _selectedAddress.value = selectedAddress;

  /// ADDS new address
  Future<void> addAddress(String? city, String? street, int? house,
      int? apartment, int? floor, String? note) async {
    _userService.addAddress(city, street, house, apartment, floor, note);
  }
}
