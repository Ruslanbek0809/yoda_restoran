import 'package:stacked/stacked.dart';
import '../../../../app/app.locator.dart';
import '../../../../app/app.logger.dart';
import '../../../../models/hive_models/hive_models.dart';
import '../../../../services/services.dart';

class SOCreditCardsViewModel extends ReactiveViewModel {
  final log = getLogger('SOCreditCardsViewModel');

  final _hiveDbService = locator<HiveDbService>();

  List<HiveCreditCard> get hiveCreditCards => _hiveDbService.hiveCreditCards;

  HiveCreditCard? _tempSelectedHiveCreditCard;
  HiveCreditCard? get tempSelectedHiveCreditCard => _tempSelectedHiveCreditCard;

  /// Temporarily SETS _tempSelectedHiveCreditCard
  void updateTempSelectedHiveCreditCard(HiveCreditCard selectedHiveCreditCard) {
    log.v(
        'updateTempSelectedHiveCreditCard selectedHiveCreditCard: ${selectedHiveCreditCard.bankId}');

    _tempSelectedHiveCreditCard = selectedHiveCreditCard;
    notifyListeners();
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_hiveDbService];
}
