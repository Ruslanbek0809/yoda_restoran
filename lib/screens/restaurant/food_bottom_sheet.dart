import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/utils/utils.dart';
import 'package:yoda_res/widgets/widgets.dart';

void showFoodBottomSheet(BuildContext context, Food food) {
  showModalBottomSheet(
    enableDrag: true,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
          top: Radius.circular(Constants.BORDER_RADIUS_20)),
    ),
    backgroundColor: Colors.transparent,
    context: context,
    builder: (ctx) => DraggableScrollableSheet(
      initialChildSize: 0.95,
      maxChildSize: 0.95,
      builder: (context, scrollController) => FoodBottomSheetWidget(
        food,
        scrollController,
      ),
    ),
  );
}

class FoodBottomSheetWidget extends StatefulWidget {
  final Food food;
  final ScrollController scrollController;
  FoodBottomSheetWidget(this.food, this.scrollController);

  @override
  _FoodBottomSheetWidgetState createState() => _FoodBottomSheetWidgetState();
}

class _FoodBottomSheetWidgetState extends State<FoodBottomSheetWidget> {
  AdditionalFoodModel? selectedAdditional;

  void _setSelectedAdditionalFood(AdditionalFoodModel? additionalFoodModel) {
    setState(() {
      selectedAdditional = additionalFoodModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.95.sh,
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
              controller: widget.scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 17.5.w,
                    width: 40.w,
                    child: SvgPicture.asset(
                      'assets/bottom_sheet_dragger.svg',
                      color: AppTheme.WHITE,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(Constants.BORDER_RADIUS_20),
                    ),
                    child: YodaImage(
                      image: widget.food.image,
                      height: 0.4.sh,
                      width: 1.sw,
                    ),
                  ),
                  Container(
                    color: AppTheme.WHITE,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 15.w, horizontal: 10.w),
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
                          padding: EdgeInsets.symmetric(
                              vertical: 10.w, horizontal: 10.w),
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
                              .mapIndexed<Widget>(
                                (AdditionalFoodModel additional, int pos) =>
                                    Column(
                                  children: [
                                    RadioListTile<AdditionalFoodModel>(
                                      value: additional,
                                      groupValue: selectedAdditional,
                                      onChanged: _setSelectedAdditionalFood,
                                      title: Row(
                                        children: [
                                          Text(
                                            '${additional.name} ml',
                                            style: TextStyle(
                                              color: AppTheme.FONT_COLOR,
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                          SizedBox(width: 7.w),
                                          Text(
                                            '+${additional.price} TMT',
                                            style: TextStyle(
                                              color: AppTheme.FONT_GREY_COLOR,
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                      activeColor: AppTheme.GREEN_COLOR,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      toggleable: true,
                                    ),
                                    if (pos !=
                                        widget.food.additionals.length - 1)
                                      Divider(
                                        color: AppTheme.DRAWER_DIVIDER,
                                        indent: 0.175.sw,
                                      )
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                        // Column(
                        //   children: widget.food.additionals
                        //       .mapIndexed<Widget>((AdditionalFoodModel
                        //                   additional,
                        //               int pos) =>
                        //           Column(
                        //             children: [
                        //               CheckboxListTile(
                        //                 title: Row(
                        //                   children: [
                        //                     Text(
                        //                       additional.name,
                        //                       style: TextStyle(
                        //                         color: AppTheme.FONT_COLOR,
                        //                         fontSize: 14.sp,
                        //                       ),
                        //                     ),
                        //                     SizedBox(width: 7.w),
                        //                     Text(
                        //                       '+${additional.price} TMT',
                        //                       style: TextStyle(
                        //                         color: AppTheme.FONT_GREY_COLOR,
                        //                         fontSize: 16.sp,
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //                 value: additional.isAdded,
                        //                 controlAffinity:
                        //                     ListTileControlAffinity.leading,
                        //                 activeColor: AppTheme.GREEN,
                        //                 onChanged: (bool? value) {
                        //                   setState(() {
                        //                     additional.isAdded = value!;
                        //                   });
                        //                 },
                        //               ),
                        //               if (pos !=
                        //                   widget.food.additionals.length - 1)
                        //                 Divider(
                        //                   color: AppTheme.DRAWER_DIVIDER,
                        //                   indent: 0.175.sw,
                        //                 )
                        //             ],
                        //           ))
                        //       .toList(),
                        // ),
                        SizedBox(height: 0.175.sh)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          //// ADD CART Widget
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
                        width: 0.33.sw,
                        height: 0.15.sw,
                        decoration: BoxDecoration(
                          color: AppTheme.WHITE,
                          borderRadius: AppTheme().radius12,
                          border: Border.all(
                              color: AppTheme.BUTTON_BORDER_COLOR, width: 0.5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 0.11.sw,
                              height: 0.15.sw,
                              child: Material(
                                color: AppTheme.WHITE,
                                borderRadius: AppTheme().radius12,
                                elevation: 0,
                                child: InkWell(
                                  borderRadius: AppTheme().radius12,
                                  onTap: () async {},
                                  child: Padding(
                                    padding: EdgeInsets.all(2.w),
                                    child: Icon(
                                      Icons.remove,
                                      size: 25.w,
                                      color: AppTheme.FONT_COLOR,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 0.1.sw,
                              child: Text(
                                '1',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  color: AppTheme.FONT_COLOR,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              width: 0.11.sw,
                              height: 0.15.sw,
                              child: Material(
                                color: AppTheme.WHITE,
                                borderRadius: AppTheme().radius12,
                                elevation: 0,
                                child: InkWell(
                                  borderRadius: AppTheme().radius12,
                                  onTap: () {},
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
                        borderRadius: Constants.BORDER_RADIUS_BUTTON_12,
                        elevation: 0,
                        onPressed: () {
                          showAlertDialog(
                            context: context,
                            title: 'Täze sargyt üçin sebedi boşadyň',
                            defaultActionText: 'Sebet',
                            cancelActionText: 'Boşat',
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 0.05.sw,
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
