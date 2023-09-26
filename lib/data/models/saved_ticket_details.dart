

class SavedTicketDetails {
  String? ticketNumber;
  String? dateOfOrder;
  num? passengerCount;
  String? qrCode;
  dynamic charge;

  String? pickupTerminalName;
  int? pickupTerminalID;
  String? pickupTerminalLocation;
  String? pickupTerminalSource;
  double? pickupTerminalLatitude;
  double? pickupTerminalLongitude;

  String? dropOffTerminalName;
  int? dropOffTerminalID;
  String? dropOffTerminalLocation;
  String? dropOffTerminalSource;
  double? dropOffTerminalLatitude;
  double? dropOffTerminalLongitude;
  String? laneName;
  String? bookingTime;



  SavedTicketDetails({
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
  });

  SavedTicketDetails.fromJson(Map<String, dynamic> json){

    ticketNumber = json['ticket_number'];
    dateOfOrder = json['order_at'];
    passengerCount = json['passenger_count'];
    qrCode = json['qr_code'];
    charge = json['charge'];
    bookingTime = json['booking_time'];

    laneName = json['lane']['name'];

    pickupTerminalName = json['pickup']['name'];
    pickupTerminalID = json['pickup']['id'];
    pickupTerminalLatitude = json['pickup']['latitude'];
    pickupTerminalLongitude = json['pickup']['longitude'];

    dropOffTerminalName = json['dropoff']['name'];
    dropOffTerminalID = json['dropoff']['id'];
    dropOffTerminalLatitude = json['dropoff']['latitude'];
    dropOffTerminalLongitude = json['dropoff']['longitude'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['ticket_number'] = this.ticketNumber;
    data['order_at'] = this.dateOfOrder;
    data['booking_time'] = this.bookingTime;
    data['passenger_count'] = this.passengerCount;
    data['qr_code'] = this.qrCode;
    data['charge'] = this.charge;

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

