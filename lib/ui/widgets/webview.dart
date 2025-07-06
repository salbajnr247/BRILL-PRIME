// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart' hide WebView;
// import 'package:get/get.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// class LoadWebview extends StatefulWidget {
//   final String url;
//   const LoadWebview({required Key key, required this.url}) : super(key: key);
//
//   @override
//   State<LoadWebview> createState() => _LoadWebviewState();
// }
//
// class _LoadWebviewState extends State<LoadWebview> {
//   WebViewController controller = WebViewController()
//     ..setJavaScriptMode(JavaScriptMode.unrestricted)
//     ..setNavigationDelegate(
//       NavigationDelegate(
//         onNavigationRequest: (NavigationRequest request) {
//           if (request.url == 'https://tryba.io/login') {
//             Get.back();
//             return NavigationDecision.prevent;
//           }
//           return NavigationDecision.navigate;
//         },
//       ),
//     );
//
//   @override
//   void initState() {
//     super.initState();
//     controller.loadRequest(Uri.parse(widget.url));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         // appBar: appBar('Back', centerTitle: false),
//         body: WebViewWidget(controller: controller));
//   }
// }
//
// class CustomWebView extends StatelessWidget {
//   final String url;
//   const CustomWebView({Key? key, required this.url}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: InAppWebView(
//           androidOnPermissionRequest: (controller, origin, resources) async {
//             return PermissionRequestResponse(
//                 resources: resources,
//                 action: PermissionRequestResponseAction.GRANT);
//           },
//           shouldOverrideUrlLoading: (controller, navigationAction) async {
//             // if (uri == Uri.parse('$baseUrl/yoti-success')) {
//             //   Get.back();
//             //   return NavigationActionPolicy.CANCEL;
//             // }
//
//             return NavigationActionPolicy.ALLOW;
//           },
//           initialOptions: InAppWebViewGroupOptions(
//             crossPlatform: InAppWebViewOptions(
//               useShouldOverrideUrlLoading: true,
//               mediaPlaybackRequiresUserGesture: false,
//             ),
//             android: AndroidInAppWebViewOptions(
//               useHybridComposition: true,
//               allowContentAccess: true,
//               domStorageEnabled: true,
//               databaseEnabled: true,
//               clearSessionCache: true,
//               thirdPartyCookiesEnabled: true,
//               allowFileAccess: true,
//             ),
//             ios: IOSInAppWebViewOptions(
//               allowsInlineMediaPlayback: true,
//             ),
//           ),
//           initialUrlRequest: URLRequest(url: WebUri(url)),
//         ),
//       ),
//     );
//   }
// }
