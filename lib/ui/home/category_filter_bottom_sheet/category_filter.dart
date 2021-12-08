import 'package:flutter/material.dart';
import 'package:yoda_res/models/category_ui.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import 'package:yoda_res/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryFilterWidget extends StatefulWidget {
  final CategoryUI homeCategory;
  final bool isCategoryFilterChecked;
  final Function(int, bool)? categoryFilterCallback;
  const CategoryFilterWidget(
      {Key? key,
      required this.homeCategory,
      this.isCategoryFilterChecked = false,
      this.categoryFilterCallback})
      : super(key: key);

  @override
  _CategoryFilterWidgetState createState() => _CategoryFilterWidgetState();
}

class _CategoryFilterWidgetState extends State<CategoryFilterWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _tweenController;
  Tween<double> _tween = Tween(begin: 1, end: 0.95);
  bool isCategoryFilterChecked = false;
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
    isCategoryFilterChecked = isCategoryFilterChecked;
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _tween.animate(
          CurvedAnimation(parent: _tweenController, curve: Curves.bounceInOut)),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: GestureDetector(
          onTap: () {
            _tweenController.forward();
            setState(() {
              if (isCategoryFilterChecked == true) {
                isCategoryFilterChecked = false;
                widget.categoryFilterCallback!(widget.homeCategory.id, false);
              } else {
                isCategoryFilterChecked = true;
                widget.categoryFilterCallback!(widget.homeCategory.id, true);
              }
            });
          },
          child: Column(
            children: [
              YodaImage(
                image: widget.homeCategory.image,
              ),
              Container(
                margin: EdgeInsets.only(top: 7.w),
                padding: EdgeInsets.symmetric(
                    horizontal: isCategoryFilterChecked ? 8.w : 0.0,
                    vertical: isCategoryFilterChecked ? 3.w : 0.0),
                decoration: BoxDecoration(
                  borderRadius: AppTheme().radius15,
                  color: isCategoryFilterChecked
                      ? AppTheme.MAIN
                      : Colors.transparent,
                ),
                child: Text(
                  widget.homeCategory.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: isCategoryFilterChecked
                        ? FontWeight.w400
                        : FontWeight.w600,
                    color: isCategoryFilterChecked
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
