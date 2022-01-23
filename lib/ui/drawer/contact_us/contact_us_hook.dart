import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import 'package:yoda_res/shared/shared.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import 'package:yoda_res/utils/utils.dart';

import 'contact_us_view_model.dart';

class ContactUsHook extends HookViewModelWidget<ContactUsViewModel> {
  ContactUsHook({Key? key}) : super(key: key);

  final GlobalKey<FormState> _contactformKey = GlobalKey<FormState>();

  @override
  Widget buildViewModelWidget(BuildContext context, ContactUsViewModel model) {
    var maskFormatter = MaskTextInputFormatter(
        mask: '## ## ## ##', filter: {'#': RegExp(r'[0-9]')});
    final _nameController = useTextEditingController();
    final _phoneController = useTextEditingController();
    final _infoController = useTextEditingController();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Form(
        key: _contactformKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 25.h),
              TextFormField(
                controller: _nameController,
                style: ktsDefault16Text,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(12, 17, 12, 17),
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kcDividerColor, width: 0.5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  hintText: LocaleKeys.name.tr(),
                  hintStyle: kts16ContactText,
                  filled: true,
                  fillColor: kcSecondaryLightColor,
                ),
                validator: model.updateName,
              ),
              Container(
                height: 0.5,
                color: kcDividerColor,
              ),
              TextFormField(
                controller: _phoneController,
                style: ktsDefault16Text,
                inputFormatters: [maskFormatter],
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(12, 17, 12, 17),
                  border: UnderlineInputBorder(
                    // borderRadius: AppTheme().containerRadius,
                    borderSide: BorderSide.none,
                    // borderSide: BorderSide(color: kcDividerColor, width: 0.5),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kcDividerColor, width: 0.5),
                  ),
                  prefix: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Text('+993', style: ktsDefault16Text),
                  ),
                  labelText: LocaleKeys.phone.tr(),
                  labelStyle: kts16ContactText,
                  filled: true,
                  fillColor: kcSecondaryLightColor,
                ),
                validator: model.updatePhone,
              ),
              Container(
                height: 0.5,
                color: kcDividerColor,
              ),
              TextFormField(
                controller: _infoController,
                style: ktsDefault16Text,
                maxLines: 8,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    // borderRadius: AppTheme().containerRadius,
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  hintText: LocaleKeys.text.tr(),
                  hintStyle: kts16ContactText,
                  filled: true,
                  fillColor: kcSecondaryLightColor,
                ),
                validator: model.updateInfo,
              ),
              SizedBox(
                width: 1.sw,
                child: CustomTextChildButton(
                  child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: model.isBusy
                          ? ButtonLoading()
                          : Text(LocaleKeys.send, style: ktsButton18Text).tr()),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                  onPressed: () async {
                    FocusScope.of(context)
                        .unfocus(); // UNFOCUSES all textfield b4 data fetch
                    if (!_contactformKey.currentState!.validate()) return;
                    _contactformKey.currentState!.save();
                    await model.onContactPressed(
                        onFailForView: () async => await showErrorFlashBar(
                              context: context,
                              margin: EdgeInsets.only(
                                left: 16.w,
                                right: 16.w,
                                bottom: 0.05.sh,
                              ),
                            ),
                        onSuccessForView: () async {
                          _nameController.clear();
                          _phoneController.clear();
                          _infoController.clear();
                          await showErrorFlashBar(
                            context: context,
                            margin: EdgeInsets.only(
                              left: 16.w,
                              right: 16.w,
                              bottom: 0.05.sh,
                            ),
                          );
                        });
                  },
                ),
              ),
              SizedBox(height: 0.35.sw),
              Text(
                LocaleKeys.our_phone,
                style: TextStyle(
                  color: AppTheme.CONTACT_COLOR,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ).tr(),
              SizedBox(height: 2.h),
              Text(
                LocaleKeys.our_address,
                style: TextStyle(
                  color: AppTheme.CONTACT_COLOR,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ).tr(),
              SizedBox(height: 2.h),
              // Text(
              //   'Instagram: @yoda.restoran',
              //   style: TextStyle(
              //     color: AppTheme.CONTACT_COLOR,
              //     fontSize: 16.sp,
              //     fontWeight: FontWeight.w600,
              //   ),
              // ).tr(),
            ],
          ),
        ),
      ),
    );
  }
}
