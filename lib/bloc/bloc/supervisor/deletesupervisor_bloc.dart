import 'package:bloc/bloc.dart';
import '../../../services/attendance_apiservice.dart';
import '../../event/supervisor/deletesupervisor_event.dart';
import '../../state/supervisor/deletesupervisor_state.dart';

class DeleteSupervisorBloc extends Bloc<DeleteSupervisorEvent, DeleteSupervisorState> {
  final AttendanceApiService apiService;

  DeleteSupervisorBloc({required this.apiService}) : super(DeleteSupervisorInitial()) {
    on<SubmitDeleteSupervisor>(_onDeleteSupervisor);
  }

  Future<void> _onDeleteSupervisor(
    SubmitDeleteSupervisor event,
    Emitter<DeleteSupervisorState> emit,
  ) async {
    emit(DeleteSupervisorLoading());
    try {
      if (event.id.isEmpty) {
        emit(DeleteSupervisorFailure("Supervisor ID is required"));
        return;
      }

      print("🗑️ Sending delete request for Supervisor ID: ${event.id}");

      final response = await apiService.deleteSupervisor(event.id);

      if (response.status == true) {
        emit(DeleteSupervisorSuccess(response.message ?? "Deleted successfully"));
      } else {
        emit(DeleteSupervisorFailure(response.message ?? "Delete failed"));
      }
    } catch (e) {
      emit(DeleteSupervisorFailure("Error: $e"));
    }
  }
}
