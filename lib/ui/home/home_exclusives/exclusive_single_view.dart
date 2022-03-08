import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../models/models.dart';

import 'exclusive_single_hook.dart';
import 'exclusive_single_view_model.dart';

class ExclusiveSingleView extends StatelessWidget {
  final ExclusiveSingle exclusiveSingle;
  const ExclusiveSingleView({required this.exclusiveSingle, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ExclusiveSingleViewModel>.reactive(
      viewModelBuilder: () => ExclusiveSingleViewModel(exclusiveSingle),
      builder: (context, model, child) {
        // if (model.isCustomError && restaurant.id == model.cartRes!.id)
        //   WidgetsBinding.instance!.addPostFrameCallback((_) async {
        //     model.updateCustomError();
        //     await showErrorFlashBar(
        //       context: context,
        //       margin: EdgeInsets.only(
        //         left: 16.w,
        //         right: 16.w,
        //         bottom: 0.12.sh,
        //       ),
        //     );
        //   });
        // else if (model.isCustomError)
        //   WidgetsBinding.instance!.addPostFrameCallback((_) async {
        //     model.updateCustomError();
        //     await showErrorFlashBar(
        //       context: context,
        //       margin: EdgeInsets.only(
        //         left: 16.w,
        //         right: 16.w,
        //         bottom: 0.05.sh,
        //       ),
        //     );
        //   });

        return Scaffold(
          body: Stack(
            children: [
              ExclusiveSingleHook(exclusiveSingle: exclusiveSingle),
              //------------------ RESTAURANT MAIN PART ---------------------//
              // model.isBusy
              //     ? ResDetailsMainBusy(restaurant: restaurant)
              //     : ResDetailsMainHook(restaurant: restaurant),
              //------------------ BOTTOM CART ---------------------//
              // if (restaurant.id == model.cartRes!.id) ResDetailsBottomCart(),
            ],
          ),
        );
      },
    );
  }
}
