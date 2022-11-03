import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../../app/app.locator.dart';
import '../../../../app/app.logger.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../models/hive_models/hive_models.dart';
import '../../../../models/models.dart';
import '../../../../services/services.dart';
import '../../../../utils/utils.dart';

class SOCreditCardsViewModel extends ReactiveViewModel {
  final log = getLogger('SOCreditCardsViewModel');

  final _hiveDbService = locator<HiveDbService>();
  final _bottomSheetService = locator<BottomSheetService>();

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

//------------------------ CREDIT CARD CONFIRMATION BOTTOM SHEET ----------------------------//

  /// CALLS CreditCardsConfirmationBottomSheet
  Future<void> showCustomCreditCardsConfirmationBottomSheet() async {
    log.i('');
    // SheetResponse<bool>? _navResult;
    // _navResult =
    await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.creditCardConfirmation,
      enableDrag: true,
      barrierDismissible: true,
      isScrollControlled: true,
    );

    // if (_navResult != null && _navResult.data == true) {
    //   log.i('_navResult: $_navResult');
    //   await runBusyFuture(_checkoutService.getAddresses());
    // }
  }

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

  /// UPDATES _cardNumber
  String? updateCardNumberValidator(String? value) {
    log.v('updateCardNumberValidator value: $value, ${value!.length}');

    if (value.isEmpty) return LocaleKeys.enter_card_number.tr();
    if (value.length < 19) return LocaleKeys.enter_full_card_number.tr();

    _expiryDate = value;
    notifyListeners();
    return null;
  }

  /// UPDATES _expiryDate
  String? updateExpiryDateValidator(String? value) {
    log.v('updateExpiryDateValidator value: $value');

    if (value!.isEmpty) return LocaleKeys.enter_card_date_deadline.tr();
    if (value.length < 5) return LocaleKeys.enter_full_card_date_deadline.tr();

    _expiryDate = value;
    notifyListeners();
    return null;
  }

  /// CVC validator (EMPTY validator)
  String? updateCvvValidator(String? value) {
    log.v('updateCvvValidator value: $value');
    return null;
  }

  /// UPDATES _cardHolderName
  String? updateCardHolderValidator(String? value) {
    log.v('updateCardHolder value: $value');
    if (value!.isEmpty) return LocaleKeys.enter_card_holder.tr();

    _cardHolderName = value;
    notifyListeners();
    return null;
  }

  /// SAVES credit card info on change
  Future<void> onCreditCardModelChange(CreditCardModel? creditCardModel) async {
    _cardNumber = creditCardModel!.cardNumber;
    _expiryDate = creditCardModel.expiryDate;
    _cardHolderName = creditCardModel.cardHolderName;
    notifyListeners();
  }

  /// UPDATES _selectedBankCard
  void updateSelectedBankCard(BankCard? newSelectedBankCard) {
    log.i('updateSelectedBankCard(): ${newSelectedBankCard!.bankName}');

    _selectedBankCard = newSelectedBankCard;
    notifyListeners();
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_hiveDbService];
}
