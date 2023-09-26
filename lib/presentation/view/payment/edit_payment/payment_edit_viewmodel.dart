import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:stacked_services/stacked_services.dart';


import '../../../../presentation/widgets/setup_bottomsheet_ui.dart';
import '../../../../data/models/paymentmethods.dart';
import '../../../../enums/enums.dart';
import '../../view_model.dart';

class EditPaymentViewModel extends ViewModel {

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

  String _isPhoneValid = 'true';
  get isPhoneValid => _isPhoneValid;

  List _providerList = [
    "MTN Mobile Money",
    "AirtelTigo Money",
    "Vodafone Cash",
  ];
  get providerList => _providerList;

  TextEditingController phoneController = TextEditingController();
  FocusNode myFocusNode = FocusNode();

  PaymentMethods? _paymentMethods;
  get paymentMethods => _paymentMethods;

  BuildContext appContext = Get.context!;


  Future initialized(PaymentMethods value , context)async{
    print(value.provider);

    _isEditing = true;
    _paymentMethods = value;
    _provider = value.provider;
    phoneController.text = value.phone!;

    if(value.provider == "mtn"){
      _selectedProvider = 'MTN Mobile Money';
      notifyListeners();
    }else if(value.provider == "airteltigo"){
      _selectedProvider = 'AirtelTigo Money';
      notifyListeners();
    }else if(value.provider== "vodafone"){
      _selectedProvider = 'Vodafone Cash';
      notifyListeners();
    }

    print(selectedProvider);

    notifyListeners();

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

  Future editPayment()async{

    showLoadingDialog('${AppLocalizations.of(appContext)!.loading}', false);

    bool internet = await internetCheckWithLoading();

    if(!internet){
      return;
    }

    final Map<String, dynamic> data = Map<String, dynamic>();

    data['payment_method_id'] = paymentMethods.paymentID;
    data['type'] = 'mobile_money';
    data['phone'] = phoneController.text;
    data['provider'] = provider;
    data['is_primary'] = false;

    final bool isSuccess = await getUserRepositoryImpl.patchPaymentMethod(data);

    if(isSuccess){

      await fetchPaymentDetails(fromRemote: true);

      dismissLoadingDialog();

      getNavigator.back(result: true);

    }else{
      dismissLoadingDialog();

      showDialogFailed(
          title: '${AppLocalizations.of(appContext)!.updatingPaymentFailed}',
          description: '${AppLocalizations.of(appContext)!.sorryWeCouldntUpdatePayment}',
          mainTitle: '${AppLocalizations.of(appContext)!.retry}',
          secondTitle: '${AppLocalizations.of(appContext)!.cancel}'
      ).then((value) {
        if(value){
          this.editPayment();
        }else if(!(value)){
          return;
        }
      });

    }
  }

  Future deleteConfirmation()async{

    await showDialogConfirmRed(
        title: '${AppLocalizations.of(appContext)!.deletePayment}',
        description: '${AppLocalizations.of(appContext)!.ifYouChooseDeletePayment}',
        mainTitle: '${AppLocalizations.of(appContext)!.delete}',
        secondTitle: '${AppLocalizations.of(appContext)!.cancel}'
    ).then((value) async{
      if((value)){
        print('true');
        await deletePayment();
        return;
      } else if(!(value)){
        print('false');
        return;
      }
    });
  }

  Future deletePayment()async{

    showLoadingDialog('${AppLocalizations.of(appContext)!.loading}', false);

    bool internet = await internetCheckWithLoading();

    if(!internet){
      return;
    }

    final Map<String, dynamic> data = Map<String, dynamic>();

    print(paymentMethods.paymentID);
    data['payment_method_id'] = paymentMethods.paymentID;

    final bool isSuccess = await getUserRepositoryImpl.delPaymentMethod(data);

    if(isSuccess){

      await fetchPaymentDetails(fromRemote: true);

      dismissLoadingDialog();

      getNavigator.back(result: true);

    }else{
      dismissLoadingDialog();

      showDialogFailed(
          title: '${AppLocalizations.of(appContext)!.deletingPaymentFailed}',
          description: '${AppLocalizations.of(appContext)!.sorryWeCouldntDeletePayment}',
          mainTitle: '${AppLocalizations.of(appContext)!.retry}',
          secondTitle: '${AppLocalizations.of(appContext)!.cancel}'
      ).then((value) {
        if(value){
          this.deletePayment();
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