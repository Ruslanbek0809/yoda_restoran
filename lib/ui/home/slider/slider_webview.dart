import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:yoda_res/utils/utils.dart';
import '../../widgets/widgets.dart';

class SliderWebview extends StatefulWidget {
  final String sliderUrl;
  const SliderWebview({required this.sliderUrl, Key? key}) : super(key: key);

  @override
  State<SliderWebview> createState() => _SliderWebviewState();
}

class _SliderWebviewState extends State<SliderWebview> {
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
        color: AppTheme.MAIN,
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.WHITE,
        elevation: 0.5,
        leading: BackButtonWidget(),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            InAppWebView(
              key: webViewKey,
              initialUrlRequest: URLRequest(url: Uri.parse(widget.sliderUrl)),
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
              onUpdateVisitedHistory: (controller, url, androidIsReload) {
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              onConsoleMessage: (controller, consoleMessage) {
                print(consoleMessage);
              },
            ),
            progress < 1.0
                ? LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppTheme.MAIN.withOpacity(0.3),
                    color: AppTheme.MAIN,
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
