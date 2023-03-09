import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../shared/shared.dart';
import '../../../utils/utils.dart';
import 'res_details_view_model.dart';

class ResDetailsFavoriteButton extends ViewModelWidget<ResDetailsViewModel> {
  const ResDetailsFavoriteButton({Key? key}) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, ResDetailsViewModel model) {
    return ValueListenableBuilder<Box<int>>(
      valueListenable: Hive.box<int>(Constants.favoritesBox).listenable(),
      builder: (context, hiveFavoritesBox, _) {
        return InkWell(
          customBorder: CircleBorder(),
          onTap: () => hiveFavoritesBox.containsKey(model.restaurant.id!)
              ? model.removeRestaurantFromFav(model.restaurant.id!)
              : model.addRestaurantToFav(model.restaurant.id!),
          child: Padding(
            padding: EdgeInsets.all(8.r),
            child: Icon(
              hiveFavoritesBox.containsKey(model.restaurant.id!)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: hiveFavoritesBox.containsKey(model.restaurant.id!)
                  ? kcRedColor
                  : kcSecondaryDarkColor,
              size: 27.r,
            ),
          ),
        );
      },
    );
  }
}
