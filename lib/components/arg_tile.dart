import 'package:flutter/material.dart';
import '../models/arg.dart';

class TextArgTile extends StatelessWidget {
  final Arg arg;
  const TextArgTile({super.key, required this.arg});

  void giveExplaination(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('详解 Explaination'),
              content: Text(arg.explaination),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
      child: ListTile(
        title: Row(
          children: [
            Text(arg.name),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: () => giveExplaination(context),
              child: Icon(arg.icon, size: 20),
            )
          ],
        ),
        subtitle: TextField(
          controller: arg.controller,
          decoration: InputDecoration(hintText: arg.hintText),
        ),
      ),
    );
  }
}
