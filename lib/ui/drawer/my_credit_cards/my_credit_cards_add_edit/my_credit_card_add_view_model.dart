import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../../utils/utils.dart';
import '../../../../app/app.locator.dart';
import '../../../../app/app.logger.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../models/models.dart';
import '../../../../services/services.dart';

class MyCreditCardAddViewModel extends BaseViewModel {
  final log = getLogger('MyCreditCardAddViewModel');

  final _navService = locator<NavigationService>();
  final _hiveDbService = locator<HiveDbService>();

  String _cardNumber = '';
  String get cardNumber => _cardNumber;

  String _expiryDate = '';
  String get expiryDate => _expiryDate;

  String _cardHolderName = '';
  String get cardHolderName => _cardHolderName;

  String _cvvCode = '';
  String get cvvCode => _cvvCode;

  BankCard? _selectedBankCard = bankList[0];
  BankCard? get selectedBankCard => _selectedBankCard;

  //* UPDATES _cardNumber
  String? updateCardNumberValidator(String? value) {
    log.v('updateCardNumberValidator value: $value, ${value!.length}');

    if (value.isEmpty) return LocaleKeys.enter_card_number.tr();
    if (value.length < 19) return LocaleKeys.enter_full_card_number.tr();

    _cardNumber = value;
    notifyListeners();
    return null;
  }

  //* UPDATES _expiryDate
  String? updateExpiryDateValidator(String? value) {
    log.v('updateExpiryDateValidator value: $value');

    if (value!.isEmpty) return LocaleKeys.enter_card_date_deadline.tr();
    if (value.length < 5) return LocaleKeys.enter_full_card_date_deadline.tr();

    _expiryDate = value;
    notifyListeners();
    return null;
  }

  //* CVC validator (EMPTY validator)
  String? updateCvvValidator(String? value) {
    log.v('updateCvvValidator value: $value');
    return null;
  }

  //* UPDATES _cardHolderName
  String? updateCardHolderValidator(String? value) {
    log.v('updateCardHolder value: $value');
    if (value!.isEmpty) return LocaleKeys.enter_card_holder.tr();

    _cardHolderName = value;
    notifyListeners();
    return null;
  }

  //* SAVES credit card info on change
  Future<void> onCreditCardModelChange(CreditCardModel? creditCardModel) async {
    _cardNumber = creditCardModel!.cardNumber;
    _expiryDate = creditCardModel.expiryDate;
    _cardHolderName = creditCardModel.cardHolderName;
    notifyListeners();
  }

  //* SAVES and CREATED credit card info to HIVE
  Future<void> onCreditCardSave() async {
    await _hiveDbService.addCreditCard(
      CreditCard(
        cardNumber: _cardNumber,
        expiryDate: _expiryDate,
        cardHolderName: _cardHolderName,
      ),
      _selectedBankCard!,
    );
    navBack();
    notifyListeners();
  }

  //* UPDATES _selectedBankCard
  void updateSelectedBankCard(BankCard? newSelectedBankCard) {
    log.i('updateSelectedBankCard(): ${newSelectedBankCard!.bankName}');

    if (_selectedBankCard!.bankId != newSelectedBankCard.bankId) {
      _selectedBankCard = newSelectedBankCard;
      notifyListeners();
    }
  }

//------------------------ NAVIGATION ----------------------------//
  void navBack() => _navService.back(result: true);

  void navBackWithFalse() => _navService.back(result: false);
}
