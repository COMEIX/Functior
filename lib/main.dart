import 'dart:io';
import 'package:flutter/material.dart';
import 'package:functior/models/arg_asker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'pages/home_page.dart';
import 'global_box.dart';

void main() async {
  // * 无边框窗口化
  if (Platform.isWindows) {
    WidgetsFlutterBinding.ensureInitialized();
    WindowManager w = WindowManager.instance;
    await w.ensureInitialized();
    WindowOptions windowOptions =
        WindowOptions(size: await w.getSize(), center: true, titleBarStyle: TitleBarStyle.hidden);
    w.waitUntilReadyToShow(windowOptions, () async {
      await w.setBackgroundColor(Colors.transparent);
      await w.show();
      await w.focus();
      await w.setAsFrameless();
    });
  }

  // * Android 请求权限
  if (Platform.isAndroid) {
    WidgetsFlutterBinding.ensureInitialized();
    final prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('first_time') ?? true;

    if (isFirstTime) {
      await requestFilePermission();
      prefs.setBool('first_time', false);
    }
  }

  // * Run
  runApp(ChangeNotifierProvider(
    create: (context) => ArgsAsker(),
    child: GlobalBoxManager(
      child: const MaterialApp(
        home: MyApp(),
      ),
    ),
  ));

  // * 调整窗口大小
  if (Platform.isWindows) {
    doWhenWindowReady(() {
      final win = appWindow;
      const initialSize = Size(500, 1000);
      win.size = initialSize;
      win.alignment = Alignment.center;
      win.show();
    });
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ));
    return const MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}

// Request for file io permission
Future<void> requestFilePermission() async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.manageExternalStorage.request();
    await Permission.storage.request();
  }
}
