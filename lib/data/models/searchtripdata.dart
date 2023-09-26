
class SearchTripDetails {
  double? pickupLatitude;
  double? pickupLongitude;
  String? pickupName;
  String? pickupLocation;
  double? dropoffLatitude;
  double? dropoffLongitude;
  String? dropoffName;
  String? dropoffLocation;
  dynamic charge;
  //double trip_distance;
  String? orderID;

  SearchTripDetails({
    this.pickupLatitude,
    this.pickupLongitude,
    this.pickupName,
    this.pickupLocation ,
    this.dropoffLatitude,
    this.dropoffLongitude,
    this.dropoffName,
    this.dropoffLocation,
    this.charge,
    //this.trip_distance,
    this.orderID
  });

  SearchTripDetails.fromJson(Map<String, dynamic> json){
    orderID = json['orderID'];
    pickupLatitude =  (json['pickupLatitude']);
    pickupLongitude =  (json['pickupLongitude']);
    pickupName = json['pickupName'];
    pickupLocation = json['pickupLocation'];
    dropoffLatitude =  (json['dropoffLatitude']);
    dropoffLongitude =  (json['dropoffLongitude']);
    dropoffName = json['dropoffNname'];
    dropoffLocation = json['dropoffLocation'];
    charge = (json['charge']);
}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =new Map<String, dynamic>();
    data['orderID'] = this.orderID;
    data['pickupLatitude'] = this.pickupLatitude;
    data['pickupLongitude'] = this.pickupLongitude;
    data['pickupName'] = this.pickupName;
    data['pickupLocation'] = this.pickupLocation;
    data['dropoffLatitude'] = this.dropoffLatitude;
    data['dropoffLongitude'] = this.dropoffLongitude;
    data['dropoffName'] = this.dropoffName;
    data['dropoffLocation'] = this.dropoffLocation;
    data['charge'] = this.charge;


    /*
    data['pickup'] =
    {
      "latitude": this.pickupLatitude,
      "longitude": this.pickupLongitude
    }
    ;
    data['dropoff'] =
    {
      "latitude": this.dropoffLatitude,
      "longitude": this.dropoffLongitude
    }
    ;

     */
    return data;
  }

}





class SearchTripBusDetails {
  double? pickupLatitude;
  double? pickupLongitude;
  String? pickupName;
  String? pickupID;
  String? pickupLocation;
  double? dropoffLatitude;
  double? dropoffLongitude;
  String? dropoffName;
  String? dropoffID;
  String? dropoffLocation;
  dynamic charge;
  //double trip_distance;
  String? orderID;

  SearchTripBusDetails({
    this.pickupLatitude,
    this.pickupLongitude,
    this.pickupName,
    this.pickupID,
    this.pickupLocation ,
    this.dropoffLatitude,
    this.dropoffLongitude,
    this.dropoffName,
    this.dropoffID,
    this.dropoffLocation,
    this.charge,
    //this.trip_distance,
    this.orderID
  });

  SearchTripBusDetails.fromJson(Map<String, dynamic> json){
    orderID = json['orderID'];
    pickupLatitude =  (json['pickupLatitude']);
    pickupLongitude =  (json['pickupLongitude']);
    pickupName = json['pickupName'];
    pickupID = json['pickupID'];
    pickupLocation = json['pickupLocation'];
    dropoffLatitude =  (json['dropoffLatitude']);
    dropoffLongitude =  (json['dropoffLongitude']);
    dropoffName = json['dropoffNname'];
    dropoffID = json['dropoffID'];
    dropoffLocation = json['dropoffLocation'];
    charge = (json['charge']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =new Map<String, dynamic>();
    data['orderID'] = this.orderID;
    data['pickupLatitude'] = this.pickupLatitude;
    data['pickupLongitude'] = this.pickupLongitude;
    data['pickupName'] = this.pickupName;
    data['pickupID'] = this.pickupID;
    data['pickupLocation'] = this.pickupLocation;
    data['dropoffLatitude'] = this.dropoffLatitude;
    data['dropoffLongitude'] = this.dropoffLongitude;
    data['dropoffName'] = this.dropoffName;
    data['dropoffID'] = this.dropoffID;
    data['dropoffLocation'] = this.dropoffLocation;
    data['charge'] = this.charge;


    /*
    data['pickup'] =
    {
      "latitude": this.pickupLatitude,
      "longitude": this.pickupLongitude
    }
    ;
    data['dropoff'] =
    {
      "latitude": this.dropoffLatitude,
      "longitude": this.dropoffLongitude
    }
    ;

     */
    return data;
  }

}