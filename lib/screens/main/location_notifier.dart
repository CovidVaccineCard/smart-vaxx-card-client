import 'package:flutter/widgets.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

enum LocationStatus {
  IDLE,
  NO_PERMISSION,
  NO_LOCATION,
  CHECKING,
  SUCCESS,
}

class LocationNotifier extends ChangeNotifier {
  LocationStatus _locationStatus = LocationStatus.IDLE;
  LocationData? _locationData;

  static LocationNotifier of(BuildContext context, {bool listen = false}) =>
      Provider.of<LocationNotifier>(context, listen: listen);

  bool get isLocationReceived => _locationData != null;

  LocationStatus get status => _locationStatus;
  set status(LocationStatus locationStatus) {
    _locationStatus = locationStatus;
    notifyListeners();
  }

  LocationData get data => _locationData!;
  set data(LocationData locationData) {
    _locationData = locationData;
    notifyListeners();
  }
}
