import 'dart:async';


import 'package:connectivity_plus/connectivity_plus.dart';

import '../../enums/connectivity_status.dart';




class ConnectivityService {

  /*
  Stream<ConnectivityStatus> streamConnection() {
    var controller = StreamController<ConnectivityStatus>();
    ConnectivityService() {
      // Subscribe to the connectivity Changed Stream
      Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
        // Use Connectivity() here to gather more info if you need t

        controller.add(_getStatusFromResult(result));
      });
    }

    ConnectivityService(); // BAD: Starts before it has subscribers.
    return controller.stream;
  }

   */
  // Create our public controller
  StreamController<ConnectivityStatus> connectionStatusController = StreamController<ConnectivityStatus>();

  ConnectivityService() {
    // Subscribe to the connectivity Changed Stream
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Use Connectivity() here to gather more info if you need t

      connectionStatusController.add(_getStatusFromResult(result));
    });
  }




  // Convert from the third part enum to our own enum
  ConnectivityStatus _getStatusFromResult(ConnectivityResult result) {
    switch (result){
      case ConnectivityResult.mobile:
        return ConnectivityStatus.Cellular;
      case ConnectivityResult.wifi:
        return ConnectivityStatus.WiFi;
      case ConnectivityResult.none:
        return ConnectivityStatus.Offline;
      default:
        return ConnectivityStatus.Offline;
    }
  }
}
