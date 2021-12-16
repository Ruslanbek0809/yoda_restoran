// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import '../models/models.dart';
import '../ui/home/home_view.dart';
import '../ui/profile/address_add_edit/address_add_edit_view.dart';
import '../ui/profile/login/login_view.dart';
import '../ui/restaurant/restaurant_details/restaurant_details_view.dart';
import '../ui/restaurant/restaurant_search/restaurant_search_vew.dart';
import '../ui/startup/startup_view.dart';

class Routes {
  static const String startUpView = '/';
  static const String homeView = '/home-view';
  static const String restaurantDetailsView = '/restaurant-details-view';
  static const String restaurantSearchView = '/restaurant-search-view';
  static const String loginView = '/login-view';
  static const String otpView = '/otp-view';
  static const all = <String>{
    startUpView,
    homeView,
    restaurantDetailsView,
    restaurantSearchView,
    loginView,
    otpView,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.startUpView, page: StartUpView),
    RouteDef(Routes.homeView, page: HomeView),
    RouteDef(Routes.restaurantDetailsView, page: RestaurantDetailsView),
    RouteDef(Routes.restaurantSearchView, page: RestaurantSearchView),
    RouteDef(Routes.loginView, page: LoginView),
    RouteDef(Routes.otpView, page: OtpView),
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
    RestaurantDetailsView: (data) {
      var args = data.getArgs<RestaurantDetailsViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => RestaurantDetailsView(
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
      return MaterialPageRoute<dynamic>(
        builder: (context) => LoginView(),
        settings: data,
      );
    },
    OtpView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const OtpView(),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// RestaurantDetailsView arguments holder class
class RestaurantDetailsViewArguments {
  final Restaurant restaurant;
  final Key? key;
  RestaurantDetailsViewArguments({required this.restaurant, this.key});
}

/// RestaurantSearchView arguments holder class
class RestaurantSearchViewArguments {
  final AnimationController bottomCartController;
  RestaurantSearchViewArguments({required this.bottomCartController});
}
