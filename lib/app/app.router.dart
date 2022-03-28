// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/ui/home/home_exclusives/single_ex_view.dart';
import '../models/models.dart';
import '../ui/cart/cart_view.dart';
import '../ui/cart/order/order_success_view.dart';
import '../ui/cart/order/orders_view.dart';
import '../ui/drawer/about_us/about_us_view.dart';
import '../ui/drawer/addresses/addresses.dart';
import '../ui/drawer/contact_us/contact_us_view.dart';
import '../ui/drawer/login/login_view.dart';
import '../ui/drawer/otp/otp_view.dart';
import '../ui/drawer/profile/profile_view.dart';
import '../ui/home/home_search/home_search_view.dart';
import '../ui/home/home_view.dart';
import '../ui/home/slider/slider_webview.dart';
import '../ui/restaurant/restaurant_details/res_details_view.dart';
import '../ui/restaurant/restaurant_search/restaurant_search_view.dart';
import '../ui/startup/onboarding/onboarding_view.dart';
import '../ui/startup/startup_view.dart';
import 'custom_material_page_route.dart';

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
  static const String addressAddView = '/address-add-view';
  static const String addressEditView = '/address-edit-view';
  static const String homeSearchView = '/home-search-view';
  static const String contactUsView = '/contact-us-view';
  static const String aboutUsView = '/about-us-view';
  static const String onBoardingView = '/on-boarding-view';
  static const String singleExView = '/single-ex-view';
  static const String sliderWebview = '/slider-webview';
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
    addressAddView,
    addressEditView,
    homeSearchView,
    contactUsView,
    aboutUsView,
    onBoardingView,
    singleExView,
    sliderWebview,
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
    RouteDef(Routes.addressAddView, page: AddressAddView),
    RouteDef(Routes.addressEditView, page: AddressEditView),
    RouteDef(Routes.homeSearchView, page: HomeSearchView),
    RouteDef(Routes.contactUsView, page: ContactUsView),
    RouteDef(Routes.aboutUsView, page: AboutUsView),
    RouteDef(Routes.onBoardingView, page: OnBoardingView),
    RouteDef(Routes.singleExView, page: SingleExView),
    RouteDef(Routes.sliderWebview, page: SliderWebview),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    StartUpView: (data) {
      var args = data.getArgs<StartUpViewArguments>(
        orElse: () => StartUpViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => StartUpView(key: args.key),
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
      return CustomMaterialPageRoute(
        builder: (context) => RestaurantSearchView(
          restaurant: args.restaurant,
          key: args.key,
        ),
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
          phone: args.phone,
          key: args.key,
        ),
        settings: data,
      );
    },
    CartView: (data) {
      return CustomMaterialPageRoute(
        builder: (context) => const CartView(),
        settings: data,
      );
    },
    OrdersView: (data) {
      return CustomMaterialPageRoute(
        builder: (context) => OrdersView(),
        settings: data,
      );
    },
    OrderSuccessView: (data) {
      return CustomMaterialPageRoute(
        builder: (context) => const OrderSuccessView(),
        settings: data,
      );
    },
    ProfileView: (data) {
      var args = data.getArgs<ProfileViewArguments>(
        orElse: () => ProfileViewArguments(),
      );
      return CustomMaterialPageRoute(
        builder: (context) => ProfileView(key: args.key),
        settings: data,
      );
    },
    AddressesView: (data) {
      return CustomMaterialPageRoute(
        builder: (context) => const AddressesView(),
        settings: data,
      );
    },
    AddressAddView: (data) {
      var args = data.getArgs<AddressAddViewArguments>(
        orElse: () => AddressAddViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => AddressAddView(key: args.key),
        settings: data,
      );
    },
    AddressEditView: (data) {
      var args = data.getArgs<AddressEditViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => AddressEditView(
          address: args.address,
          addressesViewModel: args.addressesViewModel,
          key: args.key,
        ),
        settings: data,
      );
    },
    HomeSearchView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => HomeSearchView(),
        settings: data,
      );
    },
    ContactUsView: (data) {
      return CustomMaterialPageRoute(
        builder: (context) => ContactUsView(),
        settings: data,
      );
    },
    AboutUsView: (data) {
      return CustomMaterialPageRoute(
        builder: (context) => const AboutUsView(),
        settings: data,
      );
    },
    OnBoardingView: (data) {
      var args = data.getArgs<OnBoardingViewArguments>(
        orElse: () => OnBoardingViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => OnBoardingView(key: args.key),
        settings: data,
      );
    },
    SingleExView: (data) {
      var args = data.getArgs<SingleExViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => SingleExView(
          singleEx: args.singleEx,
          key: args.key,
        ),
        settings: data,
      );
    },
    SliderWebview: (data) {
      var args = data.getArgs<SliderWebviewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => SliderWebview(
          sliderUrl: args.sliderUrl,
          key: args.key,
        ),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// StartUpView arguments holder class
class StartUpViewArguments {
  final Key? key;
  StartUpViewArguments({this.key});
}

/// ResDetailsView arguments holder class
class ResDetailsViewArguments {
  final Restaurant restaurant;
  final Key? key;
  ResDetailsViewArguments({required this.restaurant, this.key});
}

/// RestaurantSearchView arguments holder class
class RestaurantSearchViewArguments {
  final Restaurant restaurant;
  final Key? key;
  RestaurantSearchViewArguments({required this.restaurant, this.key});
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
  final String phone;
  final Key? key;
  OtpViewArguments({required this.isCartView, required this.phone, this.key});
}

/// ProfileView arguments holder class
class ProfileViewArguments {
  final Key? key;
  ProfileViewArguments({this.key});
}

/// AddressAddView arguments holder class
class AddressAddViewArguments {
  final Key? key;
  AddressAddViewArguments({this.key});
}

/// AddressEditView arguments holder class
class AddressEditViewArguments {
  final Address address;
  final AddressesViewModel addressesViewModel;
  final Key? key;
  AddressEditViewArguments({
    required this.address,
    required this.addressesViewModel,
    this.key,
  });
}

/// OnBoardingView arguments holder class
class OnBoardingViewArguments {
  final Key? key;
  OnBoardingViewArguments({this.key});
}

class SingleExViewArguments {
  final ExclusiveSingle singleEx;
  final Key? key;
  SingleExViewArguments({required this.singleEx, this.key});
}

/// SliderWebview arguments holder class
class SliderWebviewArguments {
  final String sliderUrl;
  final Key? key;
  SliderWebviewArguments({required this.sliderUrl, this.key});
}
