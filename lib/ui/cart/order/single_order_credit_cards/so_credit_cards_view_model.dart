import 'package:stacked/stacked.dart';
import '../../../../app/app.locator.dart';
import '../../../../app/app.logger.dart';
import '../../../../models/hive_models/hive_models.dart';
import '../../../../models/models.dart';
import '../../../../services/services.dart';
import '../../../../utils/utils.dart';

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

//------------------------ CREDIT CARD CONFIRMATION ----------------------------//

  String _cardNumber = '';
  String get cardNumber => _cardNumber;

  String _expiryDate = '';
  String get expiryDate => _expiryDate;

  String _cardHolderName = '';
  String get cardHolderName => _cardHolderName;

  String _cvvCode = '';
  String get cvvCode => _cvvCode;

  bool _isCvvFocused = false;
  bool get isCvvFocused => _isCvvFocused;

  BankCard? _selectedBankCard = bankList[0];
  BankCard? get selectedBankCard => _selectedBankCard;

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_hiveDbService];
}
