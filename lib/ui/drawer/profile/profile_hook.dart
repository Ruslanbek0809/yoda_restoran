import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:yoda_res/shared/shared.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import 'package:yoda_res/utils/utils.dart';
import 'profile_view_model.dart';
import 'package:yoda_res/library/flutter_datetime_picker.dart';
import 'package:yoda_res/library/src/i18n_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileHook extends HookViewModelWidget<ProfileViewModel> {
  ProfileHook({Key? key}) : super(key: key);

  final GlobalKey<FormState> _profileformKey = GlobalKey<FormState>();

  @override
  Widget buildViewModelWidget(BuildContext context, ProfileViewModel model) {
    model.log.v(
        'name: ${model.currentUser!.firstName}, mobile: ${model.currentUser!.mobile}, email: ${model.currentUser!.email}, gender: ${model.currentUser!.gender}, birthday: ${model.currentUser!.birthday}');
    final _nameController = useTextEditingController(
        text: model.currentUser!.firstName != null
            ? model.currentUser!.firstName
            : '');
    final _birthdateController =
        useTextEditingController(text: model.currentUser!.birthday ?? '');
    final _genderController =
        useTextEditingController(text: model.currentUser!.gender ?? '');
    final _emailController =
        useTextEditingController(text: model.currentUser!.email ?? '');
    final _phoneController =
        useTextEditingController(text: model.currentUser!.mobile ?? '');

    var maskFormatter = MaskTextInputFormatter(
        mask: '## ## ## ##', filter: {'#': RegExp(r'[0-9]')});

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.WHITE,
        borderRadius: AppTheme().radius10,
      ),
      padding: EdgeInsets.only(top: 5.h, left: 22.w, right: 22.w),
      child: Form(
        key: _profileformKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Profil', style: kts30DarkText),
              // --------------- NAME -------------- //
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: TextFormField(
                  controller: _nameController,
                  style: ktsDefault18Text,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: AppTheme.DRAWER_DIVIDER, width: 0.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: AppTheme.DRAWER_DIVIDER, width: 0.5),
                    ),
                    labelText: 'Ady',
                    labelStyle: ktsDefault14HelperText,
                  ),
                  validator: model.updateName,
                ),
              ),
              // --------------- DATE TIME -------------- //
              Padding(
                padding: EdgeInsets.only(top: 8.w),
                child: TextFormField(
                  onTap: () async {
                    DateTime? date;
                    FocusScope.of(context).requestFocus(FocusNode());
                    date = await DatePicker.showDatePicker(
                      context,
                      showTitleActions: true,
                      minTime: DateTime(1900, 1, 1),
                      maxTime: DateTime.now(),
                      onChanged: (date) {
                        print('change $date');
                      },
                      onConfirm: (date) {
                        print('confirm $date');
                      },
                      currentTime: DateTime.now(),
                      locale: LocaleType.tk,
                    );
                    _birthdateController.text = date!.toIso8601String();
                    model.updateBirthDate(_birthdateController.text);
                  },
                  controller: _birthdateController,
                  style: ktsDefault18Text,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: AppTheme.DRAWER_DIVIDER, width: 0.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: AppTheme.DRAWER_DIVIDER, width: 0.5),
                    ),
                    labelText: 'Doglan senesi',
                    labelStyle: ktsDefault14HelperText,
                  ),
                ),
              ),
              // --------------- GENDER -------------- //
              Padding(
                padding: EdgeInsets.only(top: 8.w),
                child: Container(
                  color: Colors.transparent,
                  child: TextFormField(
                    onTap: () async {
                      model.updateGender(_genderController.text);
                    },
                    controller: _genderController,
                    style: ktsDefault18Text,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppTheme.DRAWER_DIVIDER, width: 0.5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppTheme.DRAWER_DIVIDER, width: 0.5),
                      ),
                      labelText: 'Jynsy',
                      labelStyle: ktsDefault14HelperText,
                    ),
                  ),
                ),
              ),
              // --------------- EMAIL -------------- //
              Padding(
                padding: EdgeInsets.only(top: 8.w),
                child: TextFormField(
                  controller: _emailController,
                  style: ktsDefault18Text,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: AppTheme.DRAWER_DIVIDER, width: 0.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: AppTheme.DRAWER_DIVIDER, width: 0.5),
                    ),
                    labelText: 'Elektron poçtasy',
                    labelStyle: ktsDefault14HelperText,
                  ),
                  validator: model.updateEmail,
                ),
              ),
              // --------------- PHONE -------------- //
              Padding(
                padding: EdgeInsets.only(top: 8.w),
                child: TextFormField(
                  controller: _phoneController,
                  style: ktsDefault18Text,
                  inputFormatters: [maskFormatter],
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: 'Tel',
                    labelStyle: ktsDefault14HelperText,
                    prefix: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Text('+993', style: ktsDefault18Text),
                    ),
                  ),
                  validator: model.updatePhone,
                ),
              ),
              SizedBox(height: 0.2.sw),
              SizedBox(
                width: 1.sw,
                child: CustomTextChildButton(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: model.isBusy
                        ? ButtonLoading()
                        : Text('Ýatda sakla', style: ktsButton18Text),
                  ),
                  color: kcSecondaryDarkColor,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  borderRadius: kbr10,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
