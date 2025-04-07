import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart'; // WebView için gerekli paket

class ZimbraPage extends StatefulWidget {
  final String url;

  const ZimbraPage({super.key, required this.url});

  @override
  State<ZimbraPage> createState() => _ZimbraPageState();
}

class _ZimbraPageState extends State<ZimbraPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: _controller),
    );
  }
}
