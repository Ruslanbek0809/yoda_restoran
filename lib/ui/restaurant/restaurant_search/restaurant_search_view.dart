import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/shared/shared.dart';
import 'package:yoda_res/ui/restaurant/meal/meal_view.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import '../../../utils/utils.dart';
import 'res_search_hook.dart';
import 'restaurant_search_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RestaurantSearchView extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantSearchView({required this.restaurant, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double itemWidth = (1.sw - 12.w - 20.h) / 2;
    // (screenwidth - Gridview crossAxisSpacing * 2 - Gridview mainAxisSpacing * 2) / crossAxisCount
    double itemHeight = itemWidth + 0.31.sw; // 0.31.sw is for item height

    return ViewModelBuilder<RestaurantSearchViewModel>.reactive(
      viewModelBuilder: () => RestaurantSearchViewModel(restaurant.id!),
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: () async {
            model.navBack(); // Workaround
            return false;
          },
          child: Scaffold(
            backgroundColor: kcWhiteColor,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: kcWhiteColor,
              elevation: 0.5,
              titleSpacing: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: kcFontColor,
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
                            Icons.search_rounded,
                            size: 22.w,
                            color: kcDividerColor,
                          ),
                          onPressed: () {},
                        )
                      : IconButton(
                          tooltip: 'Clear',
                          // tooltip: i18n(currentLang, ki18nClearCart),
                          icon: Icon(
                            Icons.clear_rounded,
                            size: 22.w,
                            color: kcDividerColor,
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
            body: model.searchMealss.isEmpty || model.hasError
                ? EmptyWidget(
                    text: '',
                    // text: LocaleKeys.nothingFound,
                    svg: 'assets/empty_search.svg',
                  )
                : model.isBusy
                    ? LoadingWidget()
                    : GridView.builder(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          vertical: 12.h,
                          horizontal: 10.w,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10.h, //spaceTopBottom
                          crossAxisSpacing: 6.w, //spaceLeftRight
                          childAspectRatio: itemWidth / itemHeight,
                        ),
                        itemCount: model.searchMealss.length,
                        itemBuilder: (context, pos) {
                          return MealView(
                            meal: model.searchMealss[pos]!,
                            restaurant: restaurant,
                          );
                        },
                      ),
          ),
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