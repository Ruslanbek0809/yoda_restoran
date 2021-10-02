import 'package:flutter/material.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/utils/utils.dart';
import 'package:yoda_res/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'food_widget.dart';

class RestaurantScreen2 extends StatefulWidget {
  @override
  _RestaurantScreen2State createState() => _RestaurantScreen2State();
}

class _RestaurantScreen2State extends State<RestaurantScreen2>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int currentTab = 0;

  late ScrollController _sliverScrollController;
  bool lastStatus = true;

  late AnimationController bottomCartController;
  late Animation<Offset> bottomCartOffset;

  List<FoodCategory> _foodCategoryList = [
    FoodCategory(0, 'Ertirlikler'),
    FoodCategory(1, 'Işdäaçarlar'),
    FoodCategory(2, 'Desertler'),
    FoodCategory(3, 'Steak'),
    FoodCategory(4, 'Burgerlar'),
    FoodCategory(3, 'Bla'),
    FoodCategory(4, 'BTaaa'),
  ];
  // I 1 2 4 Q

  List<FoodModel> _foodList = [
    FoodModel(0, 'Sandwich', 120, 'g', 25, 'assets/breakfast_sandwich.jpg', [
      AdditionalFoodModel('Peýnir', 10, false),
      AdditionalFoodModel('Ýumurtga', 10, false),
      AdditionalFoodModel('Bet zat', 15, false),
    ]),
    FoodModel(0, 'Egg', 120, 'g', 10, 'assets/breakfast_egg.jpg', [
      AdditionalFoodModel('Peýnir', 10, false),
      AdditionalFoodModel('Ýumurtga', 10, false),
      AdditionalFoodModel('Bet zat', 15, false),
    ]),
    FoodModel(0, 'Sandwich', 300, 'ml', 15, 'assets/breakfast_latte.jpg', [
      AdditionalFoodModel('Peýnir', 10, false),
      AdditionalFoodModel('Ýumurtga', 10, false),
      AdditionalFoodModel('Bet zat', 15, false),
    ]),
  ];

  void _scrollListener() {
//// Animate to currentTab when listview scrools
    // printLog("offset = ${_sliverScrollController.offset}");
    // currentTab = (_sliverScrollController.offset) ~/
    //     ((_foodList.length / 2).ceil() * (1.2.sw));
    // // currentTab = (_sliverScrollController.offset) ~/
    // //     ((_foodList.length / 2).ceil() * (1.sw / 1.65.sw));
    // print(
    //     'currentTab=> $currentTab ${(_foodList.length / 2).ceil()} ${1.sw} ${0.5.sh} ${(1.sw / 1.65.sw)}');
    // _tabController.animateTo(currentTab);

//// For SliverAppBar
    if (_isShrink != lastStatus) {
      setState(() {
        lastStatus = _isShrink;
      });
    }
  }

  bool get _isShrink {
    return _sliverScrollController.hasClients &&
        _sliverScrollController.offset > (0.5.sh - kToolbarHeight);
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      vsync: this,
      length: _foodCategoryList.length,
    );
    _sliverScrollController = ScrollController()..addListener(_scrollListener);

    bottomCartController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));

    bottomCartOffset = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero)
        .animate(bottomCartController);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _sliverScrollController.removeListener(_scrollListener);
    _sliverScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double itemWidth = (1.sw - 5.w * 2 - 20.w) / 2;
    // (screenwidth - Gridview crossAxisSpacing * 2 - Gridview horizontal padding) / crossAxisCount

    double itemHeight = itemWidth + 0.3.sw; // 0.4.sw is for item height
    printLog('ItemHeight: $itemHeight and expected ${0.75.sw}');
    return Scaffold(
      body: CustomScrollView(
        controller: _sliverScrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 0.5.sh,
            pinned: true,
            stretch: true,
            floating: false,
            leading: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: Container(
                height: 50.w,
                width: 50.w,
                margin: EdgeInsets.only(left: 10.w, top: 5.w),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isShrink ? Colors.transparent : AppTheme.WHITE,
                    boxShadow: _isShrink ? [] : [AppTheme().buttonShadow]),
                child: Material(
                  color: _isShrink ? Colors.transparent : AppTheme.WHITE,
                  shape: CircleBorder(),
                  elevation: 0,
                  child: InkWell(
                    customBorder: CircleBorder(),
                    onTap: () {},
                    child: Icon(
                      Icons.arrow_back,
                      size: 27.w,
                      color: AppTheme.BLACK,
                    ), // other widget
                  ),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: [StretchMode.zoomBackground],
              background: YodaImage(
                image: 'assets/burgerlist.jpg',
              ),
              title: Text(
                'Kebapçy',
                style: TextStyle(fontSize: 17.sp),
              ),
              centerTitle: false,
            ),
            bottom: ColoredTabBar(
              color: AppTheme.WHITE,
              tabBar: TabBar(
                controller: _tabController,
                isScrollable: true,
                unselectedLabelColor: AppTheme.MAIN,
                tabs: _foodCategoryList
                    .map<Widget>((category) => Tab(text: category.name))
                    .toList(),
                onTap: (index) {
                  double offset = _foodCategoryList.getRange(0, index).fold(
                    0,
                    (prev, category) {
                      int rows = (_foodList.length / 2)
                          .ceil(); // food length to crossAxisCount
                      return prev += rows *
                          (itemHeight + 24.w); // Gridview vertical padding
                    },
                  );

                  _sliverScrollController.animateTo(
                    offset +
                        ((index - 1) * 50.w) +
                        0.4.sh, // * 50.w is same with Category title height //  + 0.3.sh is to compensate 0.5.sh expanded height
                    duration: Duration(milliseconds: 300),
                    curve: Curves.linear,
                  );
                },
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _foodCategoryList.length,
                  separatorBuilder: (context, index) {
                    if (index < _foodCategoryList.length) {
                      FoodCategory category = _foodCategoryList[index + 1];

                      return Container(
                        height: 50.w,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            child: Text(
                              category.name,
                              textAlign: TextAlign.left,
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                  itemBuilder: (context, index) {
                    return GridView.builder(
                      padding: EdgeInsets.symmetric(
                          vertical: 15.w, horizontal: 10.w),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10.w, //spaceTopBottom
                        crossAxisSpacing: 5.w, //spaceLeftRight
                        childAspectRatio: itemWidth / itemHeight,
                      ),
                      itemCount: _foodList.length,
                      itemBuilder: (context, pos) {
                        return FoodWidget(
                          food: _foodList[pos],
                          animationController: bottomCartController,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SubcategoryTabs extends StatefulWidget {
  final List<FoodCategory> categories;
  final Function(int)? onItemPressed;

  SubcategoryTabs({
    required this.categories,
    this.onItemPressed,
  });

  @override
  _SubcategoryTabsState createState() => _SubcategoryTabsState();
}

class _SubcategoryTabsState extends State<SubcategoryTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: widget.categories.length,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        unselectedLabelColor: AppTheme.MAIN,
        tabs: widget.categories
            .map<Widget>((category) => Tab(text: category.name))
            .toList(),
        onTap: widget.onItemPressed,
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
