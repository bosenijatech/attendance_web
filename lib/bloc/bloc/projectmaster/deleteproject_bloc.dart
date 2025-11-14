import 'package:bloc/bloc.dart';
import '../../../services/attendance_apiservice.dart';
import '../../event/projectmaster/deleteproject_event.dart';
import '../../state/projectmaster/deleteproject_state.dart';


class DeleteProjectBloc extends Bloc<DeleteProjectEvent, DeleteProjectState> {
  final AttendanceApiService apiService;

  DeleteProjectBloc({required this.apiService}) : super(DeleteProjectInitial()) {
    on<SubmitDeleteProject>(_onDeleteProject);
  }

  Future<void> _onDeleteProject(
    SubmitDeleteProject event,
    Emitter<DeleteProjectState> emit,
  ) async {
    emit(DeleteProjectLoading());
    try {
      if (event.id.isEmpty) {
        emit(DeleteProjectFailure("Project ID is required"));
        return;
      }

      print("🗑️ Sending delete request for Project ID: ${event.id}");

      final response = await apiService.deleteProject(event.id);

      if (response.status == true) {
        emit(DeleteProjectSuccess(response.message ?? "Deleted successfully"));
      } else {
        emit(DeleteProjectFailure(response.message ?? "Delete failed"));
      }
    } catch (e) {
      emit(DeleteProjectFailure("Error: $e"));
    }
  }
}
