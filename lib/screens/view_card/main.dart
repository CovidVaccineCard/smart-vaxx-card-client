import 'package:flutter/material.dart';
import 'package:smart_vaxx_card_client/models/card_details.dart';

class ViewCardScreen extends StatelessWidget {
  final CardDetails cardDetails;

  const ViewCardScreen({required this.cardDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close),
        ),
        title: Text('View card'),
      ),
      body: Center(
        child: Text(cardDetails.name),
      ),
    );
  }
}
