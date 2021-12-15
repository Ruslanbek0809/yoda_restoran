import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:yoda_res/shared/shared.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import 'package:yoda_res/utils/utils.dart';

import 'login_view.form.dart';
import 'login_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@FormView(fields: [
  FormTextField(name: 'phone'),
]) // Needed when generating formFields

class LoginView extends StatelessWidget with $LoginView {
  var maskFormatter = MaskTextInputFormatter(
      mask: '+993 ## ## ## ##', filter: {'#': RegExp(r'[0-9]')});

  // void _onContinueButtonPressed() async {
  //   String phone = "+993${maskFormatter.getUnmaskedText()}";
  //   // String realPhone = maskFormatter.getUnmaskedText();
  //   if (phone.length < 12) {
  //     setState(() {
  //       _validate = FormValidation.phoneInvalid;
  //     });
  //     return;
  //   }

  //   _validate = FormValidation.valid;
  //   await _playAnimation();
  //   await _stopAnimation();
  // }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      onModelReady: (model) =>
          listenToFormUpdated(model), // Needed when generating formFields
      builder: (context, model, child) => Scaffold(
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 1.sh / 2.5,
              child: SvgPicture.asset(
                'assets/yoda_restoran.svg',
                color: AppTheme.MAIN_DARK,
                width: 0.75.sw,
              ),
            ),
            Text(
              'Ulgama girmek',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22.sp,
                color: AppTheme.MAIN_DARK,
              ),
            ),
            SizedBox(height: 25.w),
            Text(
              'Telefon belgiňizi giriziň',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppTheme.DRAWER_ICON,
              ),
            ),
            verticalSpaceLarge,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: TextField(
                controller: phoneController,
                inputFormatters: [maskFormatter],
                keyboardType: TextInputType.phone,
                style: TextStyle(color: AppTheme.FONT_COLOR),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: AppTheme().radius10,
                    borderSide: BorderSide(
                      color: AppTheme.FILL_BORDER_COLOR,
                      width: 0.3,
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.phone,
                    color: AppTheme.FONT_COLOR,
                  ),
                  fillColor: AppTheme.FILL_COLOR,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppTheme().radius10,
                    borderSide: BorderSide(
                      color: AppTheme.FILL_BORDER_COLOR,
                      width: 0.3,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppTheme().radius10,
                    borderSide: BorderSide(
                      color: AppTheme.FILL_BORDER_COLOR,
                      width: 0.3,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: AppTheme().radius10,
                    borderSide: BorderSide(
                      color: AppTheme.RED,
                      width: 0.3,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: AppTheme().radius10,
                    borderSide: BorderSide(
                      color: AppTheme.RED,
                      width: 0.3,
                    ),
                  ),
                  errorText: 'Nomeri doly giriziň',
                ),
                textInputAction: TextInputAction.done,
              ),
            ),
            verticalSpaceMedium,
            SizedBox(
              width: 1.sw,
              child: CustomTextButton(
                text: 'Ugrat',
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                textStyle: TextStyle(
                  color: AppTheme.WHITE,
                  fontSize: 18.sp,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
                onPressed: model.saveData,
              ),
            ),
            verticalSpaceMedium,
            Text(
              'Siziň telefon belgiňize gizlin SMS kody geler.',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppTheme.DRAWER_ICON,
              ),
            ),
          ],
        ),
      ),
      viewModelBuilder: () => LoginViewModel(),
    );
  }
}
