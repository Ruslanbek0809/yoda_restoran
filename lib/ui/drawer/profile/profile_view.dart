import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../shared/app_colors.dart';
import '../../../shared/styles.dart';
import 'profile_hook.dart';
import '../drawer_view.dart';
import 'profile_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileView extends StatelessWidget {
  ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      onModelReady: (model) => model.assignCurrentUserValues(),
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          model.navToHomeByRemovingAll(); // Workaround
          return false;
        },
        child: Scaffold(
          drawer: DrawerView(),
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
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 5.w),
                child: TextButton(
                  onPressed: () async => await model.showUserLogoutDialog(
                    () async {
                      model.showCustomFlashBar(
                        context: context,
                        msg: LocaleKeys.userLogoutSuccess.tr(),
                        margin: EdgeInsets.only(
                          left: 0.1.sw,
                          right: 0.1.sw,
                          bottom: 0.05.sh,
                        ),
                        duration: Duration(seconds: 3),
                      );
                      await model.navToHomeByRemovingAll();
                    },
                  ),
                  child: Text(LocaleKeys.logout, style: kts16Text).tr(),
                ),
              ),
            ],
          ),
          body: ProfileHook(),
        ),
      ),
      viewModelBuilder: () => ProfileViewModel(),
    );
  }
}
