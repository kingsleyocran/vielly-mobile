

import '../../data/models/searchtripdata.dart';

abstract class TripRepository {

  Future<SearchTripDetails?>? postSearchTrip(Map<String, dynamic> payloadData);
  Future<SearchTripBusDetails?>? postSearchTripBus(Map<String, dynamic> payloadData);
  Future<dynamic> postConfirmTrip(Map<String, dynamic> payloadData);
  Future<bool> postCancelTrip(Map<String, dynamic> payloadData);
  Future<bool> postSendTripMessage(Map<String, dynamic> payloadData);
  Future<bool> postRateTrip(Map<String, dynamic> payloadData);
  Future<bool> postPayTrip(Map<String, dynamic> payloadData);
  Future<bool> postSubmitOTP(Map<String, dynamic> payloadData);


  //Future<User> getUser();
  //Future<Profile> updateDriverProfile(Map<String, dynamic> payloadData);
  //Future<Profile> getDriverProfile({fromRemote});
  //Future<Profile> getRiderProfile(uid);
  //Future<bool> updateDriverAvailability(bool availability);
  //Future<List<String>> getManufacturers();
  //Future<List<String>> getCarModels(manufacturer, year);
  //Future updateToken(String token);
  //Future updateLocation({double lat, double lon});
  //Future<bool> receivePayment({double amount, String phone, String providerType});
}