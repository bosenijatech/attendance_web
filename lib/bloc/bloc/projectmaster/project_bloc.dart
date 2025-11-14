






import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/projectmaster/getallprojectmodel.dart';
import '../../../services/attendance_apiservice.dart';
import '../../event/projectmaster/project_event.dart';
import '../../state/projectmaster/project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final AttendanceApiService apiService;

  ProjectBloc(this.apiService) : super(ProjectInitial()) {
    on<FetchProjectEvent>(_onFetchProject);

    // Handle adding supervisor to the list
    on<AddProjectToListEvent>((event, emit) {
      if (state is ProjectLoaded) {
        final current = List<Projectlist>.from(
            (state as ProjectLoaded).project);
        current.add(event.project);
        emit(ProjectLoaded(current));
      }
    });
  }

  Future<void> _onFetchProject(
      FetchProjectEvent event, Emitter<ProjectState> emit) async {
    emit(ProjectLoading());
    try {
      final model = await apiService.getAllProject();
      emit(ProjectLoaded(model.data));
    } catch (e) {
      emit(ProjectError(e.toString()));
    }
  }
}

