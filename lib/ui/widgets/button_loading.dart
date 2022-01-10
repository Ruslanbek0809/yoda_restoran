import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../shared/shared.dart';

class ButtonLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpinKitChasingDots(
      size: 23,
      color: kcWhiteColor,
    );
  }
}
