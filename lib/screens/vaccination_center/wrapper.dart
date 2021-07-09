import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:smart_vaxx_card_client/screens/main/location_notifier.dart';
import 'package:smart_vaxx_card_client/screens/vaccination_center/blocked_screen.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({required this.builder});

  final Widget Function() builder;

  String getMessage(LocationStatus status) {
    switch (status) {
      case LocationStatus.NO_LOCATION:
        return 'Location is not enabled';
      case LocationStatus.NO_PERMISSION:
        return 'Location permission is not aaccepted';
      default:
        return 'Please wait';
    }
  }

  @override
  Widget build(BuildContext context) {
    var status = LocationNotifier.of(context, listen: true).status;
    return status == LocationStatus.CHECKING
        ? Center(child: CircularProgressIndicator())
        : status == LocationStatus.SUCCESS
            ? builder()
            : BlockedScreen(
                message: getMessage(status),
                clickHandler: () async {
                  var location = Location();

                  bool _serviceEnabled;
                  PermissionStatus _permissionGranted;

                  _serviceEnabled = await location.serviceEnabled();
                  if (!_serviceEnabled) {
                    _serviceEnabled = await location.requestService();
                    if (!_serviceEnabled) {
                      LocationNotifier.of(context).status =
                          LocationStatus.NO_LOCATION;
                      return;
                    }
                  }

                  _permissionGranted = await location.hasPermission();
                  if (_permissionGranted == PermissionStatus.denied) {
                    _permissionGranted = await location.requestPermission();
                    if (_permissionGranted != PermissionStatus.granted) {
                      LocationNotifier.of(context).status =
                          LocationStatus.NO_PERMISSION;

                      return;
                    }
                  }
                  LocationNotifier.of(context).status = LocationStatus.CHECKING;
                  var data = await location.getLocation();
                  LocationNotifier.of(context).data = data;
                  debugPrint('location: ${data.latitude}, ${data.longitude}');
                  LocationNotifier.of(context).status = LocationStatus.SUCCESS;
                },
              );
  }
}
