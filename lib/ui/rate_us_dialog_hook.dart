import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:yoda_res/shared/shared.dart';
import 'package:yoda_res/utils/utils.dart';
import 'rate_us_dialog_view_model.dart';

class RateUsDialogHook extends HookViewModelWidget<RateUsDialogViewModel> {
  const RateUsDialogHook({Key? key}) : super(key: key);

  @override
  Widget buildViewModelWidget(
      BuildContext context, RateUsDialogViewModel model) {
    final _notesController = useTextEditingController();
    return TextFormField(
      controller: _notesController,
      minLines: 8,
      maxLines: null,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: AppTheme().radius10,
          borderSide: BorderSide.none,
        ),
        // focusedBorder: UnderlineInputBorder(
        //   borderSide: BorderSide(color: AppTheme.DRAWER_DIVIDER, width: 0.5),
        // ),
        filled: true,
        fillColor: AppTheme.MAIN_LIGHT,
        hintText: 'Teswir',
        hintStyle: kts16HelperText,
      ),
      validator: model.updateNote,
    );
  }
}
