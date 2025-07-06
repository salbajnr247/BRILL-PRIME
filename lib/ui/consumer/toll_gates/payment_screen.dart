import 'package:brill_prime/providers/toll_gate_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/in_app_browser_provider.dart';
import '../../../resources/constants/color_constants.dart';
import '../../widgets/constant_widgets.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_snack_back.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late AuthProvider authProvider;

  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
      isInspectable: kDebugMode,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllow: "camera; microphone",
      iframeAllowFullscreen: true);

  PullToRefreshController? pullToRefreshController;
  String url = "https://www.google.com";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final tollGateProvider =
          Provider.of<TollGateProvider>(context, listen: false);
      url = tollGateProvider.orderPlacedModel?.data ?? "";
      debugPrint("The URL is::: $url");
      setState(() {});
    });

    pullToRefreshController = kIsWeb
        ? null
        : PullToRefreshController(
            settings: PullToRefreshSettings(
              color: Colors.blue,
            ),
            onRefresh: () async {
              if (defaultTargetPlatform == TargetPlatform.android) {
                webViewController?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                webViewController?.loadUrl(
                    urlRequest:
                        URLRequest(url: await webViewController?.getUrl()));
              }
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    authProvider = context.watch<AuthProvider>();
    return Scaffold(
        backgroundColor: appBgColor,
        body: SafeArea(
            bottom: false,
            child: Consumer2<InAppBrowserProvider, TollGateProvider>(
                builder: (ctx, inAppBrowserProvider, tollGateProvider, child) {
              return Column(children: <Widget>[
                const TopPadding(),
                CustomAppbar(
                  title: inAppBrowserProvider.pageTitle,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Expanded(
                  child: Stack(
                    children: [
                      InAppWebView(
                        key: webViewKey,
                        initialUrlRequest: URLRequest(
                            url: WebUri(
                                tollGateProvider.orderPlacedModel?.data ?? "")),
                        initialSettings: settings,
                        pullToRefreshController: pullToRefreshController,
                        onWebViewCreated: (controller) {
                          webViewController = controller;
                        },
                        onLoadStart: (controller, url) async {
                          debugPrint("URL::: ${url.toString()}");
                          setState(() {
                            this.url = url.toString();
                            urlController.text = this.url;
                            debugPrint("URL Loaded::: ${url.toString()}");
                            if (url
                                .toString()
                                .toLowerCase()
                                .contains("?trxref")) {
                              final trxRef = url?.queryParameters['trxref'];
                              if (trxRef != null) {
                                // walletProvider.verifyTransaction(
                                //     context: context, transactionRef: trxRef);
                                // authProvider.getProfile(context: context);
                                // navToWithScreenName(
                                //     context: context,
                                //     screen: const SuccessScreen());
                              } else {
                                customSnackBar(
                                    context, "Could not verify transaction");
                                Navigator.pop(context);
                              }
                              authProvider.getProfile(context: context);
                            } else if (url
                                    .toString()
                                    .contains("?status=successful") ||
                                url.toString().contains("?status=completed")) {
                              String? trxRef =
                                  url?.queryParameters['tx_ref'] ?? "";
                              String paymentId =
                                  url?.queryParameters['transaction_id'] ?? "";
                              debugPrint(
                                  "The Transaction Ref is::::::::::$trxRef");
                              Navigator.pop(context, (
                                trxRef,
                                paymentId.isEmpty ? trxRef : paymentId
                              ));
                              authProvider.getProfile(context: context);
                            } else if (url
                                .toString()
                                .contains("?status=cancelled")) {
                              Navigator.pop(context);
                              authProvider.getProfile(context: context);
                            }
                          });

                          bool canGoBack = await controller.canGoBack();
                          bool canGoForward = await controller.canGoForward();
                          inAppBrowserProvider.updateCanGoBack(canGoBack);
                          inAppBrowserProvider.updateCanGoForward(canGoForward);
                        },
                        onPermissionRequest: (controller, request) async {
                          return PermissionResponse(
                              resources: request.resources,
                              action: PermissionResponseAction.GRANT);
                        },
                        shouldOverrideUrlLoading:
                            (controller, navigationAction) async {
                          var uri = navigationAction.request.url!;

                          if (![
                            "http",
                            "https",
                            "file",
                            "chrome",
                            "data",
                            "javascript",
                            "about"
                          ].contains(uri.scheme)) {
                            if (await canLaunchUrl(uri)) {
                              // Launch the App
                              await launchUrl(
                                uri,
                              );
                              // and cancel the request
                              return NavigationActionPolicy.CANCEL;
                            }
                          }

                          return NavigationActionPolicy.ALLOW;
                        },
                        onLoadStop: (controller, url) async {
                          bool canGoBack = await controller.canGoBack();
                          bool canGoForward = await controller.canGoForward();
                          inAppBrowserProvider.updateCanGoBack(canGoBack);
                          inAppBrowserProvider.updateCanGoForward(canGoForward);
                          pullToRefreshController?.endRefreshing();
                          setState(() {
                            this.url = url.toString();
                            urlController.text = this.url;
                          });
                        },
                        onReceivedError: (controller, request, error) {
                          pullToRefreshController?.endRefreshing();
                        },
                        onProgressChanged: (controller, progress) {
                          if (progress == 100) {
                            pullToRefreshController?.endRefreshing();
                          }
                          setState(() {
                            this.progress = progress / 100;
                            urlController.text = url;
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
                          if (kDebugMode) {
                            print(consoleMessage);
                          }
                        },
                      ),
                      progress < 1.0
                          ? const Center(child: CupertinoActivityIndicator())
                          : Container(),
                    ],
                  ),
                ),
              ]);
            })));
  }
}
