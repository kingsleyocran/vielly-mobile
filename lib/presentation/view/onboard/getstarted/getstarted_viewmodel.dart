import '../../../../app/app.router.dart';
import '../../../../presentation/view/view_model.dart';

class GetStartedViewModel extends ViewModel {


  Future navigateToLogin() async {
    await getNavigator.navigateTo(Routes.loginView);

    print('Navigate to Login Screen');
  }

}