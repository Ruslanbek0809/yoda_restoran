import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/shared/shared.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import 'startup_animated_text_hook.dart';
import 'startup_viewmodel.dart';

class StartUpView extends StatelessWidget {
  const StartUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.reactive(
      onModelReady: (model) =>
          SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
        model.runStartupLogic();
      }),
      builder: (context, model, child) => Scaffold(
        body: YodaImage(
          image: 'assets/splash.png',
          height: 1.sh,
          width: 1.sw,
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
      ),
      viewModelBuilder: () => StartUpViewModel(),
    );
  }
}
