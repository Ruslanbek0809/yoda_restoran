import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'startup_viewmodel.dart';

class StartUpView extends StatelessWidget {
  const StartUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: Center(
          child: Text('StartUpView'),
        ),
        // floatingActionButton:
        //     FloatingActionButton(onPressed: model.navigateToReactiveEx),
      ),
      viewModelBuilder: () => StartUpViewModel(),
    );
  }
}
