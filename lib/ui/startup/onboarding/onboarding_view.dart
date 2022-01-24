import 'package:flutter/material.dart';
import 'package:yoda_res/library/onboarding/onboarding.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/utils/utils.dart';

import 'onboarding_view_model.dart';

class OnBoardingView extends StatelessWidget {
  OnBoardingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OnBoardingViewModel>.reactive(
      builder: (context, model, child) => OnBoardingWidget(
        introductionList: onBoardingList,
        onTapSkipButton: model.successNavToHome,
      ),
      viewModelBuilder: () => OnBoardingViewModel(),
    );
  }
}
