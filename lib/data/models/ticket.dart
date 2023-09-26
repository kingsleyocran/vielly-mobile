

class TicketDetails {
  String? ticketNumber;
  String? dateOfOrder;
  num? passengerCount;
  String? qrCode;
  String? charge;

  String? pickupTerminalName;
  String? pickupTerminalID;
  String? pickupTerminalLocation;
  String? pickupTerminalSource;
  double? pickupTerminalLatitude;
  double? pickupTerminalLongitude;

  String? dropOffTerminalName;
  String? dropOffTerminalID;
  String? dropOffTerminalLocation;
  String? dropOffTerminalSource;
  double? dropOffTerminalLatitude;
  double? dropOffTerminalLongitude;

  String? laneName;
  String? bookingTime;

  String? busDriverId;
  String? busNumber;
  String? busID;
  String? busDriverName;
  String? busColor;
  String? busModel;
  String? busVehicleNumber;
  String? busDriverProfile;
  String? busDriverProfileThumb;



  TicketDetails({
    this.ticketNumber,

    this.dateOfOrder,
    this.passengerCount,
    this.qrCode,
    this.charge,
    this.bookingTime,

    this.pickupTerminalName,
    this.pickupTerminalID,
    this.pickupTerminalLocation,
    this.pickupTerminalSource,
    this.pickupTerminalLatitude,
    this.pickupTerminalLongitude,

    this.dropOffTerminalName,
    this.dropOffTerminalID,
    this.dropOffTerminalLatitude,
    this.dropOffTerminalLongitude,
    this.laneName,


    this.busDriverId,
    this.busNumber,
    //this.busID,
    this.busDriverName,
    this.busColor,
    this.busModel,
    this.busVehicleNumber,
    this.busDriverProfile,
    this.busDriverProfileThumb,
  });

  TicketDetails.fromJson(Map<String, dynamic> json){

    ticketNumber = json['ticket_number'];
    dateOfOrder = json['order_at'];
    passengerCount = json['passenger_count'];
    qrCode = json['qr_code'];
    charge = (json['charge']).toString();
    bookingTime = json['booking_time'];

    laneName = json['lane']['name'];

    pickupTerminalName = json['pickup']['name'];
    pickupTerminalID = (json['pickup']['id']).toString();
    pickupTerminalLatitude = json['pickup']['latitude'];
    pickupTerminalLongitude = json['pickup']['longitude'];

    dropOffTerminalName = json['dropoff']['name'];
    dropOffTerminalID = (json['dropoff']['id']).toString();
    dropOffTerminalLatitude = json['dropoff']['latitude'];
    dropOffTerminalLongitude = json['dropoff']['longitude'];

    busDriverId = json['bus']['driver'];
    busNumber = json['bus']['bus_number'];
    //busID = json['dropoff']['name'];
    busDriverName = json['driver']['name'];
    busColor = json['driver']['vehicle_details']['car_color'];
    busModel = json['driver']['vehicle_details']['car_model'];
    busVehicleNumber = json['driver']['vehicle_details']['vehicle_number'];
    busDriverProfile = json['driver']['profile_image_original'];
    busDriverProfileThumb = json['driver']['profie_image_thumbnail'];


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['ticket_number'] = this.ticketNumber;
    data['order_at'] = this.dateOfOrder;
    data['booking_time'] = this.bookingTime;
    data['passenger_count'] = this.passengerCount;
    data['qr_code'] = this.qrCode;
    data['charge'] = (this.charge).toString();

    data['pickup'] =
    {
      "name": this.pickupTerminalName,
      "id": this.pickupTerminalID,
      "longitude": this.pickupTerminalLongitude,
      "latitude": this.pickupTerminalLatitude
    };

    data['dropoff'] =
    {
      "name": this.dropOffTerminalName,
      "id": this.dropOffTerminalID,
      "longitude": this.dropOffTerminalLongitude,
      "latitude": this.dropOffTerminalLatitude
    };

    data['lane'] =
    {
      "name": this.laneName,
    };

    return data;
  }

}

