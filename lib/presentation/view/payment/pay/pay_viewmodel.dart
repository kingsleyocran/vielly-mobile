

import 'package:flutter/material.dart';
import '../../../../app/app.router.dart';
import '../../../../data/models/paymentmethods.dart';
import '../../../../data/models/trip.dart';

import '../../view_model.dart';

class PayViewModel extends ViewModel {


  PaymentMethods? _primaryPaymentMethod;
  get primaryPaymentMethod => _primaryPaymentMethod;

  TextEditingController otpController = TextEditingController();
  FocusNode otpFocusNode = FocusNode();

  TripDetails? _tripDetails;
  get tripDetails => _tripDetails;

  Future initialized()async{

    controllerFocus();

    await getTripData();

    var isPayment = await getSharedPrefManager.getPrefIsPrimaryMethod();
    _primaryPaymentMethod = isPayment;
    notifyListeners();

  }

  Future getTripData() async{
    var data = await getSharedPrefManager.getPrefTrip();
    _tripDetails = data;
    notifyListeners();
  }

  void controllerFocus() {

    //nameController.text = '';
    otpController.addListener(() {
      notifyListeners();// setState every time text changes
    });

  }



  Future submitOTP()async{

    print(otpController.text);

    final Map<String, dynamic> data = Map<String, dynamic>();

    data['order_id'] = tripDetails.orderID;
    data['ride_id'] = tripDetails.rideID;
    data['otp'] = otpController.text;
    //data['ride_id'] = ride_id;

    final bool isSuccess = await getTripRepositoryImpl.postSubmitOTP(data);

    if(isSuccess){

      return true;
    }else{
      return false;
    }
  }

  Future payForTrip()async{
    if(primaryPaymentMethod.provider == 'vodafone'){
      if(otpController.text.isEmpty){
        showSnackBarRedAlert('Make sure your Vodaphone payment voucher code is entered');
      }
    }

    showLoadingDialog('Loading', false);

    bool internet = await internetCheckWithLoading();

    if(!internet){
      return;
    }

    if(primaryPaymentMethod.provider == 'vodafone'){
      if(otpController.text.isEmpty){
        dismissLoadingDialog();
        showSnackBarRedAlert('Make sure your Vodaphone payment voucher code is entered');
      }else{
        bool result = await submitOTP();
        if(!result){
          dismissLoadingDialog();

          await showDialogFailed(
              title: 'Processing your payment failed',
              description: 'We could not pay your trip. Please try again or pay the driver with cash.',
              mainTitle: 'RETRY',
              secondTitle: 'CANCEL'
          ).then((value) {
            if(value){
              this.payForTrip();
            }else if(!(value)){
              return;
            }
          });
        }
      }
    }

    setBusy(true);

    _tripDetails = await getSharedPrefManager.getPrefTrip();
    notifyListeners();

    final Map<String, dynamic> data = Map<String, dynamic>();
    data['order_id'] = tripDetails.orderID;
    data['ride_id'] = tripDetails.rideID;

    final bool isSuccess = await getTripRepositoryImpl.postPayTrip(data);

    if(isSuccess){
      dismissLoadingDialog();

      getNavigator.navigateTo(Routes.rateView);

    }else{
      dismissLoadingDialog();

      await showDialogFailed(
          title: 'Paying for trip failed',
          description: 'We could not pay your trip. Please try again or pay the driver with cash.',
          mainTitle: 'RETRY',
          secondTitle: 'CANCEL'
      ).then((value) {
        if(value){
          this.payForTrip();
        }else if(!(value)){

          return;
        }
      });
    }

  }
}