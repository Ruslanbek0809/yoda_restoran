import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubcategoryWidget extends StatefulWidget {
  SubcategoryWidget({
    Key? key,
  }) : super(key: key);

  @override
  _SubcategoryWidgetState createState() => _SubcategoryWidgetState();
}

class _SubcategoryWidgetState extends State<SubcategoryWidget>
    with SingleTickerProviderStateMixin {
  var scrollController = ScrollController();

  late TabController _tabController;
  int _activeIndex = 0;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: 3,
    );
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _activeIndex = _tabController.index;
        });
      }
    });
    scrollController = ScrollController()
      ..addListener(() {
        print("offset = ${scrollController.offset}");
        _activeIndex = (scrollController.offset) ~/ (0.5.sw);
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> subs = ['hey', 'bey', 'mey'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48.0),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Color(0xFFdddae5),
                offset: Offset(0.0, 0.0),
                blurRadius: 5,
              ),
            ],
          ),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              isScrollable: false,
              indicatorPadding:
                  EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Theme.of(context).primaryColor),
              // indicator: BubbleTabIndicator(
              //   indicatorRadius: 10,
              //   indicatorColor: Theme.of(context).primaryColor,
              //   padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0),
              // ),
              tabs: subs
                  .map<Widget>((subCat) => Tab(
                        child: Container(
                          width: 1.sw / 3 -
                              10, // - 10 is used to make compensate horizontal padding
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: _activeIndex == subs.indexOf(subCat)
                                ? Colors.transparent
                                : Theme.of(context).accentColor,
                          ),
                          margin: EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 5.0),
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 5.0),
                          alignment: Alignment.center,
                          child: Text(
                            subCat,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ))
                  .toList(),
              onTap: (index) {
                double offset = subs.getRange(0, index).fold(
                  0,
                  (prev, subCategory) {
                    return prev += (0.5.sw + 10);
                  },
                );

                scrollController.animateTo(
                  offset + ((index - 1) * 30.w),
                  duration: Duration(milliseconds: 300),
                  curve: Curves.linear,
                );
              },
            ),
          ),
          // SubcategoryTabs(
          //   subcategories: widget.subCategories,
          //   onItemPressed: (index) {
          //     scrollController.animateTo(
          //       0.5.sw + ((index - 1) * 0.5.sw),
          //       duration: Duration(milliseconds: 300),
          //       curve: Curves.linear,
          //     );
          //   },
          // ),
        ),
      ),
      body: ListView.separated(
        controller: scrollController,
        itemCount: subs.length,
        separatorBuilder: (context, index) {
          if (index < subs.length) {
            String subcategory = subs[index + 1];
            return Container(
              height: 35.w,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
                  child: Text(
                    subcategory,
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          } else {
            return Container();
          }
        },
        itemBuilder: (context, index) {
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (_, index) => ListTile(
              leading: Container(
                height: 40,
                width: 40,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
                alignment: Alignment.center,
                child: Text(index.toString()),
              ),
              title: Text('List element $index'),
            ),
          );
        },
      ),
    );
  }
}

// class SubcategoryTabs extends StatefulWidget {
//   final List<SubcategoryModel> subcategories;
//   final Function onItemPressed;

//   SubcategoryTabs({
//     Key key,
//     this.subcategories,
//     this.onItemPressed,
//   }) : super(key: key);

//   @override
//   _SubcategoryTabsState createState() => _SubcategoryTabsState();
// }

// class _SubcategoryTabsState extends State<SubcategoryTabs>
//     with SingleTickerProviderStateMixin {
//   TabController _tabController;
//   int _activeIndex = 0;
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(
//       vsync: this,
//       length: widget.subcategories.length,
//     );
//     _tabController.addListener(() {
//       if (_tabController.indexIsChanging) {
//         setState(() {
//           _activeIndex = _tabController.index;
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _tabController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: TabBar(
//         controller: _tabController,
//         isScrollable: true,
//         indicatorPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
//         indicator: BoxDecoration(
//             borderRadius: BorderRadius.circular(10.0),
//             color: Theme.of(context).primaryColor),
//         // indicator: BubbleTabIndicator(
//         //   indicatorRadius: 10,
//         //   indicatorColor: Theme.of(context).primaryColor,
//         //   padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0),
//         // ),
//         tabs: widget.subcategories
//             .map<Widget>((subCat) => Tab(
//                   child: Container(
//                     width: 1.sw / 3 -
//                         10, // - 10 is used to make compensate horizontal padding
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10.0),
//                       color:
//                           _activeIndex == widget.subcategories.indexOf(subCat)
//                               ? Colors.transparent
//                               : Color(0xffA4BDD4),
//                     ),
//                     margin:
//                         EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
//                     alignment: Alignment.center,
//                     child: Text(
//                       subCat.name,
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 11.sp,
//                           fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                 ))
//             .toList(),
//         onTap: widget.onItemPressed,
//       ),
//     );
//   }
// }
