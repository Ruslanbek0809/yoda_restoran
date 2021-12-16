import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:yoda_res/ui/profile/otp/otp_main.dart';
import 'otp_view.form.dart';
import 'otp_view_model.dart';

@FormView(
  fields: [
    FormTextField(name: 'otp'),
  ],
) // Needed when generating Formfields

class OtpView extends StatelessWidget with $OtpView {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OtpViewModel>.reactive(
      onModelReady: (model) =>
          listenToFormUpdated(model), // Needed when generating formFields
      builder: (context, model, child) => OtpMain(otpController: otpController),
      viewModelBuilder: () => OtpViewModel(),
    );
  }
}
