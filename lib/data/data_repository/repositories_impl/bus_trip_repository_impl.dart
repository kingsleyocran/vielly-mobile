
import '../../../data/models/bookedbusdata.dart';
import '../../../data/models/ticket.dart';
import '../../../domain/repository/bus_trip_repository.dart';

import '../base_repository_impl.dart';

class BusTripRepositoryImpl with BaseRepositoryImpl implements BusTripRepository {

  @override
  Future<dynamic> getBusSchedules() async{

    var dataRemote = await processRequest(() => apiService.getBusSchedulesAPI());

    if (dataRemote != null && dataRemote['data'] != null) {
      print(dataRemote);
      prefService.setPrefBusSchedules(dataRemote);
      return dataRemote;
    }else return null;

  }

  @override
  Future<dynamic> postBookTicket(Map<String, dynamic> payloadData) async{
    final uid = await prefService.getPrefUserID();

    payloadData['uid'] = uid;

    var data = await processRequest(() => apiService.postBookTicketAPI(
      data: payloadData,
    ));
    if (data != null && data['data'] != null) {

      print(data['msg']);

      final bookedBusData = BookedBusSchedule.fromJson(data['data']);

      prefService.setBookTicketData(bookedBusData);

      await prefService.getBookTicketData();
      return Future.value(data['success']);

    }else{
      return false;
    }
  }

  @override
  Future<dynamic> postConfirmTicket(Map<String, dynamic> payloadData) async{
    final uid = await prefService.getPrefUserID();

    payloadData['uid'] = uid;

    var data = await processRequest(() => apiService.postConfirmTicketAPI(
      data: payloadData,
    ));
    if (data != null && data['data'] != null) {

      print(data['msg']);

      final bookedBusData = TicketDetails.fromJson(data['data']);

      prefService.setTicketData(bookedBusData);

      await getAllTickets(fromRemote: true);

      return Future.value(bookedBusData);

    }else return false;
  }

  @override
  Future<dynamic> getAllTickets({fromRemote}) async{
    if (!fromRemote) {
      return prefService.getPrefSavedTickets();
    }
    else{
      final uid = await prefService.getPrefUserID();
      var dataRemote = await processRequest(() => apiService.getAllTicketsAPI(uid!));
      if (dataRemote != null && dataRemote['data'] != null) {
        print(dataRemote);

        prefService.setPrefSavedTickets(dataRemote['data']);

        return dataRemote;
      }else return null;
    }
  }

}