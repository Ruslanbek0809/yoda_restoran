import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/models/hive_models/hive_models.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/services/services.dart';
import 'package:yoda_res/utils/utils.dart';

class UserService {
  final log = getLogger('UserService');

  final _apiRoot = locator<ApiRootService>();
  final _pushNotificationService = locator<PushNotificationService>();

  static late Box<HiveUser> userBox;

  String? _otp = '123456';
  String?
      _phone; // To store phone info while app is active to use in verifyUser()
  String? get otp => _otp;

  HiveUser? _currentUser;

  HiveUser? get currentUser => _currentUser;

  // bool get hasLoggedInUser => _currentUser =! null ? true :;

  /// INITIALIZE in StartUpViewModel
  Future initUser() async {
    log.v('====== UserService STARTED opening boxes ======');

    /// Step 1. OPENS userBox
    await Hive.openBox<HiveUser>(Constants.userBox);

    /// Step 2. ASSIGNS opened userBox to userBox for further work in Login/Otp Views
    userBox = Hive.box<HiveUser>(Constants.userBox);

    /// Step 3. GETS hiveUser from Hive userBox
    _currentUser = userBox.get(Constants.userBox);

    log.v(
        '====== UserService ENDED opening boxes ====== _currentUser: $_currentUser');
  }

  Future<void> loginUser(String phone) async {
    log.v(
        'Phone: +993${phone.replaceAll(' ', '')}, type: ${Platform.isAndroid ? 'android' : 'ios'}, registration_id: ${_pushNotificationService.fcmToken}');

    final FormData userFormData = FormData.fromMap({
      'mobile': '+993${phone.replaceAll(' ', '')}',
      'type': Platform.isAndroid ? 'android' : 'ios',
      'registration_id': _pushNotificationService.fcmToken,
    });
    try {
      Response response = await _apiRoot.dio.post(
        'auth/login/',
        data: userFormData,
      );
      log.v('RESPONSE: auth/login/ => ${response.data}');

      if (response.data != null) {
        _otp = response.data['otp']; // This _otp var is used for testing ONLY

        _phone =
            '+993${phone.replaceAll(' ', '')}'; // To store phone info while app is active to use in verifyUser()
      }
    } catch (error) {
      log.v('ERROR on auth/login/ :$error');
      throw DioErrorType.response;
    }
  }

  Future<void> verifyUser() async {
    log.v('Otp: $otp, Phone: $_phone');

    final FormData otpFormData = FormData.fromMap({
      'mobile': _phone,
      'otp': otp,
    });
    try {
      Response response = await _apiRoot.dio.post(
        'auth/verify/',
        data: otpFormData,
      );
      log.v('RESPONSE CODE: auth/verify/ => ${response.statusCode}');
      log.v('RESPONSE: auth/verify/ => ${response.data}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        /// Step 1. GETS and CONVERTS user json data to dart userModel
        final User userModel = User.fromJson(response.data);

        /// Step 2. SAVES userModel to Hive userBox
        await userBox.put(
            Constants.userBox,
            HiveUser(
              id: userModel.id,
              firstName: userModel.firstName,
              lastName: userModel.lastName,
              email: userModel.email,
              mobile: userModel.mobile,
              gender: userModel.gender,
              birthday: userModel.birthday,
              accessToken: response.data['access'],
            ));

        /// Step 3. GETS hiveUser from Hive userBox
        _currentUser = userBox.get(Constants.userBox);
      }
    } catch (error) {
      log.v('ERROR on auth/verify/ :$error');
      throw DioErrorType.response;
    }
  }
}
