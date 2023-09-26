import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
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
import 'dart:typed_data';
import 'dart:math';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import 'package:curve/data/models/nearbydrivers.dart';
import 'package:curve/data/models/ticket.dart';
import 'package:curve/data/models/user.dart';
import 'package:curve/enums/connectivity_status.dart';
import 'package:curve/presentation/configurations/colors.dart';
import 'package:curve/app/app.router.dart';
import 'package:curve/presentation/widgets/setup_bottomsheet_ui.dart';
import 'package:curve/presentation/view/view_model.dart';

@lazySingleton
class BusRideViewModel extends ViewModel {

  //Panel Variables
  double _walletOpacity = 1.0;
  get walletOpacity => _walletOpacity;

  double _topLocationOpacity = 1.0;
  get topLocationOpacity => _topLocationOpacity;

  double _driverFocusOpacity = 1.0;
  get driverFocusOpacity => _driverFocusOpacity;

  double _tripStatusOpacity = 1.0;
  get tripStatusOpacity => _tripStatusOpacity;

  double _meetPickupOpacity = 1.0;
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

  double _tripOngoingHeight = 210.0; //150
  get tripOngoingHeight => _tripOngoingHeight;

  double _meetAtPickupOpacity = 0.0;
  get meetAtPickupOpacity => _meetAtPickupOpacity;

  double _tripTopStatusOpacity = 0.0;
  get tripTopStatusOpacity => _tripTopStatusOpacity;

  double _driverArrivingHeight = 0.0;
  get driverArrivingHeight => _driverArrivingHeight;

  double _setLocationOpacity = 1.0;
  get setLocationOpacity => _setLocationOpacity;

  double _userFocusOpacity = 1.0;
  get userFocusOpacity => _userFocusOpacity;

  double _mapPadding = 220.0;
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


  TicketDetails? _ticketDetails;
  get ticketDetails => _ticketDetails;

  UserDetails? _userProfile;
  get userProfile => _userProfile;


  //To be Initialised on start////////////////////////////////////////
  Future initialiseOnModelReady(context, getTicketDetail) async{

    _ticketDetails = getTicketDetail;
    notifyListeners();

    print(ticketDetails);


    //await initializePushNotification(context);
    await getProfileDetails();

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


    ////////////////////////////

    await driverLocationListener();

    await polyLinePickupToBusStop(context);

    await polyLineUserToBusStop(context);



    //await driverTripGeoFireListener();

    //await startUserLocationListener();






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

  Future getProfileDetails() async{


    _userProfile = await getSharedPrefManager.getPrefUserProfile();

    notifyListeners();

  }

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

    //await startGeoFireListener();
  }






  //MAP VISUALS/////////////////////////////////////
  //Pickup to busstop polyline
  Future polyLinePickupToBusStop(BuildContext context) async{

    var destinationLatLng = LatLng(ticketDetails.dropOffTerminalLatitude, ticketDetails.dropOffTerminalLongitude);
    var pickupLatLng = LatLng(ticketDetails.pickupTerminalLatitude, ticketDetails.pickupTerminalLongitude);

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

    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
  }

  //User to BusStop polyline
  Future polyLineUserToBusStop(BuildContext context) async{
    _currentPosition = await getLocationService.getCurrentLocation();
    notifyListeners();

    var pickupLatLng = LatLng(currentPosition.latitude, currentPosition.longitude);

    var destinationLatLng = LatLng(ticketDetails.dropOffTerminalLatitude, ticketDetails.dropOffTerminalLongitude);

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
      color: ThemeColor_blue,
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

    /*
    LatLngBounds bounds;
    bounds = boundsFromLatLngList([
      pickupLatLng,
      destinationLatLng,
    ]);

     */

    if (pickLocationIcon == null)
      _pickLocationIcon = await bitmapDescriptorFromSvgAsset(
          context, "assets/markers/pickupmarker.svg",
          size: 25);

    if (dropLocationIcon == null)
      _dropLocationIcon = await bitmapDescriptorFromSvgAsset(
          context, "assets/markers/dropoffmarker.svg",
          size: 25);
    notifyListeners();


    //mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 140));


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

    //mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));

  }

