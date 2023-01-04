import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import '../../generated/locale_keys.g.dart';
import '../../shared/shared.dart';
import '../widgets/widgets.dart';
import '../../utils/utils.dart';

import 'drawer_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class DrawerView extends StatelessWidget {
  DrawerView({Key? key}) : super(key: key);

  Widget menuList(String value, DrawerViewModel model) {
    String title;
    String svgName;
    Function() onTap;
    switch (value) {
      case LocaleKeys.login:
        {
          title = LocaleKeys.login;
          svgName = 'assets/user.svg';
          onTap = () async => model.navToLoginView();
          break;
        }
      case LocaleKeys.profile:
        {
          title = LocaleKeys.profile;
          svgName = 'assets/user.svg';
          onTap = () async => model.navToProfileView();
          break;
        }
      case LocaleKeys.orders:
        {
          title = LocaleKeys.orders;
          svgName = 'assets/list_bullets.svg';
          onTap = () async => model.navToOrdersView();
          break;
        }
      case LocaleKeys.addresses:
        {
          title = LocaleKeys.addresses;
          svgName = 'assets/map_pin.svg';
          onTap = () async => model.navToAddressesView();
          break;
        }
      case LocaleKeys.my_credit_cards:
        {
          title = LocaleKeys.my_credit_cards;
          svgName = 'assets/credit_card.svg';
          onTap = () async => model.navToMyCreditCardsView();
          break;
        }
      case LocaleKeys.addresses:
        {
          title = LocaleKeys.addresses;
          svgName = 'assets/map_pin.svg';
          onTap = () async => model.navToAddressesView();
          break;
        }
      case LocaleKeys.about_us:
        {
          title = LocaleKeys.about_us;
          svgName = 'assets/info.svg';
          onTap = () async => model.navToAboutUsView();
          break;
        }

      default:
        {
          title = LocaleKeys.about_us;
          svgName = 'assets/info.svg';
          onTap = () async => model.navToAboutUsView();
          break;
        }
    }

    return Column(
      children: [
        ListTile(
          leading: SvgPicture.asset(
            svgName,
            color: kcHelperColor,
            width: 33.w,
          ),
          title: Text(
            title,
            style: kts16DarkBoldText,
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

  final GlobalKey<CustomExpansionTileState> expansionTile = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DrawerViewModel>.reactive(
      onModelReady: (model) => model.getAppVersion(),
      builder: (context, model, child) => Drawer(
        child: SingleChildScrollView(
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
              //*----------------- MENU LIST ---------------------//
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
              //*----------------- LANGUAGE ---------------------//
              Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent,
                  dividerTheme: DividerThemeData(
                      color: Theme.of(context).colorScheme.background),
                ),
                child: CustomExpansionTile(
                  backgroundColor: DrawerThemeData().backgroundColor,
                  key: expansionTile,
                  initiallyExpanded: false,
                  onExpansionChanged: (value) {
                    printLog('onExpansionChanged()');
                  },
                  leading: SvgPicture.asset(
                    'assets/globe.svg',
                    color: kcHelperColor,
                    width: 33.w,
                  ),
                  title: Text(
                    context.locale == context.supportedLocales[0]
                        ? LocaleKeys.lang_en
                        : LocaleKeys.lang_ru,
                    // context.locale.toString(),
                    style: kts16DarkBoldText,
                  ).tr(),
                  children: <Widget>[
                    CustomTextChildButton(
                      padding: EdgeInsets.only(
                        left: 66.w,
                        right: 66.w,
                        top: 5.h,
                        bottom: 5.h,
                      ),
                      child: Text(
                        LocaleKeys.lang_en,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.normal,
                          color: kcSecondaryDarkColor,
                        ),
                      ).tr(),
                      color: Colors.transparent,
                      onPressed: context.locale == context.supportedLocales[0]
                          ? () {}
                          : () async {
                              model.collapseExpansionTile(expansionTile);
                              await context.setLocale(context
                                  .supportedLocales[0]); // ASSIGNS turkmen lang
                              await model.setLocale(
                                  context.supportedLocales[0].toString());
                              await model.reinitializeDio();
                              await model.navToHomeByRemovingAll();
                            },
                    ),
                    Divider(
                      thickness: 0.5,
                      endIndent: 0.1.sw,
                      indent: 0.18.sw,
                      color: kcDividerColor,
                    ),
                    CustomTextChildButton(
                      padding: EdgeInsets.only(
                        left: 66.w,
                        right: 66.w,
                        top: 5.h,
                        bottom: 5.h,
                      ),
                      child: Text(
                        LocaleKeys.lang_ru,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.normal,
                          color: kcSecondaryDarkColor,
                        ),
                      ).tr(),
                      color: Colors.transparent,
                      onPressed: context.locale == context.supportedLocales[1]
                          ? () {}
                          : () async {
                              model.collapseExpansionTile(expansionTile);
                              await model.setLocale(
                                  context.supportedLocales[1].toString());
                              await context.setLocale(context
                                  .supportedLocales[1]); // ASSIGNS russian lang
                              await model.reinitializeDio();
                              await model.navToHomeByRemovingAll();
                            },
                    ),
                  ],
                ),
              ),
              //*----------------- CONTACT US ---------------------//
              Padding(
                padding: EdgeInsets.only(
                    top: 0.1.sh, left: 20.w, bottom: 0.175.sw - 10.h),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: model.navToContactUsView,
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/chat_circle.svg',
                            color: kcHelperColor,
                            width: 50.w,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            LocaleKeys.contact_us,
                            style: kts16HelperText,
                          ).tr(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: Text(
                        'V ${model.packageInfo?.version ?? '1.0.0'}',
                        style: kts14HelperText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => DrawerViewModel(),
    );
  }
}
