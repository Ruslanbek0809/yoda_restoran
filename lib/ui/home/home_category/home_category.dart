import 'package:flutter/material.dart';
import 'package:yoda_res/ui/home/category_filter_bottom_sheet/categories_filter_bottom_sheet.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import '../../../models/models.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/utils.dart';

class HomeCategory extends StatefulWidget {
  final CategoryUI homeCategory;
  final int pos;
  final int homeCatLength;
  const HomeCategory(
      {Key? key,
      required this.homeCategory,
      required this.pos,
      required this.homeCatLength})
      : super(key: key);

  @override
  _HomeCategoryState createState() => _HomeCategoryState();
}

class _HomeCategoryState extends State<HomeCategory>
    with SingleTickerProviderStateMixin {
  bool isHomeCategoryPressed = false;
  late AnimationController _tweenController;
  Tween<double> _tween = Tween(begin: 1, end: 0.95);
  List<CategoryUI> additionalCategories = [
    CategoryUI(1, 'Çaý', 'assets/cat_add_chay.png'),
    CategoryUI(2, 'Döner', 'assets/cat_add_doner.png'),
    CategoryUI(3, 'Kofe', 'assets/cat_add_kofe.png'),
    CategoryUI(4, 'Manty', 'assets/cat_add_manty.png'),
    CategoryUI(5, 'Sagdyn', 'assets/cat_add_sagdyn.png'),
    CategoryUI(6, 'Steýk', 'assets/cat_add_steyk.png'),
  ];

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
    return ScaleTransition(
      scale: _tween.animate(
          CurvedAnimation(parent: _tweenController, curve: Curves.bounceInOut)),
      child: Container(
        width: 75.w,
        height: 75.w,
        margin: EdgeInsets.only(
            top: 5.w,
            left: widget.pos == 0
                ? 10.w
                : 0.w), // margin on top of persistent header
        color: AppTheme.WHITE,
        child: GestureDetector(
          onTap: () {
            _tweenController.forward();
            setState(() {
              isHomeCategoryPressed = !isHomeCategoryPressed;
            });
            if (widget.pos == widget.homeCatLength - 1) {
              _onFilterCategoryClicked(additionalCategories);
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: YodaImage(
                  image: widget.homeCategory.image,
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
                  color: isHomeCategoryPressed ? AppTheme.MAIN : AppTheme.WHITE,
                ),
                child: Text(
                  widget.homeCategory.name,
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
  }
}
