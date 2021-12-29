import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/models/hive_models/hive_models.dart';
import 'package:yoda_res/services/services.dart';
import 'package:yoda_res/utils/utils.dart';

class UserService {
  final log = getLogger('UserService');

  final _apiRoot = locator<ApiRootService>();
  final _pushNotificationService = locator<PushNotificationService>();

  String? _otp = '123456';
  String?
      _phone; // To store phone info while app is active to use in verifyUser()
  String? get otp => _otp;

  // User? _currentUser;

  // User get currentUser => _currentUser!;

  // bool get hasLoggedInUser => _firebaseAuthenticationService.hasUser;

  /// INITIALIZE in StartUpViewModel
  Future initUser() async {
    log.v('====== UserService STARTED opening boxes ======');

    await Hive.openBox<HiveUser>(Constants.cartResBox);

    log.v('====== UserService ENDED opening boxes ======');
  }

  Future<void> loginUser(String phone) async {
    log.i(
        'Phone: +993${phone.replaceAll(' ', '')},type: ${Platform.isAndroid ? 'android' : 'ios'}, registration_id: ${_pushNotificationService.fcmToken}');

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

  Future<void> verifyUser(String otp) async {
    log.i('Otp: $otp, Phone: $_phone');

    final FormData otpFormData = FormData.fromMap({
      'mobile': _phone,
      'otp': otp,
    });
    try {
      Response response = await _apiRoot.dio.post(
        'auth/verify/',
        data: otpFormData,
      );
      log.v('RESPONSE: auth/verify/ => ${response.data}');

      // if (response.data != null) _otp = response.data;
    } catch (error) {
      log.v('ERROR on auth/verify/ :$error');
      throw DioErrorType.response;
    }
  }
}
