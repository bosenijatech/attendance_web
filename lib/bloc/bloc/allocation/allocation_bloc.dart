



import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../model/allocation/getallallocationmodel.dart';
import '../../../services/attendance_apiservice.dart';
import '../../event/allocation/allocation_event.dart';
import '../../state/allocation/allocation_state.dart';


class AllocationBloc extends Bloc<AllocationEvent, AllocationState> {
  final AttendanceApiService apiService;

  AllocationBloc(this.apiService) : super(AllocationInitial()) {
    on<FetchAllocationEvent>(_onFetchAllocation);

    // Handle adding Allocation to the list
    on<AddAllocationToListEvent>((event, emit) {
      if (state is AllocationLoaded) {
        final current = List<Allocationlist>.from(
            (state as AllocationLoaded).allocation);
        current.add(event.allocation);
        emit(AllocationLoaded(current));
      }
    });
  }

  Future<void> _onFetchAllocation(
      FetchAllocationEvent event, Emitter<AllocationState> emit) async {
    emit(AllocationLoading());
    try {
      final model = await apiService.getAllAllocation();
      emit(AllocationLoaded(model.data));
    } catch (e) {
      emit(AllocationError(e.toString()));
    }
  }
}

