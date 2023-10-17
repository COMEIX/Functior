import 'dart:io';
import 'package:flutter/material.dart';
import 'package:functior/models/args_asker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import './pages/home_page.dart';
import 'package:flutter/services.dart';

void main() async {
  if (Platform.isAndroid) {
    WidgetsFlutterBinding.ensureInitialized();
    final prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('first_time') ?? true;

    if (isFirstTime) {
      await requestFilePermission();
      prefs.setBool('first_time', false);
    }
  }
  runApp(ChangeNotifierProvider(
    create: (context) => ArgsAsker(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      // 沉浸式状态栏（仅安卓）
      statusBarColor: Colors.transparent,
      // 沉浸式导航指示器
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
