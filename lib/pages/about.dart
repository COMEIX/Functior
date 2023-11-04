import 'dart:io';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class AboutInfo extends StatelessWidget {
  const AboutInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        if (Platform.isWindows) windowManager.startDragging();
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // LOGO
              Container(
                decoration:
                    BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(0)),
                child: Row(
                  children: [
                    const Image(
                      width: 150,
                      height: 150,
                      image: AssetImage('images/logo.png'),
                    ),
                    Text(
                      "Functior",
                      style: TextStyle(
                        fontFamily: "PingFang SC",
                        fontWeight: FontWeight.w900,
                        fontSize: 36,
                        color: Colors.blueGrey[700],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 1),
              // Version
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration:
                    BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(0)),
                child: Row(
                  children: [
                    const Text(
                      '版本: ',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                        fontFamily: "PingFang SC",
                      ),
                    ),
                    Text(
                      'v2.0.0',
                      style:
                          TextStyle(fontFamily: 'PingFang SC', fontSize: 18, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 1),
              // Author
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration:
                    BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(0)),
                child: Row(
                  children: [
                    const Text(
                      '开发者： ',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                        fontFamily: "PingFang SC",
                      ),
                    ),
                    Text(
                      'COMEIX',
                      style:
                          TextStyle(fontFamily: 'PingFang SC', fontSize: 18, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 1),
              // Email
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration:
                    BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(0)),
                child: Row(
                  children: [
                    const Text(
                      '联系邮箱： ',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                        fontFamily: "PingFang SC",
                      ),
                    ),
                    Text(
                      '2245638853@qq.com',
                      style:
                          TextStyle(fontFamily: 'PingFang SC', fontSize: 18, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 1),
              // For Minecraft version
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration:
                    BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(0)),
                child: Row(
                  children: [
                    const Text(
                      '适配版本： ',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                        fontFamily: "PingFang SC",
                      ),
                    ),
                    Text(
                      'Minecraft Bedrock Edition v1.20+',
                      style:
                          TextStyle(fontFamily: 'PingFang SC', fontSize: 18, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 1),
            ],
          ),
        ),
      ),
    );
  }
}
