import 'package:bloc/bloc.dart';
import '../../../services/attendance_apiservice.dart';
import '../../event/employee/editemployee_event.dart';
import '../../state/employee/editemployee_state.dart';


class EditEmployeeBloc extends Bloc<EditEmployeeEvent, EditEmployeeState> {
  final AttendanceApiService apiService;

  EditEmployeeBloc({required this.apiService}) : super(EditEmployeeInitial()) {
    on<SubmitEditEmployee>(_onEditEmployee);
  }

  Future<void> _onEditEmployee(
      SubmitEditEmployee event, Emitter<EditEmployeeState> emit) async {
    emit(EditEmployeeLoading());
    try {
      if (event.id.isEmpty) {
        emit(EditEmployeeFailure("Employee numeric ID is required"));
        return;
      }

      final postData = {
        "id": event.id,
        "employeeid": event.employeeId,
        "employeename": event.employeeName,
        "type": event.type,
        "status": event.status,
      };

      print("📤 PUT payload: $postData");

      final response = await apiService.editEmployee(postData);

      if (response.status == true) {
        emit(EditEmployeeSuccess(response.message ?? "Employee updated successfully"));
      } else {
        emit(EditEmployeeFailure(response.message ?? "Update failed"));
      }
    } catch (e) {
      emit(EditEmployeeFailure(e.toString()));
    }
  }
}
