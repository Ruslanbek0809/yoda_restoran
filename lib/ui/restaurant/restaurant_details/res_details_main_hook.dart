import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import '../../../shared/shared.dart';
import '../meal/meal_view.dart';
import 'res_details_appbar.dart';
import 'res_details_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResDetailsMainHook extends HookViewModelWidget<ResDetailsViewModel> {
  ResDetailsMainHook({
    Key? key,
  }) : super(key: key);

  final resDetailsRectGetterKey = RectGetter.createGlobalKey();
  Map<int, dynamic> resCategoriesRectGetterKey = {};

  //* GETS visible res category and its meals index
  List<int> getVisibleResCategoryAndItsMealsIndex() {
    Rect? rect = RectGetter.getRectFromKey(resDetailsRectGetterKey);
    List<int> items = [];
    if (rect == null) return items;
    resCategoriesRectGetterKey.forEach((index, key) {
      Rect? itemRect = RectGetter.getRectFromKey(key);
      if (itemRect == null) return;
      if (itemRect.top > rect.bottom) return;
      if (itemRect.bottom < rect.top) return;
      items.add(index);
    });
    return items;
  }

  @override
  Widget buildViewModelWidget(BuildContext context, ResDetailsViewModel model) {
    double itemWidth = (1.sw - 12.w - 20.h) / 2;
    // (screenwidth - Gridview crossAxisSpacing * 2 - Gridview mainAxisSpacing * 2) / crossAxisCount
    double itemHeight = itemWidth + 0.15.sh; // 0.15.sh is for item height

    //*------------- TAB CONTROLLER ----------------//
    final tabController = useTabController(
      initialLength: model.resCategories.length,
      initialIndex: model.activeTab,
    );

    //*------------- CUSTOM SCROLL CONTROLLER ----------------//
    AutoScrollController? useAutoScrollController() {
      final scrollController = useMemoized(() => AutoScrollController());
      useEffect(() => scrollController.dispose, const []);
      useListenable(scrollController);
      return scrollController;
    }

    AutoScrollController scrollController = useAutoScrollController()!;

    return RectGetter(
      key: resDetailsRectGetterKey,
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (model.pauseRectGetterIndex) return true;
          int lastTabIndex = tabController.length - 1;
          List<int> visibleResCategoryAndItsMealsIndex =
              getVisibleResCategoryAndItsMealsIndex();
          bool reachLastTabIndex =
              visibleResCategoryAndItsMealsIndex.isNotEmpty &&
                  visibleResCategoryAndItsMealsIndex.length <= 2 &&
                  visibleResCategoryAndItsMealsIndex.last == lastTabIndex;
          if (reachLastTabIndex) {
            tabController.animateTo(lastTabIndex);
          } else if (visibleResCategoryAndItsMealsIndex.isNotEmpty) {
            int sumIndex = visibleResCategoryAndItsMealsIndex
                .reduce((value, element) => value + element);
            int middleIndex =
                sumIndex ~/ visibleResCategoryAndItsMealsIndex.length;
            if (tabController.index != middleIndex)
              tabController.animateTo(middleIndex);
          }
          return false;
        },
        child: CustomScrollView(
          // physics: BouncingScrollPhysics(),
          physics: AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          slivers: [
//*----------------- SLIVER HEADER ---------------------//
            ResDetailsAppBar(
              context: context,
              model: model,
              resCategories: model.resCategories,
              scrollController: scrollController,
              expandedHeight: 0.55.sh,
              // expandedHeight: model.expandedHeight,
              collapsedHeight: model.collapsedHeight,
              isCollapsed: model.isCollapsed,
              activeTab: model.activeTab,
              isTabPressed: model.isTabPressed,
              onCollapsed: model.updateIsCollapsed,
              tabController: tabController,
              onTap: (index) {
                model.updateActiveTab(index); //* From OLD
                model.updateOnTapRipple();
                model.updatePauseRectGetterIndex(true);
                tabController.animateTo(index);
                scrollController
                    .scrollToIndex(index,
                        preferPosition: AutoScrollPosition.begin)
                    .then((value) => model.updatePauseRectGetterIndex(false));
                model.updateOnTapRipple();
              },
            ),
//*----------------- MEAL LIST ---------------------//
            SliverPadding(
              padding: EdgeInsets.only(
                bottom: 0.11.sh,
              ), // COMPENSATES ResDetailsBottomCart height
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: model.resCategories.length,
                  (BuildContext context, int index) {
                    //! CONFIG scroll
                    resCategoriesRectGetterKey[index] =
                        RectGetter.createGlobalKey();

                    final resCategory = model.resCategories[index];
                    final resCategoryMeals = resCategory.meals;

                    return RectGetter(
                      key: resCategoriesRectGetterKey[index],
                      child: AutoScrollTag(
                        key: ValueKey(index),
                        index: index,
                        controller: scrollController,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 12.w, top: 25.h),
                              child: Text(
                                resCategory.resCategoryModel?.name ?? '',
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                  color: kcSecondaryDarkColor,
                                ),
                              ),
                            ),

                            // Container(
                            //   alignment: Alignment.centerLeft,
                            //   padding: EdgeInsets.only(left: 12.w, top: 12.h),
                            //   child: Text(
                            //     resCategory.resCategoryModel?.name ?? '',
                            //     style: TextStyle(
                            //       fontSize: 22.sp,
                            //       fontWeight: FontWeight.bold,
                            //       color: kcSecondaryDarkColor,
                            //     ),
                            //   ),
                            // ),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                vertical: 12.h,
                                horizontal: 10.w,
                              ),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10.h, //spaceTopBottom
                                crossAxisSpacing: 6.w, //spaceLeftRight
                                childAspectRatio: itemWidth / itemHeight,
                              ),
                              itemCount: resCategoryMeals!.length,
                              itemBuilder: (context, pos) {
                                return MealView(
                                  meal: resCategoryMeals[pos],
                                  restaurant: model.restaurant,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
