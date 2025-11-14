import 'package:bloc/bloc.dart';
import '../../../services/attendance_apiservice.dart';
import '../../event/site/addsite_event.dart';
import '../../state/site/addsite_state.dart';


class AddSiteBloc extends Bloc<AddSiteEvent, AddSiteState> {
  final AttendanceApiService apiService;

  AddSiteBloc({required this.apiService})
      : super(AddSiteInitial()) {
    on<CreateSiteEvent>(_onCreateSite);
  }

  Future<void> _onCreateSite(
    CreateSiteEvent event,
    Emitter<AddSiteState> emit,
  ) async {
    emit(AddSiteLoading());

    try {
      final Map<String, dynamic> postData = {
       

          "id": event.id,
        "siteid": event.siteId,
        "sitename": event. siteName,
        "siteaddress" : event.siteAddress,
        "sitecity" : event.siteCity,
       
        "status": event.status,
      };

      final model = await apiService.addSite(postData);
      emit(AddSiteSuccess(model));
    } catch (e) {
      emit(AddSiteFailure(e.toString()));
    }
  }
}
