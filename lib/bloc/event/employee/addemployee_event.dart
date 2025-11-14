import 'package:equatable/equatable.dart';

abstract class AddEmployeeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateEmployeeEvent extends AddEmployeeEvent {
   final String id; // numeric DB ID as string
  final String employeeId;
  final String employeeName;
   final String employeeemail;
  final String? type;
  final String? status;

  CreateEmployeeEvent({
      required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.employeeemail,
    required this.type,
    required this.status,
  });

  @override
  List<Object?> get props => [employeeId, employeeName,employeeemail, type, status];
}

