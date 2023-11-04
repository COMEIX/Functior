import 'package:flutter/material.dart';

class Arg {
  final String name;
  final IconData icon;
  final String hintText;
  final TextEditingController controller;
  final dynamic defaultValue;
  final String explaination;

  Arg(
      {required this.name,
      required this.icon,
      required this.hintText,
      required this.controller,
      required this.defaultValue,
      required this.explaination});
}