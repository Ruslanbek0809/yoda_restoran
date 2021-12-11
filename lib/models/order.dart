import 'models.dart';

class Order {
  final int id;
  final String restaurantName;
  final num orderPrice;
  final OrderStatus orderStatus;
  final List<MealUI> foodList;
  Order(this.id, this.restaurantName, this.orderPrice, this.orderStatus,
      this.foodList);
}
