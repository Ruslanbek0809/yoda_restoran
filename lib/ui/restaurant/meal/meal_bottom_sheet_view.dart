import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import '../../../models/models.dart';
import '../../../shared/shared.dart';
import '../../widgets/widgets.dart';
import '../../../utils/utils.dart';
import 'package:stacked/stacked.dart';
import 'meal_view_model.dart';
import 'package:easy_localization/easy_localization.dart';

class MealBottomSheet extends StatelessWidget {
  final ScrollController scrollController;
  final double offset;
  final Meal meal;
  final Restaurant restaurant;
  final MealViewModel mealViewModel;
  const MealBottomSheet({
    Key? key,
    required this.scrollController,
    required this.offset,
    required this.meal,
    required this.restaurant,
    required this.mealViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MealViewModel>.reactive(
      onModelReady: (model) => model.setOnModelReadyVolsCustoms(meal),
      // viewModelBuilder: () => MealViewModel(),
      viewModelBuilder: () => mealViewModel,
      disposeViewModel: false,
      builder: (context, model, child) => Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(Constants.BORDER_RADIUS_20),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.w, 10.h, 10.w, 15.h),
                        child: Text(
                          meal.description!,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: kcBottomDescColor,
                          ),
                        ),
                      ),
                      //----------- MAIN VOLUME LIST --------------//
                      if (meal.gVolumes!.isNotEmpty)
                        Divider(color: kcDividerColor),
                      if (meal.gVolumes!.isNotEmpty)
                        ...meal.gVolumes!
                            .mapIndexed<Widget>(
                              (MainVolume mainVolume, mainVolumePos) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.h,
                                      horizontal: 15.w,
                                    ),
                                    child: Text(
                                      mainVolume.name!,
                                      style: kts14HelperText,
                                    ),
                                  ),
                                  //----------- VOLUME LIST for each MAIN VOLUME --------------//
                                  ListView.separated(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: mainVolume.volumes!.length,
                                      separatorBuilder: (ctx, volumePos) =>
                                          Divider(
                                            color: kcDividerColor,
                                            indent: 0.175.sw,
                                          ),
                                      itemBuilder: (ctx, volumePos) {
                                        return RadioListTile<Volume?>(
                                          value: mainVolume.volumes![volumePos],
                                          groupValue:
                                              model.selectedVols[mainVolumePos],
                                          onChanged: (selectedVolume) {
                                            if (selectedVolume != null)
                                              model.updateSelectedVols(
                                                  meal,
                                                  mainVolumePos,
                                                  selectedVolume);
                                          },
                                          title: Row(
                                            children: [
                                              Text(
                                                mainVolume.volumes![volumePos]
                                                    .volumeName!,
                                                style: ktsDefault14Text,
                                              ),
                                              SizedBox(width: 7.w),
                                              Text(
                                                  '+${formatNum(meal.discount != null || meal.discount! > 0 ? (mainVolume.volumes![volumePos].price! / 100) * (100 - meal.discount!) : mainVolume.volumes![volumePos].price!)} TMT',
                                                  style: kts16HelperText),
                                            ],
                                          ),
                                          activeColor: kcGreenColor,
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.h,
                                      horizontal: 15.w,
                                    ),
                                    child: Text(
                                      mainCustomizable.name!,
                                      style: kts14HelperText,
                                    ),
                                  ),
                                  //----------- VOLUME LIST for each MAIN VOLUME --------------//
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount:
                                        mainCustomizable.customizables!.length,
                                    separatorBuilder: (ctx, pos) => Divider(
                                      color: AppTheme.DRAWER_DIVIDER,
                                      indent: 0.175.sw,
                                    ),
                                    itemBuilder: (ctx, pos) => CheckboxListTile(
                                      title: Row(
                                        children: [
                                          Text(
                                            mainCustomizable.customizables![pos]
                                                .customizableName!,
                                            style: ktsDefault14Text,
                                          ),
                                          SizedBox(width: 7.w),
                                          Text(
                                            '+${formatNum(meal.discount != null || meal.discount! > 0 ? (mainCustomizable.customizables![pos].price! / 100) * (100 - meal.discount!) : mainCustomizable.customizables![pos].price!)} TMT',
                                            style: kts16HelperText,
                                          ),
                                        ],
                                      ),
                                      value: model.isCustomSelected(
                                          mainCustomizable.customizables![pos]),
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      activeColor: kcGreenColor,
                                      onChanged: (bool? value) {
                                        model.updateSelectedCustoms(
                                          meal,
                                          mainCustomizable.customizables![pos],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),

                      // /// When there is no any other data than image
                      // if (meal.gVolumes!.isNotEmpty ||
                      //     meal.gCustomizables!.isNotEmpty ||
                      //     meal.description!.isNotEmpty)
                      //   Container(
                      //     height: 0.175.sh,
                      //   )
                    ],
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
                border:
                    Border.all(color: AppTheme.BUTTON_BORDER_COLOR, width: 0.1),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                children: [
                  //----------- MEAL INFO --------------//
                  Padding(
                    padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: meal.value != null
                              ? RichText(
                                  text: TextSpan(
                                    text: meal.name!,
                                    style: ktsDefault16Text,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            ' ${formatNum(meal.value!)} ${meal.size!.name}',
                                        style: kts14HelperText,
                                      ),
                                    ],
                                  ),
                                )
                              : Text(
                                  meal.name!,
                                  style: ktsDefault16Text,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.w),
                          child: Text(
                            '${formatNum(model.totalSumDraft)} TMT',
                            style: kts16DarkSemiBoldText,
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
                                color: kcDividerSecondaryColor,
                                width: 0.75,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                      onTap: () =>
                                          model.subtractQuantityDraft(meal),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 14.h),
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
                                    style: kts20Text,
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
                                      onTap: () => model.addQuantityDraft(meal),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 14.h),
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
                              model.isAllVolSelected
                                  ? LocaleKeys.Add
                                  : LocaleKeys.choose,
                              style: model.isAllVolSelected
                                  ? ktsButton18Text
                                  : ktsButton18ContactText,
                            ).tr(),
                            color: model.isAllVolSelected
                                ? kcPrimaryColor
                                : kcSecondaryLightColor,
                            borderRadius: AppTheme().radius15,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            onPressed: model.isAllVolSelected
                                ? () async {
                                    await model
                                        .addUpdateMealInCartFromBottomSheet(
                                            meal, restaurant);
                                    Navigator.pop(context);
                                    // completer(SheetResponse());
                                  }
                                : () {},
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
    );
  }
}
