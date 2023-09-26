
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:stacked_services/stacked_services.dart';


import '../../../app/app.router.dart';
import '../../../data/models/paymentmethods.dart';
import '../view_model.dart';
import '../../../enums/enums.dart';

class PaymentOptionViewModel extends ViewModel {


  LoadingState _loadingState = LoadingState.loading;
  get loadingState => _loadingState;

  List<PaymentMethods> _paymentMethodList = [];
  get paymentMethodList => _paymentMethodList;


  BuildContext appContext = Get.context!;


  Future initialized()async{


    await fetchPaymentDetails(fromRemote: false);

  }

  Future setIsPrimary(PaymentMethods value)async{

    showLoadingDialog('${AppLocalizations.of(appContext)!.loading}', false);

    bool internet = await internetCheckWithLoading();

    if(!internet){
      return;
    }

    final Map<String, dynamic> data = Map<String, dynamic>();

    data['payment_method_id'] = value.paymentID;
    data['type'] = value.type;
    data['phone'] = value.phone;
    data['provider'] = value.provider;
    data['is_primary'] = true;

    final bool isSuccess = await getUserRepositoryImpl.patchPaymentMethod(data);

    if(isSuccess){

      await fetchPaymentDetails(fromRemote: true);

      dismissLoadingDialog();
      showSnackBarGreenAlert('${AppLocalizations.of(appContext)!.paymentUpdated}');

    }else{
      dismissLoadingDialog();

      /*
      showDialogFailed(
          title: 'Booking bus trip failed',
          description: 'Sorry we could not book your bus trip. Please try again.',
          mainTitle: 'RETRY',
          secondTitle: 'CANCEL'
      ).then((value) {
        if(value.confirmed){
          this.bookBusTrip();
        }else if(!(value.confirmed)){
          return;
        }
      });

       */
    }
  }

  Future navigateAddPayment() async{

    print('Navigate to Add Payment');

    bool result = await getNavigator.navigateTo(Routes.addPaymentView);
    if(result == null){
      await fetchPaymentDetails(fromRemote: false);
      print('WORKS########################SSSSSSSSS');

      //showSnackBarGreenAlert('Payment method created successfully');
      notifyListeners();
    }else if(result){
      await fetchPaymentDetails(fromRemote: false);
      print('WORKS########################SSSSSSSSS');

      showSnackBarGreenAlert('${AppLocalizations.of(appContext)!.paymentCreated}');
      notifyListeners();

    }

    /*
        .then((value){
      if(value){
        fetchPaymentDetails(fromRemote: false);
        showSnackBarGreenAlert('New payment added successfully');
        notifyListeners();
      }
    });

     */



  }

  Future navigateEditPayment(PaymentMethods value)async{

    bool result = await getNavigator.navigateTo(Routes.editPaymentView,
    arguments: EditPaymentViewArguments(
      paymentMethods: value,
    ));
    if(result == null){
      await fetchPaymentDetails(fromRemote: false);
      print('WORKS########################SSSSSSSSS');

      notifyListeners();
    }else if(result){
      await fetchPaymentDetails(fromRemote: false);
      print('WORKS########################SSSSSSSSS');

      showSnackBarGreenAlert('${AppLocalizations.of(appContext)!.paymentUpdated}');
      notifyListeners();
    }


  }

  Future fetchPaymentDetails({bool? fromRemote})async{
    _loadingState = LoadingState.loading;
    notifyListeners();

    if(fromRemote == true){
      await getUserRepositoryImpl.getPaymentMethods(fromRemote: fromRemote);
    }

    var paymentData = await getSharedPrefManager.getPrefPaymentMethods();

    if(paymentData != null && fromRemote == true){
      List<PaymentMethods> paymentMethodsList = [];
      paymentMethodsList = paymentData.cast<PaymentMethods>();

      int indexPick = paymentMethodsList.indexWhere((e) => e.isPrimary == true);
      var isPrimaryPayment = paymentMethodsList[indexPick];

      getSharedPrefManager.setPrefIsPrimaryMethod(isPrimaryPayment);

      _paymentMethodList.clear();
      notifyListeners();

      _paymentMethodList = paymentData.cast<PaymentMethods>();
      _loadingState = LoadingState.fetched;
      notifyListeners();

    }
    else if(paymentData != null && fromRemote == false){

      _paymentMethodList.clear();
      notifyListeners();

      _paymentMethodList = paymentData.cast<PaymentMethods>();
      _loadingState = LoadingState.fetched;
      notifyListeners();

    }else{
      _loadingState = LoadingState.onFailed;
      notifyListeners();
    }
  }

}