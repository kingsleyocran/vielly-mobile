import '../models/busterminals.dart';

class BookedBusSchedule {
  String? orderID;
  BusTerminal? pickupTerminal;
  BusTerminal? dropOffTerminal;
  num? distance;
  dynamic charge;
  int? availableSeats;
  String? laneName;
  String? date;
  String? time;


  BookedBusSchedule({
    this.orderID,
    this.pickupTerminal,
    this.dropOffTerminal,
    this.distance,
    this.charge,
    this.availableSeats,
    this.laneName,
    this.date,
    this.time,
  });

  BookedBusSchedule.fromJson(Map<String, dynamic> json){
    orderID = json['order_id'];
    distance = json['trip_distance'];
    charge = json['charge'];
    availableSeats = int.parse((json['available_seats']).toString());
    laneName = json['lane']['name'];
    date = json['date'];
    time = json['time'];
    pickupTerminal = BusTerminal.fromJson(json['pickup'] as Map<String, dynamic>);
    dropOffTerminal = BusTerminal.fromJson(json['dropoff'] as Map<String, dynamic>);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderID;
    data['charge'] = this.charge;
    data['trip_distance'] = this.distance;
    data['pickup'] = this.pickupTerminal!.toJson();
    data['dropoff'] = this.dropOffTerminal!.toJson();
    data['available_seats'] = this.availableSeats;
    data['date'] = this.date;
    data['time'] = this.time;
    data['lane'] = {"name": this.laneName,};

    return data;
  }

}

