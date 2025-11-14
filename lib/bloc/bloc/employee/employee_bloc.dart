



import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../model/employee/getallemployeemodel.dart';
import '../../../services/attendance_apiservice.dart';
import '../../event/employee/employee_event.dart';
import '../../state/employee/employee_state.dart';



class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final AttendanceApiService apiService;

  EmployeeBloc(this.apiService) : super(EmployeeInitial()) {
    on<FetchEmployeeEvent>(_onFetchEmployee);

    // Handle adding Employee to the list
    on<AddEmployeeToListEvent>((event, emit) {
      if (state is EmployeeLoaded) {
        final current = List<EmployeeList>.from(
            (state as EmployeeLoaded).employee);
        current.add(event.employee);
        emit(EmployeeLoaded(current));
      }
    });
  }

  Future<void> _onFetchEmployee(
      FetchEmployeeEvent event, Emitter<EmployeeState> emit) async {
    emit(EmployeeLoading());
    try {
      final model = await apiService.getAllEmployee();
      emit(EmployeeLoaded(model.data));
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }
}

