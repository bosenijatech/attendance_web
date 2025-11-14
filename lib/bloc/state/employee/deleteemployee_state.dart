import 'package:equatable/equatable.dart';

abstract class DeleteEmployeeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DeleteEmployeeInitial extends DeleteEmployeeState {}

class DeleteEmployeeLoading extends DeleteEmployeeState {}

class DeleteEmployeeSuccess extends DeleteEmployeeState {
  final String message;
  DeleteEmployeeSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class DeleteEmployeeFailure extends DeleteEmployeeState {
  final String error;
  DeleteEmployeeFailure(this.error);

  @override
  List<Object?> get props => [error];
}
