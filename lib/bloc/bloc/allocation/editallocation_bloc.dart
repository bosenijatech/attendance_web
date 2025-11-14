import 'package:bloc/bloc.dart';
import '../../../services/attendance_apiservice.dart';
import '../../event/allocation/editallocation_event.dart';
import '../../state/allocation/editallocation_state.dart';

class EditAllocationBloc extends Bloc<EditAllocationEvent, EditAllocationState> {
  final AttendanceApiService apiService;

  EditAllocationBloc({required this.apiService})
      : super(EditAllocationInitial()) {
    on<SubmitEditAllocation>(_onEditAllocation);
  }

  Future<void> _onEditAllocation(
      SubmitEditAllocation event, Emitter<EditAllocationState> emit) async {
    emit(EditAllocationLoading());

    try {
      if (event.id.isEmpty) {
        emit(EditAllocationFailure("Allocation numeric ID is required"));
        return;
      }

      // ✅ Updated payload to match your event fields
      final postData = {
        "id": event.id,
        "allocationid": event.allocationid,
        "supervisorname": event.supervisorname,
        "projectname": event.projectname,
        "sitename": event.sitename,
        "fromDate": event.fromDate,
        "toDate": event.toDate,
        "status": event.status,
        "employee": event.employee, // ✅ list of employees
        "syncstaus": event.syncstaus, // ✅ added optional sync status
      };

      print("📤 PUT payload: $postData");

      final response = await apiService.editAllocation(postData);

      if (response.status == true) {
        emit(EditAllocationSuccess(response.message ?? "Allocation updated successfully"));
      } else {
        emit(EditAllocationFailure(response.message ?? "Update failed"));
      }
    } catch (e) {
      emit(EditAllocationFailure(e.toString()));
    }
  }
}
