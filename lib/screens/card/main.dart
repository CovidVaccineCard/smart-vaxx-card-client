import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CardImage extends StatelessWidget {
  int? index;
  CardImage(int index) {
    this.index = index;
  }
  @override
  Widget build(BuildContext context) {
    debugPrint((this.index).toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("Demo"),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
