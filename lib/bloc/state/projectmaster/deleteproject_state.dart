import 'package:equatable/equatable.dart';

abstract class DeleteProjectState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DeleteProjectInitial extends DeleteProjectState {}

class DeleteProjectLoading extends DeleteProjectState {}

class DeleteProjectSuccess extends DeleteProjectState {
  final String message;
  DeleteProjectSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class DeleteProjectFailure extends DeleteProjectState {
  final String error;
  DeleteProjectFailure(this.error);

  @override
  List<Object?> get props => [error];
}
