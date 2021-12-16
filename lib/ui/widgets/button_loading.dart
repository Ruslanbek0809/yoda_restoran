import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:yoda_res/utils/app_theme.dart';

class ButtonLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpinKitChasingDots(
      size: 25,
      color: AppTheme.WHITE,
    );
  }
}
