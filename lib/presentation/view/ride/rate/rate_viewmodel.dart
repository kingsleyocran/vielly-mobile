import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../data/models/trip.dart';
import '../../view_model.dart';


class RateViewModel extends ViewModel {

  TextEditingController feedbackController = TextEditingController();
  FocusNode myFocusNode = FocusNode();


  String? _feedback;
  get feedback => _feedback;

  int? _rate;
  get rate => _rate;

  bool _isRated = false;
  get isRated => _isRated;


  TripDetails? _tripDetails;
  get tripDetails => _tripDetails;


  initialise() async{

    controllerFocus();
  }

  void controllerFocus() {

    //nameController.text = '';
    feedbackController.addListener(() {
      notifyListeners();// setState every time text changes
    });

  }

  void getFeedbackText(value){
    _feedback = value;
    notifyListeners();
  }

  //CREATE PROFILE
  Future rateTrip() async{

    showLoadingDialog('Loading', false);

    bool internet = await internetCheckWithLoading();

    if(!internet){
      return;
    }

    setBusy(true);

    _tripDetails = await getSharedPrefManager.getPrefTrip();
    notifyListeners();

    final Map<String, dynamic> data = Map<String, dynamic>();

    data['ride_id'] = tripDetails.rideID;
    data['rate'] = rate;
    data['feedback'] = feedback ?? '';

    final bool isSuccess = await getTripRepositoryImpl.postRateTrip(data);

    if(isSuccess){
      dismissLoadingDialog();


      _isRated = true;
      notifyListeners();

      navigateBackLogic();
      //showSnackBarGreenAlert('Profile updated');

    }else{
      dismissLoadingDialog();

      await showDialogFailed(
          title: 'Rating your trip experience failed',
          description: 'We could not rate your experience. Please try again.',
          mainTitle: 'RETRY',
          secondTitle: 'CANCEL'
      ).then((value) {
        if(value){
          this.rateTrip();
        }else if(!(value)){
          return;
        }
      });
    }


  }

  Future navigateBackLogic() async{

    if(isRated){
      //getNavigator.back(result: 'value');
      getNavigator.popRepeated(2);
    }
  }








  String? value;

  List<String> unselectedOption = [
    'assets/icons/Rate 1 - 1.svg',
    'assets/icons/Rate 2 - 1.svg',
    'assets/icons/Rate 3 - 1.svg',
    'assets/icons/Rate 4 - 1.svg',
    'assets/icons/Rate 5 - 1.svg'
  ];

  List<String> selectedOption = [
    'assets/icons/Rate 1 - 2.svg',
    'assets/icons/Rate 2 - 2.svg',
    'assets/icons/Rate 3 - 2.svg',
    'assets/icons/Rate 4 - 2.svg',
    'assets/icons/Rate 5 - 2.svg'
  ];

  List<String> labelOption = [
    'Of course',
    'Yeah',
    'Maybe',
    'Not sure',
    'No'
  ];

  Widget _buildRateChips(context) {
    List<Widget> chips = [];

    for (int i = 0; i < unselectedOption.length; i++) {
      GestureDetector choiceChip = GestureDetector(
        onTap: (){
          if(i == 1){
            print (i);
          } else if(i == 2){
            print (i);
          } else if(i == 3){
            print (i);
          }else if(i == 4){
            print (i);
          }else if(i == 5){
            print (i);
          }

            value = unselectedOption[i];

            _rate = i + 1;
            notifyListeners();

            print('RATING INDEX   ' + rate.toString());

        },
        child:
        Column(
          children: [
            value == unselectedOption[i]
                ?
            SvgPicture.asset(
                unselectedOption[i], color: Theme.of(context).colorScheme.onSurface,
            )
              ://Emoji
            SvgPicture.asset(
                selectedOption[i],
            ),
            SizedBox(height: 5,),
            Text(labelOption[i],
                style: Theme.of(context).textTheme.subtitle2!.apply(color: Theme.of(context).colorScheme.onBackground)),//Label
          ],
        ),

      );

      chips.add(
          choiceChip
      );
    }

    return Row(
      // This next line does the trick.
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: chips,
    );
  }

  get buildRateChips => _buildRateChips;




}