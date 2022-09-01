import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import 'package:yoda_res/shared/shared.dart';
import '../../../models/models.dart';
import '../../../utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../widgets/widgets.dart';

class RestaurantInfoBottomSheet extends StatelessWidget {
  final ScrollController scrollController;
  final double offset;
  final Restaurant restaurant;
  const RestaurantInfoBottomSheet({
    Key? key,
    required this.scrollController,
    required this.offset,
    required this.restaurant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Below part COMBINES all paymentTypes' name and displays it
    String paymentTypesText = '';
    if (restaurant.paymentTypes != null) {
      if (context.locale == context.supportedLocales[0])
        paymentTypesText = restaurant.paymentTypes![0].nameTk!;
      else
        paymentTypesText = restaurant.paymentTypes![0].nameRu!;
    }
    if (restaurant.paymentTypes != null)
      for (int i = 1; i < restaurant.paymentTypes!.length; i++)
        if (context.locale == context.supportedLocales[0])
          paymentTypesText += ', ${restaurant.paymentTypes![i].nameTk!}';
        else
          paymentTypesText += ', ${restaurant.paymentTypes![i].nameRu!}';

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
          // --------------- CUSTOM BOTTOM SHEET MODAL WIDGET -------------- //
          CustomModalInsideBottomSheet(
            isOuterPaddingExist: true,
            leftOuterPadding: 16.w,
            rightOuterPadding: 16.w,
          ),

          // --------------- NAME -------------- //
          Text(
            restaurant.name!,
            maxLines: 2,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: kcSecondaryDarkColor,
            ),
          ),
          SizedBox(height: 12.h),
          // --------------- ADDRESS -------------- //
          Row(
            children: [
              SvgPicture.asset(
                'assets/map_pin_bold.svg',
                color: kcSecondaryDarkColor,
                width: 22.w,
              ),
              SizedBox(width: 5.w),
              Flexible(
                child: Text(
                  restaurant.address!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: kcFontColor,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 7.h),
            child: Divider(
              thickness: 0.5,
              color: AppTheme.DRAWER_DIVIDER,
            ),
          ),
          // --------------- WORKING HOURS -------------- //
          Row(
            children: [
              SvgPicture.asset(
                'assets/clock.svg',
                color: kcSecondaryDarkColor,
                width: 22.w,
              ),
              SizedBox(width: 5.w),
              Text(
                LocaleKeys.workingHours,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: kcFontColor,
                ),
              ).tr(),
              Text(
                ': ${restaurant.workingHours}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: kcFontColor,
                ),
              ),
            ],
          ),
          if (restaurant.paymentTypes != null)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 7.h),
              child: Divider(
                thickness: 0.5,
                color: AppTheme.DRAWER_DIVIDER,
              ),
            ),
          if (restaurant.paymentTypes != null)
            Row(
              children: [
                SvgPicture.asset(
                  'assets/wallet.svg',
                  color: kcSecondaryDarkColor,
                  width: 22.w,
                ),
                SizedBox(width: 5.w),
                Text(
                  LocaleKeys.paymentType,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: kcFontColor,
                  ),
                ).tr(),
                Text(
                  paymentTypesText,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: kcFontColor,
                  ),
                ),
              ],
            ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Divider(
              thickness: 0.5,
              color: AppTheme.DRAWER_DIVIDER,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 22.h),
            child: Text(
              restaurant.description!,
              style: kts14Text,
            ),
          ),
        ],
      ),
    );
  }
}
