import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:yoda_res/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'home_view_model.dart';

class HomeViewBottomCart extends HookViewModelWidget<HomeViewModel> {
  const HomeViewBottomCart({Key? key}) : super(key: key);

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
          onTap: () {
            // Navigator.of(context).pushNamed(RouteList.cart);
          },
          child: Container(
            height: 0.22.sw,
            width: 1.sw,
            decoration: BoxDecoration(color: AppTheme.WHITE, boxShadow: [
              AppTheme().bottomCartShadow,
            ]),
            child: Container(
              margin: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 15.w),
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              decoration: BoxDecoration(
                color: AppTheme.MAIN,
                borderRadius: AppTheme().radius10,
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Restoran ady',
                    style: TextStyle(
                      color: AppTheme.WHITE,
                      fontSize: 20.sp,
                    ),
                  ),
                  Text(
                    '35 TMT',
                    style: TextStyle(
                      color: AppTheme.WHITE,
                      fontSize: 18.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
