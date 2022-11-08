import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../shared/shared.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../widgets/widgets.dart';
import '../../../utils/utils.dart';
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
                style: kts16Text,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(12, 17, 12, 17),
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                    borderSide: BorderSide(
                      color: kcDividerColor,
                      width: 0.75,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                    borderSide: BorderSide(
                      color: kcDividerColor,
                      width: 0.75,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: kcDividerColor,
                      width: 0.75,
                    ),
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
              TextFormField(
                controller: _phoneController,
                style: kts16Text,
                inputFormatters: [maskFormatter],
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(12, 17, 12, 17),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: kcDividerColor,
                      width: 0.75,
                    ),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: kcDividerColor,
                      width: 0.75,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: kcDividerColor,
                      width: 0.75,
                    ),
                  ),
                  prefix: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Text('+993', style: kts16Text),
                  ),
                  labelText: LocaleKeys.phone.tr(),
                  labelStyle: kts16ContactText,
                  filled: true,
                  fillColor: kcSecondaryLightColor,
                ),
                validator: model.updatePhone,
              ),
              TextFormField(
                controller: _infoController,
                style: kts16Text,
                maxLines: 8,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: kcDividerColor,
                      width: 0.75,
                    ),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: kcDividerColor,
                      width: 0.75,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: kcDividerColor,
                      width: 0.75,
                    ),
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
                        msg: LocaleKeys.msgDidntSent,
                        margin: EdgeInsets.only(
                          left: 16.w,
                          right: 16.w,
                          bottom: 0.025.sh,
                        ),
                      ),
                      onSuccessForView: () async {
                        _nameController.clear();
                        _phoneController.clear();
                        _infoController.clear();
                        await showErrorFlashBar(
                          context: context,
                          msg: LocaleKeys.msgSentSuccessfully,
                          margin: EdgeInsets.only(
                            left: 16.w,
                            right: 16.w,
                            bottom: 0.025.sh,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 0.33.sw),
              Text(
                LocaleKeys.our_phone_title,
                style: kts16DialogBoldText,
              ).tr(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      LocaleKeys.our_phone_for_client_title,
                      style: kts16DialogText,
                    ).tr(),
                  ),
                  Text(
                    LocaleKeys.our_phone_for_client,
                    style: kts16ContactBlueBoldText,
                  ).tr(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      LocaleKeys.our_phone_for_cooperation_title,
                      style: kts16DialogText,
                    ).tr(),
                  ),
                  Text(
                    LocaleKeys.our_phone_for_cooperation,
                    style: kts16ContactBlueBoldText,
                  ).tr(),
                ],
              ),
              SizedBox(height: 24.h),
              Text(
                LocaleKeys.our_address_title,
                style: kts16DialogBoldText,
              ).tr(),
              Text(
                LocaleKeys.our_address,
                style: kts16DialogText,
              ).tr(),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}
