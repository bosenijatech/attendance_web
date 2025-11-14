



import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/attendance_apiservice.dart';
import '../../event/projectmaster/editproject_event.dart';
import '../../state/projectmaster/editproject_state.dart';


class EditProjectBloc extends Bloc<EditProjectEvent, EditProjectState> {
  final AttendanceApiService apiService;

  EditProjectBloc({required this.apiService}) : super(EditProjectInitial()) {
    on<SubmitEditProject>(_onEditProject);
  }

  Future<void> _onEditProject(
      SubmitEditProject event, Emitter<EditProjectState> emit) async {
    emit(EditProjectLoading());
    try {
      if (event.id.isEmpty) {
        emit(EditProjectFailure("Project numeric ID is required"));
        return;
      }

      final postData = {
           "id": event.id,
        "projectid": event.projectId,
        "projectname": event.projectName,
        "projectaddress" : event.projectAddress,
        
       
        "status": event.status,
      };

      print("📤 PUT payload: $postData");

      final response = await apiService.editProject(postData);

      if (response.status == true) {
        emit(EditProjectSuccess(response.message ?? "Project updated successfully"));
      } else {
        emit(EditProjectFailure(response.message ?? "Update failed"));
      }
    } catch (e) {
      emit(EditProjectFailure(e.toString()));
    }
  }
}
