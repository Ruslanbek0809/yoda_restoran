import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import 'package:yoda_res/shared/shared.dart';
import 'package:yoda_res/ui/drawer/contact/contact_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import 'package:yoda_res/utils/utils.dart';

class ContactHook extends HookViewModelWidget<ContactViewModel> {
  ContactHook({Key? key}) : super(key: key);

  final GlobalKey<FormState> _contactformKey = GlobalKey<FormState>();

  @override
  Widget buildViewModelWidget(BuildContext context, ContactViewModel model) {
    final _nameController = useTextEditingController();
    final _phoneController = useTextEditingController();
    final _infoController = useTextEditingController();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Form(
        key: _contactformKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 50.w),
            TextFormField(
              controller: _nameController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(12, 17, 12, 17),
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                  borderSide:
                      BorderSide(color: AppTheme.CONTACT_COLOR, width: 0.5),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: AppTheme.CONTACT_COLOR, width: 0.5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                hintText: LocaleKeys.name.tr(),
                hintStyle:
                    TextStyle(fontSize: 18.sp, color: AppTheme.DRAWER_ICON),
                filled: true,
                fillColor: kcSecondaryLightColor,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return LocaleKeys.your_name.tr();
                }
                return null;
              },
            ),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(12, 17, 12, 17),
                border: UnderlineInputBorder(
                  // borderRadius: AppTheme().containerRadius,
                  borderSide:
                      BorderSide(color: AppTheme.CONTACT_COLOR, width: 0.5),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: AppTheme.CONTACT_COLOR, width: 0.5),
                ),
                hintText: LocaleKeys.phone.tr(),
                hintStyle:
                    TextStyle(fontSize: 18.sp, color: AppTheme.DRAWER_ICON),
                filled: true,
                fillColor: kcSecondaryLightColor,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return LocaleKeys.phone.tr();
                }
                return null;
              },
            ),
            TextFormField(
              controller: _infoController,
              maxLines: 10,
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
                hintStyle:
                    TextStyle(fontSize: 18.sp, color: AppTheme.DRAWER_ICON),
                filled: true,
                fillColor: kcSecondaryLightColor,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return LocaleKeys.enter_text.tr();
                }
                return null;
              },
            ),
            SizedBox(
              width: 1.sw,
              child: CustomTextChildButton(
                child: Text(LocaleKeys.send, style: ktsButton18Text).tr(),
                padding: EdgeInsets.symmetric(vertical: 13.w, horizontal: 16.w),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
                onPressed: _onContactPressed,
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
    );
  }
}
