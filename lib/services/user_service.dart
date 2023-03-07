import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app/app.locator.dart';
import '../app/app.logger.dart';
import '../models/hive_models/hive_models.dart';
import '../models/models.dart';
import '../utils/utils.dart';
import 'services.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' show Document;

class UserService {
  final log = getLogger('UserService');

  final _apiRoot = locator<ApiRootService>();
  final _pushNotificationService = locator<PushNotificationService>();

  static late Box<HiveUser> userBox;
  static late Box<int> favoritesBox;

  String? _otp = '123456';
  String?
      _phone; // To store phone info while app is active to use in verifyUser()
  String? get otp => _otp;

  HiveUser? _currentUser;

  HiveUser? get currentUser => _currentUser;

  bool get hasLoggedInUser => _currentUser != null ? true : false;

  // Future<void> getInitialUser(
  //     {Function()? onSuccess, Function()? onFail}) async {
  //   log.v('====== getInitialUser() STARTED ======');
  //   try {
  //     Response response = await _apiRoot.dio.get('api/user/');
  //     log.v('RESPONSE: api/user/ => ${response.data}');
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       //* Step 1. GETS and CONVERTS user json data to dart userModel
  //       User? userModel;
  //       for (final _userJson in response.data)
  //         userModel = User.fromJson(_userJson);

  //       //* Step 2. ASSIGNS opened userBox to userBox for further work in Login/Otp Views
  //       userBox = Hive.box<HiveUser>(Constants.userBox);

  //       //* Step 3. SAVES userModel to Hive userBox.
  //       //* NOTE: Don't rewrite accessToken here.
  //       await userBox.put(
  //         Constants.userBox,
  //         HiveUser(
  //           id: userModel!.id,
  //           firstName: userModel.firstName,
  //           lastName: userModel.lastName,
  //           email: userModel.email,
  //           mobile: userModel.mobile,
  //           gender: userModel.gender,
  //           birthday: userModel.birthday,
  //           favs: userModel.favourites ?? [],
  //         ),
  //       );

  //       //* Step 4. GETS hiveUser from Hive userBox
  //       _currentUser = userBox.get(Constants.userBox);

  //       log.v(
  //           '_currentUser in getInitialUser() with his/her phone: ${_currentUser!.mobile} and favs: ${_currentUser!.favs}');
  //       onSuccess!();
  //     } else
  //       onFail!();
  //   } on DioError catch (error) {
  //     log.v('ERROR on api/user/ :${error.response}');
  //     onFail!();
  //     throw DioErrorType.response;
  //   }
  // }

  // //* INITIALIZE in StartUpViewModel
  // Future clearUser() async {
  //   log.v('====== UserService STARTED opening boxes ======');

  //   //* Step 1. ASSIGNS opened userBox to userBox for further work in Login/Otp Views
  //   userBox = Hive.box<HiveUser>(Constants.userBox);

  //   //* Step 2. CLEARS user data from hiveBox
  //   await userBox.clear();

  //   //* Step 3.GETS user data from hiveBox for loggedIn variables
  //   _currentUser = userBox.get(Constants.userBox);

  //   log.v(
  //       '====== UserService ENDED opening boxes ====== _currentUser: $_currentUser and his/her phone: ${_currentUser?.mobile}');
  // }

