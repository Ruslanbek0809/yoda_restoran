// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import '../models/models.dart';
import '../ui/cart/cart_view.dart';
import '../ui/cart/order/order_success_view.dart';
import '../ui/cart/order/orders_view.dart';
import '../ui/home/home_view.dart';
import '../ui/profile/address_add_edit/address_add_edit_view.dart';
import '../ui/profile/addresses/addresses_view.dart';
import '../ui/profile/login/login_view.dart';
import '../ui/profile/otp/otp_view.dart';
import '../ui/profile/profile_view.dart';
import '../ui/restaurant/restaurant_details/res_details_view.dart';
import '../ui/restaurant/restaurant_search/restaurant_search_vew.dart';
import '../ui/startup/startup_view.dart';

class Routes {
  static const String startUpView = '/';
  static const String homeView = '/home-view';
  static const String resDetailsView = '/res-details-view';
  static const String restaurantSearchView = '/restaurant-search-view';
  static const String loginView = '/login-view';
  static const String otpView = '/otp-view';
  static const String cartView = '/cart-view';
  static const String ordersView = '/orders-view';
  static const String orderSuccessView = '/order-success-view';
  static const String profileView = '/profile-view';
  static const String addressesView = '/addresses-view';
  static const String addressAddEditView = '/address-add-edit-view';
  static const all = <String>{
    startUpView,
    homeView,
    resDetailsView,
    restaurantSearchView,
    loginView,
    otpView,
    cartView,
    ordersView,
    orderSuccessView,
    profileView,
    addressesView,
    addressAddEditView,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.startUpView, page: StartUpView),
    RouteDef(Routes.homeView, page: HomeView),
    RouteDef(Routes.resDetailsView, page: ResDetailsView),
    RouteDef(Routes.restaurantSearchView, page: RestaurantSearchView),
    RouteDef(Routes.loginView, page: LoginView),
    RouteDef(Routes.otpView, page: OtpView),
    RouteDef(Routes.cartView, page: CartView),
    RouteDef(Routes.ordersView, page: OrdersView),
    RouteDef(Routes.orderSuccessView, page: OrderSuccessView),
    RouteDef(Routes.profileView, page: ProfileView),
    RouteDef(Routes.addressesView, page: AddressesView),
    RouteDef(Routes.addressAddEditView, page: AddressAddEditView),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    StartUpView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const StartUpView(),
        settings: data,
      );
    },
    HomeView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => HomeView(),
        settings: data,
      );
    },
    ResDetailsView: (data) {
      var args = data.getArgs<ResDetailsViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => ResDetailsView(
          restaurant: args.restaurant,
          key: args.key,
        ),
        settings: data,
      );
    },
    RestaurantSearchView: (data) {
      var args = data.getArgs<RestaurantSearchViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => RestaurantSearchView(
            bottomCartController: args.bottomCartController),
        settings: data,
      );
    },
    LoginView: (data) {
      var args = data.getArgs<LoginViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => LoginView(
          isCartView: args.isCartView,
          key: args.key,
        ),
        settings: data,
      );
    },
    OtpView: (data) {
      var args = data.getArgs<OtpViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => OtpView(
          isCartView: args.isCartView,
          key: args.key,
        ),
        settings: data,
      );
    },
    CartView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const CartView(),
        settings: data,
      );
    },
    OrdersView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => OrdersView(),
        settings: data,
      );
    },
    OrderSuccessView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const OrderSuccessView(),
        settings: data,
      );
    },
    ProfileView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const ProfileView(),
        settings: data,
      );
    },
    AddressesView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const AddressesView(),
        settings: data,
      );
    },
    AddressAddEditView: (data) {
      var args = data.getArgs<AddressAddEditViewArguments>(
        orElse: () => AddressAddEditViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => AddressAddEditView(key: args.key),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// ResDetailsView arguments holder class
class ResDetailsViewArguments {
  final Restaurant restaurant;
  final Key? key;
  ResDetailsViewArguments({required this.restaurant, this.key});
}

/// RestaurantSearchView arguments holder class
class RestaurantSearchViewArguments {
  final AnimationController bottomCartController;
  RestaurantSearchViewArguments({required this.bottomCartController});
}

/// LoginView arguments holder class
class LoginViewArguments {
  final bool isCartView;
  final Key? key;
  LoginViewArguments({required this.isCartView, this.key});
}

/// OtpView arguments holder class
class OtpViewArguments {
  final bool isCartView;
  final Key? key;
  OtpViewArguments({required this.isCartView, this.key});
}

/// AddressAddEditView arguments holder class
class AddressAddEditViewArguments {
  final Key? key;
  AddressAddEditViewArguments({this.key});
}
