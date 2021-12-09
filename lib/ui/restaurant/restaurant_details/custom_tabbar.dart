import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:yoda_res/utils/utils.dart';

import 'restaurant_details_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTabBar extends HookViewModelWidget<RestaurantDetailsViewModel> {
  const CustomTabBar({Key? key}) : super(key: key, reactive: true);

  @override
  Widget buildViewModelWidget(
      BuildContext context, RestaurantDetailsViewModel model) {
    final tabController = useTabController(
      initialLength: foodCategoryList.length,
      initialIndex: model.activeTab,
    );

    /// To dispose a listener attached to TabController
    useEffect(() {
      void _tabListener() => model.updateActiveTab(tabController.index);
      tabController.addListener(_tabListener);
      return () => tabController.removeListener(_tabListener);
    }, [tabController]);

    return ColoredTabBar(
      color: AppTheme.WHITE,
      tabBar: TabBar(
        controller: tabController,
        isScrollable: true,
        indicatorColor: Colors.transparent,
        labelPadding: EdgeInsets.all(0.0),
        tabs: foodCategoryList
            .map<Widget>((category) => Tab(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      borderRadius: AppTheme().radius15,
                      color:
                          model.activeTab == foodCategoryList.indexOf(category)
                              ? model.isTabPressed
                                  ? AppTheme.MAIN_LIGHT
                                  : AppTheme.WHITE
                              : AppTheme.WHITE,
                    ),
                    margin: EdgeInsets.symmetric(
                      vertical: 3.w,
                      horizontal: 5.w,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    alignment: Alignment.center,
                    child: Text(
                      category.name,
                      style: TextStyle(
                        color: AppTheme.FONT_COLOR,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ))
            .toList(),
        onTap: (index) {
        },
      ),
    );
  }
}

class ColoredTabBar extends Container implements PreferredSizeWidget {
  ColoredTabBar({required this.color, required this.tabBar});

  final Color color;
  final TabBar tabBar;

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) => Container(
        color: color,
        child: tabBar,
      );
}
