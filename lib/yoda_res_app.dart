import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked_services/stacked_services.dart';

import 'app/app.router.dart';
import 'shared/shared.dart';
import 'ui/widgets/widgets.dart';
import 'utils/utils.dart';

class YodaResApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //* Orientation: PORTRAIT Only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    //* WORKS in every screen except the screen in which appBar are used (STATUS BAR)
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark,
      // SystemUiOverlayStyle(
      //   statusBarColor: kcPrimaryColor,
      //   statusBarIconBrightness: Brightness.dark,
      //   systemNavigationBarIconBrightness: Brightness.light,
      // ),
    );
    return ScreenUtilInit(
      minTextAdapt: true,
      builder: (context, child) => MaterialApp(
        // useInheritedMediaQuery: true, //* Config DevicePreview
        // locale: DevicePreview.locale(context), //* Config DevicePreview
        // builder: DevicePreview.appBuilder, //* Config DevicePreview
        title: Constants.appName,
        navigatorObservers: [StackedService.routeObserver],
        navigatorKey: StackedService.navigatorKey, //* Stacked_services config
        onGenerateRoute: StackedRouter()
            .onGenerateRoute, //* Auto generates all routes using stacked package
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale, //* Config DevicePreview
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: kcPrimaryColor,
          scaffoldBackgroundColor: kcWhiteColor,
          splashColor: kcSecondaryLightColor,
          fontFamily: 'Segoe',
          appBarTheme: AppBarTheme(elevation: 0),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: kcPrimaryColor,
          scaffoldBackgroundColor: kcWhiteColor,
          splashColor: kcSecondaryLightColor,
          fontFamily: 'Segoe',
          appBarTheme: AppBarTheme(elevation: 0),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        builder: (context, child) {
          //*A widget that unfocus everything when tapped.
          return UnfocusWidget(
            child: ScrollConfiguration(
              behavior: MyBehavior(), // To remove the glow effect entirely
              child: MediaQuery(
                //* Setting font does not change with system font size
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: child!,
              ),
            ),
          );
        }, //* Config DevicePreview
      ),
    );
  }
}
