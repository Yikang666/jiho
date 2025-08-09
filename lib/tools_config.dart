import 'package:flutter/material.dart';
import 'theme_config.dart';
import "pages/map.dart";

// 工具项模型
class ToolItem {
  final String id;
  final String title;
  final IconData icon;
  final String pagePath;

  ToolItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.pagePath,
  });
}

// 工具组模型
class ToolGroup {
  final String id;
  final String title;
  final List<ToolItem> tools;

  ToolGroup({
    required this.id,
    required this.title,
    required this.tools,
  });
}

// 工具配置类
class ToolsConfig {
  // 所有工具组
  static final List<ToolGroup> toolGroups = [
    ToolGroup(
      id: 'common',
      title: '常用工具',
      tools: [
        ToolItem(
          id: 'calculator',
          title: '计算器',
          icon: Icons.calculate,
          pagePath: 'pages/calculator_page.dart',
        ),
        ToolItem(
          id: 'translator',
          title: '翻译',
          icon: Icons.translate,
          pagePath: 'pages/translator_page.dart',
        ),
        ToolItem(
          id: 'notebook',
          title: '记事本',
          icon: Icons.note,
          pagePath: 'pages/notebook_page.dart',
        ),
      ],
    ),
    ToolGroup(
      id: 'efficiency',
      title: '效率工具',
      tools: [
        ToolItem(
          id: 'timer',
          title: '计时器',
          icon: Icons.timer,
          pagePath: 'pages/timer_page.dart',
        ),
        ToolItem(
          id: 'qr_code',
          title: '二维码',
          icon: Icons.qr_code,
          pagePath: 'pages/qr_code_page.dart',
        ),
        ToolItem(
          id: 'color_picker',
          title: '取色器',
          icon: Icons.color_lens,
          pagePath: 'pages/color_picker_page.dart',
        ),
      ],
    ),
    ToolGroup(
      id: 'other',
      title: '其他工具',
      tools: [
        ToolItem(
          id: 'camera',
          title: '相机',
          icon: Icons.camera,
          pagePath: 'pages/camera_page.dart',
        ),
        ToolItem(
          id: 'music',
          title: '音乐',
          icon: Icons.music_note,
          pagePath: 'pages/music_page.dart',
        ),
        ToolItem(
          id: 'map',
          title: '地图',
          icon: Icons.map,
          pagePath: 'pages/map.dart',
        ),
      ],
    ),
  ];

  // 根据工具ID获取页面路径
  static String getPagePath(String toolId) {
    for (final group in toolGroups) {
      for (final tool in group.tools) {
        if (tool.id == toolId) {
          return tool.pagePath;
        }
      }
    }
    return '';
  }

  // 生成路由配置
  static Map<String, WidgetBuilder> generateRoutes() {
    final Map<String, WidgetBuilder> routes = {};
    for (final group in toolGroups) {
      for (final tool in group.tools) {
        routes['/${tool.id}'] = (context) {
          // 尝试动态导入页面
          // 这里我们使用占位页面，实际项目中可以使用反射或代码生成
          return PlaceholderPage(title: tool.title);
        };
      }
    }
    // 特殊处理地图页面，因为它已经实现
    routes['/map'] = (context) => MapPage();
    return routes;
  }
}

// 占位页面组件
class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: ThemeConfig.primaryColor,
        titleTextStyle: TextStyle(
          color: ThemeConfig.textOnPrimaryColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Center(
        child: Text(
          '$title 页面尚未实现',
          style: TextStyle(
            color: ThemeConfig.textPrimaryColor,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
