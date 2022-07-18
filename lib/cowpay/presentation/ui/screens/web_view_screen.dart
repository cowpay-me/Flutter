library cowpay;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cowpay/core/helpers/cowpay_helper.dart';
import 'package:cowpay/core/helpers/localization.dart';
import 'package:cowpay/cowpay/domain/entities/credit_card_entity.dart';
import 'package:cowpay/cowpay/presentation/ui/generic_views/dialog_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../data/models/payload_model.dart';

export 'package:cowpay/core/helpers/enum_models.dart';

class WebViewScreen extends StatefulWidget {
  final CreditCardEntity creditCardEntity;
  final Function(dynamic error) onError;

  WebViewScreen({required this.creditCardEntity, required this.onError});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Localization().localizationCode == LocalizationCode.ar
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          // title: Text(Localization().localizationMap["paymentMethod"]),
          backgroundColor: Color(0xff3D1A54),
        ),
        body: Column(
          children: [
            Expanded(
              child: WebView(
                initialUrl:
                    '${CowpayHelper.activeEnvironment!.baseUrl}/v2/card/form/${widget.creditCardEntity.token}',
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
                onProgress: (int progress) {
                  print("WebView is loading (progress : $progress%)");
                },
                javascriptChannels: <JavascriptChannel>{
                  _javascriptChannel(context),
                },
                // navigationDelegate: (NavigationRequest request) {
                //   if (request.url.contains('SUCCESS')) {
                //     return NavigationDecision.navigate;
                //   } else
                //     return NavigationDecision.navigate;
                // },
                onPageStarted: (String url) {
                  print('Page started loading: $url');
                },
                onPageFinished: (String url) {
                  print('Page finished loading: $url');
                },
                gestureNavigationEnabled: true,
              ),
            )
          ],
        ),
      ),
    );
  }

  JavascriptChannel _javascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'FlutterBridge',
        onMessageReceived: (message) {
          PayLoadModel model =
              PayLoadModel.fromJson(jsonDecode(message.message));
          if (model.paymentStatus == 'PAID') {
            _successDialog(context, model);
          } else {
            _errorDialog(context);
          }
        });
  }

  Future<void> _successDialog(
      BuildContext _context, PayLoadModel payLoadModel) {
    return showDialog(
        context: _context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return DialogView(
            dialogType: DialogType.DIALOG_INFO,
            actionText: "Done",
            content: "Your Payment Successfully Done",
            onCLick: (_) {
              //TODO: do onSuccess
              Navigator.of(context).pop(payLoadModel);
            },
            mainContext: _context,
            // title: 'Success',
          );
        });
  }

  Future<void> _errorDialog(BuildContext _context) {
    return showDialog(
        context: _context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return DialogView(
            // title: "Error",
            dialogType: DialogType.DIALOG_WARNING,
            actionText: "done",
            content: Localization().localizationMap["someThingWentWrong"],
            onCLick: (_) {
              widget.onError(
                  Localization().localizationMap["someThingWentWrong"]);
              Navigator.of(context).pop();
            },
            mainContext: _context,
          );
        });
  }
}
