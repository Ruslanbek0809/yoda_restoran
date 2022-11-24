import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart' hide Trans;
import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../app/app.router.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../models/hive_models/hive_models.dart';
import '../../../services/services.dart';
import '../../../utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileViewModel extends BaseViewModel {
  final log = getLogger('ProfileViewModel');

  final _userService = locator<UserService>();
  final _navService = locator<NavigationService>();
  final _hiveDbService = locator<HiveDbService>();
  final _dialogService = locator<DialogService>();

  HiveUser? get currentUser => _userService.currentUser;
  bool get hasLoggedInUser => _userService.hasLoggedInUser;

  String? _name;
  String? get name => _name;

  DateTime? _birthDate;
  DateTime? get birthDate => _birthDate;

  String? _gender;
  String? get gender => _gender;

  String? _email;
  String? get email => _email;

  String? _phone;
  String? get phone => _phone;

  /// LOGOUTS a user from app
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(Constants.accessToken);
    final String? _accessToken = prefs.getString(Constants.accessToken);
    log.i('ACCESS TOKEN after remove: $_accessToken');
    await _userService.logoutUser();
    await _hiveDbService.clearCart();
    await navToHomeByRemovingAll();
  }

  /// ASSIGNS currentUser value
  void assignCurrentUserValues() {
    log.v('assignCurrentUserValues()');

    _name = currentUser?.firstName;

    _birthDate = currentUser?.birthday;

    _gender = currentUser?.gender;

    _email = currentUser?.email;

    _phone = currentUser!.mobile;
  }

  /// UPDATES _name
  String? updateName(String? value) {
    log.v('updateName value: $value');
    // if (value!.isEmpty) {
    //   return 'Ady giriziň';
    // }

    _name = value;
    notifyListeners();
    return null;
  }

  /// UPDATES _birthDate
  String? updateBirthDate(DateTime? value) {
    log.v('updateBirthDate value: $value');
    // if (value!.isEmpty) {
    //   return 'Doglan senäňizi giriziň';
    // }

    _birthDate = value;
    notifyListeners();
    return null;
  }

  /// UPDATES _gender
  String? updateGender(String? value) {
    log.v('updateGender value: $value');
    // if (value!.isEmpty) {
    //   return 'Jynsy giriziň';
    // }

    _gender = value;
    notifyListeners();
    return null;
  }

  /// UPDATES _email
  String? updateEmail(String? value) {
    log.v('updateEmail value: $value');
    // if (value!.isEmpty) {
    //   return 'Elektron poçtaňyzy giriziň';
    // }

    _email = value;
    notifyListeners();
    return null;
  }

  /// UPDATES _email
  String? updatePhone(String? value) {
    log.v('updatePhone value: $value');
    if (value == null || value.isEmpty || value.length < 11) {
      return LocaleKeys.enter_phone.tr();
    }

    _phone = value;
    notifyListeners();
    return null;
  }

  /// UPDATES user info
  Future<void> onUpdateUserPressed({
    Function()? onFailForView,
    Function()? onSuccessForView,
  }) async {
    log.v('onUpdateUserPressed()');
    try {
      await runBusyFuture(_userService.updateUser(
        _name,
        _birthDate,
        _gender,
        _email,
        _phone,
        () => onSuccessForView!(),
        () => onFailForView!(),
      ));
    } catch (err) {
      throw err;
    }
  }

//------------------------ USER LOGOUT/DELETE DIALOG ----------------------------//

  /// SHOWS USER LOGOUT Dialog
  Future showUserLogoutDialog(
    Function()? onSuccessForView,
  ) async {
    log.i('showUserLogoutDialog()');
    DialogResponse<dynamic>? respData = await _dialogService.showCustomDialog(
      variant: DialogType.userLogout,
      title: LocaleKeys.wannaLogoutUser,
      mainButtonTitle: LocaleKeys.no,
      secondaryButtonTitle: LocaleKeys.yes,
      showIconInMainButton: false,
      barrierDismissible: true,
    );
    if (respData != null && respData.data == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Constants.accessToken);
      final String? _accessToken = prefs.getString(Constants.accessToken);
      log.i('ACCESS TOKEN after remove: $_accessToken');
      await _userService.logoutUser();
      await _hiveDbService.clearCart();
      onSuccessForView!();
    }
  }

  /// SHOWS USER DELETE Dialog
  Future showUserDeleteDialog(
    Function()? onSuccessForView,
  ) async {
    log.i('showUserDeleteDialog()');
    DialogResponse<dynamic>? respData = await _dialogService.showCustomDialog(
      variant: DialogType.userDelete,
      title: LocaleKeys.wannaDeleteUser,
      description: LocaleKeys.deleteUserInfo,
      mainButtonTitle: LocaleKeys.no,
      secondaryButtonTitle: LocaleKeys.remove,
      showIconInMainButton: false,
      barrierDismissible: true,
    );
    if (respData != null && respData.data == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Constants.accessToken);
      final String? _accessToken = prefs.getString(Constants.accessToken);
      log.i('ACCESS TOKEN after remove: $_accessToken');
      await _userService.logoutUser();
      await _hiveDbService.clearCart();
      onSuccessForView!();
    }
  }

//------------------------ NAVIGATIONS ----------------------------//

  void navBack() => _navService.back();

  /// NAVIGATES to Home by removing all previous routes
  Future<void> navToHomeByRemovingAll() async =>
      await _navService.pushNamedAndRemoveUntil(Routes.homeView);
}
