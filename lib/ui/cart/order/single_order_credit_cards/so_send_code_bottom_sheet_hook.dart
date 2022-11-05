import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/shared.dart';
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
            border: OutlineInputBorder(
              borderRadius: kbr10,
              borderSide: BorderSide(
                color: kcFillBorderColor,
                width: 0.5,
              ),
            ),
            
            hintText: LocaleKeys.code.tr(),
            hintStyle: ktsDefault18HelperText,
          ),
          validator: model.updateSendCodeValidator,
        ),
      ],
    );
  }
}
