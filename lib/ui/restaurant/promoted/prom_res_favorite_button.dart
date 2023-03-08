import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../models/models.dart';
import '../../../shared/shared.dart';
import '../../../utils/utils.dart';
import 'prom_res_view_model.dart';

class PromResFavoriteButton extends ViewModelWidget<PromResViewModel> {
  final Restaurant restaurant;
  const PromResFavoriteButton({required this.restaurant, Key? key})
      : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, PromResViewModel model) {
    return Positioned(
      top: 8.r,
      right: 8.r,
      child: Container(
        width: 0.09.sw,
        height: 0.09.sw,
        decoration: BoxDecoration(
          color: kcWhiteColor.withOpacity(0.8),
          shape: BoxShape.circle,
        ),
        child: ValueListenableBuilder<Box<int>>(
            valueListenable: Hive.box<int>(Constants.favoritesBox).listenable(),
            builder: (context, hiveFavoritesBox, _) {
              return IconButton(
                padding: EdgeInsets.zero,
                onPressed: () => hiveFavoritesBox.containsKey(restaurant.id!)
                    ? model.removeRestaurantFromFav(restaurant.id!)
                    : model.addRestaurantToFav(restaurant.id!),
                icon: Icon(
                  hiveFavoritesBox.containsKey(restaurant.id!)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: hiveFavoritesBox.containsKey(restaurant.id!)
                      ? kcRedColor
                      : kcSecondaryDarkColor,
                  size: 20.w,
                ),
              );
            }),
      ),
    );
  }
}
