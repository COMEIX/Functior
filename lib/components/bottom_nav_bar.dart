import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

// ignore: must_be_immutable
class MyBottomNavBar extends StatelessWidget {
  void Function(int?) onTabChange;
  MyBottomNavBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: GNav(
          onTabChange: (value) => onTabChange(value),
          mainAxisAlignment: MainAxisAlignment.center,
          color: Colors.grey[400],
          activeColor: Colors.grey[700],
          tabBackgroundColor: Colors.grey.shade300,
          tabs: const [
            GButton(
              icon: Icons.bubble_chart,
              text: 'ToParticles',
            ),
            GButton(
              icon: Icons.filter_hdr,
              text: 'ToBlocks',
            ),
            GButton(
              icon: Icons.nights_stay,
              text: 'About',
            )
          ]),
    );
  }
}
