import 'dart:io';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../models/models.dart';
import '../../../shared/shared.dart';
import '../meal/meal_view.dart';
import '../../toggle_buttons/toggle_buttons_view.dart';
import '../../widgets/widgets.dart';
import '../../../utils/utils.dart';
import 'fappbar.dart';
import 'res_details_info_bottom_sheet.dart';
import 'res_details_notification_bell_bottom_sheet.dart';
import 'res_details_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class ResDetailsMainHook extends StatefulWidget {
  final Restaurant restaurant;
  final List<ResCategory> resCategories;
  ResDetailsMainHook({
    required this.restaurant,
    required this.resCategories,
    Key? key,
  }) : super(key: key);

  @override
  State<ResDetailsMainHook> createState() => _ResDetailsMainHookState();
}

class _ResDetailsMainHookState extends State<ResDetailsMainHook>
    with SingleTickerProviderStateMixin {
  bool isCollapsed = false;
  late AutoScrollController scrollController;
  late TabController tabController;

  final double expandedHeight = 500.0;
  final double collapsedHeight = kToolbarHeight;

  final listViewKey = RectGetter.createGlobalKey();
  Map<int, dynamic> itemKeys = {};

  // prevent animate when press on tab bar
  bool pauseRectGetterIndex = false;

  @override
  void initState() {
    tabController =
        TabController(length: widget.resCategories.length, vsync: this);
    scrollController = AutoScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    tabController.dispose();
    super.dispose();
  }

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

  void onCollapsed(bool value) {
    if (this.isCollapsed == value) return;
    setState(() => this.isCollapsed = value);
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (pauseRectGetterIndex) return true;
    int lastTabIndex = tabController.length - 1;
    List<int> visibleItems = getVisibleItemsIndex();

    bool reachLastTabIndex = visibleItems.isNotEmpty &&
        visibleItems.length <= 2 &&
        visibleItems.last == lastTabIndex;
    if (reachLastTabIndex) {
      tabController.animateTo(lastTabIndex);
    } else if (visibleItems.isNotEmpty) {
      int sumIndex = visibleItems.reduce((value, element) => value + element);
      int middleIndex = sumIndex ~/ visibleItems.length;
      if (tabController.index != middleIndex)
        tabController.animateTo(middleIndex);
    }
    return false;
  }

  void animateAndScrollTo(int index) {
    pauseRectGetterIndex = true;
    tabController.animateTo(index);
    scrollController
        .scrollToIndex(index, preferPosition: AutoScrollPosition.begin)
        .then((value) => pauseRectGetterIndex = false);
  }

  @override
  Widget build(BuildContext context) {
    double itemWidth = (1.sw - 12.w - 20.h) / 2;
    // (screenwidth - Gridview crossAxisSpacing * 2 - Gridview mainAxisSpacing * 2) / crossAxisCount
    double itemHeight = itemWidth + 0.15.sh; // 0.15.sh is for item height
    return RectGetter(
      key: listViewKey,
      child: NotificationListener<ScrollNotification>(
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            FAppBar(
              restaurant: widget.restaurant,
              resCategories: widget.resCategories,
              context: context,
              scrollController: scrollController,
              expandedHeight: expandedHeight,
              collapsedHeight: collapsedHeight,
              isCollapsed: isCollapsed,
              onCollapsed: onCollapsed,
              tabController: tabController,
              onTap: (index) => animateAndScrollTo(index),
            ),
//*----------------- MEAL LIST ---------------------//
            SliverPadding(
              padding: EdgeInsets.only(
                  bottom: 0.11.sh), // COMPENSATES ResDetailsBottomCart height
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: widget.resCategories.length,
                  (BuildContext context, int index) {
                    //! CONFIG scroll
                    itemKeys[index] = RectGetter.createGlobalKey();

                    final resCategory = widget.resCategories[index];
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
                                  restaurant: widget
                                      .restaurant, // Needed for add meal with conditions only in CART
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
        onNotification: onScrollNotification,
      ),
    );
  }
}
