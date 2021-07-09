import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_vaxx_card_client/screens/main/location_notifier.dart';
import 'package:smart_vaxx_card_client/screens/vaccination_center/list_view.dart';
import 'package:smart_vaxx_card_client/screens/vaccination_center/wrapper.dart';

class VaccinationCenterScreen extends StatelessWidget {
  final centers = FirebaseFirestore.instance.collection('centers');
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final ValueKey<String> _streamKey = ValueKey('stream');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text('Vaccination centers'),
      ),
      body: Wrapper(
        builder: () => CentersListView(
            streamKey: _streamKey,
            centers: centers,
            latitude: LocationNotifier.of(context).data.latitude!,
            longitude: LocationNotifier.of(context).data.longitude!),
      ),
    );
  }
}
