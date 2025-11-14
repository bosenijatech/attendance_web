import 'package:equatable/equatable.dart';

abstract class EditEmployeeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EditEmployeeInitial extends EditEmployeeState {}

class EditEmployeeLoading extends EditEmployeeState {}

class EditEmployeeSuccess extends EditEmployeeState {
  final String message;
  EditEmployeeSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class EditEmployeeFailure extends EditEmployeeState {
  final String error;
  EditEmployeeFailure(this.error);
  @override
  List<Object?> get props => [error];
}
