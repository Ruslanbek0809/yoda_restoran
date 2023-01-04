import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'home_search_hook.dart';
import 'home_search_view_model.dart';

class HomeSearchView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeSearchViewModel>.reactive(
      builder: (context, model, child) => HomeSearchHook(),
      viewModelBuilder: () => HomeSearchViewModel(),
    );
  }
}
