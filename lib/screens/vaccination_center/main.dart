import 'package:flutter/material.dart';

import 'package:smart_vaxx_card_client/models/place_info.dart';
import 'package:smart_vaxx_card_client/screens/card/painter.dart';

class VaccinationCenterScreen extends StatelessWidget {
  final double _borderRadius = 24;

  var items = [
    PlaceInfo(
      'Hospital 1',
      Color(0xff6DC8F3),
      Color(0xff73A1F9),
      500,
      'cbe',
    ),
    PlaceInfo(
      'hospital 2',
      Color(0xffFFB157),
      Color(0xffFFA057),
      100,
      'Cbe',
    ),
    PlaceInfo(
      'hosital 4',
      Color(0xffFF5B95),
      Color(0xffF8556D),
      1000,
      'Coimbatore',
    ),
    PlaceInfo(
      'MMMMM',
      Color(0xffD76EF5),
      Color(0xff8F7AFE),
      122,
      'mmm',
    ),
    PlaceInfo('xxxxx', Color(0xff42E695), Color(0xff3BB2B8), 66, 'xxxx'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vaccine Card'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              // onTap: () {
              //   setState(() {
              //     int sno = index;
              //     navigate(sno);
              //   });
              // },
              child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: <Widget>[
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(_borderRadius),
                      gradient: LinearGradient(colors: [
                        items[index].startColor,
                        items[index].endColor
                      ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      boxShadow: [
                        BoxShadow(
                          color: items[index].endColor,
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
                      painter: CustomCardShapePainter(_borderRadius,
                          items[index].startColor, items[index].endColor),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                items[index].name,
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
                                      items[index].location,
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
                                items[index].days.toString(),
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
          ));
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: Icon(Icons.search),
      // ),
    );
  }

//   createAlertDialog(BuildContext context) {
//     TextEditingController searchElementController = TextEditingController();
//     return showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text("Search City"),
//             content: TextFormField(
//               controller: searchElementController,
//             ),
//             actions: <Widget>[
//               MaterialButton(
//                 onPressed: () {},
//                 elevation: 5.0,
//                 child: Text("Submit"),
//               )
//             ],
//           );
//         });
//   }
}
