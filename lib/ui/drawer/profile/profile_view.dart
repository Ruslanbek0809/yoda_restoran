import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/shared/styles.dart';
import 'package:yoda_res/ui/drawer/profile/profile_hook.dart';
import 'package:yoda_res/utils/utils.dart';
import '../drawer_view.dart';
import 'profile_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                  child: Text('Ulgamdan çyk', style: ktsDefault16Text),
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
