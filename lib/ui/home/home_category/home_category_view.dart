import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/ui/home/category_filter_bottom_sheet/categories_filter_bottom_sheet.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import 'package:yoda_res/utils/util_functions.dart';
import 'package:yoda_res/utils/utils.dart';
import 'home_category_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeCategoryView extends StatefulWidget {
  final List<MainCategory>? mainCategories;
  const HomeCategoryView({Key? key, this.mainCategories}) : super(key: key);

  @override
  State<HomeCategoryView> createState() => _HomeCategoryViewState();
}

class _HomeCategoryViewState extends State<HomeCategoryView>
    with SingleTickerProviderStateMixin {
  bool isHomeCategoryPressed = false;
  late AnimationController _tweenController;
  Tween<double> _tween = Tween(begin: 1, end: 0.95);

  @override
  void initState() {
    super.initState();
//// Container bounce back
    _tweenController = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this)
      ..addStatusListener((status) {
//// This listener was used to repeat animation once
        if (status == AnimationStatus.completed) {
          _tweenController.reverse();
        }
      });
  }

  void _onFilterCategoryClicked(List<CategoryUI> additionalCategories) {
    showCategoriesFilterBottomSheet(context, additionalCategories);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeCategoryViewModel>.nonReactive(
      builder: (context, model, child) => SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: widget.mainCategories!.mapIndexed((mainCategory, pos) {
            return ScaleTransition(
              scale: _tween.animate(CurvedAnimation(
                  parent: _tweenController, curve: Curves.bounceInOut)),
              child: Container(
                width: 75.w,
                height: 75.h,
                margin: EdgeInsets.only(
                    top: 5.h,
                    left: pos == 0
                        ? 10.w
                        : 0.w), // margin on top of persistent header
                color: AppTheme.WHITE,
                child: GestureDetector(
                  onTap: () {
                    _tweenController.forward();
                    setState(() {
                      isHomeCategoryPressed = !isHomeCategoryPressed;
                    });
                    if (pos == widget.mainCategories!.length - 1) {
                      _onFilterCategoryClicked(additionalCategories);
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: YodaImage(
                          image: mainCategory.image!,
                          fit: BoxFit.cover,
                          width: 50.w,
                          height: 50.w,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 3.w),
                        padding: EdgeInsets.symmetric(
                            horizontal: isHomeCategoryPressed ? 5.w : 0.0,
                            vertical: isHomeCategoryPressed ? 2.w : 0.0),
                        decoration: BoxDecoration(
                          borderRadius: AppTheme().radius15,
                          color: isHomeCategoryPressed
                              ? AppTheme.MAIN
                              : AppTheme.WHITE,
                        ),
                        child: Text(
                          mainCategory.name!,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: isHomeCategoryPressed
                                ? AppTheme.WHITE
                                : AppTheme.FONT_COLOR,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
      viewModelBuilder: () => HomeCategoryViewModel(),
    );
  }
}
