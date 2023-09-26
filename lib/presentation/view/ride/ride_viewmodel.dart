import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:share/share.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'dart:ui' as ui;
import 'package:firebase_database/firebase_database.dart';
import 'dart:typed_data';
import 'dart:math';
import 'package:flutter_svg/svg.dart';

import 'package:curve/app/app.router.dart';
import 'package:curve/data/models/address.dart';
import 'package:curve/data/models/nearbydrivers.dart';
import 'package:curve/data/models/paymentmethods.dart';
import 'package:curve/data/models/savedlocations.dart';
import 'package:curve/data/models/user.dart';
import 'package:curve/enums/connectivity_status.dart';
import 'package:curve/presentation/configurations/colors.dart';
import 'package:curve/presentation/widgets/setup_bottomsheet_ui.dart';
import '../../../data/models/searchtripdata.dart';
import '../../../data/models/trip.dart';
import '../../../presentation/view/view_model.dart';

@lazySingleton
class RideViewModel extends ViewModel {

  //Panel Variables
  double _walletOpacity = 1.0;
  get walletOpacity => _walletOpacity;

  double _topLocationOpacity = 0.0;
  get topLocationOpacity => _topLocationOpacity;

  double _driverFocusOpacity = 0.0;
  get driverFocusOpacity => _driverFocusOpacity;

  double _tripStatusOpacity = 0.0;
  get tripStatusOpacity => _tripStatusOpacity;

  double _meetPickupOpacity = 0.0;
  get meetPickupOpacity => _meetPickupOpacity;

  double _homeSheetHeight = 240; //250;
  get homeSheetHeight => _homeSheetHeight;

  double _rideDetailsHeight = 0.0;
  get rideDetailsHeight => _rideDetailsHeight;

  double _confirmTerminalHeight = 0.0;
  get confirmTerminalHeight => _confirmTerminalHeight;

  double _requestRideHeight = 0.0;
  get requestRideHeight => _requestRideHeight;

  double _driverPanelHeight = 0.0;
  get driverPanelHeight => _driverPanelHeight;

  double _tripOngoingHeight = 0.0; //150
  get tripOngoingHeight => _tripOngoingHeight;

  double _meetAtPickupOpacity = 0.0;
  get meetAtPickupOpacity => _meetAtPickupOpacity;

  double _tripTopStatusOpacity = 0.0;
  get tripTopStatusOpacity => _tripTopStatusOpacity;

  double _driverArrivingHeight = 0.0;
  get driverArrivingHeight => _driverArrivingHeight;

  double _setLocationOpacity = 1.0;
  get setLocationOpacity => _setLocationOpacity;

  double _userFocusOpacity = 0.0;
  get userFocusOpacity => _userFocusOpacity;

  double _mapPadding = 245.0;
  get mapPadding => _mapPadding;



  List<LatLng> _polyLineCoordinates = [];
  get polyLineCoordinates => _polyLineCoordinates;

  Set<Polyline> _polyLines = {};
  get polyLines => _polyLines;

  List<LatLng> _userToBusPolyLineCoordinates = [];
  get userToBusPolyLineCoordinates => _userToBusPolyLineCoordinates;

  Set<Marker> _markers = {};
  get markers => _markers;

  Set<Circle> _circles = {};
  get circles => _circles;

  BitmapDescriptor? _carIcon;
  get carIcon => _carIcon;

  BitmapDescriptor? _driverIcon;
  get driverIcon => _driverIcon;

  BitmapDescriptor? _pickLocationIcon;
  get pickLocationIcon => _pickLocationIcon;

  BitmapDescriptor? _dropLocationIcon;
  get dropLocationIcon => _dropLocationIcon;

  Position? _currentPosition;
  get currentPosition => _currentPosition;

  Position? _destinationPosition;
  get destinationPosition => _destinationPosition;

  LatLng? _driverLatLng;
  get driverLatLng => _driverLatLng;



  //Define Map Style here
  String? _mapStyleLight;
  get mapStyleLight => _mapStyleLight;

  String? _mapStyleDark;
  get mapStyleDark => _mapStyleDark;

  bool _nearbyDriverKeysLoaded = false;
  get nearbyDriverKeysLoaded => _nearbyDriverKeysLoaded;

  GoogleMapController? _mapController;
  get mapController => _mapController;

