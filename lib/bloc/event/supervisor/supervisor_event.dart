


import '../../../model/supervisor/getallsupervisormodel.dart';

abstract class SupervisorEvent {}

class FetchSupervisorsEvent extends SupervisorEvent {}

class AddSupervisorToListEvent extends SupervisorEvent {
  final Supervisorlist supervisor;
  AddSupervisorToListEvent(this.supervisor);
}
