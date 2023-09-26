

import '../../../app/app.router.dart';
import '../../../data/models/user.dart';

import '../../../presentation/view/view_model.dart';

class SettingsViewModel extends ViewModel {

  UserDetails? _userProfile;
  get userProfile => _userProfile;

  Future initializer()async{
    var userdata = await getSharedPrefManager.getPrefUserProfile();
    _userProfile = userdata;
    notifyListeners();

  }


  Future logout()async{

    showLoadingDialog('Signing Out', false);

    await getFirebaseAuthService.processSignOut();

    await getSharedPrefManager.prefLogout();

    await cacheManager.removeFile(userProfile.originalImage);

    await cacheManager.emptyCache();

    getNavigator.clearStackAndShow(Routes.getStartedView);
  }

  Future logoutConfirmation()async{

    await showDialogConfirm(
        title: 'Do you really want to logout?',
        description: 'Choosing logout will sign you out of this account',
        mainTitle: 'LOGOUT',
        secondTitle: 'CANCEL'
    ).then((value) async{
      if((value)){
        print('true');
        await logout();
        return;
      } else if(!(value)){
        print('false');
        return;
      }
    });
  }
}