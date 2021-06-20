import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_vaxx_card_client/models/card_details.dart';
import 'package:smart_vaxx_card_client/screens/card/painter.dart';
import 'package:smart_vaxx_card_client/screens/view_card/main.dart';
import 'package:smart_vaxx_card_client/utils.dart';

class VaxxCardScreen extends StatelessWidget {
  final double _borderRadius = 24;
  final cards = FirebaseFirestore.instance.collection("cards");
  final userId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text('Vaccine Card'),
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: cards.where("userId", isEqualTo: userId).get(),
        builder: (ctx, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Oops! something went wrong'));
          }
          if (snapshot.hasData && snapshot.data!.size == 0) {
            return Center(child: Text('No cards on the cloud'));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            final list = snapshot.data!.docs
                .map((q) => CardDetails.fromMap(q.data()))
                .toList();
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final color = getColor(index);
                final startColor = color['start']!;
                final endColor = color['end']!;
                final cardDetails = list[index];
                return Material(
                  child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) =>
                                ViewCardScreen(cardDetails: cardDetails),
                          ),
                        );
                      },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(_borderRadius),
                                  gradient: LinearGradient(
                                      colors: [startColor, endColor],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight),
                                  boxShadow: [
                                    BoxShadow(
                                      color: endColor,
                                      blurRadius: 12,
                                      offset: Offset(0, 6),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                top: 0,
                                child: CustomPaint(
                                  size: Size(100, 150),
                                  painter: CustomCardShapePainter(
                                      _borderRadius, startColor, endColor),
                                ),
                              ),
                              Positioned.fill(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Image.asset(
                                        'images/vaccine-icon.png',
                                        height: 64,
                                        width: 64,
                                      ),
                                      flex: 2,
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            cardDetails.name,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Avenir',
                                                fontWeight: FontWeight.w700),
                                          ),
                                          SizedBox(height: 16),
                                          Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.location_on,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  cardDetails.location,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Avenir',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            cardDetails.dose,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Avenir',
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
