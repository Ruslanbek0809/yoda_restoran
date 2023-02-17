import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import '../../../models/models.dart';
import '../../../shared/shared.dart';
import '../meal/meal_view.dart';
import 'fappbar.dart';
import 'res_details_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResDetailsMainHook extends HookViewModelWidget<ResDetailsViewModel> {
  final List<ResCategory> resCategories;
  ResDetailsMainHook({
    required this.resCategories,
    Key? key,
  }) : super(key: key);

  final listViewKey = RectGetter.createGlobalKey();
  Map<int, dynamic> itemKeys = {};

  List<int> getVisibleItemsIndex() {
    Rect? rect = RectGetter.getRectFromKey(listViewKey);
    List<int> items = [];
    if (rect == null) return items;
    itemKeys.forEach((index, key) {
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
      key: listViewKey,
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (model.pauseRectGetterIndex) return true;
          int lastTabIndex = tabController.length - 1;
          List<int> visibleItems = getVisibleItemsIndex();
          bool reachLastTabIndex = visibleItems.isNotEmpty &&
              visibleItems.length <= 2 &&
              visibleItems.last == lastTabIndex;
          if (reachLastTabIndex) {
            tabController.animateTo(lastTabIndex);
          } else if (visibleItems.isNotEmpty) {
            int sumIndex =
                visibleItems.reduce((value, element) => value + element);
            int middleIndex = sumIndex ~/ visibleItems.length;
            if (tabController.index != middleIndex)
              tabController.animateTo(middleIndex);
          }
          return false;
        },
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            FAppBar(
              restaurant: model.restaurant,
              resCategories: model.resCategories,
              context: context,
              scrollController: scrollController,
              expandedHeight: model.expandedHeight,
              collapsedHeight: model.collapsedHeight,
              isCollapsed: model.isCollapsed,
              onCollapsed: model.updateIsCollapsed,
              tabController: tabController,
              onTap: (index) {
                model.updatePauseRectGetterIndex(true);
                tabController.animateTo(index);
                scrollController
                    .scrollToIndex(index,
                        preferPosition: AutoScrollPosition.begin)
                    .then((value) => model.updatePauseRectGetterIndex(false));
              },
            ),
//*----------------- MEAL LIST ---------------------//
            SliverPadding(
              padding: EdgeInsets.only(
                  bottom: 0.11.sh), // COMPENSATES ResDetailsBottomCart height
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: model.resCategories.length,
                  (BuildContext context, int index) {
                    //! CONFIG scroll
                    itemKeys[index] = RectGetter.createGlobalKey();

                    final resCategory = model.resCategories[index];
                    final resCategoryMeals = resCategory.meals;

                    return RectGetter(
                      key: itemKeys[index],
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
