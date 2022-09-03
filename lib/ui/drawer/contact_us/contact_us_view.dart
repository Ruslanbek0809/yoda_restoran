import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../shared/shared.dart';
import '../../../utils/utils.dart';
import 'contact_us_hook.dart';
import 'contact_us_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class ContactUsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ContactUsViewModel>.reactive(
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          model.navToHomeByRemovingAll(); // Workaround
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kcWhiteColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: kcFontColor,
                size: 25.w,
              ),
              onPressed: model.navToHomeByRemovingAll,
            ),
            title: Text(
              LocaleKeys.contact_us,
              style: TextStyle(
                color: kcSecondaryDarkColor,
              ),
            ).tr(),
            centerTitle: true,
          ),
          body: ContactUsHook(),
        ),
      ),
      viewModelBuilder: () => ContactUsViewModel(),
    );
  }
}