  //* INITIALIZE in StartUpViewModel
  Future initUser() async {
    log.v('====== UserService STARTED initUser() ======');

    //* Step 1. ASSIGNS opened userBox to userBox for further work in Login/Otp Views
    userBox = Hive.box<HiveUser>(Constants.userBox);
    favoritesBox = Hive.box<int>(Constants.favoritesBox);

    //* Step 2. GETS hiveUser from Hive userBox
    _currentUser = userBox.get(Constants.userBox);

    log.v(
        '====== UserService ENDED initUser() ======> _currentUser: $_currentUser');
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
        //* Step 1. GETS and CONVERTS user json data to dart userModel
        final User userModel = User.fromJson(response.data['user']);

        //* Step 2. SAVES userModel to Hive userBox
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
            favs: userModel.favourites ?? [],
          ),
        );

        //* Step 3. SETS accessToken to Constants.accessToken var
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            Constants.accessToken, response.data['access'] as String);
        final String? _accessToken = prefs.getString(Constants.accessToken);
        log.i('ACCESS TOKEN after setString: $_accessToken');

        //* Step 4. GETS hiveUser from Hive userBox
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
    Function()? onSuccess,
    Function()? onFail,
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
        //* Step 1. GETS and CONVERTS user json data to dart userModel
        final User? userModel = User.fromJson(response.data);

        //* Step 2. UPDATES userModel to Hive userBox
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
            favs: userModel.favourites ?? [],
          ),
        );

        //* Step 3. GETS hiveUser from Hive userBox
        _currentUser = userBox.get(Constants.userBox);
        onSuccess!();
      } else
        onFail!();
    } on DioError catch (error) {
      log.v('ERROR on api/user/${_currentUser!.id}/ :${error.response}');
      onFail!();
      throw DioErrorType.response;
    }
  }

  Future<void> logoutUser() async {
    await userBox.clear();
    _currentUser = userBox.get(Constants.userBox);
    log.i('logoutUser() _currentUser: $_currentUser');
  }

  //* ------------------ ADDRESS APIS ---------------------//

  Future<List<Address>> getAddresses() async {
    List<Address> _addresses = [];
    try {
      Response response = await _apiRoot.dio.get('api/user/');
      log.v('RESPONSE: api/user/ => ${response.data}');

      //* Below data structure is like user list in each user and its addresses
      if (response.data != null) {
        for (final _user in response.data) {
          for (final _address in _user['addresses']) {
            _addresses.add(Address.fromJson(_address));
          }
        }
      }

      return _addresses;
    } on DioError catch (error) {
      log.v(error);
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
    Function()? onSuccess,
    Function()? onFail,
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

      if (response.data != null &&
          (response.statusCode == 200 || response.statusCode == 201))
        onSuccess!();
      else
        onFail!();
    } on DioError catch (error) {
      log.v('ERROR on api/address/ ${error.response}');
      onFail!();
      rethrow;
    }
  }

  Future<void> editAddress(
    int? addressId,
    String? city,
    String? street,
    int? house,
    int? apartment,
    int? floor,
    String? note,
    Function()? onSuccess,
    Function()? onFail,
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
      Response response = await _apiRoot.dio.patch(
        'api/address/$addressId/',
        data: addressFormData,
      );
      log.v('RESPONSE: api/address/$addressId/ => ${response.data}');

      if (response.data != null &&
          (response.statusCode == 200 || response.statusCode == 201))
        onSuccess!();
      else
        onFail!();
    } on DioError catch (error) {
      log.v('ERROR on api/address/$addressId/ ${error.response}');
      onFail!();
      rethrow;
    }
  }

  Future<void> deleteAddress(
      {int? addressId, Function()? onSuccess, Function()? onFail}) async {
    try {
      Response response = await _apiRoot.dio.delete('api/address/$addressId/');
      log.v('RESPONSE: api/address/$addressId/ => ${response.statusCode}');

      if (response.data != null && response.statusCode == 204)
        onSuccess!();
      else
        onFail!();
    } on DioError catch (error) {
      log.v('ERROR on api/address/$addressId/: $error');
      onFail!();
      rethrow;
    }
  }

  //* ------------------ CREATE ORDER API ---------------------//

  Future<void> createOrder(
    Address? selectedAddress,
    bool isDelivery,
    DateTime? deliveryDateTime,
    HiveResPaymentType? paymentType,
    Promocode? promocode,
    String? checkoutNote,
    HiveRestaurant? cartRes,
    List<HiveMeal> cartMeals,
    Function()? onSuccess,
    Function()? onFail,
  ) async {
    List<CreateOrderItem>? orderItemList = [];

    //* Step 1. For each cartMeal in cartMeals, creating and assigning to orderItemList
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

      //* VOLUME DISSECTING into List<int> part
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

    //* Step 2. Here we CREATE new order based on above params and conditions
    CreateOrder createOrder = CreateOrder(
      restaurant: cartRes!.id,
      address: isDelivery ? selectedAddress!.id : null,
      selfPickUp: !isDelivery,
      deliveryTime: deliveryDateTime,
      paymentType: paymentType!.id,
      promocode:
          promocode != null && promocode.quantity != -1 ? promocode.id : null,
      notes: checkoutNote,
      orderItems: orderItemList,
    );
    log.i('createOrder.toJson(): ${createOrder.toJson()}');
    log.i('createOrder.toJson() with jsonEncode: ${jsonEncode(createOrder)}');

    try {
      Response response = await _apiRoot.dio.post(
        'api/order/',
        data: jsonEncode(
            createOrder), // Step 3. Instead of using formData I used jsonSerializable's toJson with built-in jsonEncode func
      );
      log.v('RESPONSE: api/order/ => ${response.data}');

      if (response.data != null &&
          (response.statusCode == 200 || response.statusCode == 201))
        onSuccess!();
      else
        onFail!();
    } on DioError catch (error) {
      log.v('ERROR api/order/ with RESPONSE: ${error.response!.statusCode}');
      if (error.response!.statusCode == 502 ||
          error.response!.statusCode == 503)
        onSuccess!();
      else
        onFail!();
      throw DioErrorType.response;
    }
  }

  //* ------------------ ORDERS Start ---------------------//

  Future<List<Order>> getOrders() async {
    List<Order> _orders = [];
    try {
      Response response = await _apiRoot.dio.get('api/order/');
      // log.v('RESPONSE: api/order/ => ${response.data}');

      if (response.data != null) {
        for (final _order in response.data) {
          _orders.add(Order.fromJson(_order));
        }
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

  //* ORDER PAG
  Future<void> getPaginatedOrders(
    int page,
    Function(List<Order>?, String?)? onSuccess,
  ) async {
    List<Order> _paginatedOrders = [];
    try {
      Response response =
          await _apiRoot.dio.get('api/paginatedorder?page=$page');
      log.v('RESPONSE: api/paginatedorder/ => ${response.data}');

      if (response.data['results'] != null) {
        for (final _paginatedOrder in response.data['results'])
          _paginatedOrders.add(Order.fromJson(_paginatedOrder));
      }
      if (_paginatedOrders.isNotEmpty)
        _paginatedOrders.sort((prev, next) => prev.status!
            .compareTo(next.status!)); // Sorting status ids in ascending order
      onSuccess!(_paginatedOrders, response.data['next']);
    } catch (error) {
      log.v('ERROR on api/paginatedorder:$error');
      rethrow;
    }
  }

  Future<void> cancelOrder(
    int orderId,
    Function()? onSuccess,
    Function()? onFail,
  ) async {
    try {
      Response response = await _apiRoot.dio.patch(
        'api/order/$orderId/',
        data: FormData.fromMap({'status': 0}),
      );
      log.v('RESPONSE: api/order/$orderId/ => ${response.data}');

      if (response.data != null &&
          (response.statusCode == 200 || response.statusCode == 201))
        onSuccess!();
      else
        onFail!();
    } on DioError catch (error) {
      log.v('ERROR api/order/$orderId/ with RESPONSE: ${error.response}');
      onFail!();
      rethrow;
    }
  }

  Future<void> deleteOrder(
    int orderId,
    Function()? onSuccess,
    Function()? onFail,
  ) async {
    // try {
    //   Response response =
    //       await _apiRoot.dio.delete('api/order/$orderId/');
    //   log.v('RESPONSE: api/order/$orderId/ => ${response.statusCode}');

    //   if (response.data != null && response.statusCode == 204)
    //     onSuccess!();
    //   else
    //     onFail!();
    // } on DioError catch (error) {
    //   log.v('ERROR on api/order/$orderId/: ${error.response}');
    //   onFail!();
    //   rethrow;
    // }

    //* CHANGED order from DELETE to PATCH in order to BACKUP online payments in DJANGO admin panel
    try {
      Response response = await _apiRoot.dio.patch(
        'api/order/$orderId/',
        data: FormData.fromMap({'status': 5}),
      );
      log.v('RESPONSE: api/order/$orderId/ => ${response.data}');

      if (response.data != null &&
          (response.statusCode == 200 || response.statusCode == 201))
        onSuccess!();
      else
        onFail!();
    } on DioError catch (error) {
      log.v('ERROR api/order/$orderId/ with RESPONSE: ${error.response}');
      onFail!();
      rethrow;
    }
  }

  //* ------------------ ORDERS End ---------------------//

  //* ------------------ ONLINE PAYMENT Start ---------------------//

  //* CREATES BANK ORDER from backend STEP 1
  Future<void> createBankOrder(
    HiveCreditCard hiveCreditCard,
    String cvcCode,
    Order order,
    CreateBankOrderEnum createBankOrderEnum,
    int onlineRetryCounter,
    Function(OrderPaymentCreateBankOrder) onSuccess,
    Function(CreateBankOrderEnum) onFail,
  ) async {
    log.v(
        'createBankOrder() createBankOrderEnum: $createBankOrderEnum, onlineRetryCounter: $onlineRetryCounter');

    Map<String, dynamic> _queryParams = {};
    _queryParams['userName'] = '101211004240';
    _queryParams['password'] = 'Ver43k764ghwS2H';
    if (createBankOrderEnum == CreateBankOrderEnum.reorderFail)
      _queryParams['orderNumber'] = '${order.orderNumber}-$onlineRetryCounter';
    else
      _queryParams['orderNumber'] = order.orderNumber;

    //* ======= AMOUNT part START ======= //

    num _totalOrderSum = order.totPrice!;
    if (order.promocode != null) {
      if (order.promocode!.promoType == 1)
        _totalOrderSum -= order.promocode!.discount!;
      else
        _totalOrderSum = order.totPrice! -
            (order.totPrice! / 100) * order.promocode!.discount!;
    }
    if (order.dostawkaPrice != null) _totalOrderSum += order.dostawkaPrice!;

    _totalOrderSum *= 100; //* CONVERTS real value to make it acceptable by bank
    _queryParams['amount'] = _totalOrderSum.toInt();

    //* ======= AMOUNT part END ======= //

    _queryParams['returnUrl'] = 'https://mpi.gov.tm/payment/finish.html';
    _queryParams['failUrl'] = 'https://mpi.gov.tm/payment/finish.html';
    _queryParams['description'] = 'Yoda Restoran: ${order.restaurant!.name}';
    _queryParams['currency'] = 934;
    _queryParams['language'] = 'ru';
    _queryParams['pageView'] = 'DESKTOP';
    _queryParams['clientId'] = _currentUser!.id;

    //* User card Info
    _queryParams['\$PAN'] =
        int.parse(hiveCreditCard.cardNumber.replaceAll(' ', ''));
    _queryParams['\$CVC'] = int.parse(cvcCode);

    var splittedExpiryDate = hiveCreditCard.expiryDate.split('/');
    _queryParams['YYYY'] = int.parse('20${splittedExpiryDate[1]}');
    _queryParams['MM'] = int.parse(splittedExpiryDate[0]);
    _queryParams['TEXT'] = hiveCreditCard.cardHolderName;

    log.v('_queryParams at the END: $_queryParams');

    try {
      Response response = await _apiRoot.dio.post(
        'api/createBankOrder/',
        queryParameters: _queryParams,
      );
      if (response.data != null && response.statusCode == 200) {
        log.v('SUCCESS RESPONSE: createBankOrder => ${response.data}');

        //* CONVERTS JSON into DART MODEL
        OrderPaymentCreateBankOrder? _paymentCreateBankOrder;
        _paymentCreateBankOrder =
            OrderPaymentCreateBankOrder.fromJson(response.data);

        //* if SUCCESS
        onSuccess(_paymentCreateBankOrder);
      } else

        //* if FAIL
        onFail(CreateBankOrderEnum.fail);
    } on DioError catch (error) {
      log.v('ERROR on createBankOrder => ${error.response}');
      log.v('ERROR on createBankOrder error.response?.data ?? '
          ' => ${error.response?.data ?? ''}');

      var errorData = error.response?.data;
      if (errorData != null) {
        log.v('ERROR on errorData => $errorData');
        //* CONVERTS JSON into DART MODEL
        OrderPaymentCreateBankOrder? _paymentCreateBankOrder;
        _paymentCreateBankOrder =
            OrderPaymentCreateBankOrder.fromJson(errorData);
        log.v(
            'ERROR on errorData _paymentCreateBankOrder => ${_paymentCreateBankOrder.toString()}');

        if (_paymentCreateBankOrder.errorCode == '1' &&
            _paymentCreateBankOrder.errorMessage ==
                'Заказ с таким номером уже обработан') {
          //* if reorderFail FAIL
          onFail(CreateBankOrderEnum.reorderFail);
        } else if (_paymentCreateBankOrder.errorCode == 1 &&
            _paymentCreateBankOrder.errorMessage ==
                'Неизвестная платёжная система<br>')
          //* if wrongCardInfoFail FAIL
          onFail(CreateBankOrderEnum.wrongCardInfoFail);
        else
          //* if other FAIL
          onFail(CreateBankOrderEnum.fail);
      } else
        //* if FAIL
        onFail(CreateBankOrderEnum.fail);
      rethrow;
    }
  }

  //* VERIFIES OTP ORDER PAYMENT STEP 2
  Future<void> verifyOtpOrderPayment(
    String requestId,
    int smsCode,
    Function(String) onSuccess,
    Function(int) onFail,
  ) async {
    Map<String, dynamic> _queryParams = {};

    _queryParams['authForm'] = 'authForm';
    _queryParams['request_id'] = requestId;
    _queryParams['pwdInputVisible'] = smsCode;
    _queryParams['submitPasswordButton'] = 'Submit';

    log.v('_queryParams at the END: $_queryParams');

    try {
      //*----------- DIO PART START -------------//
      Dio dio = Dio();

      //*----------- DIO BASE URL -------------//
      dio.options.baseUrl =
          'https://acs.gov.tm/acs/pages/enrollment/authentication.jsf';
      dio.options.contentType = Headers.formUrlEncodedContentType;

      //*----------- DIO INTERCEPTORS -------------//
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            // Do something before request is sent
            log.i(
                'REQUEST[${options.method}] => BASE URL:${options.baseUrl}?${options.queryParameters} OR FORM DATA:${options.data}');
            return handler.next(options); //continue
            // If you want to resolve the request with some custom data，
            // you can resolve a `Response` object eg: `handler.resolve(response)`.
            // If you want to reject the request with a error message,f
            // you can reject a `DioError` object eg: `handler.reject(dioError)`
          },
          onResponse: (response, handler) {
            // Do something with response data
            return handler.next(response); // continue
            // If you want to reject the request with a error message,
            // you can reject a `DioError` object eg: `handler.reject(dioError)`
          },
          onError: (DioError e, handler) {
            // Do something with response error
            return handler.next(e); //continue
            // If you want to resolve the request with some custom data，
            // you can resolve a `Response` object eg: `handler.resolve(response)`.
          },
        ),
      );
      //*----------- DIO PART END -------------//
      Response response = await dio.post(
        '',
        queryParameters: _queryParams,
      );

      if (response.data != null && response.statusCode == 200) {
        // log.v(
        //     'SUCCESS RESPONSE: verifyOtpOrderPayment => response.statusCode: ${response.statusCode}');
        // log.v('SUCCESS RESPONSE: verifyOtpOrderPayment => ${response.data}');

        //* Step 1. Parses the HTML string into a Document object
        Document document = parse(response.data);
        log.v(
            'SUCCESS RESPONSE: verifyOtpOrderPayment HTML BODY INNER ELEMENT => ${document.body!.innerHtml}');

        //* Step 2. EXECUTES query on the input element with the name "PaRes". If it is FOUND, it EXECUTES next query. If it is NOT FOUND, it throws StateError
        try {
          //* Finds the input element with the name "PaRes".
          final paresElements =
              document.querySelectorAll('input[name="PaRes"]');

          //* Gets the value of the input element.
          final paresElementValue =
              paresElements.first.attributes['value'] ?? '';
          //* Prints the value.
          // print('PaRes\'s value paresElementValue: $paresElementValue');

          //* Step 3. If "PaRes" element FOUND, it EXECUTES next query on "operationCancelledMessage" element. If it is FOUND, it gives FAIL. If it is NOT FOUND, it gives SUCCESS.
          try {
            // //* PRINTS operationCancelledMessage method 1
            //   //* Find the element with the "operationCancelledMessage" class
            //   var operationCancelledMessageElement1 = document
            //       .getElementsByClassName('operationCancelledMessage')
            //       .first;
            //   //* Get the text content of the element
            //   String operationCancelledMessage1 =
            //       operationCancelledMessageElement1.text;
            // //* Print the error message
            // print(
            //     'operationCancelledMessage1: $operationCancelledMessage1'); // Output: "Operation cancelled"

            //* PRINTS operationCancelledMessage method 2
            //* Find the element with the "operationCancelledMessage" class
            var operationCancelledMessageElement2 =
                document.querySelector('.operationCancelledMessage');

            //* Step 3.1. If "operationCancelledMessage" element is FOUND, then it is 100% FAIL
            if (operationCancelledMessageElement2 != null) {
              //* Get the text content of the element
              // String operationCancelledMessage2 =
              //     operationCancelledMessageElement2.text;
              //* Print the error message
              // print(
              //     'operationCancelledMessage2: $operationCancelledMessage2'); // Output: "Operation cancelled"

              //* if FAIL
              onFail(-1);
            } else {
              //* Step 3.2. If "operationCancelledMessage" element is NOT FOUND, then process was SUCCESS
              //* SUCCESS
              onSuccess(paresElementValue);
            }
          } on StateError catch (e) {
            //* The input element was not found.
            print('operationCancelledMessage element not found: $e');

            //* Step 3.2. If "operationCancelledMessage" element is NOT FOUND, then process was SUCCESS
            //* SUCCESS
            onSuccess(paresElementValue);
          }

          //* Step 4. If "PaRes" element is NOT FOUND, it EXECUTES next query on "errorMessage" element.
        } on StateError catch (e) {
          //* The input element was not found.
          print('PaRes element not found: $e');

          // //* PRINTS errorMessage method 1
          // //* Finds the element with the "errorMessage" class
          // var errorMessageElement1 =
          //     document.getElementsByClassName('errorMessage').first;
          // //* Gets the text content of the element
          // String errorMessage1 = errorMessageElement1.text;
          // //* Prints the error message
          // print(
          //     'errorMessage1: $errorMessage1'); //* Output: "Wrong password typed attempt 1 of 3"

          //* PRINTS errorMessage method 2
          //* Find the element with the "errorMessage" class
          var errorMessageElement2 = document.querySelector('.errorMessage');

          //* Step 4.1. If "errorMessage" element is FOUND, then it is FAIL
          if (errorMessageElement2 != null) {
            //* Gets the text content of the element
            String errorMessage2 = errorMessageElement2.text;
            errorMessage2 = errorMessage2.replaceAll(' ', '');
            // //* Prints the error message
            // print(
            //     'errorMessage2: $errorMessage2'); //* Output: "Wrong password typed attempt 1 of 3"
            // print(
            //     'errorMessage2 length: ${errorMessage2.length}'); //* Output: "Wrong password typed attempt 1 of 3"
            String? attemptCountString = errorMessage2[26];
            // print(
            //     'attemptCountString: $attemptCountString and its runType: ${attemptCountString.runtimeType}'); //* Output: attemptCount

            int attemptCountInt = 0;
            try {
              attemptCountInt = int.parse(attemptCountString);
            } catch (e) {
              // print('FormatException: Invalid number');
            }

            //* if FAIL
            onFail(attemptCountInt);
          }
        }
      } else

        //* if FAIL
        onFail(0);
    } on DioError catch (error) {
      log.v('ERROR on verifyOtpOrderPayment => ${error.response}');
      onFail(0);
      rethrow;
    }
  }

  //** POST finish3ds  STEP 3
  Future<void> postFinish3ds(
    String orderId,
    String paResValue,
    Function() onSuccess,
    Function() onFail,
  ) async {
    Map<String, dynamic> _queryParams = {};
    _queryParams['MD'] = orderId;
    _queryParams['PaRes'] = paResValue;

    log.v('_queryParams at the END: $_queryParams');

    try {
      //* ----------- DIO PART START -------------//
      Dio dio = Dio();

      //* ----------- DIO BASE URL -------------//
      dio.options.baseUrl = 'https://mpi.gov.tm:443/payment/rest/finish3ds.do';
      dio.options.contentType = Headers.formUrlEncodedContentType;

      //* ----------- DIO INTERCEPTORS -------------//
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            // Do something before request is sent
            log.i(
                'REQUEST[${options.method}] => BASE URL:${options.baseUrl}?${options.queryParameters} OR FORM DATA:${options.data}');
            return handler.next(options); //continue
            // If you want to resolve the request with some custom data，
            // you can resolve a `Response` object eg: `handler.resolve(response)`.
            // If you want to reject the request with a error message,f
            // you can reject a `DioError` object eg: `handler.reject(dioError)`
          },
          onResponse: (response, handler) {
            // Do something with response data
            return handler.next(response); // continue
            // If you want to reject the request with a error message,
            // you can reject a `DioError` object eg: `handler.reject(dioError)`
          },
          onError: (DioError e, handler) {
            // Do something with response error
            return handler.next(e); //continue
            // If you want to resolve the request with some custom data，
            // you can resolve a `Response` object eg: `handler.resolve(response)`.
          },
        ),
      );
      //* ----------- DIO PART END -------------//

      Response response = await dio.post(
        '',
        queryParameters: _queryParams,
      );

      log.v('SUCCESS RESPONSE: postFinish3ds => ${response.data}');
      log.v(
          'SUCCESS RESPONSE: postFinish3ds => response.statusCode: ${response.statusCode}');

      if (response.data != null &&
          (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 302)) {
        //* SUCCESS
        onSuccess();
      } else {
        //* FAIL
        onFail();
      }
    } on DioError catch (error) {
      if (error.response?.statusCode == 200 ||
          error.response?.statusCode == 201 ||
          error.response?.statusCode == 302) {
        //* SUCCESS
        onSuccess();
      } else {
        log.v('ERROR on postFinish3ds => ${error.response}');
        //* FAIL
        onFail();
      }
      rethrow;
    }
  }

  //** CHECKS ONLINE PAYMENT ORDER STATUS EXTENDED STEP 4
  Future<void> checkOnlinePaymentOrderStatusExtended(
    String orderId,
    Function() onSuccess,
    Function(SmsErrorEnum) onFail,
  ) async {
    Map<String, dynamic> _queryParams = {};
    _queryParams['userName'] = '101211004240';
    _queryParams['password'] = 'Ver43k764ghwS2H';
    _queryParams['orderId'] = orderId;
    _queryParams['language'] = 'ru';

    log.v('_queryParams at the END: $_queryParams');
    final FormData onlinePaymentOrderStatusFormData =
        FormData.fromMap(_queryParams);

    try {
      //*----------- DIO PART START -------------//
      Dio dio = Dio();

      //*----------- DIO BASE URL -------------//
      dio.options.baseUrl =
          'https://mpi.gov.tm/payment/rest/getOrderStatusExtended.do';

      //*----------- DIO INTERCEPTORS -------------//
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            // Do something before request is sent
            log.v(
                'REQUEST[${options.method}] => BASE URL:${options.baseUrl}?${options.queryParameters} OR FORM DATA:${options.data}');
            return handler.next(options); //continue
            // If you want to resolve the request with some custom data，
            // you can resolve a `Response` object eg: `handler.resolve(response)`.
            // If you want to reject the request with a error message,f
            // you can reject a `DioError` object eg: `handler.reject(dioError)`
          },
          onResponse: (response, handler) {
            // Do something with response data
            return handler.next(response); // continue
            // If you want to reject the request with a error message,
            // you can reject a `DioError` object eg: `handler.reject(dioError)`
          },
          onError: (DioError e, handler) {
            // Do something with response error
            return handler.next(e); //continue
            // If you want to resolve the request with some custom data，
            // you can resolve a `Response` object eg: `handler.resolve(response)`.
          },
        ),
      );
      //*----------- DIO PART END -------------//

      Response response = await dio.post(
        '',
        data: onlinePaymentOrderStatusFormData,
      );
      if (response.data != null && response.statusCode == 200) {
        log.v(
            'SUCCESS RESPONSE: checkOnlinePaymentOrderStatusExtended => ${response.data}');

        //* PARSES the string and returns the resulting Json object
        final _decodedResponse = jsonDecode(response.data);

        //* CONVERTS JSON into DART MODEL
        OrderPaymentCheckStatus? _orderPaymentCheckStatus;
        _orderPaymentCheckStatus =
            OrderPaymentCheckStatus.fromJson(_decodedResponse);

        //* if SUCCESS
        if (_orderPaymentCheckStatus.orderStatus == 2 &&
            _orderPaymentCheckStatus.actionCode == 0)
          onSuccess();

        //* if CVC FAIL after SUCCESS
        else if (_orderPaymentCheckStatus.orderStatus == 6 &&
            _orderPaymentCheckStatus.actionCode == 5)
          onFail(SmsErrorEnum.cvcFail);

        //* if NOT ENOUGH MONEY FAIL after SUCCESS
        else if (_orderPaymentCheckStatus.orderStatus == 6 &&
            _orderPaymentCheckStatus.actionCode == 116)
          onFail(SmsErrorEnum.notEnoughFail);

        //* if FAIL
        else
          onFail(SmsErrorEnum.fail);
      }
    } on DioError catch (error) {
      log.v(
          'ERROR on checkOnlinePaymentOrderStatusExtended => ${error.response}');
      onFail(SmsErrorEnum.fail);
      rethrow;
    }
  }

  Future<void> patchOrderToPaid(
    int orderId,
    Function()? onSuccess,
    Function()? onFail,
  ) async {
    try {
      Response response = await _apiRoot.dio.patch(
        'api/order/$orderId/',
        data: FormData.fromMap({'paid': true}),
      );
      log.v(
          'SUCCESS RESPONSE patchOrderToPaid => api/order/$orderId/ => ${response.data}');

      if (response.data != null &&
          (response.statusCode == 200 || response.statusCode == 201))
        onSuccess!();
      else
        onFail!();
    } on DioError catch (error) {
      log.v(
          'ERROR patchOrderToPaid => api/order/$orderId/ with RESPONSE: ${error.response}');
      onFail!();
      rethrow;
    }
  }

  Future<void> patchOrderOnlineToCash(
    int orderId,
    Function()? onSuccess,
    Function()? onFail,
  ) async {
    try {
      Response response = await _apiRoot.dio.patch(
        'api/order/$orderId/',
        data: FormData.fromMap({'paymentType': 3}),
      );
      log.v(
          'SUCCESS RESPONSE patchOrderOnlineToCash => api/order/$orderId/ => ${response.data}');

      if (response.data != null &&
          (response.statusCode == 200 || response.statusCode == 201))
        onSuccess!();
      else
        onFail!();
    } on DioError catch (error) {
      log.v(
          'ERROR patchOrderOnlineToCash => api/order/$orderId/ with RESPONSE: ${error.response}');
      onFail!();
      rethrow;
    }
  }

  //* ------------------ ONLINE PAYMENT End ---------------------//

  //* ------------------ USER FAVORITES START ---------------------//
  Future<void> patchUserFavs(
    int resId,
    bool isTempFavourited,
    Function()? onFail,
  ) async {
    if (_currentUser!.favs.contains(resId))
      _currentUser?.favs.remove(resId);
    else
      _currentUser?.favs.add(resId);

    final _formData = FormData.fromMap({'favourites': _currentUser!.favs});

    log.v(
        'BEFORE fav patch _currentUser?.favs! with result: ${_currentUser?.favs} and ${_formData.fields}');
    try {
      Response response = await _apiRoot.dio.patch(
        'api/user/${_currentUser!.id}/',
        data: _currentUser!.favs.isNotEmpty
            ? _formData
            : <String, dynamic>{'favourites': []},
      );
      log.v(
          'RESPONSE: api/user/${_currentUser!.id}/ with favs: ${_currentUser?.favs ?? []} => ${response.data}');

      if (response.data != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        log.v(
            'AFTER SUCCESS fav patch _currentUser?.favs!: ${_currentUser?.favs}');

        //* If success then updates local _currentUser's favs
        //* Step 2. UPDATES userModel to Hive userBox
        await userBox.put(
          Constants.userBox,
          _currentUser!,
        );

        //* Step 3. GETS hiveUser from Hive userBox
        _currentUser = userBox.get(Constants.userBox);
      } else {
        if (isTempFavourited)
          _currentUser?.favs.remove(resId);
        else
          _currentUser?.favs.add(resId);
        log.v(
            'AFTER FAIL fav patch _currentUser?.favs!: ${_currentUser?.favs}');
        onFail!();
      }
    } on DioError catch (error) {
      log.v(
          'ERROR api/user/${_currentUser!.id}/ with RESPONSE: ${error.response}');
      if (isTempFavourited)
        _currentUser?.favs.remove(resId);
      else
        _currentUser?.favs.add(resId);
      log.v('AFTER FAIL fav patch _currentUser?.favs!: ${_currentUser?.favs}');
      onFail!();
      rethrow;
    }
  }

  Future<void> addRestaurantToFav(int resId) async {
    //* ADDS id of current res to favoritesBox
    favoritesBox.put(
      resId, //* Unique hive id for this object
      resId,
    );

    log.v(
        'BEFORE addRestaurantToFav() PATCH favoritesBox.values.toList() with result: ${favoritesBox.values.toList()}');

    final _formData =
        FormData.fromMap({'favourites': favoritesBox.values.toList()});

    try {
      Response response = await _apiRoot.dio.patch(
        'api/user/${_currentUser!.id}/',
        data: favoritesBox.values.isNotEmpty
            ? _formData
            : <String, dynamic>{'favourites': []},
      );
      log.v(
          'RESPONSE: api/user/${_currentUser!.id}/ with favoritesBox.values.toList(): ${favoritesBox.values.toList()} => ${response.data}');

      if (response.data != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        log.v(
            'AFTER SUCCESS addRestaurantToFav() PATCH favoritesBox.values.toList(): ${favoritesBox.values.toList()}');
      } else {
        //* If server FAILS, DELETE current res id from favoritesBox
        await favoritesBox.delete(resId);
        log.v(
            'AFTER FAIL addRestaurantToFav() PATCH favoritesBox.values.toList(): ${favoritesBox.values.toList()}');
      }
    } on DioError catch (error) {
      log.v(
          'ERROR api/user/${_currentUser!.id}/ with RESPONSE: ${error.response}');
      //* If server FAILS, DELETE current res id from favoritesBox
      await favoritesBox.delete(resId);
      log.v(
          'AFTER FAIL addRestaurantToFav() PATCH favoritesBox.values.toList(): ${favoritesBox.values.toList()}');

      rethrow;
    }
  }

  //* ------------------ USER FAVORITES END ---------------------//

  //* ------------------ RATINGS ---------------------//

  Future<void> orderRating(
    int? orderId,
    int? restaurantId,
    double? value,
    String? feedback,
    Function()? onSuccess,
    Function()? onFail,
  ) async {
    Map<String, dynamic> _queryParams = {};
    _queryParams['order'] = orderId;
    _queryParams['restaurant'] = restaurantId;
    _queryParams['value'] = value;
    _queryParams['feedback'] = feedback;

    log.v('_queryParams at the END: $_queryParams');
    final FormData orderRatingFormData = FormData.fromMap(_queryParams);

    try {
      Response response = await _apiRoot.dio.post(
        'api/ratings/',
        data: orderRatingFormData,
      );
      log.v(
          'RESPONSE: api/ratings/ => ${response.data} and ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201)
        onSuccess!();
      else
        onFail!();
    } on DioError catch (error) {
      log.v('ERROR api/ratings/ with RESPONSE: ${error.response}');
      onFail!();
      throw DioErrorType.response;
    }
  }

  //* ------------------ CONTACT US ---------------------//

  Future<void> contactUs(
    String? name,
    String? phone,
    String? info,
    Function()? onSuccess,
    Function()? onFail,
  ) async {
    Map<String, dynamic> _queryParams = {};
    _queryParams['name'] = name;
    _queryParams['mobile'] = phone;
    _queryParams['text'] = info;

    log.v('_queryParams at the END: $_queryParams');
    final FormData userContactFormData = FormData.fromMap(_queryParams);

    try {
      Response response = await _apiRoot.dio.post(
        'api/messages/',
        data: userContactFormData,
      );
      log.v(
          'RESPONSE: api/messages/ => ${response.data} and ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201)
        onSuccess!();
      else
        onFail!();
    } on DioError catch (error) {
      log.v('ERROR api/messages/ with RESPONSE: ${error.response}');
      onFail!();
      throw DioErrorType.response;
    }
  }

  //* ------------------ ADDITIONALS APIS ---------------------//

  Future<List<AdditionalModel>> getAdditionals() async {
    List<AdditionalModel> _additionals = [];
    try {
      Response response = await _apiRoot.dio.get('api/additional/');
      log.v('RESPONSE: api/additional/ => ${response.data}');

      if (response.data != null && response.statusCode == 200) {
        for (final _additional in response.data) {
          _additionals.add(AdditionalModel.fromJson(_additional));
        }
      }

      return _additionals;
    } on DioError catch (error) {
      log.v(error);
      rethrow;
    }
  }
}
