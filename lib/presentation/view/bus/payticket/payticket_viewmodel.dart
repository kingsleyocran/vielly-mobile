

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import 'package:curve/data/models/bookedbusdata.dart';
import 'package:curve/data/models/paymentmethods.dart';
import 'package:curve/app/app.router.dart';
import '../../view_model.dart';

class PayTicketViewModel extends ViewModel {

  BookedBusSchedule? _bookedBusData;
  get bookedBusData => _bookedBusData;

  PaymentMethods? _primaryPaymentMethod;
  get primaryPaymentMethod => _primaryPaymentMethod;

  TextEditingController otpController = TextEditingController();
  FocusNode otpFocusNode = FocusNode();

  Future initialized()async{

    controllerFocus();

    await getBookBusData();

    var isPayment = await getSharedPrefManager.getPrefIsPrimaryMethod();
    _primaryPaymentMethod = isPayment;
    notifyListeners();

  }

  void controllerFocus() {

    //nameController.text = '';
    otpController.addListener(() {
      notifyListeners();// setState every time text changes
    });

  }

  Future getBookBusData() async{
    _bookedBusData = await getSharedPrefManager.getBookTicketData();
    notifyListeners();
  }




  Future submitOTP(context)async{

    print(otpController.text);

    showLoadingDialog('${AppLocalizations.of(context)!.loading}', false);

    bool internet = await internetCheckWithLoading();

    if(!internet){
      return;
    }

    final Map<String, dynamic> data = Map<String, dynamic>();

    data['order_id'] = bookedBusData.orderID;
    data['otp'] = otpController.text;
    //data['ride_id'] = ride_id;


    final bool isSuccess = await getTripRepositoryImpl.postSubmitOTP(data);

    if(isSuccess){

      dismissLoadingDialog();

      getNavigator.navigateTo(Routes.ticketView);

    }else{
      dismissLoadingDialog();

      showDialogFailed(
          title: '${AppLocalizations.of(context)!.bookingBusTripFailed}',
          description: '${AppLocalizations.of(context)!.sorryWeCouldNotBusTrip}',
          mainTitle: '${AppLocalizations.of(context)!.retry}',
          secondTitle: '${AppLocalizations.of(context)!.cancel}'
      ).then((value) {
        if(value){
          this.submitOTP(context);
        }else if(!(value)){
          return;
        }
      });
    }


  }

  Future navigateToTicket() async{
    getNavigator.navigateTo(Routes.ticketView);
  }
}