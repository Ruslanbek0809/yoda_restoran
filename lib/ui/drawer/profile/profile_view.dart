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

  // void _onGenderPressed() async {
  //   printLog('_onGenderPressed');
  //   if (Platform.isIOS) {
  //     await showCupertinoModalPopup(
  //       context: context,
  //       barrierDismissible: true,
  //       builder: (BuildContext context) {
  //         return CupertinoActionSheet(
  //           actions: <Widget>[
  //             CupertinoActionSheetAction(
  //               child: Text(
  //                 'Erkek',
  //               ),
  //               onPressed: () {
  //                 _genderController.text = 'Erkek';
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //             CupertinoActionSheetAction(
  //               child: Text(
  //                 'Aýal',
  //               ),
  //               onPressed: () {
  //                 _genderController.text = 'Aýal';
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //           ],
  //           cancelButton: CupertinoActionSheetAction(
  //             isDestructiveAction: true,
  //             child: Text(
  //               'Ýap',
  //             ),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         );
  //       },
  //     );
  //   } else {
  //     await showModalBottomSheet(
  //       context: context,
  //       isDismissible: true,
  //       builder: (BuildContext context) {
  //         return BottomSheet(
  //           onClosing: () {},
  //           builder: (BuildContext context) {
  //             return Container(
  //               height: 186,
  //               child: ListView(
  //                 children: <Widget>[
  //                   ListTile(
  //                     title: Center(
  //                       child: Text(
  //                         'Erkek',
  //                       ),
  //                     ),
  //                     onTap: () {
  //                       _genderController.text = 'Erkek';
  //                       Navigator.of(context).pop();
  //                     },
  //                   ),
  //                   Divider(height: 8),
  //                   ListTile(
  //                     title: Center(
  //                       child: Text(
  //                         'Aýal',
  //                       ),
  //                     ),
  //                     onTap: () {
  //                       _genderController.text = 'Aýal';
  //                       Navigator.of(context).pop();
  //                     },
  //                   ),
  //                   Divider(height: 8),
  //                   ListTile(
  //                     title: Center(
  //                       child: Text(
  //                         'Ýap',
  //                         style: TextStyle(color: AppTheme.RED),
  //                       ),
  //                     ),
  //                     onTap: () {
  //                       Navigator.of(context).pop();
  //                     },
  //                   )
  //                 ],
  //               ),
  //             );
  //           },
  //         );
  //       },
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
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
