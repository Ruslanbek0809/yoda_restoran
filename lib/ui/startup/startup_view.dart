import 'package:easy_localization/easy_localization.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';

import '../../generated/locale_keys.g.dart';
import '../../shared/shared.dart';
import '../../utils/utils.dart';
import 'startup_animated_text_hook.dart';
import 'startup_viewmodel.dart';

class StartUpView extends StatelessWidget {
  StartUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.reactive(
      onModelReady: (model) => WidgetsBinding.instance
          .addPostFrameCallback((_) => model.runStartupLogic()),
      viewModelBuilder: () => StartUpViewModel(),
      builder: (context, model, child) {
        //*CALLED when user has NO Internet Connection
        if (model.startAnimation == false &&
            (model.connectivityStatus == ConnectivityStatus.Offline ||
                model.connectivityStatus == null)) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await showFlash(
              context: context,
              persistent: true,
              builder: (context, controller) {
                model.flashController = controller;
                return Flash(
                  controller: controller,
                  barrierDismissible: false,
                  enableVerticalDrag: false,
                  borderRadius: AppTheme().radius15,
                  backgroundColor: kcSecondaryLightColor,
                  boxShadows: kElevationToShadow[0],
                  margin: EdgeInsets.only(
                    left: 32.w,
                    right: 32.w,
                    bottom: 0.075.sh,
                  ),
                  position: FlashPosition.bottom,
                  behavior: FlashBehavior.floating,
                  child: FlashBar(
                    icon: Padding(
                      padding: EdgeInsets.only(left: 24.w, right: 12.w),
                      child: SvgPicture.asset('assets/no_wifi.svg'),
                    ),
                    content: Text(
                      LocaleKeys.noInternet,
                      style: context.locale == context.supportedLocales[0]
                          ? kts20Text
                          : kts18Text,
                    ).tr(),
                  ),
                );
              },
            );
          });
        }

        //*CALLED when user has INTERNET CONNECTION
        if (model.startAnimation == false &&
            (model.connectivityStatus != ConnectivityStatus.Offline &&
                model.connectivityStatus != null))
          model.navToHomeWithConnection(context.locale);

        return Scaffold(
          body: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //*---------- STYLE 1 --------------//
                    AnimatedContainer(
                      curve: Curves.fastOutSlowIn,
                      duration: Duration(milliseconds: 2500),
                      width: model.startCircleAnimation ? 0.4.sw : 0.0,
                      height: model.startCircleAnimation ? 0.4.sw : 0.0,
                      decoration: BoxDecoration(
                        color: kcPrimaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(height: 25.h),
                    StartUpAnimatedTextHook(
                      delay: 2400,
                      child: SvgPicture.asset(
                        'assets/title_yoda_restoran_start.svg',
                        color: kcSecondaryDarkColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (model.startAnimation == false &&
                  (model.connectivityStatus != ConnectivityStatus.Offline &&
                      model.connectivityStatus != null))
                Positioned(
                  bottom: 0.125.sh,
                  left: 0,
                  right: 0,
                  child: SpinKitChasingDots(
                    size: 35.w,
                    color: kcPrimaryColor,
                  ),
                ),
            ],
          ),
          //*---------- STYLE 2 --------------//
          // Stack(
          //   children: [
          //     YodaImage(
          //       image: 'assets/splash.png',
          //       height: 1.sh,
          //       width: 1.sw,
          //     ),
          //     if (model.connectivityStatus != null &&
          //         model.connectivityStatus != ConnectivityStatus.Offline)
          //       Positioned(
          //         bottom: 0.125.sh,
          //         left: 0,
          //         right: 0,
          //         child: SpinKitChasingDots(
          //           size: 35.w,
          //           color: kcPrimaryColor,
          //         ),
          //       ),
          //   ],
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     StartUpAnimatedTextHook(
          //       delay: 2600,
          //       child: SvgPicture.asset(
          //         'assets/title_yoda.svg',
          //         color: kcSecondaryDarkColor,
          //         // width: 0.22.sw,
          //       ),
          //     ),
          //     SizedBox(width: 10.w),
          //     Padding(
          //       padding: EdgeInsets.only(bottom: 2.h),
          //       child: StartUpAnimatedTextHook(
          //         delay: 3600,
          //         child: SvgPicture.asset(
          //           'assets/title_restoran.svg',
          //           color: kcSecondaryDarkColor,
          //           // width: 0.33.sw,
          //         ),
          //       ),
          //     ),
          //   ],
          // )
          //*---------- STYLE 3 --------------//
          // OverflowBox(
          //   maxHeight: MediaQuery.of(context).size.longestSide * 2,
          //   maxWidth: MediaQuery.of(context).size.longestSide * 2,
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       AnimatedContainer(
          //         curve: Curves.easeIn,
          //         duration: Duration(milliseconds: 3000),
          //         width: model.startAnimation
          //             ? 0.5.sw
          //             : MediaQuery.of(context).size.longestSide * 2,
          //         height: model.startAnimation
          //             ? 0.5.sw
          //             : MediaQuery.of(context).size.longestSide * 2,
          //         decoration: BoxDecoration(
          //           color: kcPrimaryColor,
          //           shape: BoxShape.circle,
          //         ),
          //       ),
          //       SizedBox(height: 25.h),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           StartUpAnimatedTextHook(
          //             delay: 3800,
          //             child: SvgPicture.asset(
          //               'assets/title_yoda.svg',
          //               color: kcSecondaryDarkColor,
          //               width: 0.22.sw,
          //             ),
          //           ),
          //           SizedBox(width: 10.w),
          //           Padding(
          //             padding: EdgeInsets.only(bottom: 2.h),
          //             child: StartUpAnimatedTextHook(
          //               delay: 4800,
          //               child: SvgPicture.asset(
          //                 'assets/title_restoran.svg',
          //                 color: kcSecondaryDarkColor,
          //                 width: 0.33.sw,
          //               ),
          //             ),
          //           ),
          //         ],
          //       )
          //     ],
          //   ),
          // ),
        );
      },
    );
  }
}
