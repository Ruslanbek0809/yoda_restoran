import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart' hide Trans;
import '../../../../app/app.locator.dart';
import '../../../../app/app.logger.dart';
import '../../../../generated/locale_keys.g.dart';
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

  bool _useGlassMorphism = false;
  bool get useGlassMorphism => _useGlassMorphism;

  bool _useBackgroundImage = false;
  bool get useBackgroundImage => _useBackgroundImage;

  OutlineInputBorder? _border;
  OutlineInputBorder? get border => _border;

  /// UPDATES _city
  String? updateCity(String? value) {
    log.v('updateCity value: $value');
    if (value!.isEmpty) return LocaleKeys.enterCity.tr();

    _city = value;
    notifyListeners();
    return null;
  }

  /// UPDATES _street
  String? updateStreet(String? value) {
    log.v('updateStreet value: $value');
    // if (value == null || value.isEmpty) return null;
    if (value!.isEmpty) return LocaleKeys.enterStreet.tr();

    _street = value;
    notifyListeners();
    return null;
  }

  // /// ADDS new address
  // Future<void> onAddAddressPressed(
  //   Function()? onSuccess,
  //   Function()? onFail,
  // ) async {
  //   log.v('onAddAddressPressed()');
  //   try {
  //     await runBusyFuture(_userService.addAddress(
  //       city,
  //       street,
  //       house,
  //       apartment,
  //       floor,
  //       note,
  //       () => onSuccess!(),
  //       () => onFail!(),
  //     ));
  //   } catch (err) {
  //     throw err;
  //   }
  // }

  void onGlassmorphismChange(bool value) {
    _useGlassMorphism = value;
    notifyListeners();
  }

  void onBackgroundChange(bool value) {
    _useBackgroundImage = value;
    notifyListeners();
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    _cardNumber = creditCardModel!.cardNumber;
    _expiryDate = creditCardModel.expiryDate;
    _cardHolderName = creditCardModel.cardHolderName;
    _cvvCode = creditCardModel.cvvCode;
    _isCvvFocused = creditCardModel.isCvvFocused;
    notifyListeners();
  }

//------------------------ NAVIGATION ----------------------------//
  void navBack() => _navService.back(result: true);

  void navBackWithFalse() => _navService.back(result: false);
}
