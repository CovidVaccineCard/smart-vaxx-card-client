import 'package:cloud_firestore/cloud_firestore.dart';

class CenterDetails {
  final String id, name, place;
  final GeoPoint location;
  const CenterDetails({
    required this.id,
    required this.name,
    required this.place,
    required this.location,
  });

  static CenterDetails fromMap(Map<String, dynamic> map) {
    return CenterDetails(
      id: map['id'],
      name: map['name'],
      place: map['place'],
      location: map['location'],
    );
  }
}
