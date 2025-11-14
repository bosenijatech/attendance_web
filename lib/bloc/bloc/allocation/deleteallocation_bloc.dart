import 'package:bloc/bloc.dart';
import '../../../services/attendance_apiservice.dart';
import '../../event/allocation/deleteallocation_event.dart';
import '../../state/allocation/deleteallocationstate.dart';




class DeleteAllocationBloc extends Bloc<DeleteAllocationEvent, DeleteAllocationState> {
  final AttendanceApiService apiService;

  DeleteAllocationBloc({required this.apiService}) : super(DeleteAllocationInitial()) {
    on<SubmitDeleteAllocation>(_onDeleteAllocation);
  }

  Future<void> _onDeleteAllocation(
    SubmitDeleteAllocation event,
    Emitter<DeleteAllocationState> emit,
  ) async {
    emit(DeleteAllocationLoading());
    try {
      if (event.id.isEmpty) {
        emit(DeleteAllocationFailure("Allocation ID is required"));
        return;
      }

      print("🗑️ Sending delete request for Allocation ID: ${event.id}");

      final response = await apiService.deleteAllocation(event.id);

      if (response.status == true) {
        emit(DeleteAllocationSuccess(response.message ?? "Deleted successfully"));
      } else {
        emit(DeleteAllocationFailure(response.message ?? "Delete failed"));
      }
    } catch (e) {
      emit(DeleteAllocationFailure("Error: $e"));
    }
  }
}
