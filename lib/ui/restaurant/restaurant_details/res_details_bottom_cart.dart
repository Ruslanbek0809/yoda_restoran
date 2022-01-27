import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'res_bottom_cart/res_bottom_cart_total_view.dart';
import 'res_details_view_model.dart';
import '../../../utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResDetailsBottomCart extends HookViewModelWidget<ResDetailsViewModel> {
  const ResDetailsBottomCart({Key? key}) : super(key: key);

  @override
  Widget buildViewModelWidget(BuildContext context, ResDetailsViewModel model) {
    final bottomCartController = useAnimationController(
      duration: const Duration(milliseconds: 150),
    );
    final bottomCartOffset =
        Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero)
            .animate(bottomCartController);

    /// BottomCartController trigger
    if (model.bottomCartStatus != BottomCartStatus.idle)
      switch (bottomCartController.status) {
        case AnimationStatus.dismissed:
          {
            if (model.bottomCartStatus == BottomCartStatus.forward)
              bottomCartController.forward();
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
              color: AppTheme.WHITE,
              boxShadow: [AppTheme().bottomCartShadow],
            ),
            child: Container(
              margin: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 15.h + 0.02.sw),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: AppTheme.MAIN,
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
