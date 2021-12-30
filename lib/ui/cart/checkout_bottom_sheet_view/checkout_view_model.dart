import 'package:stacked/stacked.dart';
import 'package:yoda_res/app/app.logger.dart';

class CheckoutViewModel extends BaseViewModel {
  final log = getLogger('CheckoutViewModel');

  /// DateTime vars
  final now = DateTime.now();
  DateTime? tomorrow;
  DateTime? maxDateTime;
  DateTime? deliverDateTime;
  String? deliverDateFormatted = '';

  void getOnModelReady() {
    deliverDateTime = now;
    tomorrow = DateTime(now.year, now.month, now.day + 1);
    maxDateTime = DateTime(now.year, now.month, now.day + 1, 20);
  }
}
