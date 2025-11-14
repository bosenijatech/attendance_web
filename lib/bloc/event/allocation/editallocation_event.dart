import 'package:equatable/equatable.dart';

abstract class EditAllocationEvent extends Equatable {
  const EditAllocationEvent();

  @override
  List<Object?> get props => [];
}

class SubmitEditAllocation extends EditAllocationEvent {
  final String id; // numeric DB ID as string
   final String allocationid;
  final String supervisorname;
  final String projectname;
  final String sitename;
  final String fromDate;
  final String toDate;
  final String status;
  final int? syncstaus; // ✅ added
  final List<Map<String, dynamic>> employee; // ✅ supports multiple employees

  const SubmitEditAllocation({
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
        syncstaus,
      ];
}
