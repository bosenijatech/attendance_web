
import '../../../model/employee/getallemployeemodel.dart';


abstract class EmployeeEvent {}

class FetchEmployeeEvent extends EmployeeEvent {}

class AddEmployeeToListEvent extends EmployeeEvent {
  final EmployeeList employee;
  AddEmployeeToListEvent(this.employee);
}
