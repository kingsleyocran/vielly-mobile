

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/address.dart';
import '../../../data/models/bookedbusdata.dart';
import '../../../data/models/busschedule_data.dart';
import '../../../data/models/paymentmethods.dart';
import '../../../data/models/ridehistory_data.dart';
import '../../../data/models/savedlocations.dart';
import '../../../data/models/searchtripdata.dart';
import '../../../data/models/ticket.dart';
import '../../../data/models/trip.dart';

import '../../../data/models/user.dart';

class SharedPrefManager {
  static SharedPreferences? _preferences;

  static const String UserKey = 'user';
  static const String SignedUpKey = 'signedUp';
  static const String LoggedInKey = 'loggedIn';

  //Get Instance of SharedPreference
  /*
  static Future<SharedPrefManager> getInstance() async {
    if (_instance == null) {
      _instance = SharedPrefManager();
    }

    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }
    return _instance;
  }

   */


  SharedPrefManager() {
    _getInstance();
  }

  _getInstance() async {
    _preferences = await SharedPreferences.getInstance();
  }

  prefLogout() async {
    _preferences!.clear();
  }

  //_getFromDisk function that handles all get from shared preference
  _getFromDisk(String key) {
    var value  = _preferences!.get(key);
    print('(TRACE) LocalStorageService:_getFromDisk. key: $key value: $value');
    return value;
  }

  //_saveToDisk function that handles all types
  void _saveToDisk<T>(String key, T content){
    print('(TRACE) LocalStorageService:_saveToDisk. key: $key value: $content');

    if(content is String) {
      _preferences!.setString(key, content);
    }
    if(content is bool) {
      _preferences!.setBool(key, content);
    }
    if(content is int) {
      _preferences!.setInt(key, content);
    }
    if(content is double) {
      _preferences!.setDouble(key, content);
    }
    if(content is List<String>) {
      _preferences!.setStringList(key, content);
    }
  }










  //Login or sign-up assertion from the shared preference
  bool get hasSignedUp => _getFromDisk(SignedUpKey) ?? false;
  set hasSignedUp(bool value) => _saveToDisk(SignedUpKey, value);

  bool get hasLoggedIn => _getFromDisk(LoggedInKey) ?? false;
  set hasLoggedIn(bool value) => _saveToDisk(LoggedInKey, value);


  //Get User from disk
  Future<String?>? getPrefUserID() {
    final data = _getFromDisk("UserID");

    return data != null
        ? Future.value(data)
        : null;
  }
  void setPrefUserID(String data) {
    _saveToDisk("UserID", data);
  }


  //Get and set phone number
  Future<String?>? getPrefUserPhone() {
    final data = _getFromDisk("UserPhone");

    return data != null
        ? Future.value(data)
        : null;
  }
  void setPrefUserPhone(String data) {
    _saveToDisk("UserPhone", data);
  }


  //Get and set phone number
  Future<bool?>? getIsTokenUpdated() {
    final data = _getFromDisk("IsTokenUpdated");

    return data != null
        ? Future.value(data)
        : null;
  }
  void setIsTokenUpdated(bool data) {
    _saveToDisk("IsTokenUpdated", data);
  }













  //User Profile Functions
  Future<UserDetails?>? getPrefUserProfile() {
    final data = _getFromDisk(UserKey);

    return data != null
        ? Future.value(UserDetails.fromJson(jsonDecode(data)))
        : null;
  }
  void setPrefUserProfile(UserDetails data) {
    _saveToDisk(UserKey, json.encode(data.toJson()));
  }


  //User Saved Locations
  Future<List?>? getPrefSavedLocations() {
    final data = _getFromDisk('SavedLocations');
    if(data == null)return null;

    final dataDecode = jsonDecode(data);
    var dataList = (dataDecode as List)
        .map((e) => SavedLocationModel.fromJson(e))
        .toList();

    return data != null
        ? Future.value(dataList)
        : null;
  }
  void setPrefSavedLocations(var data) {
    _saveToDisk('SavedLocations', jsonEncode(data));
  }


  //Search Trip Details
  Future<SearchTripDetails?>? getPrefSearchTrip() {
    final data = _getFromDisk('SearchTrip');

    return data != null
        ? Future.value(SearchTripDetails.fromJson(jsonDecode(data)))
        : null;
  }
  void setPrefSearchTrip(SearchTripDetails data) {
    _saveToDisk('SearchTrip', json.encode(data.toJson()));
  }


  //Search Trip Bus Details
  Future<SearchTripBusDetails?>? getPrefSearchTripBus() {
    final data = _getFromDisk('SearchTripBus');

    return data != null
        ? Future.value(SearchTripBusDetails.fromJson(jsonDecode(data)))
        : null;
  }
  void setPrefSearchTripBus(SearchTripBusDetails data) {
    _saveToDisk('SearchTripBus', json.encode(data.toJson()));
  }


