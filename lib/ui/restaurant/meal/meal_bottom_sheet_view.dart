import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/shared/shared.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import 'package:yoda_res/utils/utils.dart';
import 'package:stacked/stacked.dart';

import 'meal_main_volume.dart';
import 'meal_view_model.dart';

class MealBottomSheet extends StatelessWidget {
  final Meal meal;
  final SheetRequest request;
  final Function(SheetResponse) completer;
  const MealBottomSheet({
    Key? key,
    required this.meal,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MealViewModel>.reactive(
      builder: (context, model, child) => DraggableScrollableSheet(
        initialChildSize: 0.95,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
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
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 15.h,
                        width: 40.w,
                        child: SvgPicture.asset(
                          'assets/bottom_sheet_dragger.svg',
                          color: kcWhiteColor,
                        ),
                      ),
                      //----------- IMAGE --------------//
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(Constants.BORDER_RADIUS_20),
                        ),
                        child: YodaImage(
                          image: meal.image!,
                          height: 1.sw,
                          width: 1.sw,
                        ),
                      ),
                      //----------- DESCRIPTION --------------//
                      Container(
                        color: kcWhiteColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 15.h,
                                horizontal: 10.w,
                              ),
                              child: Text(
                                meal.description!,
                                maxLines: 3,
                                style: ktsDefault16HelperColor,
                              ),
                            ),
                            //----------- MAIN VOLUME LIST --------------//
                            ...meal.gVolumes!
                                .mapIndexed<Widget>(
                                  (MainVolume mainVolume, int pos) =>
                                      MealMainVolumeView(
                                    mainVolume: mainVolume,
                                    mainVolumePos: pos,
                                  ),
                                )
                                .toList(),
                            // //----------- MAIN CUSTOMIZE LIST --------------//
                            // ...meal.gCostumizes!
                            //     .map<Widget>(
                            //       (MainVolume mainCustomize) => Column(
                            //         children: [
                            //           Padding(
                            //             padding: EdgeInsets.symmetric(
                            //               vertical: 10.h,
                            //               horizontal: 10.w,
                            //             ),
                            //             child: Text(
                            //               mainCustomize.name!,
                            //               style: ktsDefault14HelperColor,
                            //             ),
                            //           ),
                            //           //----------- VOLUME LIST for each MAIN VOLUME --------------//
                            //           ListView.separated(
                            //             shrinkWrap: true,
                            //             physics: NeverScrollableScrollPhysics(),
                            //             itemCount:
                            //                 mainCustomize.volumes!.length,
                            //             separatorBuilder: (ctx, pos) => Divider(
                            //               color: AppTheme.DRAWER_DIVIDER,
                            //               indent: 0.175.sw,
                            //             ),
                            //             itemBuilder: (ctx, pos) =>
                            //                 CheckboxListTile(
                            //               title: Row(
                            //                 children: [
                            //                   Text(
                            //                     mainCustomize
                            //                         .volumes![pos].volumeName!,
                            //                     style: ktsDefault14Text,
                            //                   ),
                            //                   SizedBox(width: 7.w),
                            //                   Text(
                            //                     '+${mainCustomize.volumes![pos].price} TMT',
                            //                     style: ktsDefault16HelperColor,
                            //                   ),
                            //                 ],
                            //               ),
                            //               value: additional.isAdded,
                            //               controlAffinity:
                            //                   ListTileControlAffinity.leading,
                            //               activeColor: AppTheme.GREEN,
                            //               onChanged: (bool? value) {
                            //                 setState(() {
                            //                   additional.isAdded = value!;
                            //                 });
                            //               },
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //     )
                            //     .toList(),
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
                    border: Border.all(
                        color: AppTheme.BUTTON_BORDER_COLOR, width: 0.1),
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
                                  meal.name!,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    color: AppTheme.FONT_COLOR,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  '${meal.value!.toInt()} ${meal.size!.name}',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: AppTheme.DRAWER_ICON,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${meal.price} TMT',
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
                                  color: AppTheme.BUTTON_BORDER_COLOR,
                                  width: 0.5),
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
        ),
      ),
      viewModelBuilder: () => MealViewModel(),
    );
  }
}
