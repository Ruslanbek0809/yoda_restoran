import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/ui/home/home_search/search_box.dart';
import 'package:yoda_res/ui/restaurant/food/food_view.dart';
import 'package:yoda_res/utils/utils.dart';
import 'restaurant_search_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RestaurantSearchView extends StatefulWidget {
  final AnimationController bottomCartController;
  RestaurantSearchView({required this.bottomCartController});

  @override
  State<RestaurantSearchView> createState() => _RestaurantSearchViewState();
}

class _RestaurantSearchViewState extends State<RestaurantSearchView>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  // This node is owned, but not hosted by, the search page. Hosting is done by
  // the text field.
  final _searchFieldNode = FocusNode();
  final _searchFieldController = TextEditingController();

  bool isVisibleSearch = false;
  bool _showProductsResult = false;

  // SearchProvider get _searchPvd =>
  //     Provider.of<SearchProvider>(context, listen: false);

  String get _searchKeyword => _searchFieldController.text;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 2,
      vsync: this,
    );
    _searchFieldNode.addListener(() {
      if (_searchKeyword.isEmpty && !_searchFieldNode.hasFocus) {
        _showProductsResult = false;
      } else {
        _showProductsResult = !_searchFieldNode.hasFocus;
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    _searchFieldNode.dispose();
    _searchFieldController.dispose();
    super.dispose();
  }

  void _onSearchTextChangeCallBack(String searchText) {
    if (searchText.isEmpty) {
      _showProductsResult = false;
      setState(() {});
      return;
    }

    if (_searchFieldNode.hasFocus) {
      setState(() {
        _showProductsResult = true;
        // _searchPvd.loadProducts(
        //   searchText: searchText,
        //   catID: widget.catID,
        //   subCatID: widget.subCatID,
        // );
      });
    }
  }

  //------------------ SUBMIT ---------------------//
  void _onSubmitCallBack(String searchText) {
    _searchFieldController.text = searchText;
    setState(() {
      _showProductsResult = true;
      // _searchPvd.loadProducts(
      //   searchText: searchText,
      //   catID: widget.catID,
      //   subCatID: widget.subCatID,
      // );
    });

    var currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  void close() {
    var currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    double itemWidth = (1.sw - 5.w * 2 - 20.w) / 2;
    double itemHeight = itemWidth + 0.3.sw; // 0.4.sw is for item height
    return ViewModelBuilder<RestaurantSearchViewModel>.reactive(
      builder: (context, model, child) => Padding(
        padding: const EdgeInsets.only(top: kToolbarHeight / 4),
        child: Semantics(
          explicitChildNodes: true,
          scopesRoute: true,
          namesRoute: true,
          child: Scaffold(
            backgroundColor: AppTheme.WHITE,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: AppTheme.WHITE,
              elevation: 0.5,
              titleSpacing: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: AppTheme.FONT_COLOR,
                  size: 20.w,
                ),
                onPressed: close,
              ),
              title: SearchBox(
                autoFocus: true,
                controller: _searchFieldController,
                focusNode: _searchFieldNode,
                onChanged: _onSearchTextChangeCallBack,
                onSubmitted: _onSubmitCallBack,
              ),
              actions: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _searchFieldController.text.isEmpty
                      ? IconButton(
                          tooltip: 'Search',
                          // tooltip: i18n(currentLang, ki18nSearch),
                          icon: Icon(
                            Icons.search,
                            size: 22.w,
                            color: AppTheme.DRAWER_DIVIDER,
                          ),
                          onPressed: () {},
                        )
                      : IconButton(
                          tooltip: 'Clear',
                          // tooltip: i18n(currentLang, ki18nClearCart),
                          icon: Icon(
                            Icons.clear,
                            size: 22.w,
                            color: AppTheme.DRAWER_DIVIDER,
                          ),
                          onPressed: () {
                            _searchFieldController.clear();
                            _searchFieldNode.requestFocus();
                          },
                        ),
                ),
              ],
            ),
            //------------------ FOOD ListView builder ---------------------//
            body: GridView.builder(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12.h, //spaceTopBottom
                crossAxisSpacing: 8.w, //spaceLeftRight
                childAspectRatio: itemWidth / itemHeight,
              ),
              itemCount: foodList.length,
              itemBuilder: (context, pos) {
                return FoodView(
                  food: foodList[pos],
                  animationController: widget.bottomCartController,
                );
              },
            ),
            // AnimatedSwitcher(
            //   duration: const Duration(milliseconds: 300),
            //   reverseDuration: const Duration(milliseconds: 300),
            //   child: _showProductsResult
            //       ? SizedBox() // In production change to SearchProductsResultWidget()
            //       // SearchProductsResultWidget(
            //       //     searchName: _searchKeyword,
            //       //   )
            //       : Align(
            //           alignment: Alignment.topCenter,
            //           child:
            //               SizedBox() // In production change to RecentSearchesWidget()
            //           // RecentSearchesWidget(onTap: _onSubmitCallBack),
            //           ),
            // ),
          ),
        ),
      ),
      viewModelBuilder: () => RestaurantSearchViewModel(),
    );
  }
}
