import 'package:equatable/equatable.dart';

abstract class DeleteSupervisorEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitDeleteSupervisor extends DeleteSupervisorEvent {
  final String id; // supervisor's DB ID (as string)

  SubmitDeleteSupervisor({required this.id});

  @override
  List<Object?> get props => [id];
}
