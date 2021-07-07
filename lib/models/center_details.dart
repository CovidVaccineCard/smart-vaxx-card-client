import 'package:cloud_firestore/cloud_firestore.dart';

class CenterDetails {
  const CenterDetails({
    required this.id,
    required this.name,
    required this.place,
    required this.location,
  });
  final String id, name, place;
  final GeoPoint location;

  static CenterDetails fromMap(Map<String, dynamic> map) {
    return CenterDetails(
      id: map['id'],
      name: map['name'],
      place: map['place'],
      location: map['location'],
    );
  }
}
