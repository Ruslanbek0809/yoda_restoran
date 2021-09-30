import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:yoda_res/models/models.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoda_res/utils/utils.dart';

import 'food_widget.dart';

class SectionWidget extends StatefulWidget {
  @override
  _SectionWidgetState createState() => _SectionWidgetState();
}

class _SectionWidgetState extends State<SectionWidget>
    with TickerProviderStateMixin {
  final scrollController = ScrollController();

  late AnimationController bottomCartController;
  late Animation<Offset> bottomCartOffset;

  List<FoodCategory> _foodCategoryList = [
    FoodCategory(0, 'Ertirlikler'),
    FoodCategory(1, 'Işdäaçarlar'),
    FoodCategory(2, 'Desertler'),
    FoodCategory(3, 'Steak'),
    FoodCategory(4, 'Burgerlar'),
  ];

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

  @override
  void initState() {
    super.initState();

    bottomCartController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));

    bottomCartOffset = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero)
        .animate(bottomCartController);
  }

  Widget _buildBody() {
    return SafeArea(
      bottom: false,
      child: ListView.separated(
        controller: scrollController,
        itemCount: _foodCategoryList.length,
        separatorBuilder: (context, index) {
          if (index < _foodCategoryList.length) {
            FoodCategory category = _foodCategoryList[index + 1];

            return Container(
              height: 50,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text(
                    category.name,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
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
            padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 10.w),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10.w, //spaceTopBottom
              crossAxisSpacing: 5.w, //spaceLeftRight
              childAspectRatio: 1.sw / 1.65.sw,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48.0),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 0.0),
                blurRadius: 10,
              ),
            ],
          ),
          child: SubcategoryTabs(
            categories: _foodCategoryList,
            onItemPressed: (index) {
              double offset = _foodCategoryList.getRange(0, index).fold(
                0,
                (prev, category) {
                  int rows = (3 / 2).ceil(); // food length to crossAxisCount
                  return prev += rows * (1.sw + 10);
                },
              );

              scrollController.animateTo(
                offset + ((index - 1) * 55),
                duration: Duration(milliseconds: 300),
                curve: Curves.linear,
              );
            },
          ),
        ),
        // : Container()
      ),
      body: _buildBody(),
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
