// import 'dart:async';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:yoda_res/utils/utils.dart';

// class AppInit extends StatefulWidget {
//   final Function onNext;

//   AppInit({
//     required this.onNext,
//   });

//   @override
//   _AppInitState createState() => _AppInitState();
// }

// class _AppInitState extends State<AppInit> {
//   bool isFirstSeen = false;

//   Future<bool> checkFirstSeen() async {
//     printLog('Method: checkFirstSeen');
//     var prefs = await SharedPreferences.getInstance();
//     var _seen = prefs.getBool(Constants.isSeenIntro) ?? false;
//     return _seen;
//   }

//   // Future<void> initCurrentLang() async {
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   final String? currentLangCode = prefs.getString(Constants.currentLang);

//   //   // // Language has not set before, set default lang "tm"
//   //   // if (currentLangCode == null) {
//   //   //   Provider.of<LangProvider>(context, listen: false).setLang(MyConstants.tm);
//   //   // } else {
//   //   //   Provider.of<LangProvider>(context, listen: false)
//   //   //       .setLang(currentLangCode);
//   //   // }
//   // }

//   Future<void> _initFunc() async {
//     printLog('[AppInit] initFunc() START');

//     isFirstSeen = await checkFirstSeen();

//     // _initCurrentLang();

//     /// You can use provider here

//     printLog('[AppState] initFunc() END');
//   }

//   Widget? onNextScreen(bool isFirstSeen) {
//     // if (!isFirstSeen) return OnBoardScreen();

//     return widget.onNext();
//   }

//   void goToNextScreen() {
//     Navigator.of(context).pushReplacement(CupertinoPageRoute(
//         builder: (BuildContext context) => onNextScreen(isFirstSeen)!));
//   }

//   @override
//   void initState() {
//     super.initState();
//     _initFunc();
//   }

//   @override
//   Widget build(BuildContext context) {
//     printLog('[AppInit] BUILD');
//     return StaticSplashScreen(
//       onNextScreen: goToNextScreen,
//     );
//   }
// }
