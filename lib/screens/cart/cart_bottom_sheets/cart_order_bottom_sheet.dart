import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yoda_res/screens/cart/cart_bottom_sheets/cart_address_select_bottom_sheet.dart';
import 'package:yoda_res/utils/utils.dart';
import 'package:yoda_res/widgets/widgets.dart';

void cartOrderBottomSheet(BuildContext context) {
  showModalBottomSheet(
    enableDrag: true,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(Constants.BORDER_RADIUS_20),
      ),
    ),
    backgroundColor: Colors.transparent,
    context: context,
    builder: (ctx) => DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.6,
      builder: (context, scrollController) => CartOrderBottomSheetWidget(
        scrollController,
      ),
    ),
  );
}

class CartOrderBottomSheetWidget extends StatefulWidget {
  final ScrollController scrollController;
  CartOrderBottomSheetWidget(this.scrollController);

  @override
  _CartOrderBottomSheetWidgetState createState() =>
      _CartOrderBottomSheetWidgetState();
}

class _CartOrderBottomSheetWidgetState extends State<CartOrderBottomSheetWidget>
    with SingleTickerProviderStateMixin {
  final TextEditingController _notesController = TextEditingController();

  void _onCartAddressClicked() {
    cartAddressSelectBottomSheet(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(Constants.BORDER_RADIUS_20),
            ),
            color: Colors.transparent,
          ),
          child: SingleChildScrollView(
            controller: widget.scrollController,
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
                  padding: EdgeInsets.fromLTRB(20.w, 20.w, 0.w, 20.w),
                  child: Column(
                    children: [
// --------------- PHONE PART -------------- //
                      Column(
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: SvgPicture.asset(
                                  'assets/phone.svg',
                                  color: AppTheme.MAIN_DARK,
                                  width: 25.w,
                                ),
                              ),
                              SizedBox(width: 15.w),
                              Text(
                                '+993 61883349',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: AppTheme.FONT_COLOR,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            color: AppTheme.DRAWER_DIVIDER,
                            indent: 0.111.sw,
                          )
                        ],
                      ),
// --------------- HOUSE PART -------------- //
                      Material(
                        color: AppTheme.WHITE,
                        child: InkWell(
                          onTap: () {
                            _onCartAddressClicked();
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/house.svg',
                                      color: AppTheme.MAIN_DARK,
                                      width: 25.w,
                                    ),
                                    SizedBox(width: 15.w),
                                    Text(
                                      'A.Nowaýy 23, 64',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: AppTheme.FONT_COLOR,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 20.w),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 20,
                                    color: AppTheme.FONT_COLOR,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        color: AppTheme.DRAWER_DIVIDER,
                        indent: 0.111.sw,
                      ),
// --------------- DELIVERY TIME -------------- //
                      Material(
                        color: AppTheme.WHITE,
                        child: InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/clock.svg',
                                      color: AppTheme.MAIN_DARK,
                                      width: 25.w,
                                    ),
                                    SizedBox(width: 15.w),
                                    Text(
                                      'Eltip bermeli wagty 30-40 minut',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: AppTheme.FONT_COLOR,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 20.w),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 20,
                                    color: AppTheme.FONT_COLOR,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        color: AppTheme.DRAWER_DIVIDER,
                        indent: 0.111.sw,
                      ),
                      SizedBox(height: 10.w),
// --------------- NOTE -------------- //
                      Padding(
                        padding: EdgeInsets.only(
                            left: 40.w, right: 15.w, bottom: 15.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 5.w),
                              child: Text(
                                'Bellik',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: AppTheme.DRAWER_ICON,
                                ),
                              ),
                            ),
                            SizedBox(height: 5.w),
                            TextField(
                              controller: _notesController,
                              maxLines: 5,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: AppTheme().containerRadius,
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: AppTheme.MAIN_LIGHT,
                              ),
                            ),
                          ],
                        ),
                      ),
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
              border:
                  Border.all(color: AppTheme.BUTTON_BORDER_COLOR, width: 0.1),
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
                  text: 'Sargyt et',
                  padding:
                      EdgeInsets.symmetric(vertical: 17.w, horizontal: 0.2.sw),
                  textStyle: TextStyle(
                    color: AppTheme.WHITE,
                    fontSize: 18.sp,
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .popAndPushNamed(RouteList.orderSuccess);
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
