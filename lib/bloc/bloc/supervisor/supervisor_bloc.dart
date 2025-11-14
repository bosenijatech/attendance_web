



import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/attendance_apiservice.dart';

import '../../event/supervisor/supervisor_event.dart';
import '../../state/supervisor/supervisor_state.dart';
import '../../../model/supervisor/getallsupervisormodel.dart';

class SupervisorBloc extends Bloc<SupervisorEvent, SupervisorState> {
  final AttendanceApiService apiService;

  SupervisorBloc(this.apiService) : super(SupervisorInitial()) {
    on<FetchSupervisorsEvent>(_onFetchSupervisors);

    // Handle adding supervisor to the list
    on<AddSupervisorToListEvent>((event, emit) {
      if (state is SupervisorLoaded) {
        final current = List<Supervisorlist>.from(
            (state as SupervisorLoaded).supervisors);
        current.add(event.supervisor);
        emit(SupervisorLoaded(current));
      }
    });
  }

  Future<void> _onFetchSupervisors(
      FetchSupervisorsEvent event, Emitter<SupervisorState> emit) async {
    emit(SupervisorLoading());
    try {
      final model = await apiService.getAllSupervisor();
      emit(SupervisorLoaded(model.data));
    } catch (e) {
      emit(SupervisorError(e.toString()));
    }
  }
}

