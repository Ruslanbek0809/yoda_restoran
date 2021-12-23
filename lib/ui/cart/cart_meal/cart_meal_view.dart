import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/models/hive_models/hive_models.dart';
import 'package:yoda_res/shared/styles.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import 'package:yoda_res/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'cart_meal_view_model.dart';

class CartMealView extends StatelessWidget {
  final HiveMeal meal;
  const CartMealView({Key? key, required this.meal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CartMealViewModel>.reactive(
      builder: (context, model, child) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YodaImage(
            image: meal.image!,
            height: 0.3.sw,
            width: 0.3.sw,
            borderRadius: Constants.BORDER_RADIUS_10,
          ),
          Expanded(
            child: Container(
              height: 0.3
                  .sw, // this height is used to make Column apply MainAxisAlignment.spaceBetween
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        meal.name!,
                        style: ktsDefault16Text,
                      ),
                      Text(
                        '${meal.price} TMT',
                        style: ktsDefault18Text,
                      ),
                    ],
                  ),
                  // Text(
                  //   'Ajy sos',
                  //   style: TextStyle(
                  //     fontSize: 14.sp,
                  //     color: AppTheme.DRAWER_ICON,
                  //   ),
                  // ),
//// Button Widget
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Material(
                        color: AppTheme.MAIN_LIGHT,
                        borderRadius: AppTheme().radius15,
                        elevation: 0,
                        child: InkWell(
                          borderRadius: AppTheme().radius15,
                          onTap: () async {},
                          child: Padding(
                            padding: EdgeInsets.all(10.w),
                            child: Icon(
                              Icons.remove,
                              size: 25.w,
                              color: AppTheme.FONT_COLOR,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        '12',
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: AppTheme.FONT_COLOR,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Material(
                        color: AppTheme.MAIN_LIGHT,
                        borderRadius: AppTheme().radius15,
                        elevation: 0,
                        child: InkWell(
                          borderRadius: AppTheme().radius15,
                          onTap: () {},
                          child: Padding(
                            padding: EdgeInsets.all(10.w),
                            child: Icon(
                              Icons.add,
                              size: 25.w,
                              color: AppTheme.FONT_COLOR,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      viewModelBuilder: () => CartMealViewModel(),
    );
  }
}
