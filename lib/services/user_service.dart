import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app/app.locator.dart';
import '../app/app.logger.dart';
import '../models/hive_models/hive_models.dart';
import '../models/models.dart';
import 'services.dart';
import '../utils/utils.dart';

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

  bool get hasLoggedInUser => _currentUser != null ? true : false;

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

  Future<void> loginUser(
      {String? phone, Function()? onSuccess, Function()? onFail}) async {
    log.v(
        'Phone: +993${phone!.replaceAll(' ', '')}, type: ${Platform.isAndroid ? 'android' : 'ios'}, registration_id: ${_pushNotificationService.fcmToken}');

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

      if (response.statusCode == 200 || response.statusCode == 201) {
        _otp = response.data['otp']; // This _otp var is used for testing ONLY

        _phone =
            '+993${phone.replaceAll(' ', '')}'; // To store phone info while app is active to use in verifyUser()
        onSuccess!();
      } else
        onFail!();
    } on DioError catch (error) {
      log.v('ERROR on auth/login/ :${error.response}');
      onFail!();
      throw DioErrorType.response;
    }
  }

  Future<void> verifyUser({Function()? onSuccess, Function()? onFail}) async {
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
      log.v('RESPONSE: auth/verify/ => ${response.data}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        /// Step 1. GETS and CONVERTS user json data to dart userModel
        final User userModel = User.fromJson(response.data['user']);
        log.v('userModel: $userModel, name: ');

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
          ),
        );

        /// Step 3. SETS accessToken to Constants.accessToken var
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(Constants.accessToken, response.data['access']);

        /// Step 4. GETS hiveUser from Hive userBox
        _currentUser = userBox.get(Constants.userBox);

        onSuccess!();
      } else {
        onFail!();
      }
    } on DioError catch (error) {
      log.v('ERROR on auth/verify/ :$error');
      onFail!();
      throw DioErrorType.response;
    }
  }

  Future<void> updateUser(
    String? name,
    DateTime? birthDate,
    String? gender,
    String? email,
    String? phone,
  ) async {
    Map<String, dynamic> _queryParams = {};
    if (name != null) _queryParams['first_name'] = name;
    if (birthDate != null) _queryParams['birthday'] = birthDate;
    if (gender != null) _queryParams['gender'] = gender;
    if (email != null) _queryParams['email'] = email;
    _queryParams['mobile'] = phone;

    log.v('_queryParams at the END: $_queryParams');
    final FormData userUpdateFormData = FormData.fromMap(_queryParams);

    try {
      Response response = await _apiRoot.dio.patch(
        'api/user/${_currentUser!.id}/',
        data: userUpdateFormData,
      );
      log.v(
          'RESPONSE: api/user/${_currentUser!.id}/ => ${response.data} and ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        /// Step 1. GETS and CONVERTS user json data to dart userModel
        final User? userModel = User.fromJson(response.data);

        /// Step 2. UPDATES userModel to Hive userBox
        await userBox.put(
          Constants.userBox,
          HiveUser(
            id: userModel!.id,
            firstName: userModel.firstName,
            lastName: userModel.lastName,
            email: userModel.email,
            mobile: userModel.mobile,
            gender: userModel.gender,
            birthday: userModel.birthday,
          ),
        );

        /// Step 3. GETS hiveUser from Hive userBox
        _currentUser = userBox.get(Constants.userBox);
      }
    } on DioError catch (error) {
      log.v('ERROR on auth/user/${_currentUser!.id}/ :${error.response}');
      // log.v(
      //     'ERROR on api/user/${_currentUser!.id}/ :${error.response!.statusCode} and ${error.response!.data}');
      rethrow;
    }
  }

  Future<void> logoutUser() async {
    await userBox.clear();
    _currentUser = userBox.get(Constants.userBox);
    log.i('_currentUser and its ID: $_currentUser, ${_currentUser?.id}');
  }

  //------------------ ADDRESS APIS ---------------------//

  Future<List<Address>> getAddresses() async {
    List<Address> _addresses = [];
    try {
      Response response = await _apiRoot.dio.get('api/user/');
      log.v('RESPONSE: api/user/ => ${response.data}');

      /// Below data structure is like user list in each user and its addresses
      if (response.data != null) {
        response.data.forEach((_user) {
          _user['addresses'].forEach((_address) {
            _addresses.add(Address.fromJson(_address));
          });
        });
      }

      return _addresses;
    } on DioError catch (error) {
      log.v(error);
      // log.v(
      //     'ERROR on api/user/ :${error.response!.statusCode} and ${error.response!.data}');
      rethrow;
    }
  }

  Future<void> addAddress(
    String? city,
    String? street,
    int? house,
    int? apartment,
    int? floor,
    String? note,
  ) async {
    Map<String, dynamic> _queryParams = {};
    _queryParams['city'] = city;
    _queryParams['street'] = street;
    if (house != null) _queryParams['house'] = house;
    if (apartment != null) _queryParams['apartment'] = apartment;
    if (floor != null) _queryParams['floor'] = floor;
    if (note != null) _queryParams['notes'] = note;

    log.v('_queryParams at the END: $_queryParams');
    final FormData addressFormData = FormData.fromMap(_queryParams);

    try {
      Response response = await _apiRoot.dio.post(
        'api/address/',
        data: addressFormData,
      );
      log.v('RESPONSE: api/address/ => ${response.data}');

      if (response.data != null) {}
    } on DioError catch (error) {
      // log.v(error);
      log.v('ERROR on api/address/ ${error.response!.data}');
      rethrow;
    }
  }

  //------------------ CREATE ORDER API ---------------------//

  Future<void> createOrder(
    Address? selectedAddress,
    bool isDelivery,
    DateTime? deliveryDateTime,
    PaymentType? paymentType,
    Promocode? promocode,
    String? checkoutNote,
    HiveRestaurant? cartRes,
    List<HiveMeal> cartMeals,
    Function()? onSuccess,
    Function()? onFail,
  ) async {
    List<CreateOrderItem>? orderItemList = [];

    /// Step 1. For each cartMeal in cartMeals, creating and assigning to orderItemList
    cartMeals.forEach((_cartMeal) {
      num totalCartMealSum = 0;

      totalCartMealSum += _cartMeal.discount != null || _cartMeal.discount! > 0
          ? _cartMeal.discountedPrice!
          : _cartMeal.price!;

      _cartMeal.volumes!.forEach((vol) {
        if (vol.id != -1) totalCartMealSum += vol.price!;
      });
      _cartMeal.customs!.forEach((cus) {
        totalCartMealSum += cus.price!;
      });

      /// VOLUME DISSECTING into List<int> part
      List<int> volList = [];
      List<int> cusList = [];

      _cartMeal.volumes!.forEach((vol) {
        if (vol.id != -1) volList.add(vol.id!);
      });
      _cartMeal.customs!.forEach((cus) {
        cusList.add(cus.id!);
      });

      orderItemList.add(CreateOrderItem(
        meal: _cartMeal.id,
        price: totalCartMealSum,
        quantity: _cartMeal.quantity,
        volumePrices: volList,
        costumizedMeals: cusList,
      ));
    });

    /// Step 2. Here we CREATE new order based on above params and conditions
    CreateOrder createOrder = CreateOrder(
      restaurant: cartRes!.id,
      address: isDelivery ? selectedAddress!.id : null,
      selfPickUp: !isDelivery,
      deliveryTime: deliveryDateTime,
      paymentType: paymentType!.id,
      promocode: promocode != null ? promocode.id : null,
      notes: checkoutNote,
      orderItems: orderItemList,
    );
    log.i('createOrder.toJson(): ${createOrder.toJson()}');
    log.i('createOrder.toJson() with jsonEncode: ${jsonEncode(createOrder)}');

    try {
      Response response = await _apiRoot.dio.post(
        'api/order/',
        data: jsonEncode(
            createOrder), // Step 3. Instead of using formData I used jsonSerializable's toJson with build-in jsonEncode func
      );
      log.v('RESPONSE: api/order/ => ${response.data}');

      if (response.data != null &&
          (response.statusCode == 200 || response.statusCode == 201))
        onSuccess!();
      else
        onFail!();
    } on DioError catch (error) {
      log.v('ERROR api/order/ with RESPONSE: ${error.response}');
      onFail!();
      throw DioErrorType.response;
    }
  }

  //------------------ ORDERS ---------------------//

  Future<List<Order>> getOrders() async {
    List<Order> _orders = [];
    try {
      Response response = await _apiRoot.dio.get('api/order/');
      // log.v('RESPONSE: api/order/ => ${response.data}');

      if (response.data != null) {
        response.data.forEach((_order) {
          _orders.add(Order.fromJson(_order));
        });
      }

      if (_orders.isNotEmpty)
        _orders.sort((prev, next) => prev.status!
            .compareTo(next.status!)); // Sorting status ids in ascending order
      return _orders;
    } on DioError catch (error) {
      log.v('ERROR api/order/ with RESPONSE: ${error.response}');
      rethrow;
    }
  }
}
