import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../shared/shared.dart';

class ButtonLoading extends StatelessWidget {
  final Color color;
  ButtonLoading({this.color = kcWhiteColor});
  @override
  Widget build(BuildContext context) {
    return SpinKitChasingDots(
      size: 26,
      color: color,
    );
  }
}
