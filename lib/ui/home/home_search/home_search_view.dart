import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import 'package:yoda_res/models/restaurant.dart';
import 'package:yoda_res/shared/shared.dart';
import '../../widgets/widgets.dart';
import '../../../utils/utils.dart';
import 'home_search_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'home_search_hook.dart';

class HomeSearchView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeSearchViewModel>.reactive(
      builder: (context, model, child) {
        model.log.v('model.isBusy: ${model.isBusy}');

        return Padding(
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
                  onPressed: model.navBack,
                ),
                title: HomeSearchHook(),
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
                      text: LocaleKeys.nothingFound,
                      svg: 'assets/empty_search.svg',
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //------------------ RESTAURANT PART ---------------------//
                                      GestureDetector(
                                        onTap: () => model
                                            .navToResDetailsView(Restaurant(
                                          id: _searchRestaurant!.id,
                                          image: _searchRestaurant.image,
                                          name: _searchRestaurant.name,
                                          address: _searchRestaurant.address,
                                          rated: _searchRestaurant.rated,
                                          rating: _searchRestaurant.rating,
                                          workingHours:
                                              _searchRestaurant.workingHours,
                                          deliveryPrice:
                                              _searchRestaurant.deliveryPrice,
                                          description:
                                              _searchRestaurant.description,
                                          phoneNumber:
                                              _searchRestaurant.phoneNumber,
                                          prepareTime:
                                              _searchRestaurant.prepareTime,
                                        )),
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
                                                  borderRadius: Constants
                                                      .BORDER_RADIUS_10,
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
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          kcSecondaryDarkColor,
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
                                      if (_searchRestaurant.meals != null)
                                        ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.only(
                                              top: 15.h, left: 24.w + 35.h),
                                          itemCount: _searchRestaurant.meals!
                                              .take(3)
                                              .toList()
                                              .length,
                                          itemBuilder: (context, pos) {
                                            var _meal =
                                                _searchRestaurant.meals![pos];
                                            return GestureDetector(
                                              onTap: () =>
                                                  model.navToResDetailsView(
                                                      Restaurant(
                                                id: _searchRestaurant.id,
                                                image: _searchRestaurant.image,
                                                name: _searchRestaurant.name,
                                                address:
                                                    _searchRestaurant.address,
                                                rated: _searchRestaurant.rated,
                                                rating:
                                                    _searchRestaurant.rating,
                                                workingHours: _searchRestaurant
                                                    .workingHours,
                                                deliveryPrice: _searchRestaurant
                                                    .deliveryPrice,
                                                description: _searchRestaurant
                                                    .description,
                                                phoneNumber: _searchRestaurant
                                                    .phoneNumber,
                                                prepareTime: _searchRestaurant
                                                    .prepareTime,
                                              )),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    _meal.name!,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 18.sp,
                                                      color:
                                                          AppTheme.FONT_COLOR,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 16.w, left: 5.w),
                                                    child: Text(
                                                      _meal.discount != null ||
                                                              _meal.discount! >
                                                                  0
                                                          ? '${_meal.discountedPrice!.toInt()} TMT'
                                                          : '${_meal.price!.toInt()} TMT',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: ktsDefault16Text,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
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
                                      //------------------ MEAL MORE ---------------------//
                                      if (_searchRestaurant.meals != null &&
                                          _searchRestaurant.meals!.length > 3)
                                        GestureDetector(
                                          onTap: () {},
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              left: 24.w + 35.h,
                                              top: 15.h,
                                              bottom: 5.h,
                                            ),
                                            child: Text(
                                              'Ýene ' +
                                                  '${model.searchRestaurants.length - 3}',
                                              style: ktsDefault18HelperText,
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
        );
      },
      viewModelBuilder: () => HomeSearchViewModel(),
    );
  }
}
