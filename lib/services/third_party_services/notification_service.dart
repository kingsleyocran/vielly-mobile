import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../app/app.locator.dart';
import '../../data/data_repository/repositories_impl/user_repository_impl.dart';
import '../../data/data_sources/local/sharedpreference.dart';
import '../../data/models/trip.dart';


class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final SharedPrefManager _sharedPrefManager = locator<SharedPrefManager>();
  final UserRepositoryImpl _userRepositoryImpl = locator<UserRepositoryImpl>();

  Function(String)? onChanged;

  /*
  Future initializeNotification(Function(String) _onChanged) async {
    this.onChanged = _onChanged;

    _firebaseMessaging.configure(

      //When the app is running
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");

        getRideId(message);
        fetchRideInfo(getRideId(message));
      },

      //When the app is closed this execute when we launch the app from the notification
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        getRideId(message);
        fetchRideInfo(getRideId(message));
      },

      //When app is in the foreground
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");

        getRideId(message);
        fetchRideInfo(getRideId(message));
      },
    );
  }
   */



  Future initializeNotification(Function(String) _onChanged) async {
    this.onChanged = _onChanged;

    FirebaseMessaging.onBackgroundMessage(onBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      print("onMessage: $message");
      print("onMessage: ${message.data}");

      getRideId(message.data);
      fetchRideInfo(getRideId(message.data));

    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {

      print("onMessage: $message");
      print("onMessage: ${message.data}");

      getRideId(message.data);
      fetchRideInfo(getRideId(message.data));
    });
  }


  Future<void> onBackgroundHandler(RemoteMessage message) async {
    print("onResume: $message");

    getRideId(message.data);
    fetchRideInfo(getRideId(message.data));
  }


  String getRideId(Map<String, dynamic> message){
    String rideID = '';
    //String orderID = '';
    //String status = '';

    if(Platform.isAndroid){
      rideID = message['data']['ride_id'];
      //orderID = message['data']['order_id'];
      //status = message['data']['status'];
    }else if(Platform.isIOS){
      rideID = message['ride_id'];
      //orderID = message['order_id'];
      //status = message['status'];
    }

    print('This is the ride ID');
    print(rideID);

    return rideID;
  }


  void fetchRideInfo(String rideID) async{

    DatabaseReference rideRef = FirebaseDatabase.instance.reference().child('riders/$rideID');

    //Listen for data
    rideRef.onValue.listen((event) async{

      var snapshot = event.snapshot;

      print('####');
      print(snapshot.value['trip']['status'].toString());

      if( snapshot.value != null) {

        //create variables to store the important value from rideRef in the real time database
        num charge = double.parse(snapshot.value['trip']['charge']);
        int waitTime = snapshot.value['trip']['waitTime'];
        String status = snapshot.value['trip']['status'];
        String orderID = snapshot.value['trip']['orderId'];
        bool confirmed = snapshot.value['trip']['confirmed'];

        double driverLatitude = double.parse(snapshot.value['trip']['driver']['location']['latitude'].toString());
        double driverLongitude = double.parse(snapshot.value['trip']['driver']['location']['longitude'].toString());
        String driverName = snapshot.value['trip']['driver']['profile']['name'];
        String driverID = snapshot.value['trip']['driver']['id'];
        String driverImageThumbnail = snapshot.value['trip']['driver']['profile']['profie_image_thumbnail'];
        String driverImageOriginal = snapshot.value['trip']['driver']['profile']['profie_image_original'];
        String driverPhone = '+233507233595';

        String carColor = snapshot.value['trip']['driver']['profile']['vehicle_details']['car_color'];
        String carModel = snapshot.value['trip']['driver']['profile']['vehicle_details']['car_model'];
        String vehicleNumber = snapshot.value['trip']['driver']['profile']['vehicle_details']['vehicle_number'];


        double dropoffLatitude = double.parse(snapshot.value['trip']['dropoffTerminal']['coords']['latitude'].toString());
        double dropoffLongitude = double.parse(snapshot.value['trip']['dropoffTerminal']['coords']['longitude'].toString());
        String dropoffLocation= snapshot.value['trip']['dropoffTerminal']['name'].toString();

        double pickupLatitude = double.parse(snapshot.value['trip']['pickupTerminal']['coords']['latitude'].toString());
        double pickupLongitude = double.parse(snapshot.value['trip']['pickupTerminal']['coords']['longitude'].toString());
        String pickupLocation= snapshot.value['trip']['pickupTerminal']['name'].toString();

        print(driverName);
        print(driverLatitude);
        print(driverLongitude);
        print(carColor);
        print(carModel);
        print(vehicleNumber);


        TripDetails tripDetails = TripDetails();
        tripDetails.rideID = rideID;
        tripDetails.charge = charge;
        tripDetails.waitTime = waitTime;
        tripDetails.status = status;
        tripDetails.orderID = orderID;
        tripDetails.confirmed = confirmed;

        tripDetails.driverLatitude = driverLatitude;
        tripDetails.driverLongitude = driverLongitude;
        tripDetails.driverName = driverName;
        tripDetails.driverID = driverID;
        tripDetails.driverImageThumbnail = driverImageThumbnail;
        tripDetails.driverImageOriginal = driverImageOriginal;
        tripDetails.phone = driverPhone;

        tripDetails.carColor = carColor;
        tripDetails.carModel = carModel;
        tripDetails.vehicleNumber = vehicleNumber;

        tripDetails.dropoffLatitude = dropoffLatitude;
        tripDetails.dropoffLongitude = dropoffLongitude;
        tripDetails.dropoffLocation = dropoffLocation;

        tripDetails.pickupLatitude = pickupLatitude ;
        tripDetails.pickupLongitude = pickupLongitude;
        tripDetails.pickupLocation = pickupLocation;

        _sharedPrefManager.setPrefTrip(tripDetails);

        onChanged?.call(snapshot.value['trip']['status']);
      }
    });


  }


  //Set notification to the API post notification
  setNotificationToken() {
    _firebaseMessaging.subscribeToTopic('all');
    _firebaseMessaging.getToken().then((token) async{

      final bool isSuccess = await _userRepositoryImpl.postSetNotificationToken(token!);

      if(isSuccess) debugPrint('FCM token => $token');
    });
  }

}
