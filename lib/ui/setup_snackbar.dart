import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked_services/stacked_services.dart';
import '../app/app.locator.dart';
import '../utils/utils.dart';

void setupSnackbar() {
  final service = locator<SnackbarService>();

  service.registerCustomSnackbarConfig(
    variant: SnackBarType.restaurantDetailsError,
    config: SnackbarConfig(
      backgroundColor: Colors.blueAccent,
      textColor: Colors.yellow,
      borderRadius: 1,
      icon: SvgPicture.asset(
        'assets/warning.svg',
        // width: 20,
        // height: 20,
      ),
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 50,
      ),
      dismissDirection: DismissDirection.horizontal,
    ),
  );
}
