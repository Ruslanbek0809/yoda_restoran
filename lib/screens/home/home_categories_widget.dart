import 'package:flutter/material.dart';
import '../../models/models.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
import 'category_filter_bottom_sheet/category_bottom_sheet.dart';

class HomeCategoriesWidget extends StatefulWidget {
  final List<HomeCategory> homeCategories;
  const HomeCategoriesWidget({Key? key, required this.homeCategories})
      : super(key: key);

  @override
  _HomeCategoriesWidgetState createState() => _HomeCategoriesWidgetState();
}

class _HomeCategoriesWidgetState extends State<HomeCategoriesWidget> {
  int selectedCatId = 0;
  List<HomeCategory> additionalCategories = [
    HomeCategory(1, 'Çaý', 'assets/cat_add_chay.png'),
    HomeCategory(2, 'Döner', 'assets/cat_add_doner.png'),
    HomeCategory(3, 'Kofe', 'assets/cat_add_kofe.png'),
    HomeCategory(4, 'Manty', 'assets/cat_add_manty.png'),
    HomeCategory(5, 'Sagdyn', 'assets/cat_add_sagdyn.png'),
    HomeCategory(6, 'Steýk', 'assets/cat_add_steyk.png'),
  ];
  void _onFilterCategoryClicked(List<HomeCategory> additionalCategories) {
    showCategoriesFilterBottomSheet(context, additionalCategories);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: widget.homeCategories.mapIndexed((category, pos) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 250),
            curve: Curves.fastOutSlowIn,
            width: selectedCatId == category.id ? 72.w : 75.w,
            height: selectedCatId == category.id ? 72.w : 75.w,
            margin: EdgeInsets.only(
                top: 15.w,
                left: pos == 0
                    ? 10.w
                    : 0.w), // margin on top of persistent header
            color: AppTheme.WHITE,
            child: GestureDetector(
              onTap: () {
                if (pos == widget.homeCategories.length - 1) {
                  _onFilterCategoryClicked(additionalCategories);
                } else {
                  setState(() {
                    selectedCatId = category.id;
                  });
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: YodaImage(
                      image: category.image,
                      fit: BoxFit.cover,
                      width: selectedCatId == category.id ? 45.w : 50.w,
                      height: selectedCatId == category.id ? 45.w : 50.w,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 7.w),
                    padding: EdgeInsets.symmetric(
                        horizontal: selectedCatId == category.id ? 5.w : 0.0,
                        vertical: selectedCatId == category.id ? 2.w : 0.0),
                    decoration: BoxDecoration(
                      borderRadius: AppTheme().buttonBorderRadius,
                      color: selectedCatId == category.id
                          ? AppTheme.MAIN
                          : AppTheme.WHITE,
                    ),
                    child: Text(
                      category.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: selectedCatId == category.id ? 11.sp : 12.sp,
                        fontWeight: FontWeight.w600,
                        color: selectedCatId == category.id
                            ? AppTheme.WHITE
                            : AppTheme.MAIN,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
