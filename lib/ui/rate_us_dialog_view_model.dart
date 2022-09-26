import 'dart:async';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart' hide Trans;
import '../app/app.locator.dart';
import '../app/app.logger.dart';
import '../models/models.dart';
import '../services/services.dart';

class RateUsDialogViewModel extends BaseViewModel {
  final log = getLogger('RateUsDialogViewModel');

  final NotificationModel notificationModel;
  RateUsDialogViewModel(this.notificationModel);

  final _userService = locator<UserService>();
  final _navService = locator<NavigationService>();
  final _hiveDbService = locator<HiveDbService>(); // TODO: HiveRating

  bool _ratingError = false;
  bool get ratingError => _ratingError;

  double _rating = 0;
  double get rating => _rating;

  String? _note;
  String? get note => _note;

  late Timer _timer;
  Timer get timer => _timer;

  void ratingVal() {
    _ratingError = true;
    notifyListeners();
    log.v('ratingVal _ratingError: $_ratingError');
    Timer(Duration(seconds: 2), () {
      _ratingError = false;
      notifyListeners();
      log.v('ratingVal _ratingError: $_ratingError');
    });
  }

  void updateRating(double rating) {
    log.v('updateRating value: $rating');
    _ratingError = false;
    _rating = rating;
    notifyListeners();
  }

  // /// UPDATES _note
  // String? updateNote(String? value) {
  //   log.v('updateNote value: $value');
  //   if (value == null || value.isEmpty) return null;

  //   _note = value;
  //   notifyListeners();
  //   return null;
  // }

  /// UPDATES _note
  void updateNote(String? value) {
    log.v('updateNote value: $value');

    _note = value;
    notifyListeners();
  }

  /// TODO: HiveRating
  /// CLEARS hiveRating with this orderId if it EXISTS in hiveRatings
  Future<void> removeHiveRatingFromHiveRatings(int? orderId) async =>
      await _hiveDbService.deleteHiveRatingFromHiveRatings(orderId);

  /// SENDS user rating
  Future<void> onRatingSendPressed(
    Function()? onSuccess,
    Function()? onFail,
  ) async {
    log.v('onRatingSendPressed(): $_note, $note');
    try {
      await runBusyFuture(_userService.orderRating(
        int.parse(notificationModel.id!),
        int.parse(notificationModel.resId!),
        _rating,
        _note,
        () => onSuccess!(),
        () => onFail!(),
      ));
    } catch (err) {
      throw err;
    }
  }

  /// DISMISSES Dialog after assigned time duratin
  void dismissDialogs() =>
      _timer = Timer(Duration(seconds: 2), () => _navService.back());

  /// CANCELS timer if user taps outside of this dialog
  void cancelTimer() => _timer.cancel();

//------------------------ NAVIGATION ----------------------------//
  void navBack() => _navService.back(result: true);

  void navBackWithFalse() => _navService.back(result: false);
}
