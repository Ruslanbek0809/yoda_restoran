import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/utils/utils.dart';
import 'package:yoda_res/widgets/widgets.dart';

void showFoodBottomSheet(BuildContext context, FoodModel food) {
  showModalBottomSheet(
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
          top: Radius.circular(Constants.BORDER_RADIUS_BUTTON)),
    ),
    context: context,
    builder: (ctx) {
      return FoodBottomSheetWidget(food);
    },
  );
}

class FoodBottomSheetWidget extends StatefulWidget {
  final FoodModel food;
  FoodBottomSheetWidget(this.food);

  @override
  _FoodBottomSheetWidgetState createState() => _FoodBottomSheetWidgetState();
}

class _FoodBottomSheetWidgetState extends State<FoodBottomSheetWidget> {
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
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 15.w, horizontal: 10.w),
                  child: Text(
                    'Bu sandwiçi iýseň uzak gün keýpiň kök bolýar we hiç açlyk duýmaýarsyň. Iýip görenler soň hemişe bu sendwiçi sargaýarlar.',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppTheme.BOTTOM_SHEET_FONT_COLOR,
                    ),
                    maxLines: 3,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.w, horizontal: 10.w),
                  child: Text(
                    'Goşmaça',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppTheme.DRAWER_ICON,
                    ),
                    maxLines: 3,
                  ),
                ),
                Column(
                  children: widget.food.additionals
                      .map<Widget>((AdditionalFoodModel additional) =>
                          CheckboxListTile(
                            title: Text(additional.name),
                            value: additional.isAdded,
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: AppTheme.MAIN,
                            contentPadding: EdgeInsets.only(left: 5.w),
                            onChanged: (bool? value) {
                              setState(() {
                                additional.isAdded = value!;
                              });
                            },
                          ))
                      .toList(),
                ),
                SizedBox(height: 0.175.sh)
              ],
            ),
          ),
//// BELOW CONTAINER Widget
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
                            SizedBox(width: 10.w),
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
                                  padding: EdgeInsets.all(14.w),
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
                                  padding: EdgeInsets.all(14.w),
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
                        width: 0.575.sw,
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
