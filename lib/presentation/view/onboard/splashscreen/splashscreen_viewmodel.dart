import 'dart:async';
//import 'package:vielly/app/router.gr.dart';

import '../../../../presentation/view/view_model.dart';


class SplashScreenViewModel extends ViewModel {

  get isLoggedIn => getSharedPrefManager.hasLoggedIn;

  loginLogic(getUserRepositoryImpl);


  Future<void> startupLogic() async {

    //loginLogic(getUserRepositoryImpl);

      await Future.delayed(Duration(seconds: 0)).then((_) {
        loginLogic(getUserRepositoryImpl);
      });


  }








  /*

    void startupLogic (){

    Timer(Duration(seconds: 2),
            () => getNavigator.navigateTo('_getStartupScreen()')
    );
  }


    Future<void> navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 3)).then((_) {
      if (isLoggedIn) {
        checkLoginStatus(locator<UserRepositoryImpl>());
      } else
        navigator.clearStackAndShow(Routes.getStartedView);
    });
  }



   */


}