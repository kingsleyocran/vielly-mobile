import '../../data/models/busterminals.dart';

class BusSchedule {
  String? busID;
  String? slug;
  String? endTime;
  String? startTime;
  String? time;
  dynamic seats;
  String? laneName;
  String? laneID;
  String? date;
  String? startTerminal;
  double? startLatitude;
  double? startLongitude;
  String? endTerminal;
  double? endLatitude;
  double? endLongitude;
  List<BusTerminal>? busTerminal;
  List<dynamic>? laneOperatingTimes;



  BusSchedule({
    this.busID,
    this.slug,
    this.endTime,
    this.startTime,
    this.time,
    this.seats,
    this.laneName,
    this.date,
    this.startTerminal,
    this.startLatitude,
    this.startLongitude,
    this.endTerminal,
    this.endLatitude,
    this.endLongitude,
    this.laneOperatingTimes,

  });

  BusSchedule.fromJson(Map<String, dynamic> json){
    busID = json['id'];
    slug = json['slug'];
    date = json['date'];
    endTime = json['end_time'];
    startTime = json['start_time'];
    seats = json['available_seats'];
    time = json['time'];
    laneName = json['lane']['name'];
    laneID = json['lane']['id'];
    startTerminal = json['lane']['start_terminal'];
    startLatitude = json['lane']['start_location']['latitude'];
    startLongitude = json['lane']['start_location']['longitude'];
    endTerminal = json['lane']['end_terminal'];
    endLatitude = json['lane']['end_location']['latitude'];
    endLongitude = json['lane']['end_location']['longitude'];
    busTerminal = (json['lane']['stops'] as List<dynamic>)
                      .map((e) => BusTerminal.fromJson(e as Map<String, dynamic>))
                      .toList();
    laneOperatingTimes = (json['lane']['operating_times'] as List<dynamic>).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.busID;
    data['slug'] = this.slug;
    data['date'] = this.date;
    data['end_time'] = this.endTime;
    data['start_time'] = this.startTime;
    data['time'] = this.time;
    data['available_seats'] = this.seats;
    data['lane'] = {"name": this.laneName,};
    data['lane'] = {"id": this.laneID,};
    data['lane']  = {"start_terminal": this.startTerminal,};

    data['lane'] =
    {"start_location": {
      "longitude": this.startLongitude,
      "latitude": this.startLatitude
      },
    };

    data['lane']  = {"end_terminal": this.endTerminal,};

    data['lane'] =
    {"end_location": {
      "longitude": this.endLongitude,
      "latitude": this.endLatitude
      },
    };

    data['lane'] =
    {"stops": this.busTerminal!.map((e) => e.toJson()).toList(),
    };

    return data;
  }

}

