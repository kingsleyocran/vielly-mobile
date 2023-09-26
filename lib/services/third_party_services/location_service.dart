import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator_apple/geolocator_apple.dart';
import 'package:geolocator_android/geolocator_android.dart';
//import 'package:location/location.dart';

import 'package:flutter_geofire/flutter_geofire.dart';
//import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../data/data_sources/local/sharedpreference.dart';
import '../../app/app.locator.dart';
import '../../data/models/directiondetials.dart';
import '../../data/models/address.dart';
import '../../presentation/widgets/setup_snackbar_ui.dart';



class LocationService {

  final SnackbarService _snackBarService = locator<SnackbarService>();
  SnackbarService get getSnackBar => _snackBarService;

  final SharedPrefManager _sharedPrefManager = locator<SharedPrefManager>();
  SharedPrefManager get getSharedPrefManager => _sharedPrefManager;

  int _updateInterval = 5;

  StreamSubscription<Position>? _positionStream;
  LocationPermission? permission;



  set updateInterval(int newInterval) {
    _updateInterval = newInterval;
  }

  void setLocationListener({Function(Position locationData)? onUpdated, String? uid}) async {
    Geofire.initialize("drivers");
    await _checkLocationPermissions();

    late LocationSettings locationSettings;

    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
        forceLocationManager: true,
        intervalDuration: const Duration(seconds: 10),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 100,
        pauseLocationUpdatesAutomatically: true,
      );
    } else {
      locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
    }

    // subscribe to changes in the user's location
    // by "listening" to the location's onLocationChanged event

    _positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings
      //intervalDuration: Duration(seconds: _updateInterval),
      //forceAndroidLocationManager: true,
      //desiredAccuracy: LocationAccuracy.best,
    ).listen((Position position) async {

      //Uodate location using GeoFire
      //todo undo

      Geofire.setLocation(
        uid!, position.latitude, position.longitude,
      );

      print("Bearing => ${position.heading}");
      print('lat >> ${position.latitude},  || lon >> ${position.longitude}');
      onUpdated?.call(position);
    });
  }


  Future<Position?> getLastKnownLocation() async {
    _checkLocationPermissions();

    return Geolocator.getLastKnownPosition();
  }


  Future<Position> getCurrentLocation() async {
    _checkLocationPermissions();

    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }


  void dispose() async {
    await Geofire.stopListener();

    _positionStream?.cancel();
    print("################## Location Service => cancelled #################");
  }


  _checkLocationPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {

      showSnackBarGreyAlert('Location services are disabled');

      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.deniedForever) {

      showSnackBarGreyAlert('Location permissions are permantly denied, we cannot request permissions.');

      return Future.error('Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {

        showSnackBarGreyAlert('Location permissions are denied (actual value: $permission).');

        return Future.error('Location permissions are denied (actual value: $permission).');
      }
    }
  }


  Future<String> findCoordinateAddress(Position position) async{
    String placeAddress = '';

    //Check for internet connectivity
    var connectivityResult = await (Connectivity().checkConnectivity());
    if(connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi){
      return placeAddress;
    }

    String url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyBRH0E02krGb4Zd2qs9jvi6dMAOEihutqs';

    var response = await getRequest(url);

    if(response != 'failed'){
      placeAddress = response['results'][0]['formatted_address'];

      AddressDetails pickupAddress = new AddressDetails();
      pickupAddress.longitude = position.longitude;
      pickupAddress.latitude = position.latitude;
      pickupAddress.placeName = placeAddress;

      getSharedPrefManager.setPrefPickupAddress(pickupAddress);
    }

    return placeAddress;
  }


  Future<DirectionDetails?> getDirectionDetails (LatLng startPosition, LatLng endPosition) async{
    String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=AIzaSyBRH0E02krGb4Zd2qs9jvi6dMAOEihutqs';

    var response = await getRequest(url);

    if(response != 'failed'){
      DirectionDetails directionDetails = DirectionDetails();

      directionDetails.durationText = response['routes'][0]['legs'][0]['duration']['text'];
      directionDetails.durationValue = response['routes'][0]['legs'][0]['duration']['value'];

      directionDetails.distanceText = response['routes'][0]['legs'][0]['distance']['text'];
      directionDetails.distanceValue = response['routes'][0]['legs'][0]['distance']['value'];

      directionDetails.encodedPoints = response['routes'][0]['overview_polyline']['points'];

      return directionDetails;
    }else{return null;}

  }






  //Helper Methods
  Future showSnackBarGreyAlert( String message) async{
    getSnackBar.showCustomSnackBar(
      variant: SnackbarType.greyAlert,
      duration: Duration(seconds: 3),
      message: message,
    );
  }

  Future<dynamic> getRequest(var url) async {
    http.Response response = await http.get(Uri.parse(url));

    try{
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data);
        return decodedData;
      }
      else {
        return 'failed';
      }
    }catch(e){
      return 'failed';
    }
  }

  Future<dynamic> postRequest(var url, String body) async {
    http.Response response = await http.post(Uri.parse(url), headers: {"Content-Type": "application/json",'Accept': 'application/json'}, body: body);

    try{
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data);
        return decodedData;
      }
      else {
        return 'failed';
      }
    }catch(e){
      return 'failed';
    }
  }

  Future<dynamic> patchRequest(var url, String body) async {
    http.Response response = await http.patch(Uri.parse(url), headers: {"Content-Type": "application/json",'Accept': 'application/json'}, body: body);

    try{
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data);
        return decodedData;
      }
      else {
        return 'failed';
      }
    }catch(e){
      return 'failed';
    }
  }



}


