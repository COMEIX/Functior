import 'package:flutter/material.dart';
import 'package:functior/components/bottom_nav_bar.dart';
import '../const.dart';
import './to_particles.dart';
import './to_blocks.dart';
import './about.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = const [ToParticles(), ToBlocks(), AboutInfo()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      bottomNavigationBar: MyBottomNavBar(
        onTabChange: (index) => navigateBottomBar(index!),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
