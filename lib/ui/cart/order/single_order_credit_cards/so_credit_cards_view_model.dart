import 'package:stacked/stacked.dart';
import '../../../../app/app.locator.dart';
import '../../../../app/app.logger.dart';
import '../../../../services/services.dart';

class SOCreditCardsViewModel extends ReactiveViewModel {
  final log = getLogger('SOCreditCardsViewModel');

  final _checkoutService = locator<CheckoutService>();

//------------------------ SELECT ADDRESS BOTTOM SHEET ----------------------------//

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_checkoutService];
}
