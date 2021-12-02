import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yoda_res/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoda_res/widgets/widgets.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          SizedBox(height: 30.w),
          YodaImage(
            image: 'assets/orderSuccess.jpg',
            height: 0.25.sh,
          ),
          SizedBox(height: 25.w),
          Text(
            'Sargydyňyz restorana geçirildi',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.sp,
              color: AppTheme.FONT_COLOR,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10.w),
          Text(
            'Sargydy tassyklamak üçin restorandan geljek jaňa garaşyň',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppTheme.FONT_COLOR,
            ),
          ),
          SizedBox(height: 50.w),
          SizedBox(
            width: 1.sw,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: AppTheme.MAIN,
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
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () => Navigator.of(context)
                    .pushNamedAndRemoveUntil(RouteList.home, (route) => false),
              ),
            ),
          ),
          SizedBox(height: 15.w),
          TextButton(
            child: Text(
              'Sargytlar sahypasy',
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
    );
  }
}
