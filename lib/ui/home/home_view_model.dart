import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/app/app.logger.dart';

class HomeViewModel extends BaseViewModel {
  final log = getLogger('HomeViewModel');
  final GlobalKey<ScaffoldState> homeScaffoldKey = GlobalKey<ScaffoldState>();

  void homeMenuPressed() {
    log.i('openDrawer()');
    homeScaffoldKey.currentState!.openDrawer();
  }
}
