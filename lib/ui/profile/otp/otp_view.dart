import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/ui/profile/otp/otp_main.dart';
import 'otp_view_model.dart';

class OtpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OtpViewModel>.nonReactive(
      builder: (context, model, child) => OtpMain(),
      viewModelBuilder: () => OtpViewModel(),
    );
  }
}
