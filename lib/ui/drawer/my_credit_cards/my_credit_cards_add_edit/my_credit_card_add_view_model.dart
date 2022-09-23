import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart' hide Trans;
import 'package:yoda_res/utils/utils.dart';
import '../../../../app/app.locator.dart';
import '../../../../app/app.logger.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../models/models.dart';
import '../../../../services/services.dart';

class MyCreditCardAddViewModel extends BaseViewModel {
  final log = getLogger('MyCreditCardAddViewModel');

  final _userService = locator<UserService>();
  final _navService = locator<NavigationService>();

  String? _city = LocaleKeys.ashgabat.tr();
  String? get city => _city;

  String _street = '';
  String get street => _street;

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
