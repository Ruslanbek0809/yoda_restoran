import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../shared/shared.dart';
import '../../widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/utils.dart';

class CartMoreMealsShimmerWidget extends StatelessWidget {
  const CartMoreMealsShimmerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double itemWidth = 0.35.sw + 10.w;
    // (screenwidth - Gridview crossAxisSpacing * 2 - Gridview mainAxisSpacing * 2) / crossAxisCount
    double itemHeight = itemWidth * 1.75; // 0.32.sw is for item height

    return Padding(
      padding: EdgeInsets.only(left: 12.w, right: 12.w),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...List.generate(
              3,
              (pos) {
                return Padding(
                  padding: EdgeInsets.only(
                      right: 4.w, left: 4.w), // For proper padding
                  child: Container(
                    width: itemWidth,
                    height: itemHeight,
                    decoration: BoxDecoration(
                      color: kcSecondaryLightColor,
                      borderRadius: AppTheme().radius20,
                    ),
                    padding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 5.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        Padding(
                          padding: EdgeInsets.only(
                            top: 4.h,
                            bottom: 4.h,
                            left: 4.w,
                            right: 4.w,
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
                        Padding(
                          padding: EdgeInsets.only(left: 4.w, right: 4.w),
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
                        Padding(
                          padding: EdgeInsets.only(
                              left: 2.w, right: 2.w, bottom: 2.h),
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
