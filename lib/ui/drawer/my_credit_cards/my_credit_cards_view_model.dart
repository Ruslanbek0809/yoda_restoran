import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../app/app.router.dart';
import '../../../models/hive_models/hive_models.dart';
import '../../../models/models.dart';
import '../../../services/services.dart';

class CreditCardsViewModel extends ReactiveViewModel {
  final log = getLogger('CreditCardsViewModel');

  final _navService = locator<NavigationService>();
  final _hiveDbService = locator<HiveDbService>();

  List<Address>? _addresses = [];
  List<Address>? get addresses => _addresses;

  List<HiveCreditCard> get hiveCreditCards => _hiveDbService.hiveCreditCards;

//------------------------ NAVIGATIONS ----------------------------//

  /// NAVIGATES to MyCreditCardAddView
  Future<void> navToMyCreditCardAddView({
    required Function() onNewCreditCardAdded,
  }) async {
    dynamic _navResult;
    _navResult =
        await _navService.navigateTo(Routes.myCreditCardAddView) ?? false;
    if (_navResult) await onNewCreditCardAdded(); // Workaround
  }

  /// NAVIGATES to Home by removing all previous routes
  Future<void> navToHomeByRemovingAll() async =>
      await _navService.pushNamedAndRemoveUntil(Routes.homeView);

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_hiveDbService];
}
