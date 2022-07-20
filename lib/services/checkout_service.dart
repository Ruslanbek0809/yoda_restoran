import 'package:stacked/stacked.dart';
import 'package:yoda_res/models/hive_models/hive_models.dart';
import '../app/app.locator.dart';
import '../app/app.logger.dart';
import '../models/models.dart';
import 'services.dart';

class CheckoutService with ReactiveServiceMixin {
  final log = getLogger('CheckoutService');

  CheckoutService() {
    // 3
    listenToReactiveValues([_selectedPaymentType, _selectedAddress]);
  }

  final _api = locator<ApiService>();
  final _userService = locator<UserService>();
  HiveDbService _hiveDbService = locator<HiveDbService>();
  final _toggleButtonService = locator<ToggleButtonService>();

  ReactiveValue<HiveResPaymentType> _selectedPaymentType =
      ReactiveValue<HiveResPaymentType>(
    HiveResPaymentType(
      id: -1,
      nameRu: 'Default',
      nameTk: 'Default',
    ),
  );

  HiveResPaymentType? get selectedPaymentType => _selectedPaymentType.value;

  ReactiveValue<Address> _selectedAddress =
      ReactiveValue<Address>(Address(id: -1));

  Address? get selectedAddress => _selectedAddress.value;

  List<Address>? _addresses = [];
  List<Address>? get addresses => _addresses;

  /// SAVES paymentType
  void saveSelectedPaymentType(HiveResPaymentType selectedPaymentType) =>
      _selectedPaymentType.value = selectedPaymentType;

  /// SETS default value to _selectedPaymentType (Used to clear when new cartRes is set)
  void setDefaultValueToSelectedPaymentType() =>
      _selectedPaymentType.value = HiveResPaymentType(
        id: -1,
        nameRu: 'Default',
        nameTk: 'Default',
      );

  /// SEARCHES promocodes and GETS first
  Future<Promocode?> searchPromocode(
      String searchText, int getTotalCartSum) async {
    log.v(
        'searchText: $searchText, resId: ${_hiveDbService.cartRes!.id!}, getTotalCartSum: $getTotalCartSum');

    final _promocode = await _api.searchPromocode(
        searchText, _hiveDbService.cartRes!.id!, getTotalCartSum);
    return _promocode;
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
  Future<void> addAddress(
    String? city,
    String? street,
    int? house,
    int? apartment,
    int? floor,
    String? note,
    Function()? onSuccess,
    Function()? onFail,
  ) async {
    _userService.addAddress(
      city,
      street,
      house,
      apartment,
      floor,
      note,
      () => onSuccess!(),
      () => onFail!(),
    );
  }

  /// CREATES ORDER
  Future<void> createOrder(
    Address? selectedAddress,
    DateTime? deliveryDateTime,
    Promocode? promocode,
    String? checkoutNote,
    Function()? onSuccess,
    Function()? onFail,
  ) async {
    log.v(
        'selectedAddress: $selectedAddress, deliveryDateTime: $deliveryDateTime, paymentType: ${selectedPaymentType!.id}, promocode: $promocode, checkoutNote: $checkoutNote, resId: ${_hiveDbService.cartRes!.id}, _hiveDbService.cartMeals.length: ${_hiveDbService.cartMeals.length}');

    await _userService.createOrder(
      selectedAddress,
      _toggleButtonService.isDelivery,
      deliveryDateTime,
      selectedPaymentType,
      promocode,
      checkoutNote,
      _hiveDbService.cartRes,
      _hiveDbService.cartMeals,
      () => onSuccess!(),
      () => onFail!(),
    );
  }
}
