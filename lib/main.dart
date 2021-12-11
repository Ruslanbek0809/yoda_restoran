import 'package:flutter/material.dart';
import 'package:yoda_res/yoda_res_app.dart';

import 'app/app.locator.dart';
import 'ui/setup_bottom_sheet.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  setupBottomSheet();
  runApp(YodaResApp());
}
