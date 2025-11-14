

import '../../../model/employee/getallemployeemodel.dart';


abstract class EmployeeState {}

class EmployeeInitial extends EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeeLoaded extends EmployeeState {
  final List<EmployeeList> employee;
  EmployeeLoaded(this.employee);
}

class EmployeeError extends EmployeeState {
  final String message;
  EmployeeError(this.message);
}
