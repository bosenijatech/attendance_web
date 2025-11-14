import 'package:equatable/equatable.dart';

abstract class DeleteAllocationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitDeleteAllocation extends DeleteAllocationEvent {
  final String id; // Allocation's DB ID (as string)

  SubmitDeleteAllocation({required this.id});

  @override
  List<Object?> get props => [id];
}
