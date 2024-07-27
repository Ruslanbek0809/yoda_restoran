import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../app/app.logger.dart';
import '../utils/utils.dart';

class ConnectivityService {
  final log = getLogger('ConnectivityService');

  // Create our public controller
  StreamController<ConnectivityStatus> connectionStatusController =
      StreamController<ConnectivityStatus>();

  ConnectivityService() {
    // Subscribe to the connectivity Chanaged Steam
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      connectionStatusController.add(_getStatusFromResult(results));
    });
  }

  // Convert from the third part enum to our own enum
  ConnectivityStatus _getStatusFromResult(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.mobile)) {
      return ConnectivityStatus.Cellular;
    } else if (results.contains(ConnectivityResult.wifi)) {
      return ConnectivityStatus.WiFi;
    } else if (results.contains(ConnectivityResult.ethernet)) {
      return ConnectivityStatus.Ethernet;
    } else if (results.contains(ConnectivityResult.vpn)) {
      return ConnectivityStatus.VPN;
    } else if (results.contains(ConnectivityResult.bluetooth)) {
      return ConnectivityStatus.Bluetooth;
    } else if (results.contains(ConnectivityResult.other)) {
      return ConnectivityStatus.Other;
    } else if (results.contains(ConnectivityResult.none)) {
      return ConnectivityStatus.Offline;
    } else {
      return ConnectivityStatus.Unknown;
    }
  }
}
