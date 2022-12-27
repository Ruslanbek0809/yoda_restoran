import 'hive_models/hive_models.dart';
import 'so_bottom_sheet_data.dart';

class SOConfirmationBottomSheetData {
  SOConfirmationBottomSheetData({
    required this.isNewCreditCard,
    this.hiveCreditCard,
    required this.soBottomSheetData,
  });
  final bool isNewCreditCard;
  final HiveCreditCard? hiveCreditCard;
  final SOBottomSheetData soBottomSheetData;
}
