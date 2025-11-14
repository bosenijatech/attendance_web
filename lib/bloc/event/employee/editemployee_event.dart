import 'package:equatable/equatable.dart';

abstract class EditEmployeeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitEditEmployee extends EditEmployeeEvent {
  final String id; // numeric DB ID as string
  final String employeeId;
  final String employeeName;
  final String employeeemail;
  final String type;
  final String status;

  SubmitEditEmployee({
    required this.id,
    required this.employeeId,
    required this.employeeemail,
    required this.employeeName,
    required this.type,
    required this.status,
  });

  @override
  List<Object?> get props => [id, employeeId, employeeName,employeeemail, type, status];
}
