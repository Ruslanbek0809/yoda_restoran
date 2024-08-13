import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:stacked/stacked.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../models/models.dart';
import '../../../shared/shared.dart';
import '../../widgets/widgets.dart';
import 'order_view_model.dart';
import 'single_order_view.dart';

class OrdersView extends StatefulWidget {
  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  final _refreshController = RefreshController();

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OrderViewModel>.reactive(
      onViewModelReady: (model) async => await model.getInitialOrders(),
      builder: (context, model, child) {
        //*When the app is open and it receives a push notification
        FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
          model.log.v('OrdersView OnMESSAGE with data ${message.data}');

          if (message.notification != null) {
            model.log.v(
                'Message also contained a notification: ${message.notification}');
            model.log.v(
                'Message also contained a notification\' title: ${message.notification?.title ?? ''}');
            model.log.v(
                'Message also contained a notification\' body: ${message.notification?.body ?? ''}');
          }

          final noti = NotificationModel.fromJson(message.data);
          model.log.v(
              'notificationData JSON title: ${noti.title}, status: ${noti.status}');

          await model.getInitialOrders();
        });

        //*When the app is in the background and opened directly from the push notification. and to open a notification message displayed via FCM
        FirebaseMessaging.onMessageOpenedApp
            .listen((RemoteMessage message) async {
          model.log
              .v('OrdersView OnMESSAGE_OPENEDAPP with data ${message.data}');

          //* REINITIALIZES ORDERS
          await model.getInitialOrders();
        });
        return PopScope(
          canPop: false,
          onPopInvoked: (value) {
            model.navToHomeByRemovingAll(); // Workaround
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: kcWhiteColor,
              elevation: 0.5,
              leadingWidth: 35.w,
              leading: Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: kcFontColor,
                    size: 25.w,
                  ),
                  onPressed: model.navToHomeByRemovingAll,
                ),
              ),
              centerTitle: true,
              title: Text(
                LocaleKeys.myOrders,
                style: kts22DarkText,
              ).tr(),
            ),
            body: SmartRefresher(
              header: CustomHeaderWidget(isRefreshIgnored: true),
              footer: CustomFooterWidget(),
              controller: _refreshController,

              //*ORDER PAG
              enablePullUp: model.isPullUpEnabled,
              onRefresh: () async {
                await model.getInitialOrders();
                _refreshController.refreshCompleted();
              },

              //*ORDER PAG
              onLoading: () async {
                await model.getMorePaginatedOrders();
                _refreshController.loadComplete();
              },
              child: model.hasError && model.page == 1
                  ? ViewErrorWidget(
                      modelCallBack: () async => await model.getInitialOrders(),
                    )
                  : model.isBusy && model.page == 1
                      ? LoadingWidget()
                      : model.orders.isEmpty
                          ? EmptyWidget(
                              text: LocaleKeys.noOrdersYet,
                              svg: 'assets/empty_orders.svg',
                            )
                          : ListView.separated(
                              physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              itemCount: model.orders.length,
                              itemBuilder: (context, pos) {
                                Order order = model.orders[pos];
                                return SingleOrderView(
                                  order: order,
                                  orderViewModel: model,
                                );
                              },
                              separatorBuilder: (context, index) {
                                return Divider(
                                  thickness: 0.5,
                                  color: kcDividerColor,
                                );
                              },
                            ),
            ),
          ),
        );
      },
      viewModelBuilder: () => OrderViewModel(),
    );
  }
}
