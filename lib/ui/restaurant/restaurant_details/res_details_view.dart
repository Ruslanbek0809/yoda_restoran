import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/utils/utils.dart';
import '../../../models/models.dart';
import 'res_details_bottom_cart.dart';
import 'res_details_main_hook.dart';
import 'res_details_main_busy.dart';
import 'res_details_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResDetailsView extends StatelessWidget {
  final Restaurant restaurant;
  const ResDetailsView({required this.restaurant, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ResDetailsViewModel>.reactive(
      viewModelBuilder: () => ResDetailsViewModel(restaurant),
      builder: (context, model, child) {
        // model.log.i('model.isBusy: ${model.isBusy}');
        if (model.isCustomError && restaurant.id == model.cartRes!.id)
          WidgetsBinding.instance!.addPostFrameCallback((_) async {
            model.updateCustomError();
            await showErrorFlashBar(
              context: context,
              margin: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
                bottom: 0.11.sh,
              ),
            );
          });
        else if (model.isCustomError)
          WidgetsBinding.instance!.addPostFrameCallback((_) async {
            model.updateCustomError();
            await showErrorFlashBar(
              context: context,
              margin: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
                bottom: 0.05.sh,
              ),
            );
          });

        return Scaffold(
          body: Stack(
            children: [
              //------------------ RESTAURANT MAIN PART ---------------------//
              model.isBusy
                  // || model.isCustomBusy
                  ? ResDetailsMainBusy(restaurant: restaurant)
                  : ResDetailsMainHook(restaurant: restaurant),
              //------------------ BOTTOM CART ---------------------//
              if (restaurant.id == model.cartRes!.id) ResDetailsBottomCart(),
            ],
          ),
        );
      },
    );
  }
}
