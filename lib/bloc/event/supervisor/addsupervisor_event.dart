import 'package:equatable/equatable.dart';

abstract class AddSupervisorEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateSupervisorEvent extends AddSupervisorEvent {
   final String id; // numeric DB ID as string
  final String supervisorId;
  final String supervisorName;
  final String? type;
  final String? status;
  String? password;

    String? username;

  CreateSupervisorEvent({
     required this.id,
    required this.supervisorId,
    required this.supervisorName,
    this.type,
    this.status,
    this.username,
    this.password,
  });

  @override
  List<Object?> get props => [supervisorId, supervisorName, username,password  , type, status];
}

