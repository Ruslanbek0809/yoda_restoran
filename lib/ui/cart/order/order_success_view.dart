import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import '../../../utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';

import 'order_view_model.dart';

class OrderSuccessView extends StatelessWidget {
  const OrderSuccessView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OrderViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              height: 36.w,
              child: SvgPicture.asset(
                'assets/yoda_restoran.svg',
                color: AppTheme.MAIN_DARK,
              ),
            ),
            Lottie.asset(
              'assets/success_check.json',
              height: 0.4.sh,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'Sargydyňyz restorana geçirildi',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.sp,
                  color: AppTheme.FONT_COLOR,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 10.w),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'Sargydy tassyklamak üçin restorandan geljek jaňa garaşyň',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppTheme.DIALOG_TITLE_COLOR,
                ),
              ),
            ),
            SizedBox(height: 50.w),
            SizedBox(
              width: 1.sw,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: AppTheme.MAIN_DARK,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: AppTheme().radius10),
                    padding: EdgeInsets.symmetric(vertical: 15.w),
                  ),
                  child: Text(
                    'Baş sahypa',
                    style: TextStyle(
                      color: AppTheme.WHITE,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onPressed: () => Navigator.of(context)
                      .pushNamedAndRemoveUntil(
                          RouteList.home, (route) => false),
                ),
              ),
            ),
            SizedBox(height: 15.w),
            TextButton(
              child: Text(
                'Sargytlar',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: AppTheme.FONT_COLOR,
                ),
              ),
              onPressed: () =>
                  Navigator.of(context).pushReplacementNamed(RouteList.orders),
            ),
          ],
        ),
      ),
      viewModelBuilder: () => OrderViewModel(),
    );
  }
}
