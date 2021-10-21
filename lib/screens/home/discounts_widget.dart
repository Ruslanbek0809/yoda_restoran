import 'package:flutter/material.dart';
import '../../models/models.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class DiscountsWidget extends StatefulWidget {
  final List<HomeCategory> homeCategories;
  const DiscountsWidget({Key? key, required this.homeCategories})
      : super(key: key);

  @override
  _DiscountsWidgetState createState() => _DiscountsWidgetState();
}

class _DiscountsWidgetState extends State<DiscountsWidget> {
  int selectedCatId = 0;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: widget.homeCategories.map((category) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 250),
            curve: Curves.fastOutSlowIn,
            width: selectedCatId == category.id ? 72.w : 75.w,
            height: selectedCatId == category.id ? 72.w : 75.w,
            margin: EdgeInsets.only(
                top: 15.w), // margin on top of persistent header
            color: AppTheme.WHITE,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedCatId = category.id;
                });
              },
              child: YodaImage(
                image: category.image,
                fit: BoxFit.cover,
                width: selectedCatId == category.id ? 45.w : 50.w,
                height: selectedCatId == category.id ? 45.w : 50.w,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
