import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import '../../../../models/models.dart';
import '../../../../shared/shared.dart';
import '../../../../utils/utils.dart';
import '../../widgets/widgets.dart';
import 'single_order_view_model.dart';

class SingleOrderPaymentBottomSheetView extends StatefulWidget {
  final ScrollController scrollController;
  final double offset;
  final OrderPaymentRegister paymentRegister;
  const SingleOrderPaymentBottomSheetView({
    Key? key,
    required this.scrollController,
    required this.offset,
    required this.paymentRegister,
  }) : super(key: key);

  @override
  State<SingleOrderPaymentBottomSheetView> createState() =>
      _SingleOrderPaymentBottomSheetViewState();
}

class _SingleOrderPaymentBottomSheetViewState
    extends State<SingleOrderPaymentBottomSheetView> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
  );

  late PullToRefreshController pullToRefreshController;

  String url = "";

  double progress = 0;

  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: kcPrimaryColor,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SingleOrderViewModel>.reactive(
      viewModelBuilder: () => SingleOrderViewModel(),
      builder: (context, model, child) => Container(
        decoration: BoxDecoration(
          color: kcWhiteColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Constants.BORDER_RADIUS_20),
          ),
        ),
        child: Column(
          children: [
            // --------------- CUSTOM BOTTOM SHEET MODAL WIDGET -------------- //
            CustomModalInsideBottomSheet(),

            // --------------- CREDIT CARD CONFIRMATION -------------- //
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Stack(
                  children: [
                    InAppWebView(
                      key: webViewKey,
                      initialUrlRequest: URLRequest(
                        url: Uri.parse(widget.paymentRegister.formUrl!),
                      ),
                      initialOptions: options,
                      pullToRefreshController: pullToRefreshController,
                      onWebViewCreated: (controller) {
                        webViewController = controller;
                      },
                      onLoadStart: (controller, url) {
                        setState(() {
                          this.url = url.toString();
                          urlController.text = this.url;
                        });
                      },
                      androidOnPermissionRequest:
                          (controller, origin, resources) async {
                        return PermissionRequestResponse(
                            resources: resources,
                            action: PermissionRequestResponseAction.GRANT);
                      },
                      onProgressChanged: (controller, progress) {
                        if (progress == 100) {
                          pullToRefreshController.endRefreshing();
                        }
                        setState(() {
                          this.progress = progress / 100;
                          urlController.text = this.url;
                        });
                      },
                      onUpdateVisitedHistory:
                          (controller, url, androidIsReload) {
                        setState(() {
                          this.url = url.toString();
                          urlController.text = this.url;
                        });
                      },
                      onConsoleMessage: (controller, consoleMessage) {
                        /// Function onConsoleMessage
                        model.onConsoleMessage(
                          paymentRegister: widget.paymentRegister,
                          controller: controller,
                          consoleMessage: consoleMessage,
                          onSuccessForView: () async {
                            Navigator.pop(context);
                            await model.showOnlinePaymentSuccessDialog();
                          },
                          onFailForView: () async {
                            Navigator.pop(context);
                            await model.showOnlinePaymentFailDialog();
                          },
                        );
                      },
                    ),
                    progress < 1.0
                        ? LinearProgressIndicator(
                            value: progress,
                            backgroundColor: kcPrimaryColor.withOpacity(0.3),
                            color: kcPrimaryColor,
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
