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
  final SOBottomSheetData soBottomSheetData;
  SOCreditCardsViewModel({
    required this.soBottomSheetData,
  });

  final _userService = locator<UserService>();
  final _hiveDbService = locator<HiveDbService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _navService = locator<NavigationService>();

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

  //* CALLS CreditCardsConfirmationBottomSheet
  Future<void> showCustomCreditCardsConfirmationBottomSheet({
    bool isNewCreditCard = true,
  }) async {
    log.i('');
    // SheetResponse<bool>? _navResult;
    // _navResult =
    await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.creditCardConfirmation,
      enableDrag: true,
      barrierDismissible: true,
      isScrollControlled: true,
      data: SOConfirmationBottomSheetData(
        isNewCreditCard: isNewCreditCard,
        hiveCreditCard: _tempSelectedHiveCreditCard,
        soBottomSheetData: soBottomSheetData,
      ),
    );

    // if (_navResult != null && _navResult.data == true) {
    //   log.i('_navResult: $_navResult');
    //   await runBusyFuture(_checkoutService.getAddresses());
    // }
  }

//!------------------------ CREDIT CARD CONFIRMATION BOTTOM SHEET ----------------------------//

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

  //* ASSIGNS INITIAL list for selectedVolumes and selectedMultiCustomizables
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
  String? updateCVCValidator(String? value) {
    log.v('updateCVCValidator value: $value');

    if (value!.isEmpty) return LocaleKeys.enter_cvc_kod.tr();
    if (value.length < 3) return LocaleKeys.enter_full_cvc_kod.tr();

    _cvcCode = value;
    notifyListeners();
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
    log.v('onCreditCardSave()');
    await _hiveDbService.addCreditCard(
      CreditCard(
        cardNumber: _cardNumber,
        expiryDate: _expiryDate,
        cardHolderName: _cardHolderName,
      ),
      _selectedBankCard!,
    );
    notifyListeners();
  }

  //* UPDATES _selectedBankCard
  void updateSelectedBankCard(BankCard? newSelectedBankCard) {
    log.i('updateSelectedBankCard(): ${newSelectedBankCard!.bankName}');

    if (_selectedBankCard!.bankId != newSelectedBankCard.bankId) {
      _selectedBankCard = newSelectedBankCard;
      notifyListeners();
    }
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  //* POST Online Payment Order button is pressed
  Future<void> onOnlinePaymentOrderButtonPressed({
    required HiveCreditCard selectedHiveCreditCard,
    Function(OrderPaymentCreateBankOrder)? onSuccessForView,
    Function()? onFailForView,
  }) async {
    log.v('onOnlinePaymentOrderButtonPressed()');

    _isLoading = true;
    notifyListeners();

    await runBusyFuture(
      //* NEW CODE for online payment fetch from backend
      _userService.createBankOrder(
        selectedHiveCreditCard,
        _cvcCode,
        soBottomSheetData.order,
        false,
        0,
        (OrderPaymentCreateBankOrder paymentCreateBankOrder) async {
          _isLoading = false;
          notifyListeners();
          onSuccessForView!(paymentCreateBankOrder);
        },
        () {
          _isLoading = false;
          notifyListeners();
          onFailForView!();
        },
      ),
    );
  }

  //* CALLS SOSendCodeConfirmationBottomSheetView
  Future<void> showCustomSendCodeConfirmationBottomSheet(
    OrderPaymentCreateBankOrder paymentCreateBankOrder,
  ) async {
    log.i('');
    await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.sendCodeConfirmation,
      enableDrag: true,
      barrierDismissible: true,
      isScrollControlled: true,
      data: SOSendCodeConfirmationBottomSheetData(
        paymentCreateBankOrder: paymentCreateBankOrder,
        soBottomSheetData: soBottomSheetData,
      ),
      // data: paymentCreateBankOrder,
    );
  }

//!------------------------ SEND CODE CONFIRMATION BOTTOM SHEET ----------------------------//

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

  //* POST after CONFIRM button is pressed
  Future<void> onOtpVerifyButtonPressed({
    required String requestId,
    Function()? onSuccessForView,
    Function()? onFailForView,
  }) async {
    log.v('onOtpVerifyButtonPressed()');

    _isLoading = true;
    notifyListeners();

    await runBusyFuture(
      _userService.verifyOtpOrderPayment(
        requestId,
        int.parse(_sendCode),
        () {
          _isLoading = false;
          notifyListeners();
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

  //* CHECKS ONLINE PAYMENT ORDER STATUS after VERIFICATION
  Future<void> checkOnlinePaymentOrderStatus({
    required String orderId,
    Function()? onSuccessForView,
    Function()? onFailForView,
  }) async {
    log.v('checkOnlinePaymentOrderStatus()');

    // _isLoading = true;
    // notifyListeners();

    await runBusyFuture(
      _userService.checkOnlinePaymentOrderStatus(
        orderId,
        () async {
          // //* PATCHS ORDER PAID VAR
          // await _userService.patchOrderToPaid(
          //   order!.id!,
          //   () async {
          //     _isLoading = false;
          //     notifyListeners();
          //     onSuccessForView!();

          //     /// REINITIALIZES ORDERS
          //     /// TODO: Optimize if possible
          //     await orderViewModel!.getInitialOrders();
          //   },
          //   () {},
          // );
        },
        () {
          _isLoading = false;
          notifyListeners();
          onFailForView!();
        },
      ),
    );
  }

//!------------------------ PAYMENT SUCCESS/FAIL BOTTOM SHEET ----------------------------//

  bool _isChangeOnlineToCashLoading = false;
  bool get isChangeOnlineToCashLoading => _isChangeOnlineToCashLoading;

  ///* CHANGES ONLINE to CASH button is PRESSED
  Future<void> onChangeOnlineToCashButtonPressed({
    Function()? onSuccessForView,
    Function()? onFailForView,
  }) async {
    log.v('onChangeOnlineToCashButtonPressed()');

    _isChangeOnlineToCashLoading = true;
    notifyListeners();

    ///* COMMENTED
    // await runBusyFuture(
    //   _userService.patchOrderOnlineToCash(
    //     order!.id!,
    //     () async {
    //       /// REINITIALIZES ORDERS
    //       /// TODO: Optimize if possible
    //       await orderViewModel!.getInitialOrders();
    //       _isChangeToCashLoading = false;
    //       notifyListeners();
    //       onSuccessForView!();
    //     },
    //     () {
    //       _isChangeToCashLoading = false;
    //       notifyListeners();
    //       onFailForView!();
    //     },
    //   ),
    // );
  }

//------------------------ NAVIGATION ----------------------------//
  void navBack() => _navService.back();
  // void navBack() => _navService.back(result: true);

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_hiveDbService];
}
