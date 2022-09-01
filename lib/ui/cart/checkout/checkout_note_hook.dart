import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import '../../../shared/shared.dart';
import 'checkout_view_model.dart';
import '../../../utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';

class CheckoutNoteHook extends HookViewModelWidget<CheckoutViewModel> {
  const CheckoutNoteHook({Key? key}) : super(key: key, reactive: true);

  @override
  Widget buildViewModelWidget(BuildContext context, CheckoutViewModel model) {
    final _noteController = useTextEditingController();

    // model.log.v('CheckoutNoteHook =========');
    return Padding(
      padding: EdgeInsets.only(left: 40.w, right: 15.w, bottom: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 5.w),
            child: Text(
              LocaleKeys.note,
              style: kts16HelperText,
            ).tr(),
          ),
          SizedBox(height: 5.h),
          TextFormField(
            controller: _noteController,
            maxLines: 5,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: AppTheme().radius10,
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: kcSecondaryLightColor,
            ),
            onChanged: model.updateCheckoutNote,
            onSaved: model.updateCheckoutNote,
          ),
        ],
      ),
    );
  }
}
