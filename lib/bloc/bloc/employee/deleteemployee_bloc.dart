import 'package:bloc/bloc.dart';
import '../../../services/attendance_apiservice.dart';
import '../../event/employee/deleteemployee_event.dart';
import '../../state/employee/deleteemployee_state.dart';



class DeleteEmployeeBloc extends Bloc<DeleteEmployeeEvent, DeleteEmployeeState> {
  final AttendanceApiService apiService;

  DeleteEmployeeBloc({required this.apiService}) : super(DeleteEmployeeInitial()) {
    on<SubmitDeleteEmployee>(_onDeleteEmployee);
  }

  Future<void> _onDeleteEmployee(
    SubmitDeleteEmployee event,
    Emitter<DeleteEmployeeState> emit,
  ) async {
    emit(DeleteEmployeeLoading());
    try {
      if (event.id.isEmpty) {
        emit(DeleteEmployeeFailure("Employee ID is required"));
        return;
      }

      print("🗑️ Sending delete request for Employee ID: ${event.id}");

      final response = await apiService.deleteEmployee(event.id);

      if (response.status == true) {
        emit(DeleteEmployeeSuccess(response.message ?? "Deleted successfully"));
      } else {
        emit(DeleteEmployeeFailure(response.message ?? "Delete failed"));
      }
    } catch (e) {
      emit(DeleteEmployeeFailure("Error: $e"));
    }
  }
}
