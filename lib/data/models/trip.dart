
class TripDetails{
  String? rideID;
  String? orderID;
  bool? confirmed;
  bool? online;
  num? charge;
  String? status;
  double? tripDistance;
  int? waitTime;

  String? driverID;
  double? driverLatitude;
  double? driverLongitude;
  String? driverName;
  String? driverImageThumbnail;
  String? driverImageOriginal;
  String? carColor;
  String? carModel;
  String? vehicleNumber;
  String? phone;

  String? dropoffLocation;
  double? dropoffLatitude;
  double? dropoffLongitude;

  String? pickupLocation;
  double? pickupLatitude;
  double? pickupLongitude;

  TripDetails({
    this.rideID,
    this.orderID,
    this.confirmed,
    this.online,
    this.charge,
    this.status,
    this.waitTime,

    this.driverID,
    this.driverLatitude,
    this.driverLongitude,
    this.driverName,
    this.driverImageThumbnail,
    this.driverImageOriginal,
    this.carColor,
    this.carModel,
    this.vehicleNumber,

    this.dropoffLocation,
    this.dropoffLatitude,
    this.dropoffLongitude,
    this.pickupLocation,
    this.pickupLatitude,
    this.pickupLongitude,
  });


  TripDetails.fromJson(Map<String, dynamic> json){
    rideID = json['rideID'];
    orderID = json['orderID'];
    confirmed = json['confirmed'];
    online = json['online'];
    charge = json['charge'];
    status = json['status'];
    waitTime = json['waitTime'];

    driverID = json['driverID'];
    driverLatitude = json['driverLatitude'];
    driverLongitude = json['driverLongitude'];
    driverName = json['driverName'];
    driverImageThumbnail = json['driverID'];
    driverImageOriginal = json['driverImageOriginal'];
    carColor = json['carColor'];
    carModel = json['carModel'];
    vehicleNumber = json['vehicleNumber'];
    dropoffLocation = json['dropoffLocation'];
    dropoffLatitude = json['dropoffLatitude'];
    dropoffLongitude = json['dropoffLongitude'];
    pickupLocation = json['pickupLocation'];
    pickupLatitude = json['pickupLatitude'];
    pickupLongitude = json['pickupLongitude'];

  }




  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =new Map<String, dynamic>();
    data['rideID'] = this.rideID;
    data['orderID'] = this.orderID;
    data['confirmed'] = this.confirmed;
    data['online'] = this.online;
    data['charge'] = this.charge;
    data['status'] = this.status;
    data['waitTime'] = this.waitTime;

    data['driverID'] = this.driverID;
    data['driverLatitude'] = this.waitTime;
    data['driverLongitude'] = this.driverLongitude;
    data['driverName'] = this.driverName;
    data['driverImageThumbnail'] = this.driverImageThumbnail;
    data['driverImageOriginal'] = this.driverImageOriginal;
    data['carColor'] = this.carColor;
    data['carModel'] = this.carModel;
    data['vehicleNumber'] = this.vehicleNumber;

    data['dropoffLocation'] = this.dropoffLocation;
    data['dropoffLatitude'] = this.dropoffLatitude;
    data['dropoffLongitude'] = this.dropoffLongitude;
    data['pickupLocation'] = this.pickupLocation;
    data['pickupLatitude'] = this.pickupLatitude;
    data['pickupLongitude'] = this.pickupLongitude;


    return data;
  }


}