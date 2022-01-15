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
      viewModelBuilder: () => LoginViewModel(isCartView),
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
                    'assets/title_yoda_restoran.svg',
                    width: 0.6.sw,
                  ),
                ),
                Text('Ulgama giriň', style: ktsDefault22DarkText),
                verticalSpaceTiny,
                verticalSpaceMedium,
                Text('Telefon belgiňizi giriziň', style: kts14HelperText),
                verticalSpaceMedium,
                //------------------ PHONE TEXTFIELD ---------------------//
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.1.sw),
                  child: TextFormField(
                    controller: phoneController,
                    inputFormatters: [maskFormatter],
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    style: kts18Text,
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Telefon',
                      labelStyle: kts16HelperText,
                      prefix: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Text('+993', style: kts18Text),
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
                        return 'Telefon belgiňizi doly giriziň';
                      }
                      return null;
                    },
                  ),
                ),
                verticalSpaceMedium,
                //------------------ Login BUTTON ---------------------//
                SizedBox(
                  width: 0.8.sw,
                  child: CustomTextChildButton(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: model.isBusy
                            ? ButtonLoading()
                            : Text('Dowam et', style: ktsButton18Text),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      borderRadius: kbr10,
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) return;
                        formKey.currentState!.save();

                        await model.saveLoginData(
                            onFailForView: () =>
                                showErrorFlashBar(context: context));
                      }),
                ),
                verticalSpaceMedium,
                Text(
                  'Siziň telefon belgiňize gizlin kodly SMS geler.',
                  style: kts14HelperText,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
