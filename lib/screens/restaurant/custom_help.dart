import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/utils/utils.dart';

class SectionWidget extends StatefulWidget {
  @override
  _SectionWidgetState createState() => _SectionWidgetState();
}

class _SectionWidgetState extends State<SectionWidget>
    with SingleTickerProviderStateMixin {
  final scrollController = ScrollController();

  List<FoodCategory> _foodCategoryList = [
    FoodCategory(0, 'Ertirlikler'),
    FoodCategory(1, 'Işdäaçarlar'),
    FoodCategory(2, 'Desertler'),
    FoodCategory(3, 'Steak'),
    FoodCategory(4, 'Burgerlar'),
    FoodCategory(5, 'Ertirlikler'),
    FoodCategory(6, 'Işdäaçarlar'),
    FoodCategory(7, 'Desertler'),
    FoodCategory(8, 'Steak'),
    FoodCategory(9, 'Burgerlar'),
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

  Widget _buildBody(
    double itemWidth,
    double itemHeight,
  ) {
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
          return GridView.count(
            padding: const EdgeInsets.only(
              left: 10,
              top: 10,
              right: 7,
              bottom: 0,
            ),
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: itemWidth / itemHeight,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: _foodList.map((product) {
              return Container(
                color: Colors.red,
                margin: EdgeInsets.symmetric(vertical: 10),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double itemWidth = (size.width - 10 * 2 - 17) / 3;

    double itemHeight = itemWidth + 66;
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
                  int rows = (_foodList.length / 3).ceil();
                  return prev += rows * (itemHeight + 10);
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
      body: _buildBody(
        itemWidth,
        itemHeight,
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
