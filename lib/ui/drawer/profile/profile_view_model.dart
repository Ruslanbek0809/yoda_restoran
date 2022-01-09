import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/app/app.router.dart';
import 'package:yoda_res/models/hive_models/hive_models.dart';
import 'package:yoda_res/services/services.dart';
import 'package:yoda_res/utils/utils.dart';

class ProfileViewModel extends BaseViewModel {
  final log = getLogger('ProfileViewModel');

  final _userService = locator<UserService>();
  final _navService = locator<NavigationService>();
  final _hiveDbService = locator<HiveDbService>();

  HiveUser? get currentUser => _userService.currentUser;
  bool get hasLoggedInUser => _userService.hasLoggedInUser;

  /// NAVIGATES to Home by removing all previous routes
  Future<void> navToHomeByRemovingAll() async =>
      await _navService.pushNamedAndRemoveUntil(Routes.homeView);

  /// LOGOUTS a user from app
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(Constants.accessToken);
    await _userService.logoutUser();
    await _hiveDbService.clearCart();
    await navToHomeByRemovingAll();
  }

  String? _name;
  String? get name => _name;

  String? _birthDate;
  String? get birthDate => _birthDate;

  String? _gender;
  String? get gender => _gender;

  String? _email;
  String? get email => _email;

  /// UPDATES _name
  String? updateName(String? value) {
    log.v('updateName value: $value');
    if (value!.isEmpty) {
      return 'Ady giriziň';
    }

    _name = value;
    notifyListeners();
  }

  /// UPDATES _birthDate
  String? updateBirthDate(String? value) {
    log.v('updateBirthDate value: $value');
    if (value!.isEmpty) {
      return 'Doglan senäňizi giriziň';
    }

    _birthDate = value;
    notifyListeners();
  }

  /// UPDATES _gender
  String? updateGender(String? value) {
    log.v('updateGender value: $value');
    if (value!.isEmpty) {
      return 'Jynsy giriziň';
    }

    _gender = value;
    notifyListeners();
  }

  /// UPDATES _email
  String? updateEmail(String? value) {
    log.v('updateEmail value: $value');
    if (value!.isEmpty) {
      return 'Elektron poçtaňyzy giriziň';
    }

    _email = value;
    notifyListeners();
  }

  /// ADDS new address
  Future<void> onAddAddressPressed() async {
    log.v('onAddAddressPressed()');
    try {
      await runBusyFuture(
          _userService.addAddress(city, street, house, apartment, floor, note));
    } catch (err) {
      throw err;
    }
  }

  void navBack() => _navService.back();
}
