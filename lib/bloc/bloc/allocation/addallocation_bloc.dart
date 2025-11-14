// import 'package:bloc/bloc.dart';
// import '../../../services/attendance_apiservice.dart';
// import '../../event/allocation/addallocation_event.dart';
// import '../../state/allocation/addallocation_state.dart';



// class AddAllocationBloc extends Bloc<AddAllocationEvent, AddAllocationState> {
//   final AttendanceApiService apiService;

//   AddAllocationBloc({required this.apiService})
//       : super(AddAllocationInitial()) {
//     on<CreateAllocationEvent>(_onCreateAllocation);
//   }

//   Future<void> _onCreateAllocation(
//     CreateAllocationEvent event,
//     Emitter<AddAllocationState> emit,
//   ) async {
//     emit(AddAllocationLoading());

//     try {
//       final Map<String, dynamic> postData = {
//         "id": event.id,
//         "supervisorname": event.supervisorname,
     
//         "projectname": event.projectname,
//         "sitename": event.sitename,
//         "fromDate": event.fromDate,
//         "sitename": event.sitename,
  
//         "status": event.status,
//       };

//       final model = await apiService.addAllocation(postData);
//       emit(AddAllocationSuccess(model));
//     } catch (e) {
//       emit(AddAllocationFailure(e.toString()));
//     }
//   }
// }


import 'package:bloc/bloc.dart';
import '../../../services/attendance_apiservice.dart';
import '../../event/allocation/addallocation_event.dart';
import '../../state/allocation/addallocation_state.dart';

class AddAllocationBloc extends Bloc<AddAllocationEvent, AddAllocationState> {
  final AttendanceApiService apiService;

  AddAllocationBloc({required this.apiService}) : super(AddAllocationInitial()) {
    on<CreateAllocationEvent>(_onCreateAllocation);
  }

  Future<void> _onCreateAllocation(
    CreateAllocationEvent event,
    Emitter<AddAllocationState> emit,
  ) async {
    emit(AddAllocationLoading());

    try {
      // ✅ Use correct field name (employeenames list)
      final Map<String, dynamic> postData = {
        "id": event.id,
        "allocationid" : event.allocationid,
        "supervisorname": event.supervisorname,
        "employee": event.employee, // ✅ backend expects array
        "projectname": event.projectname,
        "sitename": event.sitename,
        "fromDate": event.fromDate,
        "toDate": event.toDate,
        "status": event.status,
        "syncstaus": event.syncstaus,
      };

      final model = await apiService.addAllocation(postData);

      emit(AddAllocationSuccess(model));
    } catch (e) {
      emit(AddAllocationFailure(e.toString()));
    }
  }
}