  //Trip Details
  Future<TripDetails?>? getPrefTrip() {
    final data = _getFromDisk('Trip');

    return data != null
        ? Future.value(TripDetails.fromJson(jsonDecode(data)))
        : null;
  }
  void setPrefTrip(TripDetails data) {
    _saveToDisk('Trip', json.encode(data.toJson()));
  }


  //PickupAddress Details
  Future<AddressDetails?>? getPrefPickupAddress() {
    final data = _getFromDisk('Pickup Address');

    return data != null
        ? Future.value(AddressDetails.fromJson(jsonDecode(data)))
        : null;
  }
  void setPrefPickupAddress(AddressDetails data) {
    _saveToDisk('Pickup Address', json.encode(data.toJson()));
  }


  //PickupAddress Details
  Future<AddressDetails?>? getPrefDropOffAddress() {
    final data = _getFromDisk('Dropoff Address');

    return data != null
        ? Future.value(AddressDetails.fromJson(jsonDecode(data)))
        : null;
  }
  void setPrefDropOffAddress(AddressDetails data) {
    _saveToDisk('Dropoff Address', json.encode(data.toJson()));
  }


  //Ride History
  Future<List?>? getPrefRideHistory() {
    final data = _getFromDisk('RideHistory');
    if(data == null)return null;

    final dataDecode = jsonDecode(data);
    var dataList = (dataDecode as List)
        .map((e) => RideHistory.fromJson(e))
        .toList();

    return data != null
        ? Future.value(dataList)
        : null;
  }
  void setPrefRideHistory(var data) {
    _saveToDisk('RideHistory', jsonEncode(data));
  }

  Future clearTripData () async{
    _preferences!.remove('SearchTrip');
    _preferences!.remove('Trip');
    _preferences!.remove('Dropoff Address');
    _preferences!.remove('Pickup Address');

    print('####TRIP DATA REMOVED######');
  }







  //Payment
  Future<List?>? getPrefPaymentMethods() {
    final data = _getFromDisk('PaymentMethods');
    if(data == null)return null;

    final dataDecode = jsonDecode(data);
    List<PaymentMethods> dataList = (dataDecode as List)
        .map((e) => PaymentMethods.fromJson(e))
        .toList();

    return data != null
        ? Future.value(dataList)
        : null;
  }
  void setPrefPaymentMethods(var data) {
    _saveToDisk('PaymentMethods', jsonEncode(data));
  }


  //Payment Methods Primary
  Future<PaymentMethods?>? getPrefIsPrimaryMethod() {
    final data = _getFromDisk('PaymentIsPrimary');

    return data != null
        ? Future.value(PaymentMethods.fromJson(jsonDecode(data)))
        : null;
  }
  void setPrefIsPrimaryMethod(PaymentMethods data) {
    _saveToDisk('PaymentIsPrimary', json.encode(data.toJson()));
  }





  //Bus Schedules Methods
  Future<List?>? getPrefBusSchedules() {
    final data = _getFromDisk('Bus Schedules');
    if(data == null)return null;

    final dataDecode = jsonDecode(data);
    var dataJson = dataDecode['data'];
    var dataList = (dataJson as List)
        .map((e) => BusSchedule.fromJson(e))
        .toList();

    return data != null
        ? Future.value(dataList)
        : null;
  }
  void setPrefBusSchedules(var data) {
    _saveToDisk('Bus Schedules', jsonEncode(data));
  }


  //BookedBusSchedule Details
  Future<BookedBusSchedule?>? getBookTicketData() {
    final data = _getFromDisk('Booked Bus Data');

    return data != null
        ? Future.value(BookedBusSchedule.fromJson(jsonDecode(data)))
        : null;
  }
  void setBookTicketData(BookedBusSchedule data) {
    _saveToDisk('Booked Bus Data', json.encode(data.toJson()));
  }


  //TicketDetails Details
  Future<TicketDetails?>? getTicketData() {
    final data = _getFromDisk('Ticket Details Data');

    return data != null
        ? Future.value(TicketDetails.fromJson(jsonDecode(data)))
        : null;
  }
  void setTicketData(TicketDetails data) {
    _saveToDisk('Ticket Details Data', json.encode(data.toJson()));
  }


  //Saved Tickets
  Future<List?>? getPrefSavedTickets() {
    //todo check if data['data'] is right
    final data = _getFromDisk('Saved Ticket List');
    if(data == null)return null;

    final dataDecode = jsonDecode(data);
    var dataList = (dataDecode as List)
        .map((e) => TicketDetails.fromJson(e))
        .toList();

    return data != null
        ? Future.value(dataList)
        : null;
  }
  void setPrefSavedTickets(var data) {
    _saveToDisk('Saved Ticket List', jsonEncode(data));
  }

}