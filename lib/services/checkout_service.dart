import 'package:stacked/stacked.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/utils/util_functions.dart';

import 'api_service.dart';
import 'hv_db_service.dart';

class CheckoutService with ReactiveServiceMixin {
  final log = getLogger('CheckoutService');

  CheckoutService() {
    // 3
    listenToReactiveValues([_paymentType]);
  }

  final _api = locator<ApiService>();
  final _hiveDbService = locator<HiveDbService>();

  ReactiveValue<PaymentType> _paymentType =
      ReactiveValue<PaymentType>(paymentTypes[0]);

  PaymentType? get paymentType => _paymentType.value;

  Promocode? _promocode;

  Promocode? get promocode => _promocode;

  /// UPDATES paymentType
  void updatePaymentType(PaymentType selectedPaymentType) =>
      _paymentType.value = selectedPaymentType;

  /// SEARCHES promocodes and GETS first
  Future<void> searchPromocode(String searchText) async {
    log.v('searchText: $searchText, resId: ${_hiveDbService.cartRes!.id!}');

    _promocode =
        await _api.searchPromocode(searchText, _hiveDbService.cartRes!.id!);
  }
}
