
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/attendance_apiservice.dart';
import '../../event/site/editsite_event.dart';
import '../../state/site/editsite_state.dart';


class EditSiteBloc extends Bloc<EditSiteEvent, EditSiteState> {
  final AttendanceApiService apiService;

  EditSiteBloc({required this.apiService}) : super(EditSiteInitial()) {
    on<SubmitEditSite>(_onEditSite);
  }

  Future<void> _onEditSite(
      SubmitEditSite event, Emitter<EditSiteState> emit) async {
    emit(EditSiteLoading());
    try {
      if (event.id.isEmpty) {
        emit(EditSiteFailure("Site numeric ID is required"));
        return;
      }

      final postData = {
        "id": event.id,
        "siteid": event.siteId,
        "sitename": event. siteName,
        "siteaddress" : event.siteAddress,
        "sitecity" : event.siteCity,
        
        "status": event.status,
      };

      print("📤 PUT payload: $postData");

      final response = await apiService.editSite(postData);

      if (response.status == true) {
        emit(EditSiteSuccess(response.message ?? "Site updated successfully"));
      } else {
        emit(EditSiteFailure(response.message ?? "Update failed"));
      }
    } catch (e) {
      emit(EditSiteFailure(e.toString()));
    }
  }
}
