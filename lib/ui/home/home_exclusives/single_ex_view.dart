import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'single_ex_bottom_cart.dart';
import 'single_ex_webview.dart';
import '../../../models/models.dart';
import 'single_ex_view_model.dart';
import 'single_ex_reachText.dart';

class SingleExView extends StatelessWidget {
  final ExclusiveSingle singleEx;
  const SingleExView({required this.singleEx, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SingleExViewModel>.reactive(
      viewModelBuilder: () => SingleExViewModel(singleEx),
      builder: (context, model, child) {
        return Scaffold(
          body: Stack(
            children: [
              singleEx.option == 'reachText'
                  ? SingleExReachText(singleEx: singleEx)
                  : SingleExWebview(
                      singleEx: singleEx,
                      singleExViewModel: model,
                    ),
              //------------------ BOTTOM CART ---------------------//
              if (!model.hasError &&
                  model.cartRes!.id != -1 &&
                  singleEx.option == 'reachText')
                SingleExBottomCart(),
            ],
          ),
        );
      },
    );
  }
}
