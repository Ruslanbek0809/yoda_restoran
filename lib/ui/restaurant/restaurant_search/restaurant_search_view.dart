import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import 'package:yoda_res/shared/shared.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import '../../home/home_search/home_search_hook.dart';
import '../../../utils/utils.dart';
import 'res_search_hook.dart';
import 'restaurant_search_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RestaurantSearchView extends StatelessWidget {
  final int resId;
  const RestaurantSearchView({required this.resId, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RestaurantSearchViewModel>.reactive(
      viewModelBuilder: () => RestaurantSearchViewModel(resId),
      builder: (context, model, child) {
        return Padding(
          padding: const EdgeInsets.only(top: kToolbarHeight / 4),
          child: Scaffold(
              backgroundColor: kcWhiteColor,
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
                title: ResSearchHook(),
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
                      : SizedBox()),
        );
      },
    );
  }
}


  //           //------------------ FOOD ListView builder ---------------------//
  //           body: GridView.builder(
  //             padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
  //             shrinkWrap: true,
  //             physics: NeverScrollableScrollPhysics(),
  //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //               crossAxisCount: 2,
  //               mainAxisSpacing: 12.h, //spaceTopBottom
  //               crossAxisSpacing: 8.w, //spaceLeftRight
  //               childAspectRatio: itemWidth / itemHeight,
  //             ),
  //             itemCount: mealList.length,
  //             itemBuilder: (context, pos) {
  //               // return FoodView(
  //               //   food: foodList[pos],
  //               //   animationController: widget.bottomCartController,
  //               // );
  //               return SizedBox(); // TODO: Change it to above one
  //             },
  //           ),