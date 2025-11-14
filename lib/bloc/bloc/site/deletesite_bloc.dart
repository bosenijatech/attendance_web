import 'package:bloc/bloc.dart';
import '../../../services/attendance_apiservice.dart';
import '../../event/site/deletesite_event.dart';
import '../../state/site/deletesite_state.dart';



class DeleteSiteBloc extends Bloc<DeleteSiteEvent, DeleteSiteState> {
  final AttendanceApiService apiService;

  DeleteSiteBloc({required this.apiService}) : super(DeleteSiteInitial()) {
    on<SubmitDeleteSite>(_onDeleteSite);
  }

  Future<void> _onDeleteSite(
    SubmitDeleteSite event,
    Emitter<DeleteSiteState> emit,
  ) async {
    emit(DeleteSiteLoading());
    try {
      if (event.id.isEmpty) {
        emit(DeleteSiteFailure("Site ID is required"));
        return;
      }

      print("🗑️ Sending delete request for Site ID: ${event.id}");

      final response = await apiService.deleteSite(event.id);

      if (response.status == true) {
        emit(DeleteSiteSuccess(response.message ?? "Deleted successfully"));
      } else {
        emit(DeleteSiteFailure(response.message ?? "Delete failed"));
      }
    } catch (e) {
      emit(DeleteSiteFailure("Error: $e"));
    }
  }
}
