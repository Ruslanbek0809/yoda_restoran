import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/utils/utils.dart';
import '../../../models/models.dart';
import 'single_ex_view_model.dart';
import 'single_ex_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SingleExView extends StatelessWidget {
  final ExclusiveSingle singleEx;
  const SingleExView({required this.singleEx, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SingleExViewModel>.reactive(
      viewModelBuilder: () => SingleExViewModel(singleEx),
      builder: (context, model, child) {
        /// Same as below else part. Just gives extra padding when there is cartRes
        if (model.isCustomError && singleEx.id == model.cartRes!.id)
          WidgetsBinding.instance!.addPostFrameCallback((_) async {
            model.updateCustomError();
            await showErrorFlashBar(
              context: context,
              margin: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
                bottom: 0.12.sh,
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
              SingleExWidget(singleEx: singleEx),
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
