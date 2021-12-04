import 'package:flutter/material.dart';
import 'package:yoda_res/utils/utils.dart';
import 'search.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchScreen extends StatefulWidget {
  final int? catID;
  final int? subCatID;
  SearchScreen({this.catID, this.subCatID});
  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState<T> extends State<SearchScreen>
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
    assert(debugCheckHasMaterialLocalizations(context));
    // final currentLang = Provider.of<LangProvider>(context).currentLang;
    var theme = Theme.of(context);
    theme = Theme.of(context).copyWith(
      primaryColor: AppTheme.WHITE,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
      primaryColorBrightness: Brightness.light,
      primaryTextTheme: theme.textTheme,
    );

    return Padding(
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
            title: SearchBoxWidget(
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
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            reverseDuration: const Duration(milliseconds: 300),
            child: _showProductsResult
                ? SizedBox() // In production change to SearchProductsResultWidget()
                // SearchProductsResultWidget(
                //     searchName: _searchKeyword,
                //   )
                : Align(
                    alignment: Alignment.topCenter,
                    child:
                        SizedBox() // In production change to RecentSearchesWidget()
                    // RecentSearchesWidget(onTap: _onSubmitCallBack),
                    ),
          ),
        ),
      ),
    );
  }
}
