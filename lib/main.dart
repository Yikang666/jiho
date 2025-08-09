import 'package:flutter/material.dart';
import 'tools_config.dart'; // 导入工具配置文件
import 'theme_config.dart'; // 导入主题配置
import 'pages/map.dart'; // 临时保留，后续可以考虑通过反射或代码生成移除

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '集盒',
      theme: ThemeConfig.lightTheme,
      darkTheme: ThemeConfig.darkTheme,
      themeMode: ThemeMode.system, // 跟随系统主题
      home: HomeScreen(),
      // 使用工具配置生成路由
      routes: ToolsConfig.generateRoutes(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // 定义页面列表
  final List<Widget> _pages = [
    ToolsPage(),
    FavoritesPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('集盒'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // 搜索功能
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '工具',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: '收藏',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '设置',
          ),
        ],
      ),
    );
  }
}

class ToolsPage extends StatefulWidget {
  @override
  _ToolsPageState createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // 从配置文件中获取工具分组数据
  final List<ToolGroup> _toolGroups = ToolsConfig.toolGroups;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _toolGroups.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 标签栏
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _toolGroups.map((group) {
            return Tab(text: group.title);
          }).toList(),
        ),
        // 标签内容
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: _toolGroups.map((group) {
              return GridView.count(
                crossAxisCount: 3,
                padding: EdgeInsets.all(16.0),
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                children: group.tools.map((tool) {
                  return ToolCard(tool: tool);
                }).toList(),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class ToolCard extends StatelessWidget {
  final ToolItem tool;

  ToolCard({required this.tool});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () {
          // 工具点击事件 - 导航到对应页面
          Navigator.pushNamed(
            context,
            '/${tool.id}', // 使用工具ID作为路由名称
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(tool.icon, size: 40.0, color: Colors.blue),
            SizedBox(height: 8.0),
            Text(
              tool.title,
              style: TextStyle(fontSize: 14.0),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// 占位页面 - 实际使用时应该替换为真正的页面实现
class PlaceholderPage extends StatelessWidget {
  final String title;

  PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$title 页面',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text('此页面尚未实现，请创建对应的页面文件。'),
          ],
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '收藏页面',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '设置页面',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}