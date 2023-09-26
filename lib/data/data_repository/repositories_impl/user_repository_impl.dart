
import '../../../data/models/user.dart';
import '../../../domain/repository/user_repository.dart';
import '../base_repository_impl.dart';

class UserRepositoryImpl with BaseRepositoryImpl implements UserRepository {

  //USER FUNCTIONS
  @override
  Future<UserDetails?>? getUserProfile({fromRemote = true}) async {
    if (!fromRemote) return prefService.getPrefUserProfile();

    final uid = await prefService.getPrefUserID();
    var dataRemote = await processRequest(() => apiService.getUserAPI(uid!));
    if (dataRemote != null && dataRemote['data'] != null) {
      final user = UserDetails.fromJson(dataRemote['data']);

      prefService.setPrefUserProfile(user);
      return Future.value(user);
    }
    return prefService.getPrefUserProfile();
  }

  @override
  Future<bool> patchUserProfile(Map<String, dynamic> payloadData) async {
    final uid = await prefService.getPrefUserID();

    payloadData["uid"] = uid;

    var data = await processRequest(() => apiService.patchUserAPI(
      data: payloadData,
    ));
    if (data != null) {
      final profile = UserDetails.fromJson(data['data']);
      prefService.setPrefUserProfile(profile);

      return true;
    } else
      return false;
  }

  @override
  Future<bool> postSetNotificationToken(String token) async {

    //if(prefService.prefIsTokenUpdated)return true;

    final uid = await prefService.getPrefUserID();
    final body = {"token": token, "uid": uid!};

    print("$body");

    final data = await processRequest(() => apiService.postSetNotificationToken(data: body));
    if (data != null) {
      //prefService.prefIsTokenUpdated = true;
      return Future.value(true);
    } else
    return Future.value(false);
  }

  @override
  Future<bool> postReferralCode() async{
    final uid = await prefService.getPrefUserID();
    final body = {"uid": uid!};

    print("$body");

    final data =
        await processRequest(() => apiService.postReferralCodeAPI(data: body));

    if (data != null && data['success'] == true) {
      return Future.value(true);
    }
    return Future.value(false);
  }

  @override
  Future<dynamic> getRideHistory({fromRemote}) async{
    if (!fromRemote) {
      return prefService.getPrefRideHistory();
    }
    else{
      final uid = await prefService.getPrefUserID();
      var dataRemote = await processRequest(() => apiService.getRideHistoryAPI(uid!));
      if (dataRemote != null && dataRemote['data'] != null) {
        print(dataRemote);
        prefService.setPrefRideHistory( dataRemote['data']);
        return dataRemote;
      }else return null;
    }

  }


  //SAVED LOCATIONS
  @override
  Future<dynamic> getSavedLocation({fromRemote}) async{
    if (!fromRemote) {
      return await prefService.getPrefSavedLocations();
    }
    else{
      final uid = await prefService.getPrefUserID();
      var dataRemote = await processRequest(() => apiService.getSavedLocationAPI(uid!));
      if (dataRemote != null && dataRemote['data'] != null) {
        print(dataRemote);
        prefService.setPrefSavedLocations( dataRemote['data']);

        return dataRemote;
      }
      else {
        //prefService.setPrefSavedLocations(nu);
        return null;}
    }
  }

  @override
  Future<bool> postAddSavedLocation(Map<String, dynamic> payloadData) async{
    final uid = await prefService.getPrefUserID();

    payloadData["uid"] = uid;

    var data = await processRequest(() => apiService.postAddSavedLocationAPI(
      data: payloadData,
    ));
    if (data != null && data['success'] == true) {

      print(data['msg']);
      return true;
    } else return false;
  }

  @override
  Future<bool> patchSavedLocation(Map<String, dynamic> payloadData) async{
    final uid = await prefService.getPrefUserID();

    payloadData["uid"] = uid!;

    var data = await processRequest(() => apiService.patchSavedLocationAPI(
      data: payloadData,
    ));
    if (data != null && data['success'] == true) {
      print(data['msg']);
      return true;
    } else return false;
  }

  @override
  Future<bool> delSavedLocation(Map<String, dynamic> payloadData) async{
    final uid = await prefService.getPrefUserID();

    payloadData["uid"] = uid!;

    var data = await processRequest(() => apiService.delSavedLocationAPI(
      data: payloadData
    ));
    if (data != null && data['success'] == true) {

      print(data['msg']);

      return true;
    } else return false;
  }




  //PAYMENT
  @override
  Future<dynamic> getPaymentMethods({fromRemote}) async{
    if (!fromRemote) {
      return prefService.getPrefPaymentMethods();
    }
    else{
      final uid = await prefService.getPrefUserID();
      var dataRemote = await processRequest(() => apiService.getPaymentMethodsAPI(uid!));
      if (dataRemote != null && dataRemote['data'] != null) {
        print(dataRemote);
        prefService.setPrefPaymentMethods(dataRemote['data']);

        return dataRemote;
      }else return null;
    }
  }

  @override
  Future<bool> postAddPaymentMethod(Map<String, dynamic> payloadData) async{
    final uid = await prefService.getPrefUserID();



    payloadData["uid"] = uid!;
    payloadData["is_primary"] = true;

    var data = await processRequest(() => apiService.postAddPaymentMethodsAPI(
      data: payloadData,
    ));
    if (data != null && data['success'] == true) {
      print(data['msg']);

      return true;
    } else return false;
  }

  @override
  Future<bool> patchPaymentMethod(Map<String, dynamic> payloadData) async{
    final uid = await prefService.getPrefUserID();

    payloadData["uid"] = uid!;

    var data = await processRequest(() => apiService.patchPaymentMethodsAPI(
      data: payloadData,
    ));
    if (data != null && data['success'] == true) {
      print(data['msg']);
      return true;
    } else return false;
  }

  @override
  Future<bool> delPaymentMethod(Map<String, dynamic> payloadData) async{
    final uid = await prefService.getPrefUserID();

    payloadData["uid"] = uid;

    var data = await processRequest(() => apiService.delPaymentMethodsAPI(
        data: payloadData
    ));
    if (data != null && data['success'] == true) {
      print(data['msg']);
      return true;
    } else return false;
  }

}