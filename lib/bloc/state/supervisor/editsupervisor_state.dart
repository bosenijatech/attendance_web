import 'package:equatable/equatable.dart';

abstract class EditSupervisorState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EditSupervisorInitial extends EditSupervisorState {}

class EditSupervisorLoading extends EditSupervisorState {}

class EditSupervisorSuccess extends EditSupervisorState {
  final String message;
  EditSupervisorSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class EditSupervisorFailure extends EditSupervisorState {
  final String error;
  EditSupervisorFailure(this.error);
  @override
  List<Object?> get props => [error];
}
