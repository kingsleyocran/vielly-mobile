import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import 'package:flutter/material.dart';
import 'package:curve/data/models/user.dart';
import 'package:curve/presentation/widgets/setup_bottomsheet_ui.dart';
import 'package:stacked_services/stacked_services.dart';


import '../../view_model.dart';


class EditProfileViewModel extends ViewModel {

  TextEditingController? _nameController;
  get nameController => _nameController;

  TextEditingController? _emailController;
  get emailController => _emailController;

  FocusNode nameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();

  String? email;

  String? name;

  String _isNameValid = 'null';
  get isNameValid => _isNameValid;

  String _isEmailValid = 'null';
  get isEmailValid => _isEmailValid;

  String? _userPhone;
  get userPhone => _userPhone;

  String? _userID;
  get userID => _userID;

  UserDetails _userProfile = UserDetails();
  get userProfile => _userProfile;

  bool _isUpdated = false;
  get isUpdated => _isUpdated;

  File? pickedFile;

  String _upLoadState = '';
  String get upLoadState => _upLoadState;

  String _profilePath = '';
   get profilePath => _profilePath;

  String? _firstName;
   get firstName => _firstName;

  String? _lastName;
   get lastName => _lastName;

  String? _eMail;
  get eMail => _eMail;


  BuildContext appContext = Get.context!;


  Future initialise() async{

    await getProfileDetail();

    await setTextFieldData();

    controllerFocus();

    notifyListeners();
  }

  setIsNameValid(bool value){

    if (value){
      _isNameValid = 'true';
    }else{
      _isNameValid = 'false';
    }

    notifyListeners();
  }

  setIsEmailValid(bool value){
    if (value){
      _isEmailValid = 'true';
    }else{
      _isEmailValid = 'false';
    }

    notifyListeners();
  }

  void controllerFocus() {

    //nameController.text = '';
    nameController.addListener(() {
      notifyListeners();// setState every time text changes
    });


    //emailController.text = '';
    emailController.addListener(() {
     notifyListeners(); // setState every time text changes
    });

  }

  Future getProfileDetail() async{
    _userID = await getSharedPrefManager.getPrefUserID();
    _userPhone = await getSharedPrefManager.getPrefUserPhone();
    _userProfile = (await getSharedPrefManager.getPrefUserProfile())!;

    notifyListeners();
  }

  Future setTextFieldData() async{

    _nameController = TextEditingController(
      text:
      (userProfile.name != null)
          ?
      userProfile.name
          :
      '${AppLocalizations.of(appContext)!.enterName}',
    );

    _emailController = TextEditingController(
      text:
      (userProfile.email != null)
          ?
      userProfile.email
          :
      '${AppLocalizations.of(appContext)!.enterEmail}',
    );



    notifyListeners();
  }



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

    print( 'confirmationResponse confirmed: ${confirmationResponse.data}');

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
      final bool result = await updateProfile();

      if(result){
        _upLoadState = 'Success';
        _isUpdated = true;
        notifyListeners();
      }
    }
    else{
      _upLoadState = 'Failed';

      _isUpdated = false;
      notifyListeners();
    }
  }

  Future updateProfile() async{

    final String? uid = await getSharedPrefManager.getPrefUserID();

    var response = await getMediaService.retrieveProfileImage('user_profiles/$uid.jpg');

    cacheManager.removeFile(userProfile.originalImage);

    _profilePath = response;
    notifyListeners();

    await getUserRepositoryImpl.getUserProfile(fromRemote: true);
    var userData = await getUserRepositoryImpl.getUserProfile(fromRemote: false);
    _userProfile = userData!;
    notifyListeners();

    return true;
  }



  //CREATE PROFILE
  Future editProfile() async{

    showLoadingDialog('${AppLocalizations.of(appContext)!.updating}', false);

    bool internet = await internetCheckWithLoading();

    if(!internet){
      return;
    }

    setBusy(true);

    final Map<String, dynamic> data = Map<String, dynamic>();

    data['name'] = nameController.text;
    data['email'] = emailController.text;
    data['is_driver'] = false;

    final bool isCreated = await getUserRepositoryImpl.patchUserProfile(data);

    if(isCreated){
      dismissLoadingDialog();

      initialise();

      _isUpdated = true;
      notifyListeners();



      showSnackBarGreenAlert('${AppLocalizations.of(appContext)!.profileUpdated}');


    }else{
      dismissLoadingDialog();

      showDialogFailed(
          title: '${AppLocalizations.of(appContext)!.editingProfileFailed}',
          description: '${AppLocalizations.of(appContext)!.sorryWeCouldntEditProfile}',
          mainTitle: '${AppLocalizations.of(appContext)!.retry}',
          secondTitle: '${AppLocalizations.of(appContext)!.cancel}'
      ).then((value) {
        if(value){
          this.editProfile();
        }else if(!(value)){
          return;
        }
      });
    }


  }

  Future navigateBackLogic() async{

    if(isUpdated){
      getNavigator.back(result: true);
    }else{
      getNavigator.back();
    }

  }

}