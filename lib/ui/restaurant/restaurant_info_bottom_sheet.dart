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
          color: kcWhiteColor,
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
                  color: kcSecondaryLightColor,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(Constants.BORDER_RADIUS_20),
                  ),
                  color: kcWhiteColor,
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
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.MAIN_DARK,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // --------------- NAME -------------- //
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
                              color: AppTheme.FONT_COLOR,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 7.h),
                    Divider(
                      thickness: 0.5,
                      color: AppTheme.DRAWER_DIVIDER,
                    ),
                    SizedBox(height: 7.h),
                    Row(
                      children: [
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
                      style: ktsDefault14Text,
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
