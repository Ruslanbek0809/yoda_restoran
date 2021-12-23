import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:yoda_res/shared/shared.dart';
import 'package:yoda_res/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'home_view_model.dart';

class HomeBottomCart extends HookViewModelWidget<HomeViewModel> {
  const HomeBottomCart({Key? key}) : super(key: key);

  @override
  Widget buildViewModelWidget(BuildContext context, HomeViewModel model) {
    final bottomCartController = useAnimationController(
      duration: const Duration(milliseconds: 150),
    );
    final bottomCartOffset =
        Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero)
            .animate(bottomCartController);

    /// BottomCartController trigger
    if (model.bottomCartStatus != BottomCartStatus.idle)
      switch (bottomCartController.status) {
        case AnimationStatus.completed:
          if (model.bottomCartStatus == BottomCartStatus.reverse)
            bottomCartController.reverse();
          break;
        case AnimationStatus.dismissed:
          if (model.bottomCartStatus == BottomCartStatus.forward)
            bottomCartController.forward();
          break;
        default:
      }

    return Align(
      alignment: Alignment.bottomCenter,
      child: SlideTransition(
        position: bottomCartOffset,
        child: GestureDetector(
          onTap: () {},
          child: Container(
            height: 0.22.sw,
            width: 1.sw,
            decoration: BoxDecoration(
              color: AppTheme.WHITE,
              boxShadow: [AppTheme().bottomCartShadow],
            ),
            child: Container(
              margin: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 15.h),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: AppTheme.MAIN,
                borderRadius: AppTheme().radius10,
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(model.cartRes!.name!, style: ktsButton18Text),
                  Text('35 TMT', style: ktsButton18Text),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
