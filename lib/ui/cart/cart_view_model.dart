import 'package:stacked/stacked.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/services/services.dart';

class CartViewModel extends BaseViewModel {
  final log = getLogger('CartViewModel');

  final _hiveDbService = locator<HiveDbService>();

  /// CLEAR CART
  Future<void> clearCart() async {
    log.i('clearCart()');

    await _hiveDbService.clearCart();
    notifyListeners();
  }
}
