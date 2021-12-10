import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:yoda_res/ui/restaurant/restaurant_details/restaurant_details_view_model.dart';
import 'package:yoda_res/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomCartWidget extends HookViewModelWidget<RestaurantDetailsViewModel> {
  const BottomCartWidget({Key? key}) : super(key: key);

  @override
  Widget buildViewModelWidget(
      BuildContext context, RestaurantDetailsViewModel model) {
    final bottomCartController = useAnimationController(
      duration: const Duration(milliseconds: 150),
    );

    final bottomCartOffset =
        Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero)
            .animate(bottomCartController);
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
                    'Sargyt',
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
