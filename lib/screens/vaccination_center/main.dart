import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_vaxx_card_client/models/center_details.dart';
import 'package:smart_vaxx_card_client/screens/card/painter.dart';
import 'package:smart_vaxx_card_client/utils.dart';

import 'maps.dart';

class VaccinationCenterScreen extends StatelessWidget {
  final double _borderRadius = 24;
  final centers = FirebaseFirestore.instance.collection('centers');
  final userId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text('Vaccination centers'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: centers.snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Oops! something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && snapshot.data!.size == 0) {
            return Center(child: Text('No Centers available right now!!!'));
          }
          if (snapshot.hasData) {
            final list = snapshot.data!.docs
                .map((q) => CenterDetails.fromMap(q.data()))
                .toList();
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final color = getColor(index);
                final startColor = color['start']!;
                final endColor = color['end']!;
                final centerDetails = list[index];
                return Material(
                  child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => MapsScreen(
                              point: centerDetails.location,
                              name: centerDetails.name,
                            ),
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
                                      flex: 2,
                                      child: Image.asset(
                                        'images/vaccine-icon.png',
                                        height: 64,
                                        width: 64,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            centerDetails.name,
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
                                                  centerDetails.place,
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
