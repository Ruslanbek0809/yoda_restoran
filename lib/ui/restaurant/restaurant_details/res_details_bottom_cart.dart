import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

import '../../../shared/shared.dart';
import '../../../utils/utils.dart';
import 'res_bottom_cart/res_bottom_cart_total_view.dart';
import 'res_details_view_model.dart';

class ResDetailsBottomCart extends HookViewModelWidget<ResDetailsViewModel> {
  const ResDetailsBottomCart({Key? key}) : super(key: key);

  @override
  Widget buildViewModelWidget(BuildContext context, ResDetailsViewModel model) {
    final bottomCartController =
        useAnimationController(duration: const Duration(milliseconds: 300));
    final bottomCartOffset =
        Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero).animate(
      CurvedAnimation(
        parent: bottomCartController,
        curve: Curves.easeInOut,
      ),
    );
    // final stableBottomCartOffset =
    //     Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 1.0)).animate(
    //   CurvedAnimation(
    //     parent: bottomCartController,
    //     curve: Curves.easeInOut,
    //   ),
    // );
    // final bottomCartOffset = Tween<Offset>(
    //         begin: model.bottomCartStatus == BottomCartStatus.stable
    //             ? Offset.zero
    //             : Offset(0.0, 1.0),
    //         end: model.bottomCartStatus == BottomCartStatus.stable
    //             ? Offset(0.0, 1.0)
    //             : Offset.zero)
    //     .animate(
    //   CurvedAnimation(
    //     parent: bottomCartController,
    //     curve: Curves.easeInOut,
    //   ),
    // );

    // late Animation<Offset> bottomCartOffset;
    // if (model.bottomCartStatus == BottomCartStatus.forward)
    //   bottomCartOffset =
    //       Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero)
    //           .animate(bottomCartController);
    // else
    //   bottomCartOffset =
    //       Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero)
    //           .animate(bottomCartController);

    // model.log.i(
    //     'ResDetailsBottomCart BEFORE model.bottomCartStatus: ${model.bottomCartStatus} and bottomCartController.status: ${bottomCartController.status}, bottomCartOffset: $bottomCartOffset');
    //* BottomCartController trigger
    if (model.bottomCartStatus != BottomCartStatus.idle)
      switch (bottomCartController.status) {
        case AnimationStatus.dismissed:
          {
            if (model.bottomCartStatus == BottomCartStatus.forward)
              // {
              bottomCartController.forward();
            //   model.updateBottomCartToStable();
            // }
            if (model.bottomCartStatus == BottomCartStatus.reverse)
              bottomCartController.reverse();
          }
          break;
        case AnimationStatus.forward:
          {
            if (model.bottomCartStatus == BottomCartStatus.forward)
              bottomCartController.forward();
            if (model.bottomCartStatus == BottomCartStatus.reverse)
              bottomCartController.reverse();
          }
          break;
        case AnimationStatus.reverse:
          {
            if (model.bottomCartStatus == BottomCartStatus.forward)
              bottomCartController.forward();
            if (model.bottomCartStatus == BottomCartStatus.reverse)
              bottomCartController.reverse();
          }
          break;
        case AnimationStatus.completed:
          {
            if (model.bottomCartStatus == BottomCartStatus.forward)
              bottomCartController.forward();
            if (model.bottomCartStatus == BottomCartStatus.reverse)
              bottomCartController.reverse();
          }
          break;
        default:
          break;
      }
    // model.log.i(
    //     'ResDetailsBottomCart AFTER model.bottomCartStatus: ${model.bottomCartStatus} and bottomCartController.status: ${bottomCartController.status}, bottomCartOffset: $bottomCartOffset');

    return Align(
      alignment: Alignment.bottomCenter,
      child: SlideTransition(
        position: bottomCartOffset,
        child: GestureDetector(
          onTap: model.isUpdateQuantity ? () {} : model.navToCartView,
          child: Container(
            height: 0.24.sw,
            width: 1.sw,
            decoration: BoxDecoration(
              color: kcWhiteColor,
              // boxShadow: [AppTheme().resBottomShadow],
              border: Border(
                top: BorderSide(
                  width: 0.5,
                  color: kcSecondaryDarkColor.withOpacity(0.25),
                ),
              ),
            ),
            child: Container(
              margin: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 15.h + 0.02.sw),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: kcPrimaryColor,
                borderRadius: AppTheme().radius10,
              ),
              alignment: Alignment.center,
              child: ResBottomCartTotalView(),
            ),
          ),
        ),
      ),
    );
  }
}
