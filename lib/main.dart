import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixgem/pages/illust/download_manage/download_manage_page.dart';
import 'package:pixgem/pages/illust/history/history_page.dart';
import 'package:pixgem/pages/illust/illust_detail/illust_detail_page.dart';
import 'package:pixgem/pages/illust/leaderboard/illust_leaderboard_page.dart';
import 'package:pixgem/pages/illust/preview/illust_preview_page.dart';
import 'package:pixgem/pages/main_navigation.dart';
import 'package:pixgem/pages/setting/download/download_setting.dart';
import 'package:pixgem/pages/setting/network/network_setting.dart';
import 'package:provider/provider.dart';
import 'booting_page.dart';
import 'pages/account/account_manage/account_manage_page.dart';
import 'pages/login/login_by_web_page.dart';
import 'pages/login/login_wizard_page.dart';
import 'pages/search/result/search_result_page.dart';
import 'pages/user/user_detail/user_detail_page.dart';
import 'pages/user/following/user_following_page.dart';
import 'store/global.dart';
import 'pages/comment/comments_page.dart';
import 'pages/setting/theme/theme_setting.dart';
import 'pages/user/bookmark/my_bookmarks.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GlobalStore.globalProvider = GlobalProvider();
  // 其他数据在BootingPage里进行加载
  // 运行APP
  runApp(const MyApp());
  // 状态栏无前景色的沉浸式
  SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}

/* 初始化一些APP全局设定，不加载内容 */
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // var mode = ThemeStore.getThemeMode() ?? MyThemeMode.AUTO;
    ThemeData themeDataLight = ThemeData(
      brightness: Brightness.light,
      primaryColorBrightness: Brightness.light,
      // 控件亮度，影响上层文字颜色
      appBarTheme: const AppBarTheme(
        // appbar专门特制
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 18),
        toolbarTextStyle: TextStyle(color: Colors.black),
        foregroundColor: Colors.black,
      ),
      colorScheme: ColorScheme.light(
        secondary: Colors.deepOrangeAccent,
        secondaryVariant: Colors.deepOrangeAccent.shade400,
        onPrimary: Colors.white, // button文字图标颜色等
      ),
    );
    ThemeData themeDataDark = ThemeData(
      brightness: Brightness.dark,
      primaryColorBrightness: Brightness.dark,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey.shade900,
      ),
      colorScheme: ColorScheme.dark(
        primary: Colors.cyan,
        primaryVariant: Colors.cyan.shade700,
        secondary: Colors.orangeAccent,
        secondaryVariant: Colors.orangeAccent.shade400,
        // onPrimary: Colors.black,
      ),
    );
    return ChangeNotifierProvider(
      create: (context) => GlobalStore.globalProvider,
      child: Selector(
        selector: (BuildContext context, GlobalProvider provider) {
          return provider.themeMode;
        },
        builder: (BuildContext context, ThemeMode mode, Widget? child) {
          return MaterialApp(
            title: 'Pixgem',
            onGenerateRoute: (RouteSettings settings) {
              var routes = <String, WidgetBuilder>{
                "main": (context) => const MainNavigation(),
                "login_wizard": (context) => const LoginWizardPage(),
                "login_web": (context) => const LoginWebPage(),
                "artworks_leaderboard": (context) => const ArtworksLeaderboardPage(),
                "artworks_detail": (context) => ArtWorksDetailPage(settings.arguments!),
                "artworks_view": (context) => PreviewArtworksPage(settings.arguments!),
                "artworks_comments": (context) => CommentsPage(settings.arguments!),
                "user_following": (context) => UserFollowingPage(settings.arguments!),
                "user_detail": (context) => UserDetailPage(settings.arguments!),
                "search_result": (context) => SearchResultPage(settings.arguments!),
                "my_bookmarks": (context) => MyBookmarksPage(settings.arguments),
                "view_history": (context) => ViewHistoryPage(),
                "account_manage": (context) => const AccountManagePage(),
                "download_manage": (context) => const DownloadManagePage(),
                "setting_download": (context) => const SettingDownload(),
                "setting_theme": (context) => const SettingThemePage(),
                "setting_network": (context) => const SettingNetworkPage(),
              };
              WidgetBuilder builder = routes[settings.name]!;
              return MaterialPageRoute(builder: (context) => builder(context));
            },
            // 启动加载页面，在这里面初始化全局数据
            home: const BootingPage(),
            theme: themeDataLight,
            darkTheme: themeDataDark,
            themeMode: mode,
            // localizationsDelegates: [
            //   GlobalMaterialLocalizations.delegate,
            //   GlobalWidgetsLocalizations.delegate,
            // ],
            // supportedLocales: [
            //   const Locale('zh', 'CN'),
            //   const Locale('en', 'US'),
            // ],
          );
        },
      ),
    );
  }
}