  //Set initial camera position
  CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(5.6037, -0.1870),
    zoom: 5,
  );
  get kInitialPosition => _kInitialPosition;

  CameraPosition _position = const CameraPosition(
    target: LatLng(5.6037, -0.1870),
    zoom: 5,
  );
  get position => _position;

  SearchTripDetails? _searchTripDetails;
  get searchTripDetails => _searchTripDetails;

  TripDetails? _tripDetails;
  get tripDetails => _tripDetails;

  UserDetails _userProfile = UserDetails();
  get userProfile => _userProfile;

  SavedLocationModel? _isHomeLocation;
  get isHomeLocation => _isHomeLocation;

  List<dynamic> _savedLocationList = [];
  get savedLocationList => _savedLocationList;

  SavedLocationModel? _isWorkLocation;
  get isWorkLocation => _isWorkLocation;

  AddressDetails? _pickUpAddress;
  get pickUpAddress => _pickUpAddress;

  AddressDetails? _dropOffAddress;
  get dropOffAddress => _dropOffAddress;

  double? _charge;
  get charge => _charge;

  int? _seatCount;
  get seatCount => _seatCount;

  PaymentMethods? _isPrimaryMethod;
  get isPrimaryMethod => _isPrimaryMethod;

  String _selectedProvider = 'Cash';
  get selectedProvider => _selectedProvider;

  String? _canCancelOnRequest;
  get canCancelOnRequest => _canCancelOnRequest;

  bool _allowCancel = false;
  get allowCancel => _allowCancel;


  //To be Initialised on start////////////////////////////////////////
  Future initialiseOnModelReady(context) async{
    await getProfileDetails();

    await initializePushNotification(context);

    await getCurrentPosition();

    await rootBundle.loadString('assets/map_styles/map_style_light.txt').then((string) {
      _mapStyleLight = string;
      notifyListeners();
    });

    await rootBundle.loadString('assets/map_styles/map_style_dark.txt').then((string) {
      _mapStyleDark = string;
      notifyListeners();
    });

    createMarker(context);

    getConnectivity.connectionStatusController.stream.listen((event) async{
      switch(event) {
        case ConnectivityStatus.Cellular: {
          // statements;
          print('CONNECTED TO MOBILE');

          if(getSnackBar.isSnackbarOpen!){
            showSnackBarGreenInternetAlert();
          }

        }
        break;

        case ConnectivityStatus.WiFi: {
          print('CONNECTED TO WIFI');

          if(getSnackBar.isSnackbarOpen!){
            showSnackBarGreenInternetAlert();
          }

        }
        break;

        case ConnectivityStatus.Offline: {
          print('LOST CONNECTION');
          showSnackBarRedInternetAlert();
        }
        break;

        default: {
          //statements;
        }
        break;
      }
    });

  }
  ///////////////////////////////////////////////////////////////////

  Future createMarker(BuildContext context) async{

    /*
    if (driverIcon == null){
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: Size(2,2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, 'assets/markers/car_android.png').then((onValue) {_carIcon = onValue;});
    }
     */

    if (_driverIcon == null)
      _driverIcon = await bitmapDescriptorFromSvgAsset(
          context, "assets/markers/carmarker.svg",
          size: 30);

    if (_carIcon == null)
      _carIcon = await bitmapDescriptorFromSvgAsset(
          context, "assets/markers/carmarker.svg",
          size: 33);

    if (pickLocationIcon == null)
      _pickLocationIcon = await bitmapDescriptorFromSvgAsset(
          context, "assets/markers/pickupmarker.svg",
          size: 25);

    if (dropLocationIcon == null)
      _dropLocationIcon = await bitmapDescriptorFromSvgAsset(
          context, "assets/markers/dropoffmarker.svg",
          size: 25);

    notifyListeners();
  }

  Future initializePushNotification(context) async{

    getNotificationService.initializeNotification((status) async{
      if(status == 'picking_up'){
        print('##########PICKIING#######################');

        await onTripAccepted(context);

      }else if(status == 'arrived'){
        print('##########DRIVER ARRIVED#######################');

        await onTripArrived();

      }
      else if(status == 'pickup'){
        print('##########TRIP STARTED#######################');

        await onTripStarted(context);

      }else if(status == 'dropoff'){

        print('##########TRIP ENDED#######################');
        await onTripEnded();

      }else if(status == 'completed'){

      }
    });
    getNotificationService.setNotificationToken();
  }

  Future getProfileDetails() async{

    await fetchSavedLocations();

    _userProfile = (await getSharedPrefManager.getPrefUserProfile())!;
    _isPrimaryMethod = await getSharedPrefManager.getPrefIsPrimaryMethod();
    notifyListeners();
    //_userSavedLocation = await getSharedPrefManager.getPrefSavedLocations();
    if(isPrimaryMethod.provider == "mtn"){
      _selectedProvider = 'MTN Mobile Money';
      notifyListeners();
    }else if(isPrimaryMethod.provider == "airteltigo"){
      _selectedProvider = 'AirtelTigo Money';
      notifyListeners();
    }else if(isPrimaryMethod.provider== "vodafone"){
      _selectedProvider = 'Vodafone Cash';
      notifyListeners();
    }else if(isPrimaryMethod.provider== "cash"){
      _selectedProvider = 'Cash';
      notifyListeners();
    }

    print(selectedProvider);
    notifyListeners();

  }

  Future onMapCreated(GoogleMapController controller) async{

      _mapController = controller;
      notifyListeners();

      await setPositionLocator();

      await setPositionLocator();
  }

  Future updateCameraPosition(CameraPosition position) async{

    _position = position;
    notifyListeners();
  }

  Future setPositionLocator() async{

    final Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);

    _currentPosition = position;
    notifyListeners();

    LatLng pos = LatLng(position.latitude , position.longitude);
    CameraPosition cp = new CameraPosition(target: pos,zoom: 16);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cp));

    String address = await getLocationService.findCoordinateAddress(position);
    print(address);

    await startGeoFireListener();
  }




  //API Functions///////////////////////////////////////
  Future initializeSearchTrip(pickup, destination) async {

    var pickupLatLng = LatLng(pickup.latitude, pickup.longitude);
    var destinationLatLng = LatLng(destination.latitude, destination.longitude);

    print(pickup.latitude);
    print(pickup.longitude);
    print(destination.latitude);

    final Map<String, dynamic> data = Map<String, dynamic>();

    data['pickup'] =
    {
      "latitude": pickupLatLng.latitude,
      "longitude": pickupLatLng.longitude
    };
    data['dropoff'] =
    {
      "latitude": destinationLatLng.latitude,
      "longitude": destinationLatLng.longitude
    };

    SearchTripDetails searchTripDetails = SearchTripDetails();

    searchTripDetails = (await getTripRepositoryImpl.postSearchTrip(data))!;

    if(searchTripDetails != null){
      _searchTripDetails = searchTripDetails;
      _charge = double.parse(searchTripDetails.charge);
      _seatCount = 1;
      notifyListeners();

    }else{
      showDialogFailed(
          title: 'Fetching trip details failed',
          description: 'We could not fetch trip details. Please try again.',
          mainTitle: 'RETRY',
          secondTitle: 'CANCEL'
      ).then((value) {
        if(value){
          this.initializeSearchTrip(pickup, destination);
        }
      });
    }
  }

  Future initializeConfirmTrip() async {

    final Map<String, dynamic> data = Map<String, dynamic>();

    data['order_id'] = searchTripDetails.orderID;
    data['passenger_count'] = seatCount;


    var isMsg = await getTripRepositoryImpl.postConfirmTrip(data);

    print('Confirm Trip message = ' + isMsg);

    _allowCancel = true;
    notifyListeners();

    if(isMsg == 'No driver found' || isMsg == 'error'){
        bool result = await showNoDriver();
        if(result){
          await triggerResetRide();
        }
      }
      else if(isMsg == false){
        showDialogFailed(
            title: 'Confirming trip failed',
            description: 'We found an error when confirming. Please try again.',
            mainTitle: 'RETRY',
            secondTitle: 'CANCEL'
        ).then((value) {
          if(value){
            this.initializeConfirmTrip();
          }else{

            triggerResetRide();
          }
        });
      }

  }

  Future cancelRealtimeRide() async{
    var rideID = getSharedPrefManager.getPrefTrip();
    //Provider.of<AppData>(context, listen: false).tripDetails;

    if(rideID != null){
      FirebaseDatabase.instance.reference().child('riders/$rideID/trip').update({
        'status': 'cancelled'
      });
    }

  }

  Future cancelRide(String reason) async{

    String? userID = await getSharedPrefManager.getPrefUserID();
    String orderID = searchTripDetails.orderID;
    String? reason;

    print(userID);
    print(orderID);
    print(reason);

  }



  //MAP VISUALS/////////////////////////////////////
  Future polyLinePickupToBusStop(BuildContext context,pickup, destination) async{

    print('SEARCH DATA###############################');

    var destinationLatLng = LatLng(destination.latitude, destination.longitude);
    var pickupLatLng = LatLng(pickup.latitude, pickup.longitude);

    var thisDetails = await getLocationService.getDirectionDetails(pickupLatLng, destinationLatLng);


    print(thisDetails!.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> results = polylinePoints.decodePolyline(thisDetails.encodedPoints!);

    _polyLineCoordinates.clear();
    if (results.isNotEmpty){
      results.forEach((PointLatLng points) {
        _polyLineCoordinates.add(LatLng(points.latitude, points.longitude));
      });
    }
    notifyListeners();

    Polyline polyline = Polyline(
      polylineId: PolylineId('polyid'),
      color: ThemeColor_blue,
      points: polyLineCoordinates,
      jointType: JointType.round,
      width: 8,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      geodesic: true,
    );

    _polyLines.clear();
    _polyLines.add(polyline);
    notifyListeners();


    //make polyline fit into map
    LatLngBounds bounds;

    bounds = boundsFromLatLngList([
      pickupLatLng,
      destinationLatLng,
    ]);

    if (pickLocationIcon == null)
      _pickLocationIcon = await bitmapDescriptorFromSvgAsset(
          context, "assets/markers/pickupmarker.svg",
          size: 25);

    if (dropLocationIcon == null)
      _dropLocationIcon = await bitmapDescriptorFromSvgAsset(
          context, "assets/markers/dropoffmarker.svg",
          size: 25);
    notifyListeners();

    //Markers on map
    Marker pickupMarker = Marker(
      markerId: MarkerId('pickup'),
      position: pickupLatLng,
      icon: pickLocationIcon,
      //infoWindow: InfoWindow(title: pickup.placeID, snippet: 'My Location')
    );

    Marker destinationMarker = Marker(
      markerId: MarkerId('destination'),
      position: destinationLatLng,
      icon: dropLocationIcon,
      //infoWindow: InfoWindow(title: destination.placeID, snippet: 'Destination')
    );

    _markers.add(pickupMarker);
    _markers.add(destinationMarker);
    notifyListeners();

    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  Future polyLinePickupTerminalToBusStop(BuildContext context) async{

    print('SEARCH DATA###############################');
    var searchTripData = searchTripDetails;

    var destinationLatLng = LatLng(searchTripData.dropoffLatitude, searchTripData.dropoffLongitude);
    var pickupLatLng = LatLng(searchTripData.pickupLatitude, searchTripData.pickupLongitude);

    var thisDetails = await getLocationService.getDirectionDetails(pickupLatLng, destinationLatLng);


    print(thisDetails!.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> results = polylinePoints.decodePolyline(thisDetails.encodedPoints!);

    _polyLineCoordinates.clear();
    if (results.isNotEmpty){
      results.forEach((PointLatLng points) {
        _polyLineCoordinates.add(LatLng(points.latitude, points.longitude));
      });
    }
    notifyListeners();

    Polyline polyline = Polyline(
      polylineId: PolylineId('polyid'),
      color: ThemeColor_blue,
      points: polyLineCoordinates,
      jointType: JointType.round,
      width: 8,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      geodesic: true,
    );

    _polyLines.clear();
    _polyLines.add(polyline);
    notifyListeners();


    //make polyline fit into map
    LatLngBounds bounds;

    bounds = boundsFromLatLngList([
      pickupLatLng,
      destinationLatLng,
    ]);

    if (pickLocationIcon == null)
      _pickLocationIcon = await bitmapDescriptorFromSvgAsset(
          context, "assets/markers/pickupmarker.svg",
          size: 25);

    if (dropLocationIcon == null)
      _dropLocationIcon = await bitmapDescriptorFromSvgAsset(
          context, "assets/markers/dropoffmarker.svg",
          size: 25);
    notifyListeners();

    //Markers on map
    Marker pickupMarker = Marker(
      markerId: MarkerId('pickup'),
      position: pickupLatLng,
      icon: pickLocationIcon,
      //infoWindow: InfoWindow(title: pickup.placeID, snippet: 'My Location')
    );

    Marker destinationMarker = Marker(
      markerId: MarkerId('destination'),
      position: destinationLatLng,
      icon: dropLocationIcon,
      //infoWindow: InfoWindow(title: destination.placeID, snippet: 'Destination')
    );

    _markers.add(pickupMarker);
    _markers.add(destinationMarker);
    notifyListeners();

    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  Future polyLineUserToBusStop(BuildContext context) async{
    _currentPosition = await getLocationService.getCurrentLocation();
    notifyListeners();

    var destination = searchTripDetails;

    var pickupLatLng = LatLng(currentPosition.latitude, currentPosition.longitude);
    var destinationLatLng = LatLng(destination.pickupLatitude, destination.pickupLongitude);

    var thisDetails = await getLocationService.getDirectionDetails(pickupLatLng, destinationLatLng);

    print(thisDetails!.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> results = polylinePoints.decodePolyline(thisDetails.encodedPoints!);

    _userToBusPolyLineCoordinates.clear();
    if (results.isNotEmpty){
      results.forEach((PointLatLng points) {
        _userToBusPolyLineCoordinates.add(LatLng(points.latitude, points.longitude));
      });
    }
    notifyListeners();


    Polyline polyline = Polyline(
      polylineId: PolylineId('polyiduser'),
      color: ThemeColor_green,
      patterns: [PatternItem.dot, PatternItem.gap(15)],
      points: userToBusPolyLineCoordinates,
      jointType: JointType.round,
      width: 4,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      geodesic: true,
    );

    //_polylines.clear();
    _polyLines.add(polyline);

    //make polyline fit into map

    LatLngBounds bounds;

    bounds = boundsFromLatLngList([
      pickupLatLng,
      destinationLatLng,
    ]);

    if (pickLocationIcon == null)
      _pickLocationIcon = await bitmapDescriptorFromSvgAsset(
          context, "assets/markers/pickupmarker.svg",
          size: 25);

    if (dropLocationIcon == null)
      _dropLocationIcon = await bitmapDescriptorFromSvgAsset(
          context, "assets/markers/dropoffmarker.svg",
          size: 25);
    notifyListeners();


    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 140));


    /*
    Marker busStopMarker = Marker(
      markerId: MarkerId('busstop'),
      position: destinationLatLng,
      icon: pickLocationIcon,
    );

    //_markers.clear();
    _markers.add(busStopMarker);
    notifyListeners();

     */

    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));

  }

  Future polyLineDriverToBusStop(BuildContext context) async{
    TripDetails destination = (await getSharedPrefManager.getPrefTrip())!;

    var pickupLatLng = driverLatLng;

    var destinationLatLng = LatLng((destination.dropoffLatitude)!, (destination.dropoffLongitude)!);

    var thisDetails = await getLocationService.getDirectionDetails(pickupLatLng, destinationLatLng);

    print(thisDetails!.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> results = polylinePoints.decodePolyline(thisDetails.encodedPoints!);

    _polyLineCoordinates.clear();
    if (results.isNotEmpty){
      results.forEach((PointLatLng points) {
        _polyLineCoordinates.add(LatLng(points.latitude, points.longitude));
      });
    }
    notifyListeners();

    Polyline polyline = Polyline(
      polylineId: PolylineId('polytrip'),
      color: ThemeColor_blue,
      points: polyLineCoordinates,
      jointType: JointType.round,
      width: 8,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      geodesic: true,
    );


    _polyLines.clear();
    _polyLines.add(polyline);

    notifyListeners();


    //make polyline fit into map
    LatLngBounds bounds;

    bounds = boundsFromLatLngList([
      pickupLatLng,
      destinationLatLng,
    ]);


    if (pickLocationIcon == null)
      _pickLocationIcon = await bitmapDescriptorFromSvgAsset(
          context, "assets/markers/pickupmarker.svg",
          size: 25);

    if (dropLocationIcon == null)
      _dropLocationIcon = await bitmapDescriptorFromSvgAsset(
          context, "assets/markers/dropoffmarker.svg",
          size: 25);
    notifyListeners();

    Marker destinationMarker = Marker(
      markerId: MarkerId('destination'),
      position: destinationLatLng,
      icon: dropLocationIcon,
      //infoWindow: InfoWindow(title: destination.placeID, snippet: 'Destination')
    );

    _markers.clear();
    _markers.add(destinationMarker);
    notifyListeners();

    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));

    /*
    Circle pickupCircle = Circle(
      circleId: CircleId('pickup'),
      strokeColor: Colors.white,
      strokeWidth: 1,
      fillColor: ThemeColor_blue,
      radius: 1,
      center: pickupLatLng,
    );

    Circle destinationCircle = Circle(
      circleId: CircleId('destination'),
      strokeColor: Colors.white,
      strokeWidth: 1,
      fillColor: ThemeColor_green,
      radius: 1,
      center: destinationLatLng,
    );

     */

  }

  Future updatePolylineUserToBusStop() async {
    _currentPosition = await getLocationService.getCurrentLocation();
    notifyListeners();

    //var pickup = Provider.of<AppData>(context, listen: false).pickupAddress;
    final SearchTripDetails destination = (await getSharedPrefManager.getPrefSearchTrip())!;

    var pickupLatLng = LatLng(currentPosition.latitude, currentPosition.longitude);
    var destinationLatLng = LatLng(destination.pickupLatitude!, destination.pickupLongitude!);

    var thisDetails = await getLocationService.getDirectionDetails(pickupLatLng, destinationLatLng);

    print(thisDetails!.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> results = polylinePoints.decodePolyline(thisDetails.encodedPoints!);

    _userToBusPolyLineCoordinates.clear();
    if (results.isNotEmpty){
      results.forEach((PointLatLng points) {
        _userToBusPolyLineCoordinates.add(LatLng(points.latitude, points.longitude));
      });
    }
    notifyListeners();

    //_polylines.clear();

    Polyline updatedPolyline = Polyline(
      polylineId: PolylineId('polyiduser'),
      color: ThemeColor_green,
      patterns: [PatternItem.dot, PatternItem.gap(15)],
      points: userToBusPolyLineCoordinates,
      jointType: JointType.round,
      width: 4,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      geodesic: true,
    );

    _polyLines.clear();
    _polyLines.add(updatedPolyline);
    notifyListeners();
  }

  Future updatePolylineTrip() async {
    final TripDetails destination = (await getSharedPrefManager.getPrefTrip())!;

    var pickupLatLng = driverLatLng;

    var destinationLatLng = LatLng(destination.dropoffLatitude!, destination.dropoffLongitude!);

    var thisDetails = await getLocationService.getDirectionDetails(pickupLatLng, destinationLatLng);

    print(thisDetails!.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> results = polylinePoints.decodePolyline(thisDetails.encodedPoints!);

    _polyLineCoordinates.clear();
    if (results.isNotEmpty){
      results.forEach((PointLatLng points) {
        _polyLineCoordinates.add(LatLng(points.latitude, points.longitude));
      });
    }
    notifyListeners();

    //_polylines.clear();


      Polyline polyline = Polyline(
        polylineId: PolylineId('polytrip'),
        color: ThemeColor_blue,
        points: polyLineCoordinates,
        jointType: JointType.round,
        width: 8,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      _polyLines.clear();
      _polyLines.add(polyline);

      notifyListeners();
  }

  Future userWalkingFocus() async{
    final Position position = await getLocationService.getCurrentLocation();
    _currentPosition = position;
    notifyListeners();

    LatLng pos = LatLng(position.latitude , position.longitude);
    CameraPosition cp = new CameraPosition(target: pos,zoom: 18);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cp));
  }

  Future driverUserOnMapFocus() async{
    _currentPosition = await getLocationService.getCurrentLocation();
    notifyListeners();

    var pickupLatLng = LatLng(currentPosition.latitude, currentPosition.longitude);
    var destinationLatLng = driverLatLng;

    LatLngBounds bounds;

    bounds = boundsFromLatLngList([
      pickupLatLng,
      destinationLatLng,
    ]);

    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
  }

  Future tripPolylineFocus() async{
    TripDetails destination = (await getSharedPrefManager.getPrefTrip())!;

    var pickupLatLng = driverLatLng;

    var destinationLatLng = LatLng(destination.dropoffLatitude!, destination.dropoffLongitude!);

    LatLngBounds bounds;

    bounds = boundsFromLatLngList([
      pickupLatLng,
      destinationLatLng,
    ]);

    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
  }

  //Nearby driver location on map with icon
  Future updateDriversIconOnMap() async{

    _markers.clear();
    notifyListeners();


    Set<Marker> tempMarkers = Set<Marker>();

    for (NearbyDriver driver in nearbyDriverList){
      LatLng driverPosition = LatLng(driver.latitude!, driver.longitude!);

      Marker thisMarker = Marker(
        markerId: MarkerId('driver${driver.key}'),
        position: driverPosition,
        icon: carIcon,
        rotation: 0,//generateRandomNumber(360),
      );

      tempMarkers.add(thisMarker);

      _markers = tempMarkers;
      notifyListeners();
    }
  }

  Future updateTripDriverIconOnMap() async{

    _markers.clear();
    notifyListeners();

    Set<Marker> tempMarkers = Set<Marker>();

    Marker thisMarker = Marker(
      markerId: MarkerId('driverId'),
      position: driverLatLng,
      icon: carIcon,
      rotation: 0,//generateRandomNumber(360),
    );

    tempMarkers.add(thisMarker);

    _markers = tempMarkers;
    notifyListeners();
  }



  //Geofire Callbacks//////////////////////////////////////////////////
  Future startGeoFireListener() async{
    await stopGeoFireListener();

    print('###################################################');

    Geofire.initialize('drivers'); //Provide path to listen from

    Geofire.queryAtLocation(currentPosition.latitude, currentPosition.longitude, 500)!.listen((map) async{
      print(map);

      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {
          case Geofire.onKeyEntered:
          //This checks and gets all the data in the passed path
            print(map);
            NearbyDriver nearbyDriver = NearbyDriver();
            nearbyDriver.key = map['key'];
            nearbyDriver.latitude = map['latitude'];
            nearbyDriver.longitude = map['longitude'];

            nearbyDriverList.add(nearbyDriver);
            print('NearbyDrivers List = ${nearbyDriverList.length}');

            //Check if Geofire.onGeoQueryReady has run because it needs to run before onkeyentered can work well with the markers
            if(nearbyDriverKeysLoaded){
              await updateDriversIconOnMap();
            }
            break;

          case Geofire.onKeyExited:
          //This function checks if a Key is no more in the radius or has exited
            removeFromList(map["key"]);
            print('NearbyDrivers List = ${nearbyDriverList.length}');
            await updateDriversIconOnMap();
            //keysRetrieved.remove(map["key"]);
            break;

          case Geofire.onKeyMoved:
          // Update your key's location
            NearbyDriver nearbyDriver = NearbyDriver();
            nearbyDriver.key = map['key'];
            nearbyDriver.latitude = map['latitude'];
            nearbyDriver.longitude = map['longitude'];
            updateNearbyLocation(nearbyDriver);
            print('NearbyDrivers List = ${nearbyDriverList.length}');

            updateDriversIconOnMap();
            break;

          case Geofire.onGeoQueryReady:
          // All Initial Data is loaded
          // This function runs when all the data in the above cases have been initialized for the first time
            print(map['result']);
            print('NearbyDrivers List = ${nearbyDriverList.length}');
            updateDriversIconOnMap();
            _nearbyDriverKeysLoaded = true;
            notifyListeners();
            break;
        }
      }
      notifyListeners();
    });

  }

  Future driverTripGeoFireListener() async{
    await stopGeoFireListener();

    _markers.clear();
    notifyListeners();

    print('##########DRIVER TRIP#########################################');

    final TripDetails tripDetails = (await getSharedPrefManager.getPrefTrip())!;
    Geofire.initialize('drivers/${tripDetails.driverID}'); //Provide path to listen from

    Geofire.queryAtLocation(currentPosition.latitude, currentPosition.longitude, 500)!.listen((map) async{
      print(map);

      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {
          case Geofire.onKeyEntered:
          //This checks and gets all the data in the passed path
            print(map);
            NearbyDriver nearbyDriver = NearbyDriver();
            nearbyDriver.key = map['key'];
            nearbyDriver.latitude = map['latitude'];
            nearbyDriver.longitude = map['longitude'];

            _driverLatLng = LatLng(nearbyDriver.latitude!, nearbyDriver.longitude!);
            notifyListeners();

            await updateTripDriverIconOnMap();

            await updatePolylineTrip();

            await userWalkingFocus();

            notifyListeners();

            //Check if Geofire.onGeoQueryReady has run because it needs to run before onkeyentered can work well with the markers
            if(nearbyDriverKeysLoaded){
              await updateTripDriverIconOnMap();
            }
            break;

          case Geofire.onKeyExited:
          //This function checks if a Key is no more in the radius or has exited
          //GeoFire_Impl.removeFromList(map["key"]);
          //print('NearbyDrivers List = ${GeoFire_Impl.nearbyDriverList.length}');
            await updateTripDriverIconOnMap();
            //keysRetrieved.remove(map["key"]);
            break;

          case Geofire.onKeyMoved:
          // Update your key's location
            NearbyDriver nearbyDriver = NearbyDriver();
            nearbyDriver.key = map['key'];
            nearbyDriver.latitude = map['latitude'];
            nearbyDriver.longitude = map['longitude'];

            _driverLatLng = LatLng(nearbyDriver.latitude!, nearbyDriver.longitude!);
            notifyListeners();

            await updateTripDriverIconOnMap();

            await updatePolylineTrip();

            notifyListeners();

            break;

          case Geofire.onGeoQueryReady:
          // All Initial Data is loaded
          // This function runs when all the data in the above cases have been initialized for the first time
            print(map['result']);
            print('NearbyDrivers List = ${nearbyDriverList.length}');
            _nearbyDriverKeysLoaded = true;
            notifyListeners();

            await updateTripDriverIconOnMap();

            break;
        }
      }
      notifyListeners();
    });

  }

  Future driverGeoFireListener() async{
    await stopGeoFireListener();

    _markers.clear();
    notifyListeners();

    print('###############DRIVER GEO####################################');
    final TripDetails tripDetails = (await getSharedPrefManager.getPrefTrip())!;

    Geofire.initialize('drivers/${tripDetails.driverID}'); //Provide path to listen from

    Geofire.queryAtLocation(currentPosition.latitude, currentPosition.longitude, 500)!.listen((map) async{
      print(map);

      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {
          case Geofire.onKeyEntered:
          //This checks and gets all the data in the passed path
            print(map);
            NearbyDriver nearbyDriver = NearbyDriver();
            nearbyDriver.key = map['key'];
            nearbyDriver.latitude = map['latitude'];
            nearbyDriver.longitude = map['longitude'];

            _driverLatLng = LatLng(nearbyDriver.latitude!, nearbyDriver.longitude!);
            notifyListeners();

            await updateTripDriverIconOnMap();
            notifyListeners();

            //Check if Geofire.onGeoQueryReady has run because it needs to run before onkeyentered can work well with the markers
            if(nearbyDriverKeysLoaded){
              await updateTripDriverIconOnMap();
            }
            break;

          case Geofire.onKeyExited:
          //This function checks if a Key is no more in the radius or has exited
          //GeoFire_Impl.removeFromList(map["key"]);
          //print('NearbyDrivers List = ${GeoFire_Impl.nearbyDriverList.length}');
            await updateTripDriverIconOnMap();
            //keysRetrieved.remove(map["key"]);
            break;

          case Geofire.onKeyMoved:
          // Update your key's location
            NearbyDriver nearbyDriver = NearbyDriver();
            nearbyDriver.key = map['key'];
            nearbyDriver.latitude = map['latitude'];
            nearbyDriver.longitude = map['longitude'];


            _driverLatLng = LatLng(nearbyDriver.latitude!, nearbyDriver.longitude!);
            notifyListeners();

            await updateTripDriverIconOnMap();
            notifyListeners();

            break;

          case Geofire.onGeoQueryReady:
          // All Initial Data is loaded
          // This function runs when all the data in the above cases have been initialized for the first time
            print(map['result']);
            print('NearbyDrivers List = ${nearbyDriverList.length}');
            _nearbyDriverKeysLoaded = true;
            notifyListeners();

            await updateTripDriverIconOnMap();

            break;
        }
      }
      notifyListeners();
    });

  }

  Future<bool?> stopGeoFireListener() async{

    return Geofire.stopListener();
  }

  //Random number as rotation of driver icon
  double generateRandomNumber(int max){
    var randomGenerator = Random();
    int randInt = randomGenerator.nextInt(max);

    return randInt.toDouble();
  }

  //Get car marker location updates
  Future startUserLocationListener() async{
    stopUserLocationListener();

    getLocationService.setLocationListener(onUpdated: (position) async {
      if (currentPosition == position) {
        //todo save last know location
        return;
      }
      //_bearing = position.heading;
      _currentPosition = position;
      notifyListeners();

      updatePolylineUserToBusStop();

      print("################## Location Listener started #################");
    });

  }

  Future stopUserLocationListener () async{
    getLocationService.dispose();

    print("################## Location Disposed #################");
  }

  Future getCurrentPosition() async {
    final Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    _currentPosition = position;
    notifyListeners();

    String address = await getLocationService.findCoordinateAddress(position);
    print(address);
  }






  //Function triggers//////////////////////////////////////////////
  triggerSearchTrip(context) async{
    var pickup = await getSharedPrefManager.getPrefPickupAddress();
    var destination = await getSharedPrefManager.getPrefDropOffAddress();

    _pickUpAddress = pickup;
    _dropOffAddress = destination;
    _seatCount = 1;
    notifyListeners();

    await showDetailedSheet();

    await polyLinePickupToBusStop(context, pickup, destination );

    await initializeSearchTrip(pickup, destination);
  }

  triggerConfirmSeats(context) async{
    await showConfirmTerminalSheet();

    await polyLinePickupTerminalToBusStop(context);
    await polyLineUserToBusStop(context);

  }

  triggerConfirmTrip() async{

    await showRequestingRideSheet();

    await initializeConfirmTrip();



  }

  triggerResetRide() async{

    await getSharedPrefManager.clearTripData();
    await startGeoFireListener();
    await stopUserLocationListener();
    await showResetSheet();
    await setPositionLocator();

    _searchTripDetails = null;
    _tripDetails = null;
    _pickUpAddress = null;
    _dropOffAddress = null;
    _charge = null;
    _seatCount = null;
    _selectedIndex = 0;
    _allowCancel = false;
    _polyLines.clear();
    notifyListeners();
  }






  //TRIP STATUS
  Future onTripAccepted(context) async{
    _markers.clear();
    _polyLines.clear();
    notifyListeners();

    await driverGeoFireListener();

    await startUserLocationListener();

    await showDriverPanelSheet();

    await polyLineUserToBusStop(context);

    await driverUserOnMapFocus();

    _tripDetails = await getSharedPrefManager.getPrefTrip();
    notifyListeners();
  }

  Future onTripArrived() async{

    showDriverArrived(customData: tripDetails);

  }

  Future onTripStarted(context)async{

    await getProfileDetails();

    _markers.clear();
    _polyLines.clear();
    notifyListeners();

    await stopUserLocationListener();

    await driverTripGeoFireListener();

    await showTripOngoingSheet();

    await polyLineDriverToBusStop(context);

  }

  Future onTripEnded() async{

    await setPositionLocator();

    await startGeoFireListener();

    await stopUserLocationListener();

    //todo Navigate to PayTrip then reset trip
    navigateToPayTrip();

  }






  //Trigger UI Changes
  Future showResetSheet() async{

    _walletOpacity = 1.0; //1.0;
    _topLocationOpacity = 0.0;
    _driverFocusOpacity = 0.0;
    _tripStatusOpacity = 0.0;
    _meetPickupOpacity = 0.0;
    _homeSheetHeight = 250; //250;
    _rideDetailsHeight = 0;
    _confirmTerminalHeight = 0;
    _requestRideHeight = 0;
    _driverPanelHeight = 0;
    _tripOngoingHeight = 0; //150
    _meetAtPickupOpacity = 0;
    _tripTopStatusOpacity = 0.0;
    _setLocationOpacity = 1.0;
    _userFocusOpacity = 0.0;
    _mapPadding = 245; //250;

    _markers.clear();
    _polyLineCoordinates.clear();
    _polyLines.clear();
    _circles.clear();

    notifyListeners();
  }

  Future showDetailedSheet() async{

    _walletOpacity = 0.0; //1.0;
    _topLocationOpacity = 1.0;
    _driverFocusOpacity = 0.0;
    _tripStatusOpacity = 0.0;
    _meetPickupOpacity = 0.0;
    _homeSheetHeight = 0; //250;
    _rideDetailsHeight = 240;
    _confirmTerminalHeight = 0;
    _requestRideHeight = 0;
    _driverPanelHeight = 0;
    _tripOngoingHeight = 0; //150
    _meetAtPickupOpacity = 0;
    _tripTopStatusOpacity = 0.0;
    _setLocationOpacity = 1.0;
    _userFocusOpacity = 0.0;
    _mapPadding = 245; //250;

    notifyListeners();
  }

  Future showConfirmTerminalSheet() async{


    _walletOpacity = 0.0; //1.0;
    _topLocationOpacity = 1.0;
    _driverFocusOpacity = 0.0;
    _tripStatusOpacity = 0.0;
    _meetPickupOpacity = 0.0;
    _homeSheetHeight = 0; //250;
    _rideDetailsHeight = 0;
    _confirmTerminalHeight = 240;
    _requestRideHeight = 0;
    _driverPanelHeight = 0;
    _tripOngoingHeight = 0; //150
    _meetAtPickupOpacity = 0;
    _tripTopStatusOpacity = 0.0;
    _driverArrivingHeight = 0;
    _setLocationOpacity = 1.0;
    _userFocusOpacity = 0.0;
    _mapPadding = 245; //250;

    notifyListeners();


  }

  Future showRequestingRideSheet() async{


    _walletOpacity = 0.0; //1.0;
    _topLocationOpacity = 0.0;
    _driverFocusOpacity = 0.0;
    _tripStatusOpacity = 0.0;
    _meetPickupOpacity = 0.0;
    _homeSheetHeight = 0; //250;
    _rideDetailsHeight = 0;
    _confirmTerminalHeight = 0;
    _requestRideHeight = 240;
    _driverPanelHeight = 0;
    _tripOngoingHeight = 0; //150
    _meetAtPickupOpacity = 0;
    _tripTopStatusOpacity = 0.0;
    _driverArrivingHeight = 0;
    _setLocationOpacity = 1.0;
    _userFocusOpacity = 0.0;
    _mapPadding = 245; //250;

    notifyListeners();

  }

  Future showDriverPanelSheet() async{

    _walletOpacity = 0.0; //1.0;
    _topLocationOpacity = 0.0;
    _driverFocusOpacity = 1.0;
    _tripStatusOpacity = 0.0;
    _homeSheetHeight = 0; //250;
    _rideDetailsHeight = 0;
    _confirmTerminalHeight = 0;
    _requestRideHeight = 0;
    _driverPanelHeight = 250;
    _tripOngoingHeight = 0; //150
    _meetAtPickupOpacity = 1.0;
    _tripTopStatusOpacity = 0.0;
    _driverArrivingHeight = 0;
    _setLocationOpacity = 0.0;
    _userFocusOpacity = 1.0;
    _mapPadding = 255; //250;

    notifyListeners();
  }

  Future showTripOngoingSheet() async{

    _walletOpacity = 0.0; //1.0;
    _topLocationOpacity = 0.0;
    _driverFocusOpacity = 0.0;
    _tripStatusOpacity = 1.0;
    _homeSheetHeight = 0; //250;
    _rideDetailsHeight = 0;
    _confirmTerminalHeight = 0;
    _requestRideHeight = 0;
    _driverPanelHeight = 0;
    _tripOngoingHeight = 235; //150
    _meetAtPickupOpacity = 0.0;
    _tripTopStatusOpacity = 1.0;
    _driverArrivingHeight = 0;
    _setLocationOpacity = 1.0;
    _userFocusOpacity = 0.0;
    _mapPadding = 220; //250;

    notifyListeners();
  }


  int _selectedIndex = 0;
  get selectedIndex => _selectedIndex;

  List<String> _options = [
    '1',
    '2',
    '3'
  ];

  Widget _buildChips(BuildContext context) {
    List<Widget> chips = [];

    for (int i = 0; i < _options.length; i++) {
      ChoiceChip choiceChip = ChoiceChip(
        selected: selectedIndex == i,
        label: Text(_options[i], style: Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onBackground)),
        elevation: 0,
        pressElevation: 0,
        padding: EdgeInsets.all(9),
        backgroundColor:  Theme.of(context).colorScheme.surface,
        selectedColor: Theme.of(context).colorScheme.secondaryVariant,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
            side: BorderSide(color:  Theme.of(context).colorScheme.surface),
        ),
        onSelected: (bool selected) {

            if (selected) {
              _selectedIndex = i;

              _seatCount = i + 1;
              _charge = double.parse(searchTripDetails.charge) * (_selectedIndex + 1);

              notifyListeners();
              print(seatCount);
            }

        },
      );

      chips.add(Padding(padding: EdgeInsets.only(left: 5), child: choiceChip));
    }

    return Row(
      // This next line does the trick.
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: chips,
    );
  }

  get buildChips => _buildChips;


  Future<BitmapDescriptor> bitmapDescriptorFromSvgAsset(BuildContext context, String assetName, {size = 28}) async {
    // Read SVG file as String
    String svgString =
    await DefaultAssetBundle.of(context).loadString(assetName);
    // Create DrawableRoot from SVG String
    DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, svgString);

    // toPicture() and toImage() don't seem to be pixel ratio aware, so we calculate the actual sizes here
    MediaQueryData queryData = MediaQuery.of(context);
    double devicePixelRatio = queryData.devicePixelRatio;
    double width =
        size * devicePixelRatio; // where 32 is your SVG's original width
    double height = size * devicePixelRatio; // same thing

    // Convert to ui.Picture
    ui.Picture picture = svgDrawableRoot.toPicture(size: Size(width, height));

    // Convert to ui.Image. toImage() takes width and height as parameters
    // you need to find the best size to suit your needs and take into account the
    // screen DPI
    ui.Image image = await picture.toImage(width.toInt(), height.toInt());
    ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  Future<BitmapDescriptor> getBytesFromAsset(String path, {int width = 38}) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    final icon = (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
    return BitmapDescriptor.fromBytes(icon);
  }

  Future<Uint8List> getBytesFromCanvas(int width, int height) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.blue;
    final Radius radius = Radius.circular(20.0);
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, width.toDouble(), height.toDouble()),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        paint);
    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: 'Hello world',
      style: TextStyle(fontSize: 25.0, color: Colors.white),
    );
    painter.layout();
    painter.paint(
        canvas,
        Offset((width * 0.5) - painter.width * 0.5,
            (height * 0.5) - painter.height * 0.5));
    final img = await pictureRecorder.endRecording().toImage(width, height);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }

  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }

  Future callPhone() async{

    if(tripDetails.phone == null){
      showSnackBarRedAlert("Couldn't place call. Something went wrong");
      return;
    }

    String number = tripDetails.phone;
    bool result = (await FlutterPhoneDirectCaller.callNumber(number))!;
    if(!result){
      showSnackBarRedAlert("Couldn't place call. Something went wrong");
    }
  }





  //GeoFire Implementation
  List<NearbyDriver> nearbyDriverList = [];

  void removeFromList(String key){
    print('##############GEOFIRE#####################################');
    int index = nearbyDriverList.indexWhere((element) => element.key == key);
    nearbyDriverList.removeAt(index);
  }

  void updateNearbyLocation(NearbyDriver driver){
    print('##############GEOFIRE#####################################');

    int index = nearbyDriverList.indexWhere((element) => element.key == driver.key); //Search with driver key

    //update list with new data which will be passed from Geofire
    nearbyDriverList[index].latitude = driver.latitude;
    nearbyDriverList[index].longitude = driver.longitude;
  }

  void clearNearbyDriversList(){

    nearbyDriverList.clear();

  }





  //SAVED LOCATION STUFF
  Future navigateAddHomeWork({bool? isHome}) async{

    if(isHome!){
      print('Navigate to Add Location');

      bool result = await getNavigator.navigateTo(
          Routes.searchLocationView,
          arguments: SearchLocationViewArguments(
            isWork: false,
            isHome: true,
            isEditLocation: false,

          )
      );
      if(result == null){
        await fetchSavedLocations();
        print('WORKS########################SSSSSSSSS');

        notifyListeners();
      }else if(result){
        await fetchSavedLocations();
        print('WORKS########################SSSSSSSSS');

        showSnackBarGreenAlert('Location saved successfully');
        notifyListeners();
      }
    } else{
      print('Navigate to Add Location');

      bool result = await getNavigator.navigateTo(
          Routes.searchLocationView,
          arguments: SearchLocationViewArguments(
            isWork: true,
            isHome: false,
            isEditLocation: false,
          )
      );
      if(result == null){
        await fetchSavedLocations();
        print('WORKS########################SSSSSSSSS');

        notifyListeners();
      }else if(result){
        await fetchSavedLocations();
        print('WORKS########################SSSSSSSSS');

        showSnackBarGreenAlert('Location saved successfully');
        notifyListeners();
      }
    }

    /*
        .then((value){
      if(value){
        fetchPaymentDetails(fromRemote: false);
        showSnackBarGreenAlert('New payment added successfully');
        notifyListeners();
      }
    });

     */
  }

  Future fetchSavedLocations()async{
    _savedLocationList = (await getSharedPrefManager.getPrefSavedLocations())!;
    notifyListeners();

    var indexPickH = savedLocationList.indexWhere((e) => e.tag == '####HOME');
    if(indexPickH > -1)
    {_isHomeLocation = savedLocationList[indexPickH];}
    else
    {_isHomeLocation = null;}

    var indexPickW = savedLocationList.indexWhere((e) => e.tag == '####WORK');
    if(indexPickW > -1)
    {_isWorkLocation = savedLocationList[indexPickW];}
    else
    {_isWorkLocation = null;}
    notifyListeners();
  }

  Future navigateToEditHomeWork ( {isHome})async{

    if(isHome){
      bool result = await getNavigator.navigateTo(Routes.editLocationView,
          arguments: EditLocationViewArguments(
            savedLocation: isHomeLocation,
            isHomeTag: true,
            isWorkTag: false,
          )
      );
      if(result == null){
        await fetchSavedLocations();
        print('WORKS########################SSSSSSSSS');

        notifyListeners();
      }else if(result){
        await fetchSavedLocations();
        print('WORKS########################SSSSSSSSS');

        showSnackBarGreenAlert('Saved location edited successfully');
        notifyListeners();
      }


    }else{
      bool result = await getNavigator.navigateTo(Routes.editLocationView,
          arguments: EditLocationViewArguments(
            savedLocation: isWorkLocation,
            isHomeTag: false,
            isWorkTag: true,
          )
      );
      if(result == null){
        await fetchSavedLocations();
        print('WORKS########################SSSSSSSSS');

        notifyListeners();
      }else if(result){
        await fetchSavedLocations();
        print('WORKS########################SSSSSSSSS');

        showSnackBarGreenAlert('Saved location edited successfully');
        notifyListeners();
      }


    }
  }




  //NAVIGATORS
  Future navigateToSearch() async{

    getNavigator.navigateTo(Routes.searchRideView);

  }

  Future navigateToPaymentOpt() async{

    bool result = await getNavigator.navigateTo(Routes.paymentOptionView);
    if (result == null){
      getProfileDetails();
    }
  }

  Future navigateToCancel() async{

    print('Navigate to Cancel');

    bool result = await getNavigator.navigateTo(Routes.cancelRideView);
    if(result){
      triggerResetRide();
      showSnackBarGreyAlert('Your ride was cancelled');
    }

  }

  Future navigateToAddNote() async{

    print('Navigate to Add Note');

    await getNavigator.navigateTo(Routes.addNoteView)!.then((value) => (){
      if (value){
        showSnackBarGreenAlert('Note added successfully');
      }else{
        showSnackBarRedAlert('Failed to add note');
      }
    });

  }

  Future navigateToPayTrip() async{

    print('Navigate to PayTrip');

    bool result = await getNavigator.navigateTo(Routes.payView);
    if(result == null) {
      triggerResetRide();
    }else if(result == true) {
      triggerResetRide();
    }

  }

  Future navigateToRate() async{

    getNavigator.navigateTo(Routes.rateView);

  }

  Future reset() async{
    notifyListeners();
  }

  Future openTripSafetyBottomSheet() async{

    var confirmationResponse =
    await getBottomSheet.showCustomSheet(
      variant: BottomSheetType.tripSafety,
      isScrollControlled: true,
    );

    print('RESPONSE ${confirmationResponse!.data}');

    if(confirmationResponse.data == 'share'){

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);

      Share.share(
          'Hi ${userProfile.name} here, \n\n'
              'I just got in a ride and here are my ride details. \n'
              'Driver name: ${tripDetails.driverName}. \n'
              'Car model: ${tripDetails.carColor} ${tripDetails.carModel}. \n'
              'Vehicle registration number: ${tripDetails.vehicleNumber}'
              '\n'
              'Here is my location \n'
              'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}',

          subject: '');

    } else if(confirmationResponse.data == 'emergency'){

      bool result = (await FlutterPhoneDirectCaller.callNumber('191'))!;
      if(!result){
        showSnackBarRedAlert("Couldn't place call. Something went wrong");
      }

    }
  }

}