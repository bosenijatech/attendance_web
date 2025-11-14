import 'package:bloc/bloc.dart';
import '../../../services/attendance_apiservice.dart';
import '../../event/supervisor/addsupervisor_event.dart';
import '../../state/supervisor/addsupervisor_state.dart';


class AddSupervisorBloc extends Bloc<AddSupervisorEvent, AddSupervisorState> {
  final AttendanceApiService apiService;

  AddSupervisorBloc({required this.apiService})
      : super(AddSupervisorInitial()) {
    on<CreateSupervisorEvent>(_onCreateSupervisor);
  }

  Future<void> _onCreateSupervisor(
    CreateSupervisorEvent event,
    Emitter<AddSupervisorState> emit,
  ) async {
    emit(AddSupervisorLoading());

    try {
      final Map<String, dynamic> postData = {
        "id": event.id,
        "password" : event.password,
        "username" : event.username,

   
        "supervisorid": event.supervisorId,
        "supervisorname": event.supervisorName,
        "type": event.type ?? "",
        "status": event.status ?? "",
      };

      final model = await apiService.addSupervisor(postData);
      emit(AddSupervisorSuccess(model));
    } catch (e) {
      emit(AddSupervisorFailure(e.toString()));
    }
  }
}
