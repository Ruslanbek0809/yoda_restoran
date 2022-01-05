import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import '../../../shared/shared.dart';
import '../../widgets/widgets.dart';
import '../../../utils/utils.dart';

import 'login_view.form.dart';
import 'login_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@FormView(
  fields: [
    FormTextField(name: 'phone'),
  ],
) // Needed when generating Formfields

// ignore: must_be_immutable
class LoginView extends StatelessWidget with $LoginView {
  final bool isCartView;
  LoginView({required this.isCartView, Key? key}) : super(key: key);

  final formKey = GlobalKey<FormState>();
  var maskFormatter = MaskTextInputFormatter(
      mask: '## ## ## ##', filter: {'#': RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      onModelReady: (model) =>
          listenToFormUpdated(model), // Needed when generating formFields
      builder: (context, model, child) => Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                //------------------ YodaRes LOGO ---------------------//
                SizedBox(
                  height: 1.sh / 2.5,
                  child: SvgPicture.asset(
                    'assets/yoda_restoran.svg',
                    color: AppTheme.MAIN_DARK,
                    width: 0.73.sw,
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
                verticalSpaceTiny,
                verticalSpaceMedium,
                Text(
                  'Telefon belgiňizi giriziň',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppTheme.DRAWER_ICON,
                  ),
                ),
                verticalSpaceMedium,
                //------------------ PHONE TEXTFIELD ---------------------//
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.10.sw),
                  child: TextFormField(
                    controller: phoneController,
                    inputFormatters: [maskFormatter],
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    style: ktsTextfieldText,
                    decoration: InputDecoration(
                      labelText: 'Tel',
                      labelStyle: ktsLabelText,
                      prefix: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Text('+993', style: ktsTextfieldText),
                      ),
                      fillColor: AppTheme.FILL_COLOR,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: AppTheme().radius10,
                        borderSide: BorderSide(
                          color: AppTheme.FILL_BORDER_COLOR,
                          width: 0.3,
                        ),
                      ),
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
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 11) {
                        return 'Nomeri doly giriziň';
                      }
                      return null;
                    },
                  ),
                ),
                verticalSpaceMedium,
                //------------------ Login BUTTON ---------------------//
                SizedBox(
                  width: 0.88.sw,
                  child: CustomTextChildButton(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: model.isBusy
                            ? ButtonLoading()
                            : Text(
                                'Dowam et',
                                style: ktsButtonText,
                              ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      borderRadius: kbr10,
                      onPressed: () {
                        if (!formKey.currentState!.validate()) return;
                        formKey.currentState!.save();

                        model.saveLoginData();
                      }),
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
        ),
      ),
      viewModelBuilder: () => LoginViewModel(),
    );
  }
}
