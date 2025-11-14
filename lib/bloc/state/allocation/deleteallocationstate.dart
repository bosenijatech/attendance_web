import 'package:equatable/equatable.dart';

abstract class DeleteAllocationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DeleteAllocationInitial extends DeleteAllocationState {}

class DeleteAllocationLoading extends DeleteAllocationState {}

class DeleteAllocationSuccess extends DeleteAllocationState {
  final String message;
  DeleteAllocationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class DeleteAllocationFailure extends DeleteAllocationState {
  final String error;
  DeleteAllocationFailure(this.error);

  @override
  List<Object?> get props => [error];
}
