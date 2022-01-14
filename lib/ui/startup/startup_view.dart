import 'dart:async';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/shared/shared.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import 'package:yoda_res/utils/utils.dart';
import 'startup_viewmodel.dart';

class StartUpView extends StatelessWidget {
  StartUpView({Key? key}) : super(key: key);

  final completer = Completer<FlashController>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.reactive(
      // onModelReady: (model) =>
      //     SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
      //       model.runStartupLogic();
      //     }),
      viewModelBuilder: () => StartUpViewModel(),
      builder: (context, model, child) {
        model.log.v('connectivityStatus: ${model.connectivityStatus}');

        /// Called when No internet connection
        if (model.connectivityStatus == ConnectivityStatus.Offline ||
            model.connectivityStatus == null) {
          WidgetsBinding.instance!.addPostFrameCallback((_) async {
            await showFlash(
              context: context,
              persistent: true,
              builder: (context, controller) {
                model.flashController = controller;
                model.log.v('In Offline: ${model.flashController}');
                return Flash(
                  controller: controller,
                  barrierDismissible: false,
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
                      'Internet ýok',
                      style: ktsDefault20Text,
                    ),
                  ),
                );
              },
            );
          });
        }

        /// It is called only when above showFlash called at least once
        if (model.connectivityStatus != ConnectivityStatus.Offline &&
            model.connectivityStatus != null) {
          if (model.flashController != null) model.dismissFlashController();
        }

        /// Called when user has internet connection
        if (model.connectivityStatus != ConnectivityStatus.Offline &&
            model.connectivityStatus != null) model.navToHomeWithConnection();

        return Scaffold(
          body: Stack(
            children: [
              YodaImage(
                image: 'assets/splash.png',
                height: 1.sh,
                width: 1.sw,
              ),
              if (model.connectivityStatus != null &&
                  model.connectivityStatus != ConnectivityStatus.Offline)
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
