import 'dart:convert';

import 'package:curve/app/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../presentation/widgets/setup_snackbar_ui.dart';
import '../data_sources/local/sharedpreference.dart';
import '../../domain/api/api.dart';
//import '../../utilities/internet_util.dart';
import '../data_sources/remote/api_impl.dart';

mixin BaseRepositoryImpl {
  final Api _apiService = locator<ApiImpl>();
  final SharedPrefManager _prefService = locator<SharedPrefManager>();
  final SnackbarService _snackbarService = locator<SnackbarService>();


  Api get apiService => _apiService;
  SharedPrefManager get prefService => _prefService;
  SnackbarService get getSnackBar => _snackbarService;


  Future<Map<String, dynamic>> processRequest(Function request) async {
    //if (await InternetUtil.isConnected()) {
    if (true) {
        var response = await request();
        log((response).body);
        final data = jsonDecode((response).body);
        log(data);

        if (isSuccess(data))
          return data;
        else {
          print(data['msg']);
          //_toastService.showToast(data['msg']);

          return data;
        }
      }
      //else
        //showSnackBarRedAlert("Looks like you're offline. Make sure you're connected to the internet to proceed");
        //return null;
    //}
  }

  log(data) {
    print(data);
  }

  isSuccess(data) => data['success'] ?? data['status'] ?? false;

  Future showSnackBarRedAlert( String message) async{
    getSnackBar.showCustomSnackBar(
      variant: SnackbarType.redAlert,
      duration: Duration(seconds: 3),
      message: message,
    );
  }
}
