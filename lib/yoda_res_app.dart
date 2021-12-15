import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked_services/stacked_services.dart';
import 'app/app.router.dart';
import 'ui/widgets/widgets.dart';
import 'utils/utils.dart';

// final mainScaffoldKey = GlobalKey();
// final GlobalKey<NavigatorState> yodaResNavigatorKey = GlobalKey();

class YodaResApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// Orientation: PORTRAIT Only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
      builder: () => MaterialApp(
        title: Constants.appName,
        navigatorObservers: [StackedService.routeObserver],
        navigatorKey: StackedService.navigatorKey, // For stacked_services

        onGenerateRoute: StackedRouter()
            .onGenerateRoute, // Auto generates all routes using stacked package

        // routes: Routes.getAllRoutes,
        // navigatorKey: yodaResNavigatorKey,
        // onGenerateRoute: Routes.getRouteGenerate,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en'),
          const Locale('tk'),
          const Locale('ru'),
        ],
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: AppTheme.MAIN,
          scaffoldBackgroundColor: AppTheme.WHITE,
          splashColor: AppTheme.MAIN_LIGHT,
          appBarTheme: AppBarTheme(
            elevation: 0,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: AppTheme.MAIN,
          scaffoldBackgroundColor: AppTheme.WHITE,
          splashColor: AppTheme.MAIN_LIGHT,
          appBarTheme: AppBarTheme(
            elevation: 0,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: MyBehavior(), // To remove the glow effect entirely
            child: MediaQuery(
              //Setting font does not change with system font size
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child!,
            ),
          );
        },
      ),
    );
  }
}
