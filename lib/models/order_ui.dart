import 'models.dart';

class OrderUI {
  final int id;
  final String restaurantName;
  final num orderPrice;
  final OrderStatus orderStatus;
  final List<MealUI> foodList;
  OrderUI(this.id, this.restaurantName, this.orderPrice, this.orderStatus,
      this.foodList);
}
