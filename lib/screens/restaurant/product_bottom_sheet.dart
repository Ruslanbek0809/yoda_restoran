import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/utils/utils.dart';
import 'package:yoda_res/widgets/widgets.dart';

void showProductBottomSheet(BuildContext context, FoodModel food) {
  showModalBottomSheet(
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
          top: Radius.circular(Constants.BORDER_RADIUS_BUTTON)),
    ),
    context: context,
    builder: (ctx) {
      return ProductBottomSheetWidget(food);
    },
  );
}

class ProductBottomSheetWidget extends StatefulWidget {
  final FoodModel food;
  ProductBottomSheetWidget(this.food);

  @override
  _ProductBottomSheetWidgetState createState() =>
      _ProductBottomSheetWidgetState();
}

class _ProductBottomSheetWidgetState extends State<ProductBottomSheetWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.9.sh,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(Constants.BORDER_RADIUS_BUTTON)),
        color: AppTheme.MAIN_LIGHT,
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(Constants.BORDER_RADIUS_BUTTON)),
                  child: YodaImage(
                    image: widget.food.image,
                    height: 0.4.sh,
                    width: 1.sw,
                  ),
                ),
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
                border:
                    Border.all(color: AppTheme.BUTTON_BORDER_COLOR, width: 0.1),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10.w, bottom: 15.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.ideographic,
                          children: [
                            Text(
                              widget.food.name,
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: AppTheme.FONT_COLOR,
                              ),
                            ),
                            Text(
                              '${widget.food.weight} ${widget.food.weightType}',
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: AppTheme.DRAWER_ICON,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${widget.food.price} TMT',
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: AppTheme.FONT_COLOR,
                          ),
                        ),
                      ],
                    ),
                  ),
//// Buttons Widget
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.WHITE,
                          borderRadius: AppTheme().button2BorderRadius,
                          border: Border.all(
                              color: AppTheme.BUTTON_BORDER_COLOR, width: 0.5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Material(
                              color: AppTheme.WHITE,
                              borderRadius: AppTheme().button2BorderRadius,
                              elevation: 0,
                              child: InkWell(
                                borderRadius: AppTheme().button2BorderRadius,
                                onTap: () async {},
                                child: Padding(
                                  padding: EdgeInsets.all(13.w),
                                  child: Icon(
                                    Icons.remove,
                                    size: 25.w,
                                    color: AppTheme.FONT_COLOR,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              '1',
                              style: TextStyle(
                                fontSize: 20.sp,
                                color: AppTheme.FONT_COLOR,
                              ),
                            ),
                            Material(
                              color: AppTheme.WHITE,
                              borderRadius: AppTheme().button2BorderRadius,
                              elevation: 0,
                              child: InkWell(
                                borderRadius: AppTheme().button2BorderRadius,
                                onTap: () {},
                                child: Padding(
                                  padding: EdgeInsets.all(13.w),
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
                      ),
                      CustomElevatedButton(
                        height: 0.15.sw,
                        width: 0.6.sw,
                        text: 'Goş',
                        borderRadius: Constants.BORDER_RADIUS_BUTTON_2,
                        elevation: 0,
                        onPressed: () async {},
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 0.075.sw,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
