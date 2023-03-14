import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shimmer/shimmer.dart';
import '../../../shared/shared.dart';
import '../../widgets/widgets.dart';
import '../../../utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MealItemShimmerHook extends HookWidget {
  const MealItemShimmerHook({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double itemWidth = (1.sw - 12.w - 20.h) / 2;
    // (screenwidth - Gridview crossAxisSpacing * 2 - Gridview mainAxisSpacing * 2) / crossAxisCount
    double itemHeight = itemWidth + 0.15.sh; // 0.15.sh is for item height

    Tween<double> _tween = Tween(begin: 1, end: 0.98);
    final _tweenController = useAnimationController(
      duration: const Duration(milliseconds: 100),
    );

    //*To dispose a status listener attached to _tweenController
    useEffect(() {
      void _listenerStatus(AnimationStatus status) {
        // This listener was used to repeat animation once
        if (status == AnimationStatus.completed) {
          _tweenController.reverse();
        }
      }

      _tweenController..addStatusListener(_listenerStatus);
      return () => _tweenController.removeStatusListener(_listenerStatus);
    }, [_tweenController]);

    return ScaleTransition(
      scale: _tween.animate(
        CurvedAnimation(
          parent: _tweenController,
          curve: Curves.bounceInOut,
        ),
      ),
      child: GestureDetector(
        onTap: () async => await _tweenController.forward(),
        child: Container(
          width: itemWidth,
          height: itemHeight,
          decoration: BoxDecoration(
            color: kcSecondaryLightColor,
            borderRadius: AppTheme().radius20,
          ),
          padding: EdgeInsets.fromLTRB(6.w, 6.h, 6.w, 6.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //*----------------- IMAGE SHIMMER ---------------------//
              Container(
                height: itemWidth,
                width: itemWidth,
                decoration: BoxDecoration(
                  color: kcWhiteColor,
                  borderRadius: AppTheme().radius20,
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    YodaImage(
                      image: 'assets/ph_product.png',
                      height: itemWidth,
                      width: itemWidth,
                      borderRadius: Constants.BORDER_RADIUS_20,
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[200]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: itemWidth,
                        width: itemWidth,
                        decoration: BoxDecoration(
                          color: kcWhiteColor.withOpacity(0.4),
                          borderRadius: AppTheme().radius20,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              //*----------------- NAME SHIMMER ---------------------//
              Padding(
                padding: EdgeInsets.only(
                  top: 5.h,
                  bottom: 2.h,
                  left: 2.w,
                  right: 2.w,
                ),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[200]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: itemWidth * 0.09,
                    width: itemWidth * 0.75,
                    decoration: BoxDecoration(
                      color: kcWhiteColor,
                      borderRadius: AppTheme().radius5,
                    ),
                  ),
                ),
              ),
              //*----------------- PRICE SHIMMER ---------------------//
              Padding(
                padding: EdgeInsets.only(
                  left: 2.w,
                  right: 2.w,
                ),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[200]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: itemWidth * 0.075,
                    width: itemWidth * 0.9,
                    decoration: BoxDecoration(
                      color: kcWhiteColor,
                      borderRadius: AppTheme().radius5,
                    ),
                  ),
                ),
              ),
              Spacer(),
              //*----------------- BUTTON SHIMMER ---------------------//
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[200]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: itemWidth,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    decoration: BoxDecoration(
                      color: kcWhiteColor,
                      borderRadius: AppTheme().radius10,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
