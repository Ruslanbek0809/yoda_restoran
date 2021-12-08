import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yoda_res/utils/utils.dart';

void restaurantInfoBottomSheet(BuildContext context) {
  showModalBottomSheet(
    enableDrag: true,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(Constants.BORDER_RADIUS_20),
      ),
    ),
    backgroundColor: Colors.transparent,
    context: context,
    builder: (ctx) => DraggableScrollableSheet(
      initialChildSize: 0.47,
      maxChildSize: 0.95,
      builder: (context, scrollController) => RestaurantInfoBottomSheetWidget(
        scrollController,
      ),
    ),
  );
}

class RestaurantInfoBottomSheetWidget extends StatefulWidget {
  final ScrollController scrollController;
  RestaurantInfoBottomSheetWidget(this.scrollController);

  @override
  _RestaurantInfoBottomSheetWidgetState createState() =>
      _RestaurantInfoBottomSheetWidgetState();
}

class _RestaurantInfoBottomSheetWidgetState
    extends State<RestaurantInfoBottomSheetWidget>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Constants.BORDER_RADIUS_20),
        ),
        color: AppTheme.WHITE,
      ),
      child: SingleChildScrollView(
        controller: widget.scrollController,
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --------------- BOTTOM SHEET DRAGGER -------------- //
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.w),
              child: SvgPicture.asset(
                'assets/bottom_sheet_dragger.svg',
                color: AppTheme.MAIN_LIGHT,
                height: 8.w,
                width: 20.w,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(Constants.BORDER_RADIUS_20),
                ),
                color: AppTheme.WHITE,
              ),
              padding: EdgeInsets.fromLTRB(16.w, 5.w, 16.w, 35.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --------------- NAME -------------- //
                  Text(
                    'Kebapçy',
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.MAIN_DARK,
                    ),
                  ),
                  SizedBox(height: 15.w),
                  // --------------- NAME -------------- //
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/map_pin.svg',
                        color: AppTheme.MAIN_DARK,
                        width: 25.w,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        'Alişer Nowaýy köç. 171',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppTheme.FONT_COLOR,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.w),
                  Divider(
                    thickness: 1,
                    color: AppTheme.DRAWER_DIVIDER,
                  ),
                  SizedBox(height: 10.w),
                  Text(
                    'Sargyt alýan wagty: 10:00 - 22:00',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppTheme.FONT_COLOR,
                    ),
                  ),
                  SizedBox(height: 10.w),
                  Divider(
                    thickness: 1,
                    color: AppTheme.DRAWER_DIVIDER,
                  ),
                  SizedBox(height: 10.w),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Amet commodo nulla facilisi nullam vehicula ipsum a arcu.',
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
    );
  }
}
