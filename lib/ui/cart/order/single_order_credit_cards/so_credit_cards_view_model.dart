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

  //* SETS _tempSelectedHiveCreditCard
  void updateTempSelectedHiveCreditCard(
      HiveCreditCard selectedHiveCreditCard, int pos) {
    log.v('updateTempSelectedHiveCreditCard selectedHiveCreditCard pos: $pos');

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

  //* SAVES and CREATES a new credit card info to HIVE
  Future<void> saveCreditCardToHive() async {
    log.v('saveCreditCardToHive()');
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

  //* For REORDER feature
  CreateBankOrderEnum _createBankOrderEnum = CreateBankOrderEnum.idle;

  //* For REORDER feature
  int _onlineRetryCounter = 0;

  //* POST Online Payment Order button is pressed
  Future<void> onOnlinePaymentOrderButtonPressed({
    required HiveCreditCard selectedHiveCreditCard,
    Function(OrderPaymentCreateBankOrder)? onSuccessForView,
    Function()? onFailForView,
  }) async {
    log.v('onOnlinePaymentOrderButtonPressed()');

    _isLoading = true;
    notifyListeners();

    //* LOOPS if errorCode is '1' specifically (Meaning already existing order)
    do {
      await runBusyFuture(
        _userService.createBankOrder(
          selectedHiveCreditCard,
          _cvcCode,
          soBottomSheetData.order,
          _createBankOrderEnum,
          _onlineRetryCounter,
          (OrderPaymentCreateBankOrder paymentCreateBankOrder) async {
            _createBankOrderEnum = CreateBankOrderEnum.success;
            _isLoading = false;
            notifyListeners();
            onSuccessForView!(paymentCreateBankOrder);
          },
          (CreateBankOrderEnum newCreateBankOrderEnum) {
            _createBankOrderEnum = newCreateBankOrderEnum;
            log.v('newCreateBankOrderEnum: $newCreateBankOrderEnum');

            if (_createBankOrderEnum == CreateBankOrderEnum.fail) {
              _isLoading = false;
              notifyListeners();
              onFailForView!();
            } else if (_createBankOrderEnum == CreateBankOrderEnum.reorderFail)
              _onlineRetryCounter++;
          },
        ),
      );
    } while (_createBankOrderEnum == CreateBankOrderEnum.reorderFail);
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

  bool _isSendCodeError = false;
  bool get isSendCodeError => _isSendCodeError;
  int _sendCodeErrorAttemptCount = 0;
  int get sendCodeErrorAttemptCount => _sendCodeErrorAttemptCount;

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
    required OrderPaymentCreateBankOrder paymentCreateBankOrder,
    Function()? onSuccessForView,
    Function()? onFailForView,
  }) async {
    log.v('onOtpVerifyButtonPressed()');

    _isLoading = true;
    _isSendCodeError = false;
    _sendCodeErrorAttemptCount = 0;
    notifyListeners();

    await runBusyFuture(
      _userService.verifyOtpOrderPayment(
        paymentCreateBankOrder.requestId ?? '',
        int.parse(_sendCode),
        (String paResValue) async => await _userService.postFinish3ds(
          paymentCreateBankOrder.orderId ?? '',
          paResValue,
          () => onSuccessForView!(),
          () {
            _isLoading = false;
            notifyListeners();
            onFailForView!();
          },
        ),
        (int attemptCountInt) {
          _isLoading = false;

          if (attemptCountInt != 0 && attemptCountInt != -1)
            _isSendCodeError = true;

          _sendCodeErrorAttemptCount = attemptCountInt;

          notifyListeners();
          onFailForView!();
        },
      ),
    );
  }

  //* For sms error types
  SmsErrorEnum _smsErrorEnum = SmsErrorEnum.idle;
  SmsErrorEnum get smsErrorEnum => _smsErrorEnum;

  ///* CHECKS ONLINE PAYMENT ORDER STATUS after VERIFICATION
  Future<void> checkOnlinePaymentOrderStatus({
    required String orderId,
    Function()? onSuccessForView,
    Function()? onFailForView,
  }) async {
    log.v('checkOnlinePaymentOrderStatus()');

    await runBusyFuture(
      _userService.checkOnlinePaymentOrderStatusExtended(
        orderId,
        () async =>
            //! PATCHS ORDER PAID VAR TO PAID after SUCCESS
            await _userService.patchOrderToPaid(
          soBottomSheetData.order.id!,
          () async {
            _isLoading = false;
            notifyListeners();
            onSuccessForView!();

            //* REINITIALIZES ORDERS
            // TODO: Optimize if possible
            await soBottomSheetData.orderViewModel.getInitialOrders();
          },
          () {
            _isLoading = false;
            notifyListeners();
            onFailForView!();
          },
        ),
        (SmsErrorEnum smsErrorEnum) {
          _smsErrorEnum = smsErrorEnum;
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

    await runBusyFuture(
      _userService.patchOrderOnlineToCash(
        soBottomSheetData.order.id!,
        () async {
          //* REINITIALIZES ORDERS
          // TODO: Optimize if possible
          await soBottomSheetData.orderViewModel.getInitialOrders();
          _isChangeOnlineToCashLoading = false;
          notifyListeners();
          onSuccessForView!();
        },
        () {
          _isChangeOnlineToCashLoading = false;
          notifyListeners();
          onFailForView!();
        },
      ),
    );
  }

//------------------------ NAVIGATION ----------------------------//
  void navBack() => _navService.back();
  // void navBack() => _navService.back(result: true);

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_hiveDbService];
}
