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
  final _userService = locator<UserService>();

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
  Future<void> showCustomCreditCardsConfirmationBottomSheet({
    bool? isNewCreditCard = true,
    Order? order,
  }) async {
    log.i('');
    // SheetResponse<bool>? _navResult;
    // _navResult =
    await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.creditCardConfirmation,
      enableDrag: true,
      barrierDismissible: true,
      isScrollControlled: true,
      data: SOCreditCardsConfirmationBottomSheetData(
        isNewCreditCard: isNewCreditCard,
        hiveCreditCard: _tempSelectedHiveCreditCard,
        order: order,
      ),
    );

    // if (_navResult != null && _navResult.data == true) {
    //   log.i('_navResult: $_navResult');
    //   await runBusyFuture(_checkoutService.getAddresses());
    // }
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _cardNumber = '';
  String get cardNumber => _cardNumber;

  String _expiryDate = '';
  String get expiryDate => _expiryDate;

  String _cardHolderName = '';
  String get cardHolderName => _cardHolderName;

  String _cvcCode = '';
  String get cvcCode => _cvcCode;

  BankCard? _selectedBankCard = bankList[0];
  BankCard? get selectedBankCard => _selectedBankCard;

  bool _isConfirmAvailable = false;
  bool get isConfirmAvailable => _isConfirmAvailable;

  /// ASSIGNS INITIAL list for selectedVolumes and selectedMultiCustomizables
  void assignHiveCreditCardToTemp(HiveCreditCard hiveCreditCard) {
    log.i('assignHiveCreditCardToTemp()');

    _cardNumber = hiveCreditCard.cardNumber;
    _expiryDate = hiveCreditCard.expiryDate;
    _cardHolderName = hiveCreditCard.cardHolderName;
    _selectedBankCard = BankCard(
      bankId: hiveCreditCard.bankId,
      bankName: hiveCreditCard.bankName,
    );
    notifyListeners();
  }

  /// UPDATES _cardNumber
  String? updateCardNumberValidator(String? value) {
    log.v('updateCardNumberValidator value: $value, ${value!.length}');

    if (value.isEmpty) return LocaleKeys.enter_card_number.tr();
    if (value.length < 19) return LocaleKeys.enter_full_card_number.tr();

    _cardNumber = value;

    /// CHECKS for _isConfirmAvailable
    if ((_cardNumber.isNotEmpty && _cardNumber.length >= 19) &&
        (_expiryDate.isNotEmpty && _expiryDate.length >= 5) &&
        _cardHolderName.isNotEmpty &&
        (_cvcCode.isNotEmpty && _cvcCode.length >= 3))
      _isConfirmAvailable = true;
    else
      _isConfirmAvailable = true;

    notifyListeners();
    return null;
  }

  /// UPDATES _expiryDate
  String? updateExpiryDateValidator(String? value) {
    log.v('updateExpiryDateValidator value: $value');

    if (value!.isEmpty) return LocaleKeys.enter_card_date_deadline.tr();
    if (value.length < 5) return LocaleKeys.enter_full_card_date_deadline.tr();

    _expiryDate = value;

    /// CHECKS for _isConfirmAvailable
    if ((_cardNumber.isNotEmpty && _cardNumber.length >= 19) &&
        (_expiryDate.isNotEmpty && _expiryDate.length >= 5) &&
        _cardHolderName.isNotEmpty &&
        (_cvcCode.isNotEmpty && _cvcCode.length >= 3))
      _isConfirmAvailable = true;
    else
      _isConfirmAvailable = true;
    notifyListeners();
    return null;
  }

  /// CVC validator (EMPTY validator)
  String? updateCVCValidator(String? value) {
    log.v('updateCVCValidator value: $value');

    if (value!.isEmpty) return LocaleKeys.enter_cvc_kod.tr();
    if (value.length < 3) return LocaleKeys.enter_full_cvc_kod.tr();

    _cvcCode = value;

    /// CHECKS for _isConfirmAvailable
    if ((_cardNumber.isNotEmpty && _cardNumber.length >= 19) &&
        (_expiryDate.isNotEmpty && _expiryDate.length >= 5) &&
        _cardHolderName.isNotEmpty &&
        (_cvcCode.isNotEmpty && _cvcCode.length >= 3))
      _isConfirmAvailable = true;
    else
      _isConfirmAvailable = true;
    notifyListeners();
    return null;
  }

  /// UPDATES _cardHolderName
  String? updateCardHolderValidator(String? value) {
    log.v('updateCardHolder value: $value');
    if (value!.isEmpty) return LocaleKeys.enter_card_holder.tr();

    _cardHolderName = value;

    /// CHECKS for _isConfirmAvailable
    if ((_cardNumber.isNotEmpty && _cardNumber.length >= 19) &&
        (_expiryDate.isNotEmpty && _expiryDate.length >= 5) &&
        _cardHolderName.isNotEmpty &&
        (_cvcCode.isNotEmpty && _cvcCode.length >= 3))
      _isConfirmAvailable = true;
    else
      _isConfirmAvailable = true;
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

  /// POST after CONFIRM button is pressed
  Future<void> onConfirmButtonPressed(
    Order order,
    Function()? onSuccessForView,
    Function()? onFailForView,
  ) async {
    log.v('onConfirmButtonPressed()');

    _isLoading = true;
    notifyListeners();

    await runBusyFuture(
      _userService.postOnlinePayment(
        order,
        _cardNumber,
        _expiryDate,
        _cardHolderName,
        _cvcCode,
        _selectedBankCard,
        () {
          _isLoading = false;
          onSuccessForView!();
        },
        () {
          _isLoading = false;
          notifyListeners();
          onFailForView!();
        },
      ),
    );
  }

//------------------------ SEND CODE CONFIRMATION BOTTOM SHEET ----------------------------//

  /// CALLS SendCodeConfirmationBottomSheet
  Future<void> showCustomSendCodeConfirmationBottomSheet({
    bool? isNewCreditCard = true,
    Order? order,
  }) async {
    log.i('');
    await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.sendCodeConfirmation,
      enableDrag: true,
      barrierDismissible: true,
      isScrollControlled: true,
    );
  }

  String _sendCode = '';
  String get sendCode => _sendCode;

  /// SEND CODE validator (EMPTY validator)
  String? updateSendCodeValidator(String? value) {
    log.v('updateSendCodeValidator value: $value');

    if (value!.isEmpty) return LocaleKeys.enter_cvc_kod.tr();
    if (value.length < 3) return LocaleKeys.enter_full_cvc_kod.tr();

    _sendCode = value;
    notifyListeners();
    return null;
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_hiveDbService];
}
