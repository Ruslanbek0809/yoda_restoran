import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yoda_res/screens/profile/profile.dart';
import '../profile/contact_us_screen.dart';
import '../../utils/utils.dart';

class DrawerWidget extends StatelessWidget {
  DrawerWidget({Key? key}) : super(key: key);

  final List<String> drawerList = ["profile", "orders", "addresses", "about"];
  Widget menuList(String value, BuildContext context) {
    String title;
    String svgName;
    Function() onTap;
    switch (value) {
      case 'profile':
        {
          title = 'Profil';
          svgName = 'assets/user.svg';
          onTap = () async {
            // Navigator.of(context).pop();
            // Navigator.of(context).push(MaterialPageRoute(
            //     builder: (BuildContext context) => ProfileScreen()));
            await Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ProfileScreen()));
          };
          break;
        }
      case 'orders':
        {
          title = 'Sargytlar';
          svgName = 'assets/list_bullets.svg';
          onTap = () async {};
          break;
        }
      case 'addresses':
        {
          title = 'Salgylar';
          svgName = 'assets/map_pin.svg';
          onTap = () async {};
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
            style: TextStyle(
              fontSize: 16.sp,
              color: AppTheme.MAIN_DARK,
              fontWeight: FontWeight.w600,
            ),
          ),
          onTap: onTap,
        ),
        Divider(
          thickness: 1,
          endIndent: 0.1.sw,
          indent: 0.17.sw,
          color: AppTheme.DRAWER_DIVIDER,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
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
            //// Drawer Menu
            ...List.generate(
              drawerList.length,
              (pos) {
                return menuList(drawerList[pos], context);
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 0.25.sh, left: 20.w),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/chat_circle.svg',
                    color: AppTheme.DRAWER_ICON,
                    width: 50.w,
                  ),
                  SizedBox(width: 10.w),
                  GestureDetector(
                    onTap: () async {
                      await showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return Dialog(
                            insetPadding: EdgeInsets.symmetric(
                                vertical: 5.w, horizontal: 25.w),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            child: ContactUsScreen(),
                          );
                        },
                      );
                    },
                    child: Text(
                      'Biz bilen habarlaş',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppTheme.DRAWER_ICON,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget menuList(value) {
  //   String title;
  //   IconData icon;
  //   Function() onTap;
  //   switch (value) {
  //     case 'profile':
  //       {
  //         title = 'Profil';
  //         icon = Icons.person_outlined;
  //         onTap = () async {};
  //         break;
  //       }
  //     case 'orders':
  //       {
  //         title = 'Sargytlar';
  //         icon = Icons.list;
  //         onTap = () async {};
  //         break;
  //       }
  //     case 'addresses':
  //       {
  //         title = 'Salgylar';
  //         icon = Icons.pin_drop_outlined;
  //         onTap = () async {};
  //         break;
  //       }
  //     case 'about':
  //       {
  //         title = 'Biz barada';
  //         icon = Icons.info_outlined;
  //         onTap = () async {};
  //         break;
  //       }

  //     default:
  //       {
  //         title = 'Default';
  //         icon = Icons.cancel;
  //         onTap = () async {};
  //         break;
  //       }
  //   }

  //   return Column(
  //     children: [
  //       ListTile(
  //         leading: Icon(
  //           icon,
  //           color: AppTheme.DRAWER,
  //           size: 33.w,
  //         ),
  //         title: Text(
  //           title,
  //           style: TextStyle(
  //             fontSize: 15.sp,
  //             color: AppTheme.MAIN_DARK,
  //           ),
  //         ),
  //         onTap: onTap,
  //       ),
  //       Divider(
  //         thickness: 1,
  //         endIndent: 0.1.sw,
  //         indent: 0.17.sw,
  //         color: AppTheme.DRAWER_DIVIDER,
  //       ),
  //     ],
  //   );
  // }
}
