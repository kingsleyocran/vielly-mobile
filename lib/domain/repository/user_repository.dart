

import '../../data/models/user.dart';

abstract class UserRepository {
  Future<UserDetails?>? getUserProfile({fromRemote});
  Future<bool> patchUserProfile(Map<String, dynamic> payloadData);

  Future<bool> postSetNotificationToken(String token);
  Future<bool> postReferralCode();
  Future<dynamic> getRideHistory();

  Future<dynamic> getSavedLocation({fromRemote});
  Future<bool> postAddSavedLocation(Map<String, dynamic> payloadData);
  Future<bool> patchSavedLocation(Map<String, dynamic> payloadData);
  Future<bool> delSavedLocation(Map<String, dynamic> payloadData);

  Future<dynamic> getPaymentMethods({fromRemote});
  Future<bool> patchPaymentMethod(Map<String, dynamic> payloadData);
  Future<bool> postAddPaymentMethod(Map<String, dynamic> payloadData);
  Future<bool> delPaymentMethod(Map<String, dynamic> payloadData);

  //Future updateToken(String token);
  //Future updateLocation({double lat, double lon});
}