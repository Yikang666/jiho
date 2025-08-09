import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../theme_config.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    // 初始化WebView控制器
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://map.baidu.com'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('百度地图'),
        backgroundColor: ThemeConfig.primaryColor,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}