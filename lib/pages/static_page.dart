import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StaticPage extends StatefulWidget {
  final String page;
  const StaticPage({Key? key, required this.page}) : super(key: key);

  @override
  State<StaticPage> createState() => _StaticPageState();
}

class _StaticPageState extends State<StaticPage> {

  late String pageUrl;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    if(widget.page == "privacy-policy") {
      pageUrl = "https://trackmymoney.xyz/privacy-policy";
    }
    else if(widget.page == "terms-of-service") {
      pageUrl = "https://trackmymoney.xyz/terms-of-service";
    }
    else {
      pageUrl = "https://trackmymoney.xyz";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebView(
          initialUrl: pageUrl,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
