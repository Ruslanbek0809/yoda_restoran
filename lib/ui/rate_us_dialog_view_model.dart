import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart' hide Trans;
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/services/services.dart';

class RateUsDialogViewModel extends BaseViewModel {
  final log = getLogger('RateUsDialogViewModel');

  final NotificationModel notificationModel;
  RateUsDialogViewModel(this.notificationModel);

  final _userService = locator<UserService>();
  final _navService = locator<NavigationService>();

  double _rating = 0;
  double get rating => _rating;

  String? _note;
  String? get note => _note;

  void updateRating(double rating) {
    log.v('updateRating value: $rating');
    _rating = rating;
    // notifyListeners();
  }

  /// UPDATES _note
  String? updateNote(String? value) {
    log.v('updateNote value: $value');
    if (value == null || value.isEmpty) return null;

    _note = value;
    notifyListeners();
    return null;
  }

  /// ADDS new address
  Future<void> onAddAddressPressed(
    Function()? onSuccess,
    Function()? onFail,
  ) async {
    log.v('onAddAddressPressed()');
    // try {
    //   await runBusyFuture(_userService.addAddress(
    //     note,
    //     () => onSuccess!(),
    //     () => onFail!(),
    //   ));
    // } catch (err) {
    //   throw err;
    // }
  }

//------------------------ NAVIGATION ----------------------------//
  void navBack() => _navService.back(result: true);

  void navBackWithFalse() => _navService.back(result: false);
}
