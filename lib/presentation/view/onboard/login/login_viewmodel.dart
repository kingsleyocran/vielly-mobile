import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import 'package:curve/presentation/widgets/setup_dialog_ui.dart';
import 'package:curve/app/app.router.dart';
import 'package:curve/presentation/view/view_model.dart';
import 'package:curve/enums/enums.dart';
import 'package:curve/services/third_party_services/firebaseauth_service.dart';
import 'package:stacked_services/stacked_services.dart';


class LoginViewModel extends ViewModel {

  PhoneVerification _verificationState = PhoneVerification.none;
  bool _allowSend = false;

  get verificationState => _verificationState;
  get smsCode => getFirebaseAuthService.phoneAuthCredential?.smsCode ?? '';

  get errorMessage => error;

  get allowSendNew => _allowSend;

  String _phoneNumber = '';
  String get phoneNumber => _phoneNumber;

  BuildContext appContext = Get.context!;

//#######################################################################//

  Future navigateToOTP() async {
    await getNavigator.navigateTo(
        Routes.oTPScreenView,
        arguments: OTPScreenViewArguments(
        mobileNumber: phoneNumber
    ));


    print('Navigate to Login Screen');
  }

  Future navigateToCreateProfile() async {
    await getNavigator.clearStackAndShow(Routes.createProfileView);
    print('Navigate to Sign Up View');
  }

  Future navigateToHome() async {
    await getNavigator.clearStackAndShow(Routes.busHomeView);
    print('Navigate to Home');
  }

  set allowSend(bool allow) {
    _allowSend = allow;
    print("allow send");
    notifyListeners();
  }

  void setTimer() {
    if (!allowSendNew)
      Future.delayed(Duration(
        seconds: 10,
      )).then((value) => allowSend = true);

    notifyListeners();
  }

  void setPhoneNumber(String phone){
    getFirebaseAuthService.setPhoneNumber(phone);

    _phoneNumber = phone;
    notifyListeners();
  }

  Future<void> signInWithPhone(BuildContext context, {LoginMode? loginMode}) async {

    print(payloadData);

    print("Login mode => ${loginMode.toString()}");
    //skip verification if user is already verified.
    setBusy(true);


    if (loginMode != null) {
      getFirebaseAuthService.setLoginMode(loginMode);
    }

    if (getSharedPrefManager.hasLoggedIn) {
      checkLoginStatus(getUserRepositoryImpl);
      return;
    }

    return await getFirebaseAuthService.signInWithPhone(

      //HANDLE WHEN PHONE NUMBER CONFIRMED FOR AUTH
        onComplete:(PhoneAuthCredential credential) {
          getFirebaseAuthService.setCredential(credential);

          _verificationState = PhoneVerification.verified;


          checkLoginStatus(getUserRepositoryImpl);

          _showOTPScreen();

        },

        //HANDLE WHEN PHONE NUMBER CONFIRMATION FAILED
        onFailed: (FirebaseAuthException e) {
          print("Exception $e");
          _verificationState = PhoneVerification.error;
          setError(e.message);

          dismissLoadingDialog();
          getDialogService.showCustomDialog(
            variant: DialogType.onFailed,
            title: AppLocalizations.of(context)!.signInFailed,
            description: AppLocalizations.of(context)!.weCouldNotConfirm,
            mainButtonTitle: AppLocalizations.of(context)!.retry,
            secondaryButtonTitle: AppLocalizations.of(context)!.cancel,
            barrierDismissible: false,
          ).then((value) {
            if (value!.confirmed) this.signInWithPhone(context);
          });
          print(errorMessage);
        },

        //HANDLE WHEN VERIFICATION CODE SENT
        onCodeSent: (String verificationId, int resendToken) {
          getFirebaseAuthService.setToken(verificationId, resendToken);
          _verificationState = PhoneVerification.pending;

          _showOTPScreen();
        },

        //HANDLE TIMED OUT
        timeout: (String verificationId) {

            //ADD DIALOG FOR TIMED OUT

            if (verificationId == null)
              showSnackBarRedAlert(AppLocalizations.of(context)!.weCouldNotConfirmInternet);
              });
  }

  void verifyCode(BuildContext context, String smsCode) async {

    showLoadingDialog(AppLocalizations.of(context)!.verifying, false);

    bool internet = await internetCheckWithLoading();
    if(internet == false){
      return;
    }

    setBusy(true);

    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: getFirebaseAuthService.verificationId, smsCode: smsCode);
    try {
      final auth = await getFirebaseAuthService.verifyCode(phoneAuthCredential);

      if (auth.user != null) {
        //todo sign in okay, save user uid and loginState


        getSharedPrefManager.setPrefUserID(auth.user!.uid);


        if (getFirebaseAuthService.isLogin) {
          getSharedPrefManager.setPrefUserPhone(getFirebaseAuthService.phoneNumber);

          //todo check user data if data is null, go to profile setup.
          //else user was signing up, go to vehicle info screen

          checkLoginStatus(getUserRepositoryImpl);

        } else {
          dismissLoadingDialog();
          //Check if user was creating an account, we should already have the user data, send to server.
          print("Send profile data!");
          navigateToCreateProfile();
        }

      } else {
        setError("User is not authenticated.");
        _onVerificationFailed(context);
      }
    } catch (e) {
      setError(e.toString());
      _onVerificationFailed(context);
    }
  }

  _onVerificationFailed(BuildContext context) {
    dismissLoadingDialog().then((_) {
      getDialogService.showCustomDialog(
        variant: DialogType.onFailed,
        title: AppLocalizations.of(context)!.verificationFailed,
        description: AppLocalizations.of(context)!.weCouldNotConfirmVerify,
        mainButtonTitle: AppLocalizations.of(context)!.retry,
        secondaryButtonTitle: AppLocalizations.of(context)!.cancel,
        barrierDismissible: false,
      ).then((value) {
        dismissLoadingDialog();
        if (value!.confirmed) {
          verifyCode(context, smsCode);
        }else{

        }
      });
    });
  }

  void resendCode(BuildContext context) async {
    setBusy(true);
    showLoadingDialog(AppLocalizations.of(context)!.resending, true);

    return await getFirebaseAuthService.resendSms(
          (PhoneAuthCredential credential) async {
            getFirebaseAuthService.setCredential(credential);
        _verificationState = PhoneVerification.verified;
        dismissLoadingDialog();
      },
          (FirebaseAuthException e) {
        _verificationState = PhoneVerification.error;
        setError(e.message);

        getDialogService.showCustomDialog(
        variant: DialogType.onFailed,
            title: AppLocalizations.of(context)!.resendingCodeFailed,
            description: AppLocalizations.of(context)!.weCouldNotResend,
            mainButtonTitle: AppLocalizations.of(context)!.resendCode,
            secondaryButtonTitle:AppLocalizations.of(context)!.cancel,
            barrierDismissible: false,
            ).then((value) {
          if (value!.confirmed) this.resendCode(context);
        });

        print(errorMessage);
      },
          (String verificationId, int resendToken) {
        dismissLoadingDialog();
        getFirebaseAuthService.setToken(verificationId, resendToken);
        _verificationState = PhoneVerification.pending;
        showSnackBarGreenAlert(AppLocalizations.of(context)!.verificationCodeSent);
      },
    );
  }

  void _showOTPScreen() {
    setBusy(false);
    dismissLoadingDialog();

    navigateToOTP();
  }

  void showVerifyScreen() {
    setBusy(false);
    dismissLoadingDialog();
    navigateToOTP();
  }

}