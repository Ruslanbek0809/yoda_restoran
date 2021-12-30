import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/ui/toggle_buttons/toggle_buttons_view.dart';
import 'package:yoda_res/ui/widgets/loading_widget.dart';
import 'package:yoda_res/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResDetailsMainBusy extends StatelessWidget {
  final Restaurant restaurant;
  const ResDetailsMainBusy({required this.restaurant, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        //------------------ ARROW BACK ---------------------//
        SliverAppBar(
          expandedHeight: 0.55.sh,
          pinned: true,
          stretch: true,
          floating: false,
          backgroundColor: AppTheme.WHITE,
          centerTitle: true,
          title: SizedBox(),
          leading: AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: Container(
              height: 50.w,
              width: 50.w,
              margin: EdgeInsets.only(left: 10.w, top: 5.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.WHITE,
              ),
              child: Material(
                color: AppTheme.WHITE,
                shape: CircleBorder(),
                elevation: 0,
                child: InkWell(
                  customBorder: CircleBorder(),
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back,
                    size: 27.w,
                    color: AppTheme.BLACK,
                  ),
                ),
              ),
            ),
          ),
          //------------------ ACTIONS FAV ---------------------//
          actions: [
            Padding(
              padding: EdgeInsets.only(top: 5.w),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.WHITE,
                  // boxShadow: _isShrink
                  //     ? []
                  //     : [AppTheme().buttonShadow],
                ),
                child: Material(
                  shape: CircleBorder(),
                  elevation: 0,
                  color: AppTheme.WHITE,
                  child: InkWell(
                    customBorder: CircleBorder(),
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Icon(
                        Icons.favorite_outline_outlined,
                        size: 27.w,
                        color: AppTheme.BLACK,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
//------------------ ACTIONS SEARCH ---------------------//
            Padding(
              padding: EdgeInsets.only(top: 5.w),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.WHITE,
                  // boxShadow: _isShrink ? [] : [AppTheme().buttonShadow],
                ),
                child: Material(
                  shape: CircleBorder(),
                  elevation: 0,
                  color: AppTheme.WHITE,
                  child: InkWell(
                    customBorder: CircleBorder(),
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Icon(
                        Icons.search,
                        size: 27.w,
                        color: AppTheme.BLACK,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 15.w),
          ],
          //------------------ BACKGROUND RESTAURANT IMAGE ---------------------//
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: [StretchMode.zoomBackground],
            //// NOTE: Container background image used to add custom widget in front of this background image
            background: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(restaurant.image!),
                  fit: BoxFit.cover,
                  // AssetImage('assets/burgerlist.jpg'),
                ),
              ),
              //// NOTE: Instead of direct Container Column is used to make child work properly
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.WHITE,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    padding: EdgeInsets.only(top: 17.h, bottom: 50.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //------------------ TITLE NAME ---------------------//
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 10.h,
                            left: 16.w,
                            right: 16.w,
                          ),
                          child: Text(
                            restaurant.name!,
                            style: TextStyle(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.MAIN_DARK,
                            ),
                          ),
                        ),
                        //------------------ RATE / WORK TIME / INFO---------------------//
                        Row(
                          children: [
                            //------------------ RATE ---------------------//
                            Container(
                              decoration: BoxDecoration(
                                color: AppTheme.MAIN_LIGHT,
                                borderRadius: AppTheme().radius20,
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 7.h),
                              margin: EdgeInsets.only(
                                top: 5.w,
                                bottom: 5.w,
                                left: 16.w,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star_rounded,
                                    color: AppTheme.MAIN_DARK,
                                    size: 22.w,
                                  ),
                                  SizedBox(width: 3.w),
                                  Text(
                                    restaurant.rating.toString(),
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      color: AppTheme.FONT_COLOR,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //------------------ WORK TIME ---------------------//
                            Container(
                              decoration: BoxDecoration(
                                color: AppTheme.MAIN_LIGHT,
                                borderRadius: AppTheme().radius20,
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 7.h),
                              margin: EdgeInsets.symmetric(
                                  vertical: 5.h, horizontal: 10.w),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.access_time_rounded,
                                    color: AppTheme.MAIN_DARK,
                                    size: 22.w,
                                  ),
                                  SizedBox(width: 5.w),
                                  Text(
                                    restaurant.workingHours!,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: AppTheme.FONT_COLOR,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // //------------------ INFO ---------------------//
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppTheme.MAIN_LIGHT,
                                  shape: BoxShape.circle,
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.w, vertical: 5.h),
                                child: SvgPicture.asset(
                                  'assets/restaurant_info.svg',
                                  color: AppTheme.MAIN_DARK,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 8.h,
                            horizontal: 16.w,
                          ),
                          child: Divider(
                            color: AppTheme.MAIN_LIGHT,
                            thickness: 1.w,
                          ),
                        ),
//------------------ DELIVERY/SELF-PICKUP ---------------------//
                        IgnorePointer(
                          child: ToggleButtonView(),
                        ),
                        SizedBox(height: 23.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
//------------------ FOOD LIST with NAME ---------------------//
        SliverToBoxAdapter(
          child: LoadingWidget(),
        ),
      ],
    );
  }
}
