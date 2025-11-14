



import '../../../model/allocation/getallallocationmodel.dart';

abstract class AllocationEvent {}

class FetchAllocationEvent extends AllocationEvent {}

class AddAllocationToListEvent extends AllocationEvent {
  final Allocationlist allocation;
  AddAllocationToListEvent(this.allocation);
}
