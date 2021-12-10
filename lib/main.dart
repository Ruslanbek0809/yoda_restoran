import 'package:flutter/material.dart';
import 'package:yoda_res/yoda_res_app.dart';

import 'app/app.locator.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(YodaResApp());
}
