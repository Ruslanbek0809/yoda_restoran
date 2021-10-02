import 'package:flutter/material.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/utils/utils.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> with TickerProviderStateMixin {
  int currTab = 0;
  late ScrollController _scrollController;

  late TabController _tabController;
  List<FoodCategory> _foodCategoryList = [
    FoodCategory(0, 'Ertirlikler'),
    FoodCategory(1, 'Işdäaçarlar'),
    FoodCategory(2, 'Desertler'),
    FoodCategory(3, 'Steak'),
    FoodCategory(4, 'Burgerlar'),
  ];
  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      vsync: this,
      length: _foodCategoryList.length,
    );
    _scrollController = ScrollController()
      ..addListener(() {
        //print("offset = ${_scrollController.offset}");
        currTab = (_scrollController.offset) ~/ (5 * 50);
        print(currTab);
        _tabController.animateTo(currTab);
      });
  }

  @override
  void dispose() {
    _scrollController
        .dispose(); // it is a good practice to dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            TabBar(
              controller: _tabController,
              isScrollable: true,
              unselectedLabelColor: AppTheme.MAIN,
              tabs: _foodCategoryList
                  .map<Widget>((category) => Tab(text: category.name))
                  .toList(),
              onTap: (index) {
                _scrollController.jumpTo(index * (5 * 50).toDouble());
              },
            ),
            Expanded(
                child: ListView(
              controller: _scrollController,
              children: <Widget>[
                for (int i = 0; i < 5; i++)
                  Container(
                      height: 50, child: Text("Conten at 0 -" + i.toString())),
                for (int i = 0; i < 5; i++)
                  Container(
                      height: 50, child: Text("Conten at 1 -" + i.toString())),
                for (int i = 0; i < 5; i++)
                  Container(
                      height: 50, child: Text("Conten at 2 -" + i.toString())),
                for (int i = 0; i < 5; i++)
                  Container(
                      height: 50, child: Text("Conten at 3 -" + i.toString())),
                for (int i = 0; i < 5; i++)
                  Container(
                      height: 50, child: Text("Conten at 4 -" + i.toString())),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
