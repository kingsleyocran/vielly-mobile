import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import 'package:curve/app/app.router.dart';
import 'package:curve/data/models/paymentmethods.dart';
import '../../../widgets/setup_bottomsheet_ui.dart';
import '../../view_model.dart';

class CreateProfileViewModel extends ViewModel {
  File? pickedFile;

  String _upLoadState = '';
  String get upLoadState => _upLoadState;

  String _profilePath = '';
  String get profilePath => _profilePath;

  String? _firstName;
   get firstName => _firstName;

  String? _lastName;
   get lastName => _lastName;

  String? _eMail;
   get eMail => _eMail;

  bool _paymentDone = false;
  bool get paymentDone => _paymentDone;

  void getProfileDetails(String fname, String lname, String email){
    _firstName = fname;
    _lastName = lname;
    _eMail = email;

    notifyListeners();
  }

  Future showProfilePictureBottomSheet (context) async{
    var confirmationResponse =
    await getBottomSheet.showCustomSheet(
      variant: BottomSheetType.profilePic,
    );

    if(confirmationResponse!.data == null){return;}

    print( 'confirmationResponse confirmed: ${confirmationResponse.responseData}');

    if(confirmationResponse.data == 'Gallery'){
      pickedFile = await getMediaService.getImage(fromGallery: true,context: context);
    }

    if(confirmationResponse.data == 'Camera'){
      pickedFile = await getMediaService.getImage(fromGallery: false,context: context);
    }

    final String? uid = await getSharedPrefManager.getPrefUserID();

    if(pickedFile != null){
      _upLoadState = 'Uploading';

      notifyListeners();
    }

    bool isSuccess = await getMediaService.uploadFile(pickedFile!, 'user_profiles/$uid.jpg');

    if(isSuccess){

      //UPDATE PROFILE HERE
      final bool pathUrl = await updateProfile();

      if(pathUrl){
        _upLoadState = 'Success';

        notifyListeners();
      }
    }
    else{
      _upLoadState = 'Failed';

      notifyListeners();
    }
  }

  Future updateProfile() async{
    final String? uid = await getSharedPrefManager.getPrefUserID();

    var response = await getMediaService.retrieveProfileImage('user_profiles/$uid.jpg');

    _profilePath = response;
    notifyListeners();

    return true;
  }



  //CREATE PROFILE
  Future createProfile(String fName, String lName, String email, context) async{

    showLoadingDialog(AppLocalizations.of(context)!.loading, false);

    bool internet = await internetCheckWithLoading();
    if(!internet){
      return;
    }

    setBusy(true);

    if(paymentDone == false){
      final bool isPaymentSuccess = await createCashPayment();

      final bool isReferralSuccess = await createReferralCode();

      if(!isPaymentSuccess && !isReferralSuccess) {
        dismissLoadingDialog();

        showDialogFailed(
            title: AppLocalizations.of(context)!.profileCreationFailed,
            description: AppLocalizations.of(context)!.weCouldNotCreateProfile,
            mainTitle: AppLocalizations.of(context)!.retry,
            secondTitle: AppLocalizations.of(context)!.cancel
        ).then((value) {
          if(value){
            this.createProfile(firstName, lastName, eMail, context);
          }else if(!(value)){
            dismissLoadingDialog();
            return;
          }
        });
      }else{
        _paymentDone = true;
        notifyListeners();

      }
    }

    final Map<String, dynamic> data = Map<String, dynamic>();

    data['name'] = fName + ' ' + lName;
    data['email'] = email;
    data['is_driver'] = false;

    final bool isCreated = await getUserRepositoryImpl.patchUserProfile(data);

    if(isCreated){

      showHome();
    }else{
      dismissLoadingDialog();

      showDialogFailed(
          title: AppLocalizations.of(context)!.profileCreationFailed,
          description: AppLocalizations.of(context)!.weCouldNotCreateProfile,
          mainTitle: AppLocalizations.of(context)!.retry,
          secondTitle: AppLocalizations.of(context)!.cancel
      ).then((value) {
        if(value){
          this.createProfile(firstName, lastName, eMail, context);
        }
      });
    }
  }

  Future<bool> createCashPayment() async{

    final Map<String, dynamic> payloadData = Map<String, dynamic>();

    String? phoneNumber = await getSharedPrefManager.getPrefUserPhone();
    payloadData['type'] = 'cash';
    payloadData['phone'] = phoneNumber;
    payloadData['provider'] = 'cash';

    final bool isPaymentSuccess = await getUserRepositoryImpl.postAddPaymentMethod(payloadData);

    if(!isPaymentSuccess){

      return false;
    }else{

      PaymentMethods paymentMethods = PaymentMethods();

      paymentMethods.phone = phoneNumber;
      paymentMethods.type = 'cash';
      paymentMethods.provider = 'cash';
      paymentMethods.isPrimary = true;

      getSharedPrefManager.setPrefIsPrimaryMethod(paymentMethods);

      return true;
    }
  }

  Future<bool> createReferralCode() async{

    final bool isSuccess = await getUserRepositoryImpl.postReferralCode();

    return isSuccess;
  }


  void showHome() async{

    getSharedPrefManager.hasLoggedIn = true;

    getAllUserData();

    setBusy(false);
    dismissLoadingDialog();
    await navigateToHome();

  }

  Future navigateToHome() async {
    await getNavigator.clearStackAndShow(Routes.busHomeView);
    print('Navigate to Home');
  }

  Future navigateBackToLogin() async {
    await getNavigator.clearStackAndShow(Routes.loginView);
    print('Navigate to Login');
  }

}