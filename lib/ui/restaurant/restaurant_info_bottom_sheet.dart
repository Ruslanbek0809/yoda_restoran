import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import 'package:yoda_res/shared/shared.dart';
import '../../models/models.dart';
import '../../utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';

class RestaurantInfoBottomSheet extends StatelessWidget {
  final Restaurant restaurant;
  final SheetRequest request;
  final Function(SheetResponse) completer;
  const RestaurantInfoBottomSheet({
    Key? key,
    required this.restaurant,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.45,
      maxChildSize: 1,
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Constants.BORDER_RADIUS_20),
          ),
          color: kcSecondaryLightColor,
        ),
        child: SingleChildScrollView(
          controller: scrollController,
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --------------- BOTTOM SHEET DRAGGER -------------- //
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: SvgPicture.asset(
                  'assets/bottom_sheet_dragger.svg',
                  color: kcSecondaryDarkColor,
                  height: 6.h,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(Constants.BORDER_RADIUS_20),
                  ),
                  color: kcSecondaryLightColor,
                ),
                padding: EdgeInsets.fromLTRB(16.w, 5.w, 16.w, 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --------------- NAME -------------- //
                    Text(
                      restaurant.name!,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.MAIN_DARK,
                      ),
                    ),
                    SizedBox(height: 15.h),
                    // --------------- NAME -------------- //
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/map_pin.svg',
                          color: AppTheme.MAIN_DARK,
                          width: 25.w,
                        ),
                        SizedBox(width: 5.w),
                        Flexible(
                          child: Text(
                            restaurant.address!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: AppTheme.FONT_COLOR,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Divider(
                      thickness: 0.5,
                      color: AppTheme.DRAWER_DIVIDER,
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Text(
                          LocaleKeys.workingHours,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppTheme.FONT_COLOR,
                          ),
                        ).tr(),
                        Text(
                          ': ${restaurant.workingHours}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppTheme.FONT_COLOR,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Divider(
                      thickness: 0.5,
                      color: AppTheme.DRAWER_DIVIDER,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      restaurant.description!,
                      maxLines: 5,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppTheme.FONT_COLOR,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
