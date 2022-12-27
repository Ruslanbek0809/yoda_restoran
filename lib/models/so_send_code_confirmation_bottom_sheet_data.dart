import 'models.dart';

class SOSendCodeConfirmationBottomSheetData {
  SOSendCodeConfirmationBottomSheetData({
    required this.paymentCreateBankOrder,
    required this.soBottomSheetData,
  });
  final OrderPaymentCreateBankOrder paymentCreateBankOrder;
  final SOBottomSheetData soBottomSheetData;
}
