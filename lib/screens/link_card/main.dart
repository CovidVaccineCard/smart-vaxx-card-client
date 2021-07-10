import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_vaxx_card_client/models/card_details.dart';
import 'package:smart_vaxx_card_client/screens/link_card/arguments.dart';
import 'package:smart_vaxx_card_client/screens/view_card/main.dart';

class LinkCardScreen extends StatefulWidget {
  static const routeName = '/link-card';
  final cards = FirebaseFirestore.instance.collection('cards');

  @override
  _LinkCardScreenState createState() => _LinkCardScreenState();
}

class _LinkCardScreenState extends State<LinkCardScreen> {
  Future<Map<String, dynamic>> fetchCard(String cardId) async {
    final doc = await widget.cards.doc(cardId).get();
    if (!doc.exists) {
      return {
        'completed': true,
        'card': null,
      };
    }
    final card = CardDetails.fromMap(doc.data()!);
    return {
      'completed': true,
      'card': card,
    };
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as LinkCardScreenArguments;
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchCard(args.cardId),
      builder: (ctx, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('error'),
            ),
          );
        }
        if (snapshot.hasData) {
          final card = snapshot.data!['card'] as CardDetails?;
          if (card == null) {
            Navigator.popAndPushNamed(context, '/');
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return ViewCardScreen(cardDetails: card, fromLink: true);
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
