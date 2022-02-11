import 'package:geolocator/geolocator.dart';
import '../app/app.logger.dart';

class GeolocatorService {
  final log = getLogger('GeolocatorService');

  bool _serviceEnabled = false;
  LocationPermission _locationPermission = LocationPermission.denied;
  Position? _locationPosition;

  bool? get serviceEnabled => _serviceEnabled;
  LocationPermission get locationPermission => _locationPermission;
  Position? get locationPosition => _locationPosition;

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<void> _determinePosition() async {
    log.v('_determinePosition()');
    // Test if location services are enabled.
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      // return Future.error('Location services are disabled.');
      log.v('_determinePosition() => SERVICE NOT ENABLED');
      return;
    }

    _locationPermission = await Geolocator.checkPermission();
    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
      // if (_locationPermission == LocationPermission.denied) {
      //   // Permissions are denied, next time you could try
      //   // requesting permissions again (this is also where
      //   // Android's shouldShowRequestPermissionRationale
      //   // returned true. According to Android guidelines
      //   // your App should show an explanatory UI now.
      //   return Future.error('Location permissions are denied');
      // }
      log.v('_determinePosition() => LOCATION DENIED');
      return;
    }

    if (_locationPermission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      // return Future.error(
      //     'Location permissions are permanently denied, we cannot request permissions.');
      log.v('_determinePosition() => LOCATION DENIED FOREVER');
      return;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    _locationPosition = await Geolocator.getCurrentPosition();
    log.v(
        '_determinePosition() => SUCCESS _locationPosition: $_locationPosition');
  }
}
