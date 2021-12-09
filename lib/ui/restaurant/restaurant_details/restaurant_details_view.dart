import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/utils/utils.dart';
import 'res_details_main.dart';
import 'restaurant_details_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RestaurantDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RestaurantDetailsViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: Stack(
          children: [
            ResDetailsMainWidget(),
//------------------ BOTTOM CART ---------------------//
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: SlideTransition(
            //     position: bottomCartOffset,
            //     child: GestureDetector(
            //       onTap: () {
            //         Navigator.of(context).pushNamed(RouteList.cart);
            //       },
            //       child: Container(
            //         height: 0.22.sw,
            //         width: 1.sw,
            //         decoration:
            //             BoxDecoration(color: AppTheme.WHITE, boxShadow: [
            //           AppTheme().bottomCartShadow,
            //         ]),
            //         child: Container(
            //           margin: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 15.w),
            //           padding: EdgeInsets.symmetric(horizontal: 18.w),
            //           decoration: BoxDecoration(
            //             color: AppTheme.MAIN,
            //             borderRadius: AppTheme().radius10,
            //           ),
            //           alignment: Alignment.center,
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               Text(
            //                 'Sargyt',
            //                 style: TextStyle(
            //                   color: AppTheme.WHITE,
            //                   fontSize: 20.sp,
            //                 ),
            //               ),
            //               Text(
            //                 '35 TMT',
            //                 style: TextStyle(
            //                   color: AppTheme.WHITE,
            //                   fontSize: 18.sp,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
      viewModelBuilder: () => RestaurantDetailsViewModel(),
    );
  }
}
