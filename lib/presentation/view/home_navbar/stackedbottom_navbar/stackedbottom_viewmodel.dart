import 'package:stacked/stacked.dart';


class StackedBottomNavViewModel extends IndexTrackingViewModel {

  @override
  void setIndex(int value) {
    // TODO: implement setIndex

    _payloadData = value;
    super.setIndex(value);

    notifyListeners();
  }


  int _payloadData = 1;

  @override
  int get currentIndex => _payloadData;

}