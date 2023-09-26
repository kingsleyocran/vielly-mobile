

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../../presentation/widgets/setup_bottomsheet_ui.dart';
import '../../../../data/models/paymentmethods.dart';
import '../../../../enums/enums.dart';
import '../../view_model.dart';

class AddPaymentViewModel extends ViewModel {

  LoadingState _loadingState = LoadingState.loading;
  get loadingState => _loadingState;

  List<PaymentMethods> _paymentMethodList = [];
  get paymentMethodList => _paymentMethodList;

  String? _selectedProvider;
  get selectedProvider => _selectedProvider;

  String? _provider;
  get provider => _provider;

  bool _isEditing = false;
  get isEditing => _isEditing;

  String _isPhoneValid = 'null';
  get isPhoneValid => _isPhoneValid;

  List _providerList = [
    "MTN Mobile Money",
    "AirtelTigo Money",
    "Vodafone Cash",
  ];
  get providerList => _providerList;

  TextEditingController phoneController = TextEditingController();
  FocusNode myFocusNode = FocusNode();

  BuildContext appContext = Get.context!;


  Future initialized()async{

    controllerFocus();

  }

  void controllerFocus() {

    //nameController.text = '';
    phoneController.addListener(() {
      notifyListeners();// setState every time text changes
    });

  }

  Future openProviderBottomSheet() async{
    var confirmationResponse =
    await getBottomSheet.showCustomSheet(
      variant: BottomSheetType.busTime,
      title: '${AppLocalizations.of(appContext)!.selectProvider}',
      description: selectedProvider??'',
      data: providerList,
      isScrollControlled: true,
    );

    if(confirmationResponse!.data == null){return;}
    print( 'confirmationResponse confirmed: ${confirmationResponse.data}');

    _selectedProvider = confirmationResponse.data;
    notifyListeners();

    if(selectedProvider == "MTN Mobile Money"){
      _provider = 'mtn';
      notifyListeners();
    }else if(selectedProvider == "AirtelTigo Money"){
      _provider = 'airteltigo';
      notifyListeners();
    }else if(selectedProvider == "Vodafone Cash"){
      _provider = 'vodafone';
      notifyListeners();
    }

  }

  void setIsPhoneValid(bool value){

    if(value == true){
      _isPhoneValid = 'true';
      notifyListeners();
    }else{
      _isPhoneValid = 'false';
      notifyListeners();
    }

  }

  Future addNewPayment()async{

    print(phoneController.text);

    showLoadingDialog('${AppLocalizations.of(appContext)!.loading}', false);

    bool internet = await internetCheckWithLoading();

    if(!internet){
      return;
    }

    final Map<String, dynamic> data = Map<String, dynamic>();

    data['type'] = 'mobile_money';
    data['phone'] = phoneController.text;
    data['provider'] = provider;
    data['is_primary'] = true;

    final bool isSuccess = await getUserRepositoryImpl.postAddPaymentMethod(data);

    if(isSuccess){

      await fetchPaymentDetails(fromRemote: true);

      dismissLoadingDialog();

      getNavigator.back(result: true);

    }else{
      dismissLoadingDialog();

      showDialogFailed(
          title: '${AppLocalizations.of(appContext)!.addingPaymentFailed}',
          description: '${AppLocalizations.of(appContext)!.sorryWeCouldntAddPayment}',
          mainTitle: '${AppLocalizations.of(appContext)!.retry}',
          secondTitle: '${AppLocalizations.of(appContext)!.cancel}'
      ).then((value) {
        if(value){
          this.addNewPayment();
        }else if(!(value)){
          return;
        }
      });
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

    }else if(fromRemote == false){

      _paymentMethodList.clear();
      notifyListeners();

      _paymentMethodList = paymentData!.cast<PaymentMethods>();
      _loadingState = LoadingState.fetched;
      notifyListeners();

    }else{
      _loadingState = LoadingState.onFailed;
      notifyListeners();
    }
  }
}