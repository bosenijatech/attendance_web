import 'package:equatable/equatable.dart';

abstract class EditProjectEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitEditProject extends EditProjectEvent {
  final String id; // numeric DB ID as string
  final String projectId;
  final String projectName;
  final String projectAddress;
 

  
  final String status;

  SubmitEditProject({
    required this.id,
    required this.projectId,
    required this.projectName,
    required this.projectAddress,
    
   
    required this.status,
  });

  @override
  List<Object?> get props => [id, projectId, projectName,projectAddress, status];
}
