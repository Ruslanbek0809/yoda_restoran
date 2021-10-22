import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/utils/utils.dart';
import 'package:yoda_res/widgets/widgets.dart';

void showCategoriesFilterBottomSheet(
    BuildContext context, List<HomeCategory> additionalCategories) {
  showModalBottomSheet(
    enableDrag: true,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(Constants.BORDER_RADIUS_20),
      ),
    ),
    backgroundColor: Colors.transparent,
    context: context,
    builder: (ctx) => DraggableScrollableSheet(
      initialChildSize: 0.95,
      maxChildSize: 0.95,
      builder: (context, scrollController) => CategoriesFilterBottomSheetWidget(
        scrollController,
        additionalCategories,
      ),
    ),
  );
}

class CategoriesFilterBottomSheetWidget extends StatefulWidget {
  final ScrollController scrollController;
  final List<HomeCategory> additionalCategories;
  CategoriesFilterBottomSheetWidget(
      this.scrollController, this.additionalCategories);

  @override
  _CategoriesFilterBottomSheetWidgetState createState() =>
      _CategoriesFilterBottomSheetWidgetState();
}

class _CategoriesFilterBottomSheetWidgetState
    extends State<CategoriesFilterBottomSheetWidget> {
  CategoryFilter? selectedFilter;
  Set<int> selectedCategoryFilters = {};

  List<CategoryFilter> categoryFilters = [
    CategoryFilter(1, 'Adaty'),
    CategoryFilter(2, 'Reýtingi boýunça'),
    CategoryFilter(3, 'Çalt'),
    CategoryFilter(4, 'Gymmatdan arzana'),
    CategoryFilter(5, 'Arzandan gymmada'),
  ];

  void _setSelectedCategoryFilter(CategoryFilter? _selectedFilter) {
    setState(() {
      selectedFilter = _selectedFilter;
    });
  }

  @override
  void initState() {
    selectedFilter = categoryFilters[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.95.sh,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(Constants.BORDER_RADIUS_20)),
        color: Colors.transparent,
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(Constants.BORDER_RADIUS_20),
              ),
              color: Colors.transparent,
            ),
            child: SingleChildScrollView(
              controller: widget.scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 17.5.w,
                    width: 40.w,
                    child: SvgPicture.asset(
                      'assets/bottom_sheet_dragger.svg',
                      color: AppTheme.WHITE,
                    ),
                  ),
                  //--------------- KITCHEN CATEGORIES -------------- //
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(Constants.BORDER_RADIUS_20),
                      ),
                      color: AppTheme.WHITE,
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 30.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Aşhana',
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 10.w, //spaceTopBottom
                            crossAxisSpacing: 10.w, //spaceLeftRight
                            childAspectRatio: 0.8,
                          ),
                          itemCount: widget.additionalCategories.length,
                          itemBuilder: (context, pos) {
                            bool _isFilterCategoryChecked =
                                selectedCategoryFilters.contains(
                                    widget.additionalCategories[pos].id);
                            return AnimatedContainer(
                              duration: Duration(milliseconds: 250),
                              curve: Curves.fastOutSlowIn,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (_isFilterCategoryChecked == true) {
                                      _isFilterCategoryChecked = false;
                                      selectedCategoryFilters.remove(
                                          widget.additionalCategories[pos].id);
                                    } else {
                                      _isFilterCategoryChecked = true;
                                      selectedCategoryFilters.add(
                                          widget.additionalCategories[pos].id);
                                    }
                                    _isFilterCategoryChecked =
                                        selectedCategoryFilters.contains(widget
                                            .additionalCategories[pos].id);
                                    printLog(
                                        'is Checked=> $_isFilterCategoryChecked');
                                  });
                                },
                                child: Column(
                                  children: [
                                    YodaImage(
                                      image: widget
                                          .additionalCategories[pos].image,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 7.w),
                                      child: Text(
                                        widget.additionalCategories[pos].name,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                          color: _isFilterCategoryChecked
                                              ? AppTheme.MAIN
                                              : AppTheme.FONT_COLOR,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  //--------------- SHOWN ORDERS -------------- //
                  Container(
                    color: AppTheme.WHITE,
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Text(
                            'Görkezmeli tertibi',
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: categoryFilters
                              .mapIndexed<Widget>(
                                (CategoryFilter categoryFilter, int pos) =>
                                    Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RadioListTile<CategoryFilter>(
                                      value: categoryFilter,
                                      groupValue: selectedFilter,
                                      onChanged: _setSelectedCategoryFilter,
                                      title: Text(
                                        categoryFilter.name,
                                        style: TextStyle(
                                          color: AppTheme.FONT_COLOR,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      activeColor: AppTheme.GREEN,
                                      controlAffinity:
                                          ListTileControlAffinity.trailing,
                                      toggleable: true,
                                    ),
                                    if (pos != categoryFilters.length - 1)
                                      Divider(
                                        color: AppTheme.DRAWER_DIVIDER,
                                        indent: 10.w,
                                        endIndent: 15.w,
                                      )
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                        SizedBox(height: 0.175.sh)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          //--------------- FILTER BUTTON -------------- //
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                  color: AppTheme.WHITE,
                  border: Border.all(
                      color: AppTheme.BUTTON_BORDER_COLOR, width: 0.1),
                  boxShadow: [AppTheme().bottomCartShadow]),
              padding: EdgeInsets.fromLTRB(15.w, 10.w, 15.w, 25.w),
              child: CustomTextButton(
                text: 'Tassykla',
                padding: EdgeInsets.symmetric(vertical: 17.w),
                textStyle: TextStyle(
                  color: AppTheme.WHITE,
                  fontSize: 18.sp,
                ),
                onPressed: () {},
              ),
            ),
          )
        ],
      ),
    );
  }
}
