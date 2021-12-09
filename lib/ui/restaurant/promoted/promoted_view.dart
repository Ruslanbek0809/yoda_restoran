import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'promoted_view_model.dart';

class PromotedView extends StatelessWidget {
  const PromotedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PromotedViewModel>.reactive(
      builder: (context, model, child) => Scaffold(),
      viewModelBuilder: () => PromotedViewModel(),
    );
  }
}
