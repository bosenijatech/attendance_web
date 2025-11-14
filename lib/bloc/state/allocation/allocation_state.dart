

import '../../../model/allocation/getallallocationmodel.dart';


abstract class AllocationState {}

class AllocationInitial extends AllocationState {}

class AllocationLoading extends AllocationState {}

class AllocationLoaded extends AllocationState {
  final List<Allocationlist> allocation;
 AllocationLoaded(this.allocation);
}

class AllocationError extends AllocationState {
  final String message;
  AllocationError(this.message);
}
