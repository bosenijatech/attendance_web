
import '../../../model/supervisor/getallsupervisormodel.dart';

abstract class SupervisorState {}

class SupervisorInitial extends SupervisorState {}

class SupervisorLoading extends SupervisorState {}

class SupervisorLoaded extends SupervisorState {
  final List<Supervisorlist> supervisors;
  SupervisorLoaded(this.supervisors);
}

class SupervisorError extends SupervisorState {
  final String message;
  SupervisorError(this.message);
}
