import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/utils/utils.dart';

import 'single_ex_view_model.dart';

class SingleExWebview extends HookViewModelWidget<SingleExViewModel> {
  final ExclusiveSingle singleEx;
  const SingleExWebview({required this.singleEx, Key? key}) : super(key: key);

  @override
  Widget buildViewModelWidget(BuildContext context, SingleExViewModel model) {
    model.log.v('singleEx.url!: ${singleEx.url!}');
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

    final urlController = useTextEditingController();

    PullToRefreshController pullToRefreshController = PullToRefreshController(
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

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            InAppWebView(
              key: webViewKey,
              initialUrlRequest: URLRequest(url: Uri.parse(singleEx.url!)),
              initialOptions: options,
              pullToRefreshController: pullToRefreshController,
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onLoadStart: (controller, url) {
                model.onLoadStart(url);
                urlController.text = model.url;
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
                model.onProgressChanged(progress);
                urlController.text = model.url;
              },
              onUpdateVisitedHistory: (controller, url, androidIsReload) {
                model.onLoadStart(url);
                urlController.text = model.url;
              },
              onConsoleMessage: (controller, consoleMessage) {
                print(consoleMessage);
              },
            ),
            model.progress < 1.0
                ? LinearProgressIndicator(
                    value: model.progress,
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
