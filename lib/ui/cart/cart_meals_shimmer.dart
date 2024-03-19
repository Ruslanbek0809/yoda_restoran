import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../shared/shared.dart';
import '../../utils/utils.dart';
import '../widgets/widgets.dart';

class CartMealsShimmerWidget extends StatelessWidget {
  CartMealsShimmerWidget({
    required this.cartMealsLength,
    super.key,
  });
  int cartMealsLength;

  @override
  Widget build(BuildContext context) {
    double itemWidth = 0.35.sw + 10.w;

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(
        top: 20.h,
        left: 16.w,
        right: 16.w,
      ),
      itemCount: cartMealsLength,
      itemBuilder: (context, pos) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 0.3.sw,
              width: 0.3.sw,
              decoration: BoxDecoration(
                color: kcWhiteColor,
                borderRadius: AppTheme().radius20,
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  YodaImage(
                    image: 'assets/ph_product.png',
                    height: 0.3.sw,
                    width: 0.3.sw,
                    borderRadius: Constants.BORDER_RADIUS_10,
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[200]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 0.3.sw,
                      width: 0.3.sw,
                      decoration: BoxDecoration(
                        color: kcWhiteColor.withOpacity(0.4),
                        borderRadius: AppTheme().radius20,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                height: 0.3.sw,
                padding: EdgeInsets.only(left: 10.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[200]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              height: 20,
                              width: 0.2.sw,
                              decoration: BoxDecoration(
                                color: kcWhiteColor,
                                borderRadius: AppTheme().radius5,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 24.w),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[200]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              height: 22,
                              width: 0.1.sw,
                              decoration: BoxDecoration(
                                color: kcWhiteColor,
                                borderRadius: AppTheme().radius5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[200]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 18,
                        width: itemWidth * 0.9,
                        decoration: BoxDecoration(
                          color: kcWhiteColor,
                          borderRadius: AppTheme().radius5,
                        ),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 2.w, right: 2.w, bottom: 2.h),
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
          ],
        );
      },
      separatorBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 5.h),
          child: Divider(
            thickness: 1,
            color: kcDividerColor.withOpacity(0.5),
          ),
        );
      },
    );
  }
}
