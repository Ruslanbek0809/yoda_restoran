import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../app/app.router.dart';
import '../../../models/models.dart';
import '../../../services/services.dart';

class OrderViewModel extends BaseViewModel {
  final log = getLogger('OrderViewModel');

  final _navService = locator<NavigationService>();
  final _orderService = locator<OrderService>();

//*----------------------- ORDER PART ----------------------------//

  List<Order> get orders => _orderService.orders;

  //*ORDER PAG
  int get page => _orderService.page;
  bool get isPullUpEnabled => _orderService.isPullUpEnabled;

  //*GETS initial orders
  Future getInitialOrders() async =>
      await runBusyFuture(_orderService.getInitialPaginatedOrders());

  //*GETS more paginated orders
  Future getMorePaginatedOrders() async =>
      await runBusyFuture(_orderService.getPaginatedOrders());

//*----------------------- ORDER SUCCESS PART ----------------------------//

  //*NAVIGATES to Home by removing all previous routes
  Future<void> navToHomeByRemovingAll() async =>
      await _navService.pushNamedAndRemoveUntil(Routes.homeView);

  //*NAVIGATES to Orders by removing all previous routes
  Future<void> navToOrdersByRemovingAll() async =>
      await _navService.pushNamedAndRemoveUntil(Routes.ordersView);
}
