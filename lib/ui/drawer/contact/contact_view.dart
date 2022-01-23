import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import '../../../utils/utils.dart';

import 'contact_hook.dart';
import 'contact_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class ContactView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ContactViewModel>.reactive(
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          await Navigator.pushReplacementNamed(context, RouteList.home);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppTheme.WHITE,
            elevation: 0,
            leading: GestureDetector(
              onTap: () async =>
                  await Navigator.pushReplacementNamed(context, RouteList.home),
              child: Icon(
                Icons.arrow_back,
                color: AppTheme.FONT_COLOR,
                size: 25.w,
              ),
            ),
            title: Text(
              LocaleKeys.contact_us,
              style: TextStyle(
                color: AppTheme.MAIN_DARK,
              ),
            ).tr(),
            centerTitle: true,
          ),
          body: ContactHook(),
        ),
      ),
      viewModelBuilder: () => ContactViewModel(),
    );
  }
}
