import 'package:equatable/equatable.dart';

abstract class DeleteProjectEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitDeleteProject extends DeleteProjectEvent {
  final String id; // Project's DB ID (as string)

  SubmitDeleteProject({required this.id});

  @override
  List<Object?> get props => [id];
}
