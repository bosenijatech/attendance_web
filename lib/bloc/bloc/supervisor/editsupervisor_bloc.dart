import 'package:bloc/bloc.dart';
import '../../../services/attendance_apiservice.dart';
import '../../event/supervisor/editsupervisor_event.dart';
import '../../state/supervisor/editsupervisor_state.dart';

class EditSupervisorBloc extends Bloc<EditSupervisorEvent, EditSupervisorState> {
  final AttendanceApiService apiService;

  EditSupervisorBloc({required this.apiService}) : super(EditSupervisorInitial()) {
    on<SubmitEditSupervisor>(_onEditSupervisor);
  }

  Future<void> _onEditSupervisor(
      SubmitEditSupervisor event, Emitter<EditSupervisorState> emit) async {
    emit(EditSupervisorLoading());
    try {
      if (event.id.isEmpty) {
        emit(EditSupervisorFailure("Supervisor numeric ID is required"));
        return;
      }

      final postData = {
        "id": event.id,
        "supervisorid": event.supervisorId,
        "supervisorname": event.supervisorName,
        "type": event.type,
        "status": event.status,
         "password" : event.password,
        "username" : event.username,
      };

      print("📤 PUT payload: $postData");

      final response = await apiService.editSupervisor(postData);

      if (response.status == true) {
        emit(EditSupervisorSuccess(response.message ?? "Supervisor updated successfully"));
      } else {
        emit(EditSupervisorFailure(response.message ?? "Update failed"));
      }
    } catch (e) {
      emit(EditSupervisorFailure(e.toString()));
    }
  }
}
