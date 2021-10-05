import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'route.dart';
import 'screens/cart/cart.dart';
import 'screens/home/home.dart';
import 'utils/utils.dart';

final mainScaffoldKey = GlobalKey();
final GlobalKey<NavigatorState> yodaResNavigatorKey = GlobalKey();

class YodaResApp extends StatefulWidget {
  YodaResApp();

  @override
  _YodaResAppState createState() => _YodaResAppState();

  // static void setLocale(BuildContext context) async {
  //   await BaseProvider.setHeaders();
  // }
}

class _YodaResAppState extends State<YodaResApp> {
  @override
  void initState() {
    printLog('[YodaResAppState] INIT');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    printLog('[YodaResAppState] BUILD');

    /// Orientation: PORTRAIT Only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
        builder: () => // MultiProvider(
            //   providers: [],
            //   child:
            MaterialApp(
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
              navigatorKey: yodaResNavigatorKey,
              theme: ThemeData(
                brightness: Brightness.light,
                primaryColor: AppTheme.MAIN,
                appBarTheme: AppBarTheme(
                  elevation: 0,
                ),
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                primaryColor: AppTheme.MAIN,
                appBarTheme: AppBarTheme(
                  elevation: 0,
                ),
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              builder: (context, widget) {
                return MediaQuery(
                  //Setting font does not change with system font size
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: widget!,
                );
              },
              home: Scaffold(
                key: mainScaffoldKey,
                body:
                    // OtpScreen(),
                    // LoginScreen(),
                    HomeScreen(),
                    // CartScreen(),
              ),
              routes: Routes.getAllRoutes,
              onGenerateRoute: Routes.getRouteGenerate,
              themeMode: ThemeMode.light,
              // theme: getTheme(context),e
            )
        // );
        );
  }
}
