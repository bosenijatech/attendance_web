import 'package:bloc/bloc.dart';
import '../../../services/attendance_apiservice.dart';
import '../../event/projectmaster/addproject_event.dart';

import '../../state/projectmaster/addproject_state.dart';



class AddProjectBloc extends Bloc<AddProjectEvent, AddProjectState> {
  final AttendanceApiService apiService;

  AddProjectBloc({required this.apiService})
      : super(AddProjectInitial()) {
    on<CreateProjectEvent>(_onCreateProject);
  }

  Future<void> _onCreateProject(
    CreateProjectEvent event,
    Emitter<AddProjectState> emit,
  ) async {
    emit(AddProjectLoading());

    try {
      final Map<String, dynamic> postData = {
       

          "id": event.id,
        "projectid": event.projectId,
        "projectname": event.projectName,
        "projectaddress" : event.projectAddress,
        
       
        "status": event.status,
      };

      final model = await apiService.addProject(postData);
      emit(AddProjectSuccess(model));
    } catch (e) {
      emit(AddProjectFailure(e.toString()));
    }
  }
}
