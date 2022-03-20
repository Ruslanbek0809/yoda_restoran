import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/shared/shared.dart';
import 'package:yoda_res/utils/utils.dart';
import '../../widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'single_ex_view_model.dart';

class SingleExWebview extends StatefulWidget {
  final ExclusiveSingle singleEx;
  final SingleExViewModel singleExViewModel;
  const SingleExWebview(
      {required this.singleEx, required this.singleExViewModel, Key? key})
      : super(key: key);

  @override
  State<SingleExWebview> createState() => _SingleExWebviewState();
}

class _SingleExWebviewState extends State<SingleExWebview> {
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
        //------------------ ACTIONS FAV ---------------------//
        actions: [
          IconButton(
            onPressed: widget.singleExViewModel.createDynamicLink,
            icon: Icon(
              Icons.share,
              size: 24.w,
              color: kcSecondaryDarkColor,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            InAppWebView(
              key: webViewKey,
              initialUrlRequest:
                  URLRequest(url: Uri.parse(widget.singleEx.url!)),
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
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:stacked_hooks/stacked_hooks.dart';
// import 'package:yoda_res/models/models.dart';
// import 'package:yoda_res/utils/utils.dart';

// import 'single_ex_view_model.dart';

// class SingleExWebview extends HookViewModelWidget<SingleExViewModel> {
//   final ExclusiveSingle singleEx;
//   const SingleExWebview({required this.singleEx, Key? key}) : super(key: key);

//   @override
//   Widget buildViewModelWidget(BuildContext context, SingleExViewModel model) {
//     final GlobalKey webViewKey = GlobalKey();

//     InAppWebViewController? webViewController;

//     InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
//       crossPlatform: InAppWebViewOptions(
//         useShouldOverrideUrlLoading: true,
//         mediaPlaybackRequiresUserGesture: false,
//       ),
//       android: AndroidInAppWebViewOptions(
//         useHybridComposition: true,
//       ),
//       ios: IOSInAppWebViewOptions(
//         allowsInlineMediaPlayback: true,
//       ),
//     );

//     final urlController = useTextEditingController();

//     PullToRefreshController pullToRefreshController = PullToRefreshController(
//       options: PullToRefreshOptions(
//         color: AppTheme.MAIN,
//       ),
//       onRefresh: () async {
//         if (Platform.isAndroid) {
//           webViewController?.reload();
//         } else if (Platform.isIOS) {
//           webViewController?.loadUrl(
//               urlRequest: URLRequest(url: await webViewController?.getUrl()));
//         }
//       },
//     );

//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           children: [
//             InAppWebView(
//               key: webViewKey,
//               initialUrlRequest: URLRequest(url: Uri.parse(singleEx.url!)),
//               initialOptions: options,
//               pullToRefreshController: pullToRefreshController,
//               onWebViewCreated: (controller) {
//                 webViewController = controller;
//               },
//               onLoadStart: (controller, url) {
//                 model.onLoadStart(url);
//                 urlController.text = model.url;
//               },
//               androidOnPermissionRequest:
//                   (controller, origin, resources) async {
//                 return PermissionRequestResponse(
//                     resources: resources,
//                     action: PermissionRequestResponseAction.GRANT);
//               },
//               onProgressChanged: (controller, progress) {
//                 if (progress == 100) {
//                   pullToRefreshController.endRefreshing();
//                 }
//                 model.onProgressChanged(progress);
//                 urlController.text = model.url;
//               },
//               onUpdateVisitedHistory: (controller, url, androidIsReload) {
//                 model.onLoadStart(url);
//                 urlController.text = model.url;
//               },
//               onConsoleMessage: (controller, consoleMessage) {
//                 print(consoleMessage);
//               },
//             ),
//             model.progress < 1.0
//                 ? LinearProgressIndicator(
//                     value: model.progress,
//                     backgroundColor: AppTheme.MAIN.withOpacity(0.3),
//                     color: AppTheme.MAIN,
//                   )
//                 : SizedBox(),
//           ],
//         ),
//       ),
//     );
//   }
// }
