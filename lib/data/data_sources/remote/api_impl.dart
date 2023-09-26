
import 'dart:convert';
import 'package:http/http.dart';

import '../../../domain/api/api.dart';


class ApiImpl implements Api {
  final baseUrl = "https://us-central1-vielly-8b429.cloudfunctions.net";

  get _headers => {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  //USER APIS
  @override
  Future<Response> getUserAPI(String uid) {
    final url = Uri.parse('$baseUrl/userProfile?uid=$uid');
    print(url);
    var response = get(url, headers: _headers);
    return response;
  }
  @override
  Future<Response> patchUserAPI({data}) {
    final url = Uri.parse('$baseUrl/userProfile');
    print("data is $data");

    var response = patch(url, headers: _headers, body: jsonEncode(data));
    print("$url => response = $response");
    return response;
  }
  @override
  Future<Response> postSetNotificationToken({data}) {

    final url = Uri.parse('$baseUrl/setNotificationToken');
    print("data is $data");

    var response = post(url, headers: _headers, body: jsonEncode(data));
    print("$url => response = $response");
    return response;
  }
  @override
  Future<Response> postReferralCodeAPI({data}) {

    final url = Uri.parse('$baseUrl/createReferralCode');
    print("data is $data");

    var response = post(url, headers: _headers, body: jsonEncode(data));
    print("$url => response = $response");
    return response;
  }
  @override
  Future<Response> getRideHistoryAPI(String uid) {
    final url = Uri.parse('$baseUrl/tripHistory?uid=$uid');
    print(url);
    var response = get(url, headers: _headers);
    return response;
  }

  
  
  
  //SAVED LOCATION
  @override
  Future<Response> getSavedLocationAPI(String uid) {
    final url = Uri.parse('$baseUrl/savedLocation?uid=$uid');
    print(url);
    var response = get(url, headers: _headers);
    return response;
  }
  @override
  Future<Response> postAddSavedLocationAPI({data}) {
    final url = Uri.parse('$baseUrl/savedLocation');
    print("data is $data");

    var response = post(url, headers: _headers, body: jsonEncode(data));
    print("$url => response = $response");
    return response;
  }
  @override
  Future<Response> patchSavedLocationAPI({data}) {
    final url = Uri.parse('$baseUrl/savedLocation');
    print("data is $data");

    var response = patch(url, headers: _headers, body: jsonEncode(data));
    print("$url => response = $response");
    return response;
  }
  @override
  Future<Response> delSavedLocationAPI({data}) async{

    final url = Uri.parse('$baseUrl/savedLocation');

    final client = Client();
    try {
      var response = await client.send(
          Request("DELETE", url)
            ..headers["Content-type"] = 'application/json'
            ..headers["Accept"] = 'application/json'
            ..body = jsonEncode(data));
      //
      print("$url => response = $response");

      var responseStr = await Response.fromStream(response);
      return responseStr;
    } finally {
      client.close();
    }

  }



  //TRIP API
  @override
  Future<Response> postSearchTripAPI({data}) {
    final url = Uri.parse('$baseUrl/searchTrip');
    print("data is $data");

    var response = post(url, headers: _headers, body: jsonEncode(data));
    print("$url => response = $response");
    return response;
  }
  @override
  Future<Response> postConfirmTripAPI({data}) {
    final url = Uri.parse('$baseUrl/confirmTrip');
    print("data is $data");

    var response = post(url, headers: _headers, body: jsonEncode(data));
    print("$url => response = $response");
    return response;
  }
  @override
  Future<Response> postCancelTripAPI({data}) {
    final url = Uri.parse('$baseUrl/cancelTrip');
    print("data is $data");

    var response = post(url, headers: _headers, body: jsonEncode(data));
    print("$url => response = $response");
    return response;
  }
  @override
  Future<Response> postRateTripAPI({data}) {
    final url = Uri.parse('$baseUrl/rating');
    print("data is $data");

    var response = post(url, headers: _headers, body: jsonEncode(data));
    print("$url => response = $response");
    return response;
  }
  @override
  Future<Response> postSendTripMessageAPI({data}) {
    final url = Uri.parse('$baseUrl/sendTripMessage');
    print("data is $data");

    var response = post(url, headers: _headers, body: jsonEncode(data));
    print("$url => response = $response");
    return response;
  }
  @override
  Future<Response> postSubmitOTPAPI({data}) {
    final url = Uri.parse('$baseUrl/submitVodafoneOTP');
    print("data is $data");

    var response = post(url, headers: _headers, body: jsonEncode(data));
    print("$url => response = $response");
    return response;
  }
  @override
  Future<Response> postPayTripAPI({data}) {
    final url = Uri.parse('$baseUrl/makePayment');
    print("data is $data");

    var response = post(url, headers: _headers, body: jsonEncode(data));
    print("$url => response = $response");
    return response;
  }


  //PAYMENT API
  @override
  Future<Response> getPaymentMethodsAPI(String uid) {
    final url = Uri.parse('$baseUrl/paymentMethod?uid=$uid');
    print(url);
    var response = get(url, headers: _headers);
    return response;
  }
  @override
  Future<Response> patchPaymentMethodsAPI({data}) {
    final url = Uri.parse('$baseUrl/paymentMethod');
    print("data is $data");

    var response = patch(url, headers: _headers, body: jsonEncode(data));
    print("$url => response = $response");
    return response;
  }
  @override
  Future<Response> postAddPaymentMethodsAPI({data}) {

    final url = Uri.parse('$baseUrl/paymentMethod');
    print("data is $data");

    var response = post(url, headers: _headers, body: jsonEncode(data));
    print("$url => response = $response");
    return response;
  }
  @override
  Future<Response> delPaymentMethodsAPI({data}) async{

    final url = Uri.parse('$baseUrl/paymentMethod/');

    final client = Client();
    try {
      var response = await client.send(
          Request("DELETE", url)
            ..headers["Content-type"] = 'application/json'
            ..headers["Accept"] = 'application/json'
            ..body = jsonEncode(data));
      //
      print("$url => response = $response");

      var responseStr = await Response.fromStream(response);
      return responseStr;
    } finally {
      client.close();
    }

    //var response = delete(url, headers: _headers, body: jsonEncode(data));
    //print("$url => response = $response");
    //return response;
  }


  //BUS API
  @override
  Future<Response> getBusSchedulesAPI() {
    final url = Uri.parse('$baseUrl/busSchedule');
    print(url);
    var response = get(url, headers: _headers);
    return response;
  }
  @override
  Future<Response> postBookTicketAPI({data}) {

    final url = Uri.parse('$baseUrl/bookTicket');
    print("data is $data");

    var response = post(url, headers: _headers, body: jsonEncode(data));
    print("$url => response = $response");
    return response;
  }
  @override
  Future<Response> postConfirmTicketAPI({data}) {

    final url = Uri.parse('$baseUrl/confirmTicketBooking');
    print("data is $data");

    var response = post(url, headers: _headers, body: jsonEncode(data));
    print("$url => response = $response");
    return response;
  }

  @override
  Future<Response> getAllTicketsAPI(String uid) {
    final url = Uri.parse('$baseUrl/getTicket?ticket_number=0&uid=$uid');
    print(url);
    var response = get(url, headers: _headers);
    return response;
  }

}
