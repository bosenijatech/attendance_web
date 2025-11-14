import 'package:equatable/equatable.dart';

abstract class EditAllocationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EditAllocationInitial extends EditAllocationState {}

class EditAllocationLoading extends EditAllocationState {}

class EditAllocationSuccess extends EditAllocationState {
  final String message;
  EditAllocationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class EditAllocationFailure extends EditAllocationState {
  final String error;
  EditAllocationFailure(this.error);
  @override
  List<Object?> get props => [error];
}