  //User to BusStop polyline
  Future updatePolylineUserToBusStop() async {
    _currentPosition = await getLocationService.getCurrentLocation();
    notifyListeners();

    var pickupLatLng = LatLng(currentPosition.latitude, currentPosition.longitude);

    var destinationLatLng = LatLng(ticketDetails.pickupTerminalLatitude, ticketDetails.pickupTerminalLongitude);

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


    Polyline updatedPolyline = Polyline(
      polylineId: PolylineId('polyiduser'),
      color: ThemeColor_blue,
      patterns: [PatternItem.dot, PatternItem.gap(15)],
      points: userToBusPolyLineCoordinates,
      jointType: JointType.round,
      width: 4,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      geodesic: true,
    );

    _polyLines.clear();
    //polyLines.polylineId.removeWhere((m) => m.polylineId.value == 'polyiduser');

    _polyLines.add(updatedPolyline);
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

    var pickupLatLng = driverLatLng;

    var destinationLatLng = LatLng(ticketDetails.dropOffTerminalLatitude, ticketDetails.dropOffTerminalLongitude);

    LatLngBounds bounds;

    bounds = boundsFromLatLngList([
      pickupLatLng,
      destinationLatLng,
    ]);

    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
  }

  //Nearby driver location on map with icon
  Future updateTripDriverIconOnMap() async{

    var destinationLatLng = LatLng(ticketDetails.dropOffTerminalLatitude, ticketDetails.dropOffTerminalLongitude);
    var pickupLatLng = LatLng(ticketDetails.pickupTerminalLatitude, ticketDetails.pickupTerminalLongitude);

    _markers.clear();
    notifyListeners();

    Set<Marker> tempMarkers = Set<Marker>();

    Marker thisMarker = Marker(
      markerId: MarkerId('driverId'),
      position: driverLatLng,
      icon: carIcon,
      rotation: 0,//generateRandomNumber(360),
    );

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

    tempMarkers.add(pickupMarker);
    tempMarkers.add(destinationMarker);
    tempMarkers.add(thisMarker);

    _markers = tempMarkers;
    notifyListeners();

  }



  //Geofire Callbacks//////////////////////////////////////////////////

  Future driverLocationListener() async{

      DatabaseReference rideRef = FirebaseDatabase.instance.reference().child('drivers/${ticketDetails.busDriverId}');

      //Listen for data
      rideRef.onValue.listen((event) async{

        var snapshot = event.snapshot;

        print('####');
        print(snapshot.value['g'].toString());


        if(snapshot.value != null) {

          print(snapshot.value['l'][1].toString());
          print(snapshot.value['l'][0].toString());

          _driverLatLng = LatLng(double.parse(snapshot.value['l'][0].toString()), double.parse(snapshot.value['l'][1].toString()));
          notifyListeners();

          updateTripDriverIconOnMap();
          updateTripDriverIconOnMap();

        }
      });
  }

  Future driverTripGeoFireListener() async{

    await stopGeoFireListener();

    //_markers.clear();
    //notifyListeners();

    print('##########DRIVER TRIP#########################################');

    Geofire.initialize('drivers'); //Provide path to listen from

    Geofire.queryAtLocation(currentPosition.latitude, currentPosition.longitude, 1000)!.listen((map) async{
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
    //stopUserLocationListener();

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

  /*
  Future callPhone() async{

    if(tripDetails.phone == null){
      showSnackBarRedAlert("Couldn't place call. Something went wrong");
      return;
    }

    String number = tripDetails.phone;
    bool result = await FlutterPhoneDirectCaller.callNumber(number);
    if(!result){
      showSnackBarRedAlert("Couldn't place call. Something went wrong");
    }
  }
   */





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







  //NAVIGATORS
  /*
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

    await getNavigator.navigateTo(Routes.addNoteView).then((value) => (){
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

   */

  Future openTripSafetyBottomSheet(context) async{

    var confirmationResponse =
    await getBottomSheet.showCustomSheet(
      variant: BottomSheetType.tripSafety,
      isScrollControlled: true,
    );

    print('RESPONSE ${confirmationResponse?.data}');

    if(confirmationResponse!.data == 'share'){

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);

      Share.share(
          'Hi ${userProfile.name} here, \n\n'
              'I just got in a ride and here are my ride details. \n'
              'Driver name: ${ticketDetails.busDriverName}. \n'
              'Car model: ${ticketDetails.busColor} ${ticketDetails.busModel}. \n'
              'Vehicle registration number: ${ticketDetails.busNumber}'
              '\n'
              'Here is my location \n'
              'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}',

          subject: '');

    } else if(confirmationResponse.data == 'emergency'){

      bool? result = await FlutterPhoneDirectCaller.callNumber('191');
      if(!(result!)){
        showSnackBarRedAlert("${AppLocalizations.of(context)!.couldntPlaceCall}");
      }

    }
  }

  Future showTicket() async{

    await getNavigator.navigateTo(Routes.showTicketView,
        arguments: ShowTicketViewArguments(
          ticketDetails: ticketDetails,
        ));
  }

}