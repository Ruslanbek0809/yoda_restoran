import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import 'package:yoda_res/shared/styles.dart';
import 'package:yoda_res/ui/drawer/profile/profile_hook.dart';
import 'package:yoda_res/utils/utils.dart';
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
      builder: (context, model, child) => ConditionalWillPopScope(
        onWillPop: () async {
          model.navToHomeByRemovingAll(); // Workaround
          return false;
        },
        shouldAddCallback: true,
        child: Scaffold(
          drawer: DrawerView(),
          appBar: AppBar(
            backgroundColor: AppTheme.WHITE,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: AppTheme.FONT_COLOR,
                size: 25.w,
              ),
              onPressed: model.navToHomeByRemovingAll,
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 5.w),
                child: TextButton(
                  onPressed: model.logout,
                  child: Text(LocaleKeys.logout, style: ktsDefault16Text).tr(),
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
