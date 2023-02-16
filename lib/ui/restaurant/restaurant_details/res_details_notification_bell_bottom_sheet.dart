import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../../../models/models.dart';
import '../../../shared/shared.dart';
import '../../../utils/utils.dart';
import '../../widgets/widgets.dart';

class ResDetailsNotificationBellBottomSheet extends StatelessWidget {
  final ScrollController scrollController;
  final double offset;
  final Restaurant restaurant;
  const ResDetailsNotificationBellBottomSheet({
    Key? key,
    required this.scrollController,
    required this.offset,
    required this.restaurant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: kcWhiteColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Constants.BORDER_RADIUS_20),
        ),
      ),
      child: ListView(
        controller: scrollController,
        shrinkWrap: true,
        children: [
          //*-------------- CUSTOM BOTTOM SHEET MODAL WIDGET -------------- //
          CustomModalInsideBottomSheet(
            isOuterPaddingExist: true,
            leftOuterPadding: 16.w,
            rightOuterPadding: 16.w,
          ),

          //*-------------- NAME -------------- //
          Text(
            restaurant.name ?? '',
            maxLines: 2,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: kcSecondaryDarkColor,
            ),
          ),
          SizedBox(height: 12.h),
          //*-------------- ADDRESS -------------- //
          Padding(
            padding: EdgeInsets.only(bottom: 0.05.sh),
            child: Row(
              children: [
                Lottie.asset(
                  'assets/bell.json',
                  width: 22.r,
                  animate: false,
                ),
                SizedBox(width: 5.r),
                Flexible(
                  child: Text(
                    restaurant.notification ?? '',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: kcFontColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
