import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/ui/cart/checkout/checkout_view_model.dart';
import 'package:yoda_res/utils/utils.dart';

class CheckoutSelectAddressBottomSheetView extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;
  const CheckoutSelectAddressBottomSheetView({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  // int selectedAddressID = -1;
  // List<Address> addresses = [
  //   Address(1, 'A.Nowaýy, 164'),
  //   Address(2, 'N.Andalyp 32'),
  // ];

  // void _onCartAddressClicked() {
  //   cartAddressAddEditBottomSheet(context);
  // }
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CheckoutViewModel>.reactive(
      builder: (context, model, child) => DraggableScrollableSheet(
        initialChildSize: 0.4,
        maxChildSize: 0.4,
        builder: (context, scrollController) => Container(
          height: 0.4.sh,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(Constants.BORDER_RADIUS_20)),
            color: Colors.transparent,
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(Constants.BORDER_RADIUS_20),
                  ),
                  color: Colors.transparent,
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.only(

                      /// To resize screen when OnKeyboard opened
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
// --------------- BOTTOM SHEET DRAGGER -------------- //
                      SizedBox(
                        height: 17.5.w,
                        width: 40.w,
                        child: SvgPicture.asset(
                          'assets/bottom_sheet_dragger.svg',
                          color: AppTheme.WHITE,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(Constants.BORDER_RADIUS_20),
                          ),
                          color: AppTheme.WHITE,
                        ),
                        padding: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 50.w),
                        child: Column(
                          children: [
                            Column(
                              children: addresses
                                  .map(
                                    (address) => Column(
                                      children: [
                                        Material(
                                          color: AppTheme.WHITE,
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedAddressID = address.id;
                                              });
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5.w),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      // AnimatedSwitcher(
                                                      //   duration:
                                                      //       const Duration(
                                                      //           milliseconds:
                                                      //               300),
                                                      //   child:
                                                      //       model.tempSelectedPaymentType
                                                      //                   .id ==
                                                      //               paymentType
                                                      //                   .id
                                                      //           ? SvgPicture
                                                      //               .asset(
                                                      //               'assets/checkCircle.svg',
                                                      //               color: AppTheme
                                                      //                   .GREEN_COLOR,
                                                      //               width: 25.w,
                                                      //             )
                                                      //           : SvgPicture
                                                      //               .asset(
                                                      //               'assets/checkCircle.svg',
                                                      //               color: Colors
                                                      //                   .white,
                                                      //               width: 25.w,
                                                      //             ),
                                                      // ),
                                                      SizedBox(width: 10.w),
                                                      Text(
                                                        address.name,
                                                        style: TextStyle(
                                                          fontSize: 18.sp,
                                                          color: AppTheme
                                                              .FONT_COLOR,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SvgPicture.asset(
                                                    'assets/addressFilter.svg',
                                                    color: AppTheme.MAIN_DARK,
                                                    width: 25.w,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Divider(color: AppTheme.DRAWER_DIVIDER)
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                            Material(
                              color: AppTheme.WHITE,
                              child: InkWell(
                                onTap: () {
                                  _onCartAddressClicked();
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.w),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: AppTheme.FONT_COLOR,
                                        size: 25.w,
                                      ),
                                      SizedBox(width: 10.w),
                                      Text(
                                        'Täze salgy goş...',
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          color: AppTheme.FONT_COLOR,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //--------------- FILTER BUTTONS -------------- //
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.WHITE,
                    border: Border.all(
                        color: AppTheme.BUTTON_BORDER_COLOR, width: 0.1),
                  ),
                  padding: EdgeInsets.fromLTRB(15.w, 10.w, 15.w, 25.w),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: AppTheme.MAIN,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: AppTheme().radius15),
                      padding: EdgeInsets.symmetric(vertical: 17.w),
                    ),
                    child: Text(
                      'Salgyny saýla',
                      style: TextStyle(
                        color: AppTheme.WHITE,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onPressed: () =>
                        Navigator.of(context).pushNamed(RouteList.orders),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      viewModelBuilder: () => CheckoutViewModel(),
    );
  }
}
