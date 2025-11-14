import 'package:equatable/equatable.dart';

abstract class AddAllocationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddAllocationInitial extends AddAllocationState {}
class AddAllocationLoading extends AddAllocationState {}
class AddAllocationSuccess extends AddAllocationState {
  final dynamic model;
  AddAllocationSuccess(this.model);
}
class AddAllocationFailure extends AddAllocationState {
  final String error;
  AddAllocationFailure(this.error);
}

