import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stacked/stacked.dart';
import '../../models/hive_models/hive_models.dart';
import '../../models/models.dart';
import '../../shared/shared.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/utils.dart';
import 'restaurant_view_model.dart';

class RestaurantFavoriteButton extends ViewModelWidget<ResViewModel> {
  final Restaurant restaurant;
  const RestaurantFavoriteButton({required this.restaurant, Key? key})
      : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, ResViewModel model) {
    return Positioned(
      top: 10.r,
      right: 10.r,
      child: Container(
        width: 0.11.sw,
        height: 0.11.sw,
        decoration: BoxDecoration(
          color: kcWhiteColor.withOpacity(0.8),
          shape: BoxShape.circle,
        ),
        child: ValueListenableBuilder<Box<int>>(
            valueListenable: Hive.box<int>(Constants.favoritesBox).listenable(),
            builder: (context, hiveFavoritesBox, _) {
              return IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  if (!hiveFavoritesBox.containsKey(restaurant.id!))
                    model.addRestaurantToFav(restaurant.id!);
                },
                // onPressed: () => hiveNotificationsBox.containsKey(notification.id)
                // ? context
                //     .read<NotificationWatcherCubit>()
                //     .removeNotificationAsFavorite(
                //       notificationId: notification.id!,
                //     )
                // : model.addRestaurantToFav(restaurant.id!),
                icon: Icon(
                  hiveFavoritesBox.containsKey(restaurant.id!)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: hiveFavoritesBox.containsKey(restaurant.id!)
                      ? kcRedColor
                      : kcSecondaryDarkColor,
                  size: 24.sp,
                ),
              );
            }),
      ),
    );
  }
}
