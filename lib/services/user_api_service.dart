import 'dart:io';

import 'package:dio/dio.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/services/services.dart';

class UserApiService {
  final log = getLogger('UserApiService');

  final _apiRoot = locator<ApiRootService>();
  final _pushNotificationService = locator<PushNotificationService>();

  String? _otp;
  String?
      _phone; // To store phone info while app is active to use in verifyUser()
  String? get otp => _otp;

  // User? _currentUser;

  // User get currentUser => _currentUser!;

  // bool get hasLoggedInUser => _firebaseAuthenticationService.hasUser;

  Future<void> loginUser(String phone) async {
    log.i(
        'Phone: +993${phone.replaceAll(' ', '')},type: ${Platform.isAndroid ? 'android' : 'ios'}, registration_id: ${_pushNotificationService.fcmToken}');

    try {
      Response response = await _apiRoot.dio.get(
        'auth/login/',
        queryParameters: {
          'mobile': '+993${phone.replaceAll(' ', '')}',
          'type': Platform.isAndroid ? 'android' : 'ios',
          'registration_id': _pushNotificationService.fcmToken,
        },
      );
      log.v('RESPONSE: auth/login/ => ${response.data}');

      if (response.data != null) {
        _otp = response.data; // This _otp var is used for testing ONLY

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

    try {
      Response response = await _apiRoot.dio.get(
        'auth/verify/',
        queryParameters: {
          'mobile': _phone,
          'otp': otp,
        },
      );
      log.v('RESPONSE: auth/verify/ => ${response.data}');

      if (response.data != null) _otp = response.data;
    } catch (error) {
      log.v('ERROR on auth/verify/ :$error');
      throw DioErrorType.response;
    }
  }
}
