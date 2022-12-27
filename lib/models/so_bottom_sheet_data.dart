import '../ui/cart/order/order_view_model.dart';
import 'models.dart';

class SOBottomSheetData {
  SOBottomSheetData({
    required this.order,
    required this.orderViewModel,
  });
  final Order order;
  final OrderViewModel orderViewModel;
}
