import 'package:flutter/material.dart';

class AboutInfo extends StatefulWidget {
  const AboutInfo({super.key});

  @override
  State<AboutInfo> createState() => _AboutInfoState();
}

class _AboutInfoState extends State<AboutInfo> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          // LOGO
          Container(
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              children: [
                const Image(
                  width: 150,
                  height: 150,
                  image: AssetImage('images/logo.png'),
                ),
                Text(
                  'Functior',
                  style: TextStyle(
                      fontFamily: 'Helvetica',
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
                      color: Colors.blueGrey[700]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 1),
          // Version
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              children: [
                const Text(
                  '版本: ',
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
                Text(
                  'v2.0.0',
                  style: TextStyle(
                      fontFamily: 'Helvetica',
                      fontSize: 18,
                      color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 1),
          // Author
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              children: [
                const Text(
                  '开发者： ',
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
                Text(
                  'COMEIX',
                  style: TextStyle(
                      fontFamily: 'Helvetica',
                      fontSize: 18,
                      color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 1),
          // Email
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              children: [
                const Text(
                  '联系邮箱： ',
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
                Text(
                  '2245638853@qq.com',
                  style: TextStyle(
                      fontFamily: 'Helvetica',
                      fontSize: 18,
                      color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 1),
          // For Minecraft version
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              children: [
                const Text(
                  '适配版本： ',
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
                Text(
                  'Minecraft Bedrock Edition v1.20+',
                  style: TextStyle(
                      fontFamily: 'Helvetica',
                      fontSize: 18,
                      color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 1),
        ],
      ),
    ));
  }
}
