import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/shared/shared.dart';
import 'package:yoda_res/utils/utils.dart';

import 'drawer_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({Key? key}) : super(key: key);

  Widget menuList(String value) {
    String title;
    String svgName;
    Function() onTap;
    switch (value) {
      case 'login':
        {
          title = 'Login et';
          svgName = 'assets/user.svg';
          onTap = () async {};
      //   _navService.replaceWith(Routes.loginView);
          // onTap = () async =>
          //     await Navigator.pushReplacementNamed(context, RouteList.profile);
          break;
        }
      case 'profile':
        {
          title = 'Profil';
          svgName = 'assets/user.svg';
          onTap = () async {};
          // onTap = () async =>
          //     await Navigator.pushReplacementNamed(context, RouteList.profile);
          break;
        }
      case 'orders':
        {
          title = 'Sargytlar';
          svgName = 'assets/list_bullets.svg';
          onTap = () {};
          break;
        }
      case 'addresses':
        {
          title = 'Salgylar';
          svgName = 'assets/map_pin.svg';
          onTap = () async {};
          // onTap = () async => await Navigator.pushReplacementNamed(
          //     context, RouteList.addresses);
          break;
        }
      case 'about':
        {
          title = 'Biz barada';
          svgName = 'assets/info.svg';
          onTap = () {};
          break;
        }

      default:
        {
          title = 'Default';
          svgName = 'assets/info.svg';
          onTap = () async {};
          break;
        }
    }

    return Column(
      children: [
        ListTile(
          leading: SvgPicture.asset(
            svgName,
            color: AppTheme.DRAWER_ICON,
            width: 33.w,
          ),
          title: Text(
            title,
            style: kts16DarkSemiBoldText,
          ),
          onTap: onTap,
        ),
        Divider(
          thickness: 1,
          endIndent: 0.1.sw,
          indent: 0.17.sw,
          color: kcDividerColor,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DrawerViewModel>.reactive(
      builder: (context, model, child) => Drawer(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 0.2.sh,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 15.w),
                    child: SvgPicture.asset(
                      'assets/yoda_restoran.svg',
                      color: AppTheme.MAIN_DARK,
                      width: 0.6.sw,
                    ),
                  ),

                  Divider(
                    thickness: 1,
                    endIndent: 0.1.sw,
                    color: AppTheme.DRAWER_DIVIDER,
                  ),
                  //------------------ MENU LIST ---------------------//
                  ...List.generate(
                    model.hasLoggedInUser
                        ? drawerLoggedInList.length
                        : drawerLogoutList.length,
                    (pos) {
                      return menuList(
                        model.hasLoggedInUser
                            ? drawerLoggedInList[pos]
                            : drawerLogoutList[pos],
                      );
                    },
                  ),
                  //------------------ LANGUAGE ---------------------//
                  Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                      dividerTheme: DividerThemeData(
                          color: Theme.of(context).colorScheme.background),
                    ),
                    child: ExpansionTile(
                      initiallyExpanded: false,
                      onExpansionChanged: (value) {
                        printLog('onExpansionChanged()');
                      },
                      leading: SvgPicture.asset(
                        'assets/globe.svg',
                        color: AppTheme.DRAWER_ICON,
                        width: 33.w,
                      ),
                      title: Text(
                        'Türkmen',
                        style: kts16DarkSemiBoldText,
                      ),
                      iconColor: AppTheme.CONTACT_COLOR,
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            left: 66.w,
                            top: 5.w,
                            bottom: 5.w,
                          ),
                          child: Text(
                            'Türkmen',
                            style: kts16DarkText,
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          endIndent: 0.1.sw,
                          indent: 0.17.sw,
                          color: AppTheme.DRAWER_DIVIDER,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 66.w, top: 5.w),
                          child: Text(
                            'Rus dili',
                            style: kts16DarkText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0.20.sw,
              child: Padding(
                padding: EdgeInsets.only(top: 0.25.sh, left: 20.w),
                child: GestureDetector(
                  onTap: () async => await Navigator.pushReplacementNamed(
                      context, RouteList.contact),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/chat_circle.svg',
                        color: AppTheme.DRAWER_ICON,
                        width: 50.w,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'Biz bilen habarlaş',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppTheme.DRAWER_ICON,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      viewModelBuilder: () => DrawerViewModel(),
    );
  }
}
