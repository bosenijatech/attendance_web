import 'package:equatable/equatable.dart';

abstract class DeleteSupervisorState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DeleteSupervisorInitial extends DeleteSupervisorState {}

class DeleteSupervisorLoading extends DeleteSupervisorState {}

class DeleteSupervisorSuccess extends DeleteSupervisorState {
  final String message;
  DeleteSupervisorSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class DeleteSupervisorFailure extends DeleteSupervisorState {
  final String error;
  DeleteSupervisorFailure(this.error);

  @override
  List<Object?> get props => [error];
}
