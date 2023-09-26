

abstract class BusTripRepository {

  Future<dynamic> getBusSchedules();
  Future<dynamic> postBookTicket(Map<String, dynamic> payloadData);
  Future<dynamic> postConfirmTicket(Map<String, dynamic> payloadData);
  Future<dynamic> getAllTickets({fromRemote});

}