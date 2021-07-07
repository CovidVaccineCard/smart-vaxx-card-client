import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({required this.point, required this.name});

  final GeoPoint point;
  final String name;

  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  late GoogleMapController mapController;
  late LatLng _point;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _point = LatLng(widget.point.latitude, widget.point.longitude);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      _markers = {
        Marker(
          markerId: MarkerId(widget.name),
          position: _point,
          infoWindow: InfoWindow(title: widget.name),
        ),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        brightness: Brightness.dark,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close),
        ),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _point,
          zoom: 11.0,
        ),
        markers: _markers,
      ),
    );
  }
}
