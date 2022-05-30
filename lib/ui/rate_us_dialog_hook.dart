import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import '../generated/locale_keys.g.dart';
import '../shared/shared.dart';
import '../utils/utils.dart';
import 'rate_us_dialog_view_model.dart';

class RateUsDialogHook extends HookViewModelWidget<RateUsDialogViewModel> {
  const RateUsDialogHook({Key? key}) : super(key: key);

  @override
  Widget buildViewModelWidget(
      BuildContext context, RateUsDialogViewModel model) {
    final _notesController = useTextEditingController();
    return TextField(
      controller: _notesController,
      minLines: 5,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: AppTheme().radius10,
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: AppTheme.MAIN_LIGHT,
        hintText: LocaleKeys.ratingComment.tr(),
        hintStyle: kts16HelperText,
      ),
      onChanged: (String? val) => model.updateNote(_notesController.text),
    );
  }
}
