import 'package:firebase_auth/firebase_auth.dart';

enum LoginMode { SIGN_IN, CREATE_ACCOUNT }


class FirebaseAuthService {

  PhoneAuthCredential? _phoneAuthCredential;
  String _verificationId = '';
  int _resendToken = 0;
  String _phoneNumber = '';
  LoginMode _loginMode = LoginMode.SIGN_IN;

  get verificationId => _verificationId;
  get resendToken => _resendToken;
  get phoneAuthCredential => _phoneAuthCredential;
  get phoneNumber => _phoneNumber;
  get isLogin => _loginMode == LoginMode.SIGN_IN;

  void setLoginMode(LoginMode mode) => _loginMode = mode;

  void setCredential(PhoneAuthCredential credentials) {
    print('Setting creds >>> $credentials');
    print('verificationId >>> ${credentials.verificationId}');

    _phoneAuthCredential = credentials;
  }

  void setPhoneNumber(String _phone) {
    print('Setting phone >>> $_phone');
    _phoneNumber = _phone;
  }

  void setToken(String verificationId, int token) {
    _resendToken = token;
    _verificationId = verificationId;

    print('verificationId => $verificationId | resendToken => $resendToken');
  }

  Future<void> signInWithPhone({onComplete, onFailed, onCodeSent, timeout}) async {
    print('phoneNumber => $phoneNumber');

    return _verifyPhoneNumber(
        phoneNumber: phoneNumber,
        onComplete: onComplete,
        onFailed: onFailed,
        onCodeSent: onCodeSent,
        timeout:timeout
    );
  }

  Future<void> resendSms(onComplete, onFailed, onCodeSent) async {
    return _verifyPhoneNumber(
      resendToken: _resendToken,
      phoneNumber: phoneNumber,
      onComplete: onComplete,
      onFailed: onFailed,
      onCodeSent: onCodeSent,
    );
  }


  Future<void> _verifyPhoneNumber(
      {String? phoneNumber,
        int? resendToken,
        Function(PhoneAuthCredential)? onComplete,
        Function(FirebaseAuthException)? onFailed,
        Function(String, int)? onCodeSent,
        Function(String)? timeout}) {



    return FirebaseAuth.instance.verifyPhoneNumber(
      forceResendingToken: resendToken,
      phoneNumber: phoneNumber!,
      verificationCompleted: (PhoneAuthCredential credential) =>
          onComplete!(credential),
      verificationFailed: (FirebaseAuthException e) => onFailed!(e),
      codeSent: (String? verificationId, int? resendToken) =>
          onCodeSent!(verificationId!, resendToken!),
      codeAutoRetrievalTimeout: (String verificationId) {
        print('Code retrieval timeout');
        timeout!(verificationId);
      },
    );
  }

  Future<UserCredential> verifyCode(PhoneAuthCredential credential) async {
    return FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void>  processSignOut()async{
    FirebaseAuth.instance.signOut();
  }

}