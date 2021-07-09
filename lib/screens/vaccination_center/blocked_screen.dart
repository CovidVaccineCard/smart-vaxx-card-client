import 'package:flutter/material.dart';

class BlockedScreen extends StatelessWidget {
  const BlockedScreen({required this.message, required this.clickHandler});
  final String message;
  final Function() clickHandler;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            message,
            style: TextStyle(fontSize: 30),
          ),
          TextButton(
            onPressed: clickHandler,
            child: const Text('Enable', style: TextStyle(fontSize: 20)),
          )
        ],
      ),
    );
  }
}
