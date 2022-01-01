import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/shared/shared.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        body: OverflowBox(
          maxHeight: MediaQuery.of(context).size.longestSide * 2,
          maxWidth: MediaQuery.of(context).size.longestSide * 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                curve: Curves.easeIn,
                duration: Duration(milliseconds: 3000),
                width: model.startAnimation
                    ? 0.5.sw
                    : MediaQuery.of(context).size.longestSide * 2,
                height: model.startAnimation
                    ? 0.5.sw
                    : MediaQuery.of(context).size.longestSide * 2,
                decoration: BoxDecoration(
                  color: kcPrimaryColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => StartUpViewModel(),
    );
  }
}
