import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yoda_res/widgets/widgets.dart';
import '../../utils/utils.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.WHITE,
      appBar: AppBar(
        backgroundColor: AppTheme.WHITE,
        elevation: 0,
        leadingWidth: 35.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: SvgPicture.asset(
              'assets/cancel.svg',
              color: AppTheme.MAIN_DARK,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: SvgPicture.asset(
                'assets/trash.svg',
                color: AppTheme.MAIN_DARK,
                width: 25.w,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        width: 1.sw,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Sargyt',
                    style: TextStyle(
                      color: AppTheme.MAIN_DARK,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // ListView.separated(
                  //   padding: EdgeInsets.only(bottom: 64.0),
                  //   itemCount: cartData.cartItems.length,
                  //   itemBuilder: (context, index) {
                  //     var product = cartData.cartItems[index];

                  //     return createModalLinkContainer(
                  //       context,
                  //       ProductWidget(product),
                  //       () {
                  //         return ProductDetailsPage(product);
                  //       },
                  //     );
                  //   },
                  //   separatorBuilder: (context, index) {
                  //     return Container(
                  //       color: Colors.white,
                  //       child: Padding(
                  //         padding: const EdgeInsets.only(left: 16, right: 16),
                  //         child: Divider(
                  //           height: 0.3,
                  //           color: AppColors.MAIN_LIGHT,
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.WHITE,
                  borderRadius: AppTheme().containerRadius,
                  border: Border.all(
                      color: AppTheme.BUTTON_BORDER_COLOR, width: 0.1),
                ),
                padding: EdgeInsets.fromLTRB(15.w, 10.w, 15.w, 25.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '175 TMT',
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: AppTheme.FONT_COLOR,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '30-40 min',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppTheme.FONT_COLOR,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    CustomTextButton(
                      text: 'Dowam et',
                      padding: EdgeInsets.symmetric(
                          vertical: 17.w, horizontal: 0.2.sw),
                      textStyle: TextStyle(
                        color: AppTheme.WHITE,
                        fontSize: 18.sp,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            //// Checkout Button Widget
            // Positioned(
            //   bottom: 0,
            //   left: 0,
            //   right: 0,
            //   child: Container(
            //     decoration: BoxDecoration(
            //       color: AppTheme.WHITE,
            //       borderRadius: AppTheme().containerRadius,
            //       border:
            //           Border.all(color: AppTheme.BUTTON_BORDER_COLOR, width: 0.1),
            //     ),
            //     padding: EdgeInsets.symmetric(horizontal: 10.w),
            //     child: Row(
            //       children: [
            //         Column(
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           children: [
            //             Text(
            //               '175 TMT',
            //               style: TextStyle(
            //                 fontSize: 18.sp,
            //                 color: AppTheme.FONT_COLOR,
            //                 fontWeight: FontWeight.bold,
            //               ),
            //             ),
            //             Text(
            //               '30-40 min',
            //               style: TextStyle(
            //                 fontSize: 14.sp,
            //                 color: AppTheme.FONT_COLOR,
            //               ),
            //             ),
            //           ],
            //         ),
            //         //// Buttons Widget
            //         CustomElevatedButton(
            //           height: 0.15.sw,
            //           width: 0.575.sw,
            //           text: 'Dowam etmek',
            //           borderRadius: Constants.BORDER_RADIUS_BUTTON_2,
            //           elevation: 0,
            //           onPressed: () {},
            //         ),
            //       ],
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
