import '../../../data/models/searchtripdata.dart';

import '../../../domain/repository/trip_repository.dart';
import '../base_repository_impl.dart';


class TripRepositoryImpl with BaseRepositoryImpl implements TripRepository {


  @override
  Future<SearchTripDetails?>? postSearchTrip(Map<String, dynamic> payloadData) async{
    final uid = await prefService.getPrefUserID();

    payloadData['uid'] = uid;
    payloadData['passenger_count'] = 1;
    payloadData['trip_type'] = 'curver';


    /*
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['uid'] = uid;
    data['pickup'] =
    {
      "latitude": startPosition.latitude,
      "longitude": startPosition.longitude
    }
    ;
    data['dropoff'] =
    {
      "latitude": endPosition.latitude,
      "longitude": endPosition.longitude
    }
    ;

     */


    var data = await processRequest(() => apiService.postSearchTripAPI(
      data: payloadData,
    ));
    if (data != null) {

      SearchTripDetails searchTripDetails = SearchTripDetails();

      searchTripDetails.orderID = data['data']['order_id'];
      searchTripDetails.charge = (data['data']['charge']);
      searchTripDetails.pickupLocation = data['data']['pickup_terminal']['location'];
      searchTripDetails.pickupName = data['data']['pickup_terminal']['name'];
      searchTripDetails.pickupLatitude = data['data']['pickup_terminal']['coords']['latitude'];
      searchTripDetails.pickupLongitude = data['data']['pickup_terminal']['coords']['longitude'];
      searchTripDetails.dropoffLocation = data['data']['dropoff_terminal']['location'];
      searchTripDetails.dropoffName = data['data']['dropoff_terminal']['name'];
      searchTripDetails.dropoffLatitude = data['data']['dropoff_terminal']['coords']['latitude'];
      searchTripDetails.dropoffLongitude = data['data']['dropoff_terminal']['coords']['longitude'];

      print(data);
      prefService.setPrefSearchTrip(searchTripDetails);

      return searchTripDetails;
    } else
      return null;
  }

  @override
  Future<SearchTripBusDetails?>? postSearchTripBus(Map<String, dynamic> payloadData) async{
    final uid = await prefService.getPrefUserID();

    payloadData['uid'] = uid;
    payloadData['passenger_count'] = 1;
    payloadData['trip_type'] = 'shuttle_share';



    /*
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['uid'] = uid;
    data['pickup'] =
    {
      "latitude": startPosition.latitude,
      "longitude": startPosition.longitude
    }
    ;
    data['dropoff'] =
    {
      "latitude": endPosition.latitude,
      "longitude": endPosition.longitude
    }
    ;

     */


    var data = await processRequest(() => apiService.postSearchTripAPI(
      data: payloadData,
    ));
    if (data != null) {

      SearchTripBusDetails searchTripBusDetails = SearchTripBusDetails();

      searchTripBusDetails.orderID = data['data']['order_id'];
      searchTripBusDetails.charge = (data['data']['charge']);
      searchTripBusDetails.pickupLocation = data['data']['pickup_terminal']['location'];
      searchTripBusDetails.pickupName = data['data']['pickup_terminal']['name'];
      searchTripBusDetails.pickupID = data['data']['pickup_terminal']['id'];
      searchTripBusDetails.pickupLatitude = data['data']['pickup_terminal']['coords']['latitude'];
      searchTripBusDetails.pickupLongitude = data['data']['pickup_terminal']['coords']['longitude'];
      searchTripBusDetails.dropoffLocation = data['data']['dropoff_terminal']['location'];
      searchTripBusDetails.dropoffName = data['data']['dropoff_terminal']['name'];
      searchTripBusDetails.dropoffID = data['data']['dropoff_terminal']['id'];
      searchTripBusDetails.dropoffLatitude = data['data']['dropoff_terminal']['coords']['latitude'];
      searchTripBusDetails.dropoffLongitude = data['data']['dropoff_terminal']['coords']['longitude'];

      print(data);
      prefService.setPrefSearchTripBus(searchTripBusDetails);

      return searchTripBusDetails;
    } else
      return null;
  }

  @override
  Future<dynamic> postConfirmTrip(Map<String, dynamic> payloadData) async{
    final uid = await prefService.getPrefUserID();

    payloadData['uid'] = uid;

    var data = await processRequest(() => apiService.postConfirmTripAPI(
      data: payloadData,
    ));
    if (data != null) {

      print(data['msg']);

      if(data['success'] == true)
        return data['msg'];
      else if(data['success'] == false)
        return data['msg'];
      else
        return false;
    } else
      return false;
  }

  @override
  Future<bool> postCancelTrip(Map<String, dynamic> payloadData) async{
    final uid = await prefService.getPrefUserID();

    payloadData['uid'] = uid;

    var data = await processRequest(() => apiService.postCancelTripAPI(
      data: payloadData,
    ));
    if (data != null) {
      print(data['msg']);
      if(data['success'] == true)
        return true;
      else
        return false;
    } else
      return false;
  }

  @override
  Future<bool> postSendTripMessage(Map<String, dynamic> payloadData) async{
    final uid = await prefService.getPrefUserID();

    payloadData['uid'] = uid;

    var data = await processRequest(() => apiService.postSendTripMessageAPI(
      data: payloadData,
    ));
    if (data != null) {
      print(data['msg']);
      if(data['success'] == true)
        return true;
      else
        return false;
    } else
      return false;
  }

  @override
  Future<bool> postRateTrip(Map<String, dynamic> payloadData) async{
    final uid = await prefService.getPrefUserID();

    payloadData['uid'] = uid;

    var data = await processRequest(() => apiService.postRateTripAPI(
      data: payloadData,
    ));
    if (data != null) {
      print(data['msg']);
      if(data['success'] == true){
        return true;
      }else return false;

    }else return false;
  }


  @override
  Future<bool> postPayTrip(Map<String, dynamic> payloadData) async{
    final uid = await prefService.getPrefUserID();

    payloadData['uid'] = uid;

    var data = await processRequest(() => apiService.postPayTripAPI(
      data: payloadData,
    ));
    if (data != null) {
      print(data['msg']);
      if(data['success'] == true){
        return true;
      }else return false;

    }else return false;
  }


  @override
  Future<bool> postSubmitOTP(Map<String, dynamic> payloadData) async{
    final uid = await prefService.getPrefUserID();

    payloadData['uid'] = uid;

    var data = await processRequest(() => apiService.postSubmitOTPAPI(
      data: payloadData,
    ));
    if (data != null) {
      print(data['msg']);
      if(data['success'] == true){
        return true;
      }else return false;

    }else return false;
  }

}