import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/shared/app_colors.dart';
import 'package:yoda_res/shared/shared.dart';
import '../../widgets/widgets.dart';
import '../../../utils/utils.dart';
import 'home_search_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'search_box.dart';

class HomeSearchView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeSearchViewModel>.reactive(
      builder: (context, model, child) => Padding(
        padding: const EdgeInsets.only(top: kToolbarHeight / 4),
        child: Semantics(
          explicitChildNodes: true,
          scopesRoute: true,
          namesRoute: true,
          child: Scaffold(
            backgroundColor: AppTheme.WHITE,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: AppTheme.WHITE,
              elevation: 0.5,
              titleSpacing: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: AppTheme.FONT_COLOR,
                  size: 20.w,
                ),
                onPressed: () {},
              ),
              title: SearchBox(),
              actions: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: model.searchText!.isEmpty
                      ? IconButton(
                          tooltip: 'Search',
                          // tooltip: i18n(currentLang, ki18nSearch),
                          icon: Icon(
                            Icons.search,
                            size: 22.w,
                            color: AppTheme.DRAWER_DIVIDER,
                          ),
                          onPressed: () {},
                        )
                      : IconButton(
                          tooltip: 'Clear',
                          // tooltip: i18n(currentLang, ki18nClearCart),
                          icon: Icon(
                            Icons.clear,
                            size: 22.w,
                            color: AppTheme.DRAWER_DIVIDER,
                          ),
                          onPressed: () {
                            FocusScope.of(context)
                                .unfocus(); // UNFOCUSES all textfield b4 clear
                            model.clearSearch();
                          },
                        ),
                ),
              ],
            ),
            //------------------ ListView builder ---------------------//
            body: model.searchRestaurants.isEmpty
                ? EmptyWidget(
                    text: 'Hiç zat tapylmady',
                    svg: 'assets/empty_search.svg',
                    leftPadding: 0.12.sw,
                  )
                : model.isBusy
                    ? LoadingWidget()
                    : model.hasError
                        ? ViewErrorWidget()
                        : ListView.builder(
                            padding: EdgeInsets.only(top: 10.h),
                            itemCount: model.searchRestaurants.length,
                            itemBuilder: (ctx, pos) {
                              var _searchRestaurant =
                                  model.searchRestaurants[pos];
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //------------------ RESTAURANT PART ---------------------//
                                    GestureDetector(
                                      onTap: () {},
                                      child: Row(
                                        children: [
                                          //------------------ IMAGE ---------------------//
                                          Flexible(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12.w),
                                              child: YodaImage(
                                                image:
                                                    _searchRestaurant!.image!,
                                                height: 35.h,
                                                width: 35.h,
                                                borderRadius:
                                                    Constants.BORDER_RADIUS_10,
                                              ),
                                            ),
                                          ),
                                          //------------------ NAME and ADDRESS ---------------------//
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  _searchRestaurant.name!,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 22.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: kcSecondaryDarkColor,
                                                  ),
                                                ),
                                                SizedBox(height: 3.h),
                                                Text(
                                                  _searchRestaurant.address!,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: kts14HelperText,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //------------------ RESTAURANT MEALS ---------------------//
                                    ListView.separated(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.only(
                                          top: 15.h, left: 24.w + 35.h),
                                      itemCount:
                                          _searchRestaurant.meals!.length,
                                      itemBuilder: (context, pos) =>
                                          GestureDetector(
                                        onTap: () {},
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              mealList[pos].name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 18.sp,
                                                color: AppTheme.FONT_COLOR,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: 16.w, left: 5.w),
                                              child: Text(
                                                mealList[pos].price.toString() +
                                                    ' TMT',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppTheme.FONT_COLOR,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      separatorBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5.h),
                                          child: Divider(
                                            thickness: 0.5,
                                            color: AppTheme
                                                .DRAWER_SECOND_DIVIDER_COLOR,
                                          ),
                                        );
                                      },
                                    ),
                                    //------------------ FOOD MORE ---------------------//
                                    GestureDetector(
                                      onTap: () {},
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          left: 24.w + 35.h,
                                          top: 15.h,
                                          bottom: 5.h,
                                        ),
                                        child: Text(
                                          'Ýene ' + '${mealList.length - 3}',
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            color: AppTheme.DRAWER_ICON,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
            // AnimatedSwitcher(
            //   duration: const Duration(milliseconds: 300),
            //   reverseDuration: const Duration(milliseconds: 300),
            //   child: _showProductsResult
            //       ? SizedBox() // In production change to SearchProductsResultWidget()
            //       // SearchProductsResultWidget(
            //       //     searchName: _searchKeyword,
            //       //   )
            //       : Align(
            //           alignment: Alignment.topCenter,
            //           child:
            //               SizedBox() // In production change to RecentSearchesWidget()
            //           // RecentSearchesWidget(onTap: _onSubmitCallBack),
            //           ),
            // ),
          ),
        ),
      ),
      viewModelBuilder: () => HomeSearchViewModel(),
    );
  }
}
