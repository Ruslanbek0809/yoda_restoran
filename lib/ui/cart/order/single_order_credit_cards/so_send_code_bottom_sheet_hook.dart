import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/shared.dart';
import '../../../../utils/utils.dart';
import 'so_credit_cards_view_model.dart';

class SOSendCodeBottomSheetHook
    extends HookViewModelWidget<SOCreditCardsViewModel> {
  const SOSendCodeBottomSheetHook({
    Key? key,
  }) : super(
          key: key,
        );

  @override
  Widget buildViewModelWidget(
      BuildContext context, SOCreditCardsViewModel model) {
    final _sendCodeController = useTextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _sendCodeController,
          style: kts18Text,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: kcDividerColor, width: 0.5),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: kcDividerColor, width: 0.5),
            ),
            hintText: LocaleKeys.ashgabat.tr(),
            hintStyle: ktsDefault18HelperText,
          ),
          validator: model.updateSendCodeValidator,
        ),
      ],
    );
  }
}
