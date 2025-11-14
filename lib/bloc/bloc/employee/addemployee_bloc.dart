import 'package:bloc/bloc.dart';
import '../../../services/attendance_apiservice.dart';
import '../../event/employee/addemployee_event.dart';
import '../../state/employee/addemployee_state.dart';



class AddEmployeeBloc extends Bloc<AddEmployeeEvent, AddEmployeeState> {
  final AttendanceApiService apiService;

  AddEmployeeBloc({required this.apiService})
      : super(AddEmployeeInitial()) {
    on<CreateEmployeeEvent>(_onCreateEmployee);
  }

  Future<void> _onCreateEmployee(
    CreateEmployeeEvent event,
    Emitter<AddEmployeeState> emit,
  ) async {
    emit(AddEmployeeLoading());

    try {
      final Map<String, dynamic> postData = {
        "id": event.id,
        
        "employeeid": event.employeeId,
        "employeename": event.employeeName,
        "type": event.type ?? "",
        "status": event.status ?? "",
      };

      final model = await apiService.addEmployee(postData);
      emit(AddEmployeeSuccess(model));
    } catch (e) {
      emit(AddEmployeeFailure(e.toString()));
    }
  }
}
