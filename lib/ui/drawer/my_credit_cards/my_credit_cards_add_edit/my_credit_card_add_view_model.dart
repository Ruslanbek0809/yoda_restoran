import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/utils/utils.dart';
import '../../../../app/app.locator.dart';
import '../../../../app/app.logger.dart';
import '../../../../models/models.dart';

class MyCreditCardAddViewModel extends BaseViewModel {
  final log = getLogger('MyCreditCardAddViewModel');

  final _navService = locator<NavigationService>();

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

  /// UPDATES _expiryDate
  String? updateExpiryDateValidator(String? value) {
    log.v('updateExpiryDateValidator value: $value');

    if (value!.isEmpty || value.length < 5) return 'updateCardHolder';
    // LocaleKeys.enterStreet.tr();

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
  String? updateCardHolder(String? value) {
    log.v('updateCardHolder value: $value');
    if (value!.isEmpty) return 'updateCardHolder';
    // LocaleKeys.enterStreet.tr();

    _cardHolderName = value;
    notifyListeners();
    return null;
  }

  /// SAVES credit card info
  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    _cardNumber = creditCardModel!.cardNumber;
    _expiryDate = creditCardModel.expiryDate;
    _cardHolderName = creditCardModel.cardHolderName;
    _cvvCode = creditCardModel.cvvCode;
    _isCvvFocused = creditCardModel.isCvvFocused;
    notifyListeners();
  }

  /// UPDATES _selectedBankCard
  void updateSelectedBankCard(BankCard? newSelectedBankCard) {
    log.i('updateSelectedBankCard(): ${newSelectedBankCard!.bankName}');

    _selectedBankCard = newSelectedBankCard;
    notifyListeners();
  }

//------------------------ NAVIGATION ----------------------------//
  void navBack() => _navService.back(result: true);

  void navBackWithFalse() => _navService.back(result: false);
}
