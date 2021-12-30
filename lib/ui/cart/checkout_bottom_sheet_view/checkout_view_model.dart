import 'package:stacked/stacked.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/services/services.dart';

class CheckoutViewModel extends BaseViewModel {
  final log = getLogger('CheckoutViewModel');

  final _checkoutService = locator<CheckoutService>();

  Promocode? get promocode => _checkoutService.promocode;

  /// DateTime vars
  final now = DateTime.now();
  DateTime? tomorrow;
  DateTime? maxDateTime;
  DateTime? deliverDateTime;
  String? deliverDateFormatted = '';

  void getOnModelReady() {
    deliverDateTime = now;
    tomorrow = DateTime(now.year, now.month, now.day + 1);
    maxDateTime = DateTime(now.year, now.month, now.day + 1, 20);
  }

  /// SEARCHES and GETS promocode if found
  Future<void> searchPromocode(String? searchText) async {
    log.i('searchPromocode() searchText: $searchText');
    if (searchText != null && searchText.isEmpty || searchText!.length < 2)
      return;

    try {
      await runBusyFuture(_checkoutService.searchPromocode(searchText));
    } catch (err) {
      throw err;
    }
  }
}
