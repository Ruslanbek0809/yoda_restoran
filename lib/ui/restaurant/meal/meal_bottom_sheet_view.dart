import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/shared/shared.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import 'package:yoda_res/utils/utils.dart';
import 'package:stacked/stacked.dart';
import 'meal_view_model.dart';

class MealBottomSheet extends StatelessWidget {
  final Meal meal;
  final Restaurant restaurant;
  final MealViewModel mealViewModel;
  final SheetRequest request;
  final Function(SheetResponse) completer;
  const MealBottomSheet({
    Key? key,
    required this.meal,
    required this.restaurant,
    required this.mealViewModel,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MealViewModel>.reactive(
      onModelReady: (model) =>
          model.setOnModelReadyVolsCustoms(meal.gVolumes!.length),
      viewModelBuilder: () => mealViewModel,
      disposeViewModel: false,
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
                              padding:
                                  EdgeInsets.fromLTRB(15.w, 15.h, 10.w, 15.h),
                              child: Text(
                                meal.description!,
                                maxLines: 3,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: kcBottomDescColor,
                                ),
                              ),
                            ),
                            //----------- MAIN VOLUME LIST --------------//
                            if (meal.gVolumes!.isNotEmpty)
                              ...meal.gVolumes!
                                  .mapIndexed<Widget>(
                                    (MainVolume mainVolume, mainVolumePos) =>
                                        Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10.h,
                                            horizontal: 15.w,
                                          ),
                                          child: Text(
                                            mainVolume.name!,
                                            style: ktsDefault14HelperText,
                                          ),
                                        ),
                                        //----------- VOLUME LIST for each MAIN VOLUME --------------//
                                        ListView.separated(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount:
                                                mainVolume.volumes!.length,
                                            separatorBuilder:
                                                (ctx, volumePos) => Divider(
                                                      color: kcDividerColor,
                                                      indent: 0.175.sw,
                                                    ),
                                            itemBuilder: (ctx, volumePos) {
                                              return RadioListTile<Volume?>(
                                                value: mainVolume
                                                    .volumes![volumePos],
                                                groupValue: model.selectedVols[
                                                    mainVolumePos],
                                                onChanged: (selectedVolume) {
                                                  if (selectedVolume != null)
                                                    model.updateSelectedVols(
                                                        mainVolumePos,
                                                        selectedVolume);
                                                },
                                                title: Row(
                                                  children: [
                                                    Text(
                                                      '${mainVolume.volumes![volumePos].volumeName} ml',
                                                      style: ktsDefault14Text,
                                                    ),
                                                    SizedBox(width: 7.w),
                                                    Text(
                                                        '+${mainVolume.volumes![volumePos].price} TMT',
                                                        style:
                                                            ktsDefault16HelperColor),
                                                  ],
                                                ),
                                                activeColor: kcGreenColor,
                                                controlAffinity:
                                                    ListTileControlAffinity
                                                        .leading,
                                                toggleable: true,
                                              );
                                            }),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            if (meal.gCustomizables!.isNotEmpty)
                              Divider(color: kcDividerColor),
                            //----------- MAIN CUSTOMIZE LIST --------------//
                            if (meal.gCustomizables!.isNotEmpty)
                              ...meal.gCustomizables!
                                  .mapIndexed<Widget>(
                                    (MainCustomizable mainCustomizable,
                                            int mainCustomizablePos) =>
                                        Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10.h,
                                            horizontal: 15.w,
                                          ),
                                          child: Text(
                                            mainCustomizable.name!,
                                            style: ktsDefault14HelperText,
                                          ),
                                        ),
                                        //----------- VOLUME LIST for each MAIN VOLUME --------------//
                                        ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: mainCustomizable
                                              .customizables!.length,
                                          separatorBuilder: (ctx, pos) =>
                                              Divider(
                                            color: AppTheme.DRAWER_DIVIDER,
                                            indent: 0.175.sw,
                                          ),
                                          itemBuilder: (ctx, pos) =>
                                              CheckboxListTile(
                                            title: Row(
                                              children: [
                                                Text(
                                                  mainCustomizable
                                                      .customizables![pos]
                                                      .customizableName!,
                                                  style: ktsDefault14Text,
                                                ),
                                                SizedBox(width: 7.w),
                                                Text(
                                                  '+${mainCustomizable.customizables![pos].price} TMT',
                                                  style:
                                                      ktsDefault16HelperColor,
                                                ),
                                              ],
                                            ),
                                            value: model.isCustomSelected(
                                                mainCustomizable
                                                    .customizables![pos]),
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            activeColor: kcGreenColor,
                                            onChanged: (bool? value) {
                                              model.updateSelectedCustoms(
                                                mainCustomizable
                                                    .customizables![pos],
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            SizedBox(height: 0.175.sh)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //----------- BOTTOM CART PART --------------//
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
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    children: [
                      //----------- MEAL INFO --------------//
                      Padding(
                        padding: EdgeInsets.only(top: 10.h, bottom: 12.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.ideographic,
                              children: [
                                Text(
                                  meal.name!,
                                  style: ktsDefault18Text,
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                    '${meal.value!.toInt()} ${meal.size!.name}',
                                    style: ktsDefault16HelperColor),
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
                      //----------- BUTTONS --------------//
                      Padding(
                        padding: EdgeInsets.only(bottom: 20.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppTheme.WHITE,
                                  borderRadius: AppTheme().radius15,
                                  border: Border.all(
                                    color: AppTheme.BUTTON_BORDER_COLOR,
                                    width: 0.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Material(
                                        color: AppTheme.WHITE,
                                        borderRadius: AppTheme().radius15,
                                        // borderRadius: BorderRadius.only(
                                        //   topLeft: Radius.circular(15.0),
                                        //   bottomLeft: Radius.circular(15.0),
                                        // ),
                                        elevation: 0,
                                        child: InkWell(
                                          borderRadius: AppTheme().radius15,
                                          // borderRadius: BorderRadius.only(
                                          //   topLeft: Radius.circular(15.0),
                                          //   bottomLeft: Radius.circular(15.0),
                                          // ),
                                          onTap: model.subtractQuantityDraft,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 15.h),
                                            child: Icon(
                                              Icons.remove,
                                              size: 23.w,
                                              color: model.quantityDraft == 1
                                                  ? kcHelperColor
                                                  : AppTheme.FONT_COLOR,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        model.quantityDraft.toString(),
                                        style: ktsDefault20Text,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      child: Material(
                                        color: AppTheme.WHITE,
                                        borderRadius: AppTheme().radius15,
                                        // borderRadius: BorderRadius.only(
                                        //   topRight: Radius.circular(15.0),
                                        //   bottomRight: Radius.circular(15.0),
                                        // ),
                                        elevation: 0,
                                        child: InkWell(
                                          borderRadius: AppTheme().radius15,
                                          // borderRadius: BorderRadius.only(
                                          //   topRight: Radius.circular(15.0),
                                          //   bottomRight: Radius.circular(15.0),
                                          // ),
                                          onTap: model.addQuantityDraft,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 15.h),
                                            child: Icon(
                                              Icons.add,
                                              size: 23.w,
                                              color: AppTheme.FONT_COLOR,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              flex: 3,
                              child: CustomTextChildButton(
                                child: Text(
                                  'Goş',
                                  style: ktsButton18Text,
                                ),
                                borderRadius: AppTheme().radius15,
                                padding: EdgeInsets.symmetric(vertical: 17.h),
                                onPressed: () async {
                                  await model
                                      .addUpdateMealInCartFromBottomSheet(
                                          meal, restaurant);

                                  completer(SheetResponse());
                                  // model.navBack();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
