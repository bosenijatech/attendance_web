import 'package:equatable/equatable.dart';

abstract class EditSupervisorEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitEditSupervisor extends EditSupervisorEvent {
  final String id; // numeric DB ID as string
  final String supervisorId;
  final String supervisorName;
  final String type;
  final String status;
   String? password;

    String? username;

  SubmitEditSupervisor({
    required this.id,
    required this.supervisorId,
    required this.supervisorName,
    required this.type,
    required this.status,
     this.username,
    this.password,
  });

  @override
  List<Object?> get props => [id, supervisorId, supervisorName,username,password, type, status];
}
