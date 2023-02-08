import 'package:flutter/material.dart';
import 'dart:io';
import '../../shared/shared.dart';

class CustomBackButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: Icon(
        Platform.isIOS
            ? Icons.arrow_back_ios_new_rounded
            : Icons.arrow_back_rounded,
        color: kcSecondaryDarkColor,
      ),
    );
  }
}
