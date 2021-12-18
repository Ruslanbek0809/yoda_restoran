import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/shared/shared.dart';
import 'meal_view_model.dart';

class MealMainVolumeView extends StatelessWidget {
  final MainVolume mainVolume;
  final int pos;
  const MealMainVolumeView({
    required this.mainVolume,
    required this.pos,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MealViewModel>.reactive(
      builder: (context, model, child) => Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 10.h,
              horizontal: 10.w,
            ),
            child: Text(
              mainVolume.name!,
              style: ktsDefault14HelperColor,
            ),
          ),
          //----------- VOLUME LIST for each MAIN VOLUME --------------//
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: mainVolume.volumes!.length,
            separatorBuilder: (ctx, pos) => Divider(
              color: kcDividerColor,
              indent: 0.175.sw,
            ),
            itemBuilder: (ctx, volumePos) => RadioListTile<Volume>(
              value: mainVolume.volumes![volumePos],
              groupValue: selectedAdditional,
              onChanged: _setSelectedAdditionalFood,
              title: Row(
                children: [
                  Text(
                    '${mainVolume.volumes![volumePos].volumeName} ml',
                    style: ktsDefault14Text,
                  ),
                  SizedBox(width: 7.w),
                  Text('+${mainVolume.volumes![volumePos].price} TMT',
                      style: ktsDefault16HelperColor),
                ],
              ),
              activeColor: kcGreenColor,
              controlAffinity: ListTileControlAffinity.leading,
              toggleable: true,
            ),
          ),
        ],
      ),
      viewModelBuilder: () => MealViewModel(),
    );
  }
}
