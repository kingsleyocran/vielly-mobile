import 'package:http/http.dart' show Response;

abstract class Api {
  //USER APIS
  Future<Response> getUserAPI(String uid);
  Future<Response> patchUserAPI({data});

  Future<Response> postSetNotificationToken({data});
  Future<Response> postReferralCodeAPI({data});
  Future<Response> getRideHistoryAPI(String uid);

  //LOCATION APIS
  Future<Response> getSavedLocationAPI(String uid);
  Future<Response> postAddSavedLocationAPI({data});
  Future<Response> patchSavedLocationAPI({data});
  Future<Response> delSavedLocationAPI({data});

  //TRIP APIS
  Future<Response> postSearchTripAPI({data});
  Future<Response> postConfirmTripAPI({data});
  Future<Response> postCancelTripAPI({data});
  Future<Response> postRateTripAPI({data});
  Future<Response> postSendTripMessageAPI({data});


  //PAYMENT APIS
  Future<Response> getPaymentMethodsAPI(String uid);
  Future<Response> patchPaymentMethodsAPI({data});
  Future<Response> postAddPaymentMethodsAPI({data});
  Future<Response> postPayTripAPI({data});
  Future<Response> postSubmitOTPAPI({data});
  Future<Response> delPaymentMethodsAPI({data});

  //BUS
  Future<Response> getBusSchedulesAPI();
  Future<Response> postBookTicketAPI({data});
  Future<Response> postConfirmTicketAPI({data});
  Future<Response> getAllTicketsAPI(String uid);

}