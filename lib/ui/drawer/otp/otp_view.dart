import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'otp_main.dart';
import 'otp_view_model.dart';

class OtpView extends StatelessWidget {
  final bool isCartView;
  OtpView({required this.isCartView, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OtpViewModel>.nonReactive(
      builder: (context, model, child) => OtpMain(),
      viewModelBuilder: () => OtpViewModel(isCartView),
    );
  }
}
