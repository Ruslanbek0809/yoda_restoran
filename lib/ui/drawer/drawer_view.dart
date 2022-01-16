import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import 'package:yoda_res/shared/shared.dart';
import 'package:yoda_res/utils/utils.dart';

import 'drawer_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({Key? key}) : super(key: key);

  Widget menuList(String value, DrawerViewModel model) {
    String title;
    String svgName;
    Function() onTap;
    switch (value) {
      case 'login':
        {
          title = LocaleKeys.login;
          svgName = 'assets/user.svg';
          onTap = () async => model.navToLoginView();
          break;
        }
      case 'profile':
        {
          title = LocaleKeys.profile;
          svgName = 'assets/user.svg';
          onTap = () async => model.navToProfileView();
          break;
        }
      case 'orders':
        {
          title = LocaleKeys.orders;
          svgName = 'assets/list_bullets.svg';
          onTap = () async => model.navToOrdersView();
          break;
        }
      case 'addresses':
        {
          title = LocaleKeys.addresses;
          svgName = 'assets/map_pin.svg';
          onTap = () async => model.navToAddressesView();
          break;
        }
      case 'about':
        {
          title = LocaleKeys.about_us;
          svgName = 'assets/info.svg';
          onTap = () {};
          break;
        }

      default:
        {
          title = LocaleKeys.about_us;
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
          ).tr(),
          onTap: onTap,
        ),
        Divider(
          thickness: 0.5,
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
                      'assets/title_yoda_restoran.svg',
                      width: 0.55.sw,
                    ),
                  ),
                  Divider(
                    thickness: 0.5,
                    endIndent: 0.1.sw,
                    color: kcDividerColor,
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
                        model,
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
                            top: 5.h,
                            bottom: 5.h,
                          ),
                          child: Text(
                            'Türkmen',
                            style: kts16DarkText,
                          ),
                        ),
                        Divider(
                          thickness: 0.5,
                          endIndent: 0.1.sw,
                          indent: 0.18.sw,
                          color: kcDividerColor,
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
                  onTap: () {},
                  // onTap: () async => await Navigator.pushReplacementNamed(
                  //     context, RouteList.contact),
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
                        style: kts16HelperText,
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
