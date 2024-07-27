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

class StartUpView extends StatefulWidget {
  StartUpView({Key? key}) : super(key: key);

  @override
  State<StartUpView> createState() => _StartUpViewState();
}

class _StartUpViewState extends State<StartUpView> {
  // final GlobalKey<SnowWidgetState> snowWidgetKey = GlobalKey<SnowWidgetState>();
  FlashController<Object?>? flashController;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.reactive(
      onModelReady: (model) =>
          WidgetsBinding.instance.addPostFrameCallback((_) {
        model.runStartupLogic();
      }),
      viewModelBuilder: () => StartUpViewModel(),
      builder: (context, model, child) {
        //* CALLED immediately after start-up animation is completed to check for internet connectivity and navigation based on it
        if (!model.startAnimation) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            bool isOffline = model.checkAndHandleConnectivity(context.locale);
            if (isOffline) {
              showNoConnectionFlash(context);
            } else {
              flashController?.dismiss();
            }
          });
        }

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
              if (!model.startAnimation &&
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
              // Positioned.fill(
              //   child: IgnorePointer(
              //     child: SnowWidget(
              //       key:
              //           snowWidgetKey, //* CONTROLS the SnowWidget independently of the parent widget's rebuild
              //       isRunning: true,
              //       totalSnow: 50,
              //       speed: 0.2,
              //       maxRadius: 8,
              //       snowColor: Colors.white,
              //     ),
              //   ),
              // ),
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

  Future<void> showNoConnectionFlash(BuildContext context) async {
    await showCustomFlashBarWithFlashController(
      context: context,
      flashController: flashController,
      msgTextWidget: Text(
        LocaleKeys.noInternet,
        style: context.locale == context.supportedLocales[0]
            ? kts20Text
            : kts18Text,
      ).tr(),
      childWidget: SvgPicture.asset('assets/no_wifi.svg'),
      duration: null,
      margin: EdgeInsets.only(
        left: 32.w,
        right: 32.w,
        bottom: 0.075.sh,
      ),
    );
  }
}
