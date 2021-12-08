import 'package:flutter/material.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import '../../models/models.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/utils.dart';

class HomeDiscounts extends StatefulWidget {
  final List<Discount> discounts;
  const HomeDiscounts({Key? key, required this.discounts}) : super(key: key);

  @override
  _HomeDiscountsState createState() => _HomeDiscountsState();
}

class _HomeDiscountsState extends State<HomeDiscounts> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: widget.discounts.mapIndexed((discount, pos) {
          return Padding(
            padding: EdgeInsets.fromLTRB(pos == 0 ? 15.w : 4.w, 5.w, 4.w, 5.w),
            child: GestureDetector(
              onTap: () {},
              child: YodaImage(
                image: discount.image,
                fit: BoxFit.cover,
                width: 95.w,
                height: 95.w,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
