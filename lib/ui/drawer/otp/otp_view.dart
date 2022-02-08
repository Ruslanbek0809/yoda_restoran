import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'otp_main.dart';
import 'otp_view_model.dart';

class OtpView extends StatelessWidget {
  final bool isCartView;
  final String phone; // Needed for resend feature in OtpView
  OtpView({required this.isCartView, required this.phone, Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OtpViewModel>.nonReactive(
      builder: (context, model, child) => OtpMain(),
      viewModelBuilder: () => OtpViewModel(isCartView, phone),
    );
  }
}
