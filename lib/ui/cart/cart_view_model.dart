import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/services/services.dart';
import 'package:yoda_res/utils/utils.dart';

class CartViewModel extends BaseViewModel {
  final log = getLogger('CartViewModel');

  final _hiveDbService = locator<HiveDbService>();
  final _dialogService = locator<DialogService>();

  /// CLEAR CART
  Future<void> clearCart() async {
    log.i('clearCart()');

    await _hiveDbService.clearCart();
    notifyListeners();
  }

//------------------------ Clear CART DIALOG PART ----------------------------//

  /// SHOWS Clear CART Dialog
  Future showClearCartDialog() async {
    log.i('');
    await _dialogService.showCustomDialog(
      variant: DialogType.clearCart,
      title: 'Siz sebedi boşatmakçymy?',
      mainButtonTitle: 'Ýok',
      secondaryButtonTitle: 'Hawa',
      showIconInMainButton: false,
      barrierDismissible: true,
    );
  }
}
