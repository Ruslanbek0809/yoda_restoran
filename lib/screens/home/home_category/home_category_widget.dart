import 'package:flutter/material.dart';
import '../../../models/models.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';
import '../category_filter_bottom_sheet/category_bottom_sheet.dart';

class HomeCategoryWidget extends StatefulWidget {
  final HomeCategory homeCategory;
  final int pos;
  final int homeCatLength;
  const HomeCategoryWidget(
      {Key? key,
      required this.homeCategory,
      required this.pos,
      required this.homeCatLength})
      : super(key: key);

  @override
  _HomeCategoryWidgetState createState() => _HomeCategoryWidgetState();
}

class _HomeCategoryWidgetState extends State<HomeCategoryWidget>
    with SingleTickerProviderStateMixin {
  bool isHomeCategoryPressed = false;
  late AnimationController _tweenController;
  Tween<double> _tween = Tween(begin: 1, end: 0.95);
  List<HomeCategory> additionalCategories = [
    HomeCategory(1, 'Çaý', 'assets/cat_add_chay.png'),
    HomeCategory(2, 'Döner', 'assets/cat_add_doner.png'),
    HomeCategory(3, 'Kofe', 'assets/cat_add_kofe.png'),
    HomeCategory(4, 'Manty', 'assets/cat_add_manty.png'),
    HomeCategory(5, 'Sagdyn', 'assets/cat_add_sagdyn.png'),
    HomeCategory(6, 'Steýk', 'assets/cat_add_steyk.png'),
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

  void _onFilterCategoryClicked(List<HomeCategory> additionalCategories) {
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
                  borderRadius: AppTheme().buttonBorderRadius,
                  color: isHomeCategoryPressed ? AppTheme.MAIN : AppTheme.WHITE,
                ),
                child: Text(
                  widget.homeCategory.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
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
