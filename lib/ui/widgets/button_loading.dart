import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../shared/shared.dart';

class ButtonLoading extends StatelessWidget {
  final Color color;
  final double fontSize;
  ButtonLoading({this.color = kcWhiteColor, this.fontSize = 26});
  @override
  Widget build(BuildContext context) {
    return SpinKitChasingDots(
      size: fontSize,
      color: color,
    );
  }
}
