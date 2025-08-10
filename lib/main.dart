import 'package:flutter/material.dart';
import 'tools_config.dart'; // 导入工具配置文件
import 'theme_config.dart'; // 导入主题配置
import 'package:shared_preferences/shared_preferences.dart';

// 主题模式枚举
enum AppThemeMode { light, dark, auto }

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // 当前主题模式
  AppThemeMode _currentThemeMode = AppThemeMode.light;
  // 用于等待主题加载完成
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _loadSavedTheme();
  }

  // 加载保存的主题设置
  Future<void> _loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedThemeIndex = prefs.getInt('theme_mode') ?? 2; // 默认为自动模式
    setState(() {
      _currentThemeMode = AppThemeMode.values[savedThemeIndex];
    });
  }

  // 更新主题模式的方法
  void updateThemeMode(AppThemeMode newMode) {
    setState(() {
      _currentThemeMode = newMode;
      // 保存主题设置
      SharedPreferences.getInstance().then((prefs) {
        prefs.setInt('theme_mode', newMode.index);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: '集盒',
            theme: ThemeConfig.lightTheme,
            darkTheme: ThemeConfig.darkTheme,
            themeMode: _currentThemeMode == AppThemeMode.light 
                ? ThemeMode.light 
                : (_currentThemeMode == AppThemeMode.dark ? ThemeMode.dark : ThemeMode.system),
            home: HomeScreen(updateThemeMode: updateThemeMode, currentThemeMode: _currentThemeMode),
            // 使用工具配置生成路由
            routes: ToolsConfig.generateRoutes(),
          );
        } else {
          // 在加载主题时显示一个简单的加载界面
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  final Function(AppThemeMode) updateThemeMode;
  final AppThemeMode currentThemeMode;

  HomeScreen({required this.updateThemeMode, required this.currentThemeMode});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AppThemeMode _currentThemeMode;
  int _currentIndex = 0;

  // 定义页面列表
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _currentThemeMode = widget.currentThemeMode;
    _pages = [
      ToolsPage(),
      FavoritesPage(),
      SettingsPage(updateThemeMode: widget.updateThemeMode, currentThemeMode: _currentThemeMode),
    ];
  }

  // 在更新主题模式时更新页面列表
  void updateThemeMode(AppThemeMode newMode) {
    setState(() {
      _currentThemeMode = newMode;
      // 重新创建页面列表以更新SettingsPage
      _pages = [
        ToolsPage(),
        FavoritesPage(),
        SettingsPage(updateThemeMode: widget.updateThemeMode, currentThemeMode: _currentThemeMode),
      ];
    });
    // 调用父组件的更新方法
    widget.updateThemeMode(newMode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10.0,
              spreadRadius: 1.0,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey,
          backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          elevation: 0.0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: '工具',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_outlined),
              activeIcon: Icon(Icons.favorite),
              label: '收藏',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: '设置',
            ),
          ],
        ),
      ),
    );
  }
}

class ToolsPage extends StatelessWidget {
  // 从配置文件中获取工具分组数据
  final List<ToolGroup> _toolGroups = ToolsConfig.toolGroups;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('首页'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // 搜索功能
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              List.generate(
                _toolGroups.length,
                (index) => _buildToolGroup(_toolGroups[index], context),
              ),
            ),
          ),
        ),
      ],
    ),
  );
  }

  Widget _buildToolGroup(ToolGroup group, BuildContext context) {
    // 预先构建工具项列表，避免在构建过程中重复创建
    final toolWidgets = group.tools
        .map((tool) => _buildToolItem(tool, context))
        .toList(growable: false);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                group.title,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          Divider(height: 1.0, thickness: 1.0, color: Theme.of(context).dividerColor.withOpacity(0.2)),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.start,
              spacing: 16.0,
              runSpacing: 16.0,
              children: toolWidgets,
            ),
          ),
        ],
      ),
    );
  }

  /// 工具卡片组件
  /// 统一的工具项展示组件，用于在工具页面中显示各个工具
  Widget _buildToolItem(ToolItem tool, BuildContext context) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () {
          // 导航到对应页面
          Navigator.pushNamed(context, '/${tool.id}');
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (tool.icon != null)
                Icon(
                  tool.icon!,
                  size: 32.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
              if (tool.icon != null)
                SizedBox(height: 8.0),
              Text(
                tool.title,
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 工具卡片组件
/// 统一的工具项展示组件，用于在工具页面中显示各个工具
class ToolCard extends StatelessWidget {
  final ToolItem tool;

  const ToolCard({Key? key, required this.tool}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/${tool.id}');
        },
        borderRadius: BorderRadius.circular(16.0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (tool.icon != null) ...[
                Icon(
                  tool.icon!,
                  size: 40.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 12.0),
              ],
              Text(
                tool.title,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 占位页面组件
/// 用于在页面尚未实现时显示占位内容
class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).colorScheme.primary,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.build_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '$title 页面',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '此页面尚未实现',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              '请创建对应的页面文件',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

/// 收藏页面组件
class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('收藏'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_border_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '收藏页面',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '您还没有收藏任何内容',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              '点击工具卡片上的收藏按钮来添加收藏',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  final Function(AppThemeMode) updateThemeMode;
  final AppThemeMode currentThemeMode;

  SettingsPage({required this.updateThemeMode, required this.currentThemeMode});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // 当前主题模式
  late AppThemeMode _currentThemeMode;

  // 主题模式文本映射
  static const Map<AppThemeMode, String> _themeModeTexts = {
    AppThemeMode.light: '浅色主题',
    AppThemeMode.dark: '深色主题',
    AppThemeMode.auto: '自动模式',
  };

  // 主题模式图标映射
  static const Map<AppThemeMode, IconData> _themeModeIcons = {
    AppThemeMode.light: Icons.light_mode_outlined,
    AppThemeMode.dark: Icons.dark_mode_outlined,
    AppThemeMode.auto: Icons.auto_mode_outlined,
  };

  @override
  void initState() {
    super.initState();
    _currentThemeMode = widget.currentThemeMode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16.0),
              onTap: () {
                // 创建主题选项列表
                final List<AppThemeMode> themeModes = [
                  AppThemeMode.auto,
                  AppThemeMode.light,
                  AppThemeMode.dark,
                ];
                
                // 计算下一个主题模式
                final currentIndex = themeModes.indexOf(_currentThemeMode);
                final nextIndex = (currentIndex + 1) % themeModes.length;
                final nextThemeMode = themeModes[nextIndex];
                
                // 更新主题模式
                setState(() {
                  _currentThemeMode = nextThemeMode;
                  widget.updateThemeMode(nextThemeMode);
                });
              },
              child: ListTile(
              leading: Icon(
                Icons.color_lens_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                '主题设置',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '点击切换主题模式',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _themeModeIcons[_currentThemeMode] ?? Icons.auto_mode_outlined,
                    color: Theme.of(context).colorScheme.primary,
                    size: 16.0,
                  ),
                  SizedBox(width: 4.0),
                  Transform.translate(
                    offset: Offset(0, -1),
                    child: Text(
                      _themeModeTexts[_currentThemeMode] ?? '自动模式',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}