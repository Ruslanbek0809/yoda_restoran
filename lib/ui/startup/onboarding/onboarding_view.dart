import 'package:flutter/material.dart';
import 'package:yoda_res/library/onboarding/onboarding.dart';
import 'package:stacked/stacked.dart';

import 'onboarding_view_model.dart';

class OnBoardingView extends StatelessWidget {
  OnBoardingView({Key? key}) : super(key: key);

  final List<EachIntroWidget> list = [
    EachIntroWidget(
      subTitle: 'Söýgüli restoranlaryňyzyň tagamlaryny sargyt ediň',
      imageUrl: 'assets/onboard1.jpg',
    ),
    EachIntroWidget(
      subTitle:
          'Sargydyňyz kabul edilenden eltip berilýänçä her ädimden habarly boluň',
      imageUrl: 'assets/onboard2.jpg',
    ),
    EachIntroWidget(
      subTitle:
          'Ýörite promokod bilen restoranlardan sargydyňyza arzanladyş alyň',
      imageUrl: 'assets/onboard3.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OnBoardingViewModel>.reactive(
      builder: (context, model, child) => OnBoardingWidget(
        introductionList: list,
        onTapSkipButton: model.navBack,
      ),
      viewModelBuilder: () => OnBoardingViewModel(),
    );
  }
}
