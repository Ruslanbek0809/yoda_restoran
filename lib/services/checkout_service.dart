import 'package:stacked/stacked.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/services/services.dart';
import 'package:yoda_res/utils/util_functions.dart';

class CheckoutService with ReactiveServiceMixin {
  final log = getLogger('CheckoutService');

  CheckoutService() {
    // 3
    listenToReactiveValues([_paymentType]);
  }

  final _api = locator<ApiService>();
  final _userService = locator<UserService>();
  final _hiveDbService = locator<HiveDbService>();

  ReactiveValue<PaymentType> _paymentType =
      ReactiveValue<PaymentType>(paymentTypes[0]);

  PaymentType? get paymentType => _paymentType.value;

  Promocode? _promocode;

  Promocode? get promocode => _promocode;

  List<SliderModel>? _sliders = [];
  List<SliderModel>? get sliders => _sliders;

  /// UPDATES paymentType
  void updatePaymentType(PaymentType selectedPaymentType) =>
      _paymentType.value = selectedPaymentType;

  /// SEARCHES promocodes and GETS first
  Future<void> searchPromocode(String searchText) async {
    log.v('searchText: $searchText, resId: ${_hiveDbService.cartRes!.id!}');

    _promocode =
        await _api.searchPromocode(searchText, _hiveDbService.cartRes!.id!);
  }

  /// GETS all addresses
  Future<void> getAddresses() async {
    _userService.addAddress(city, street, house, apartment, floor, note);
  }

  /// ADDS new address
  Future<void> addAddress(String? city, String? street, int? house,
      int? apartment, int? floor, String? note) async {
    _userService.addAddress(city, street, house, apartment, floor, note);
  }
}
