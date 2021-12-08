import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked_services/stacked_services.dart';
import 'app/app.router.dart';
import 'utils/utils.dart';
import 'widgets/widgets.dart';

// final mainScaffoldKey = GlobalKey();
// final GlobalKey<NavigatorState> yodaResNavigatorKey = GlobalKey();

class YodaResApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    printLog('[YodaResAppState] BUILD');

    /// Orientation: PORTRAIT Only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
      builder: () => MaterialApp(
        title: Constants.appName,
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
            behavior: MyBehavior(), // to remove the glow effect entirely
            child: MediaQuery(
              //Setting font does not change with system font size
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child!,
            ),
          );
        },
        navigatorKey: StackedService.navigatorKey,
        onGenerateRoute: StackedRouter().onGenerateRoute,
        // routes: Routes.getAllRoutes,
        // navigatorKey: yodaResNavigatorKey,
        // onGenerateRoute: Routes.getRouteGenerate,
      ),
    );
  }
}
