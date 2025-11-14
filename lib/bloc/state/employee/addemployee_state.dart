import 'package:equatable/equatable.dart';

abstract class AddEmployeeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddEmployeeInitial extends AddEmployeeState {}
class AddEmployeeLoading extends AddEmployeeState {}
class AddEmployeeSuccess extends AddEmployeeState {
  final dynamic model;
  AddEmployeeSuccess(this.model);
}
class AddEmployeeFailure extends AddEmployeeState {
  final String error;
  AddEmployeeFailure(this.error);
}

