





import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/site/getallsitemodel.dart';
import '../../../services/attendance_apiservice.dart';
import '../../event/site/site_event.dart';
import '../../state/site/site_state.dart';


class SiteBloc extends Bloc<SiteEvent, SiteState> {
  final AttendanceApiService apiService;

  SiteBloc(this.apiService) : super(SiteInitial()) {
    on<FetchSiteEvent>(_onFetchSite);

    // Handle adding supervisor to the list
    on<AddSiteToListEvent>((event, emit) {
      if (state is SiteLoaded) {
        final current = List<Sitelist>.from(
            (state as SiteLoaded).site);
        current.add(event.site);
        emit(SiteLoaded(current));
      }
    });
  }

  Future<void> _onFetchSite(
      FetchSiteEvent event, Emitter<SiteState> emit) async {
    emit(SiteLoading());
    try {
      final model = await apiService.getAllSite();
      emit(SiteLoaded(model.data));
    } catch (e) {
      emit(SiteError(e.toString()));
    }
  }
}

