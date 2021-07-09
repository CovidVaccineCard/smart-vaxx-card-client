import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_vaxx_card_client/models/center_details.dart';
import 'package:smart_vaxx_card_client/screens/card/painter.dart';
import 'package:smart_vaxx_card_client/utils.dart';

import 'maps.dart';

class CentersListView extends StatelessWidget {
  CentersListView(
      {required this.streamKey,
      required this.centers,
      required double latitude,
      required double longitude}) {
    var lowerLat = latitude - (lat * distance);
    var lowerLon = longitude - (lon * distance);

    var greaterLat = latitude + (lat * distance);
    var greaterLon = longitude + (lon * distance);
    var lesserGeopoint = GeoPoint(lowerLat, lowerLon);
    var greaterGeopoint = GeoPoint(greaterLat, greaterLon);
    stream = centers
        .where('location', isGreaterThan: lesserGeopoint)
        .where('location', isLessThan: greaterGeopoint)
        .snapshots();
  }

  final ValueKey<String> streamKey;
  final double _borderRadius = 24;
  final CollectionReference<Map<String, dynamic>> centers;
  late Stream<QuerySnapshot<Map<String, dynamic>>> stream;
  double lat = 0.0144927536231884;
  double lon = 0.0181818181818182;
  final distance = 618.0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      key: streamKey,
      stream: stream,
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
    );
  }
}
