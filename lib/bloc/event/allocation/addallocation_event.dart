



import 'package:equatable/equatable.dart';

abstract class AddAllocationEvent extends Equatable {
  const AddAllocationEvent();

  @override
  List<Object?> get props => [];
}

class CreateAllocationEvent extends AddAllocationEvent {
  final String id;
 final String allocationid;
  final String supervisorname;
  final String projectname;
  final String sitename;
  final String fromDate;
  final String toDate;
  final String status;
  final int? syncstaus;
  final List<Map<String, dynamic>> employee; // ✅ updated type

  const CreateAllocationEvent({
    required this.id,
    required this.allocationid,
    required this.supervisorname,
    required this.projectname,
    required this.sitename,
    required this.fromDate,
    required this.toDate,
    required this.status,
    required this.employee,
     this.syncstaus,
  });

  @override
  List<Object?> get props => [
        id,
        allocationid,
        supervisorname,
        projectname,
        sitename,
        fromDate,
        toDate,
        status,
        employee,
        syncstaus
      ];
}
