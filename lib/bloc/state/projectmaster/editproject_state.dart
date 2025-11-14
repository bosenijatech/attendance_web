import 'package:equatable/equatable.dart';

abstract class EditProjectState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EditProjectInitial extends EditProjectState {}

class EditProjectLoading extends EditProjectState {}

class EditProjectSuccess extends EditProjectState {
  final String message;
  EditProjectSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class EditProjectFailure extends EditProjectState {
  final String error;
  EditProjectFailure(this.error);
  @override
  List<Object?> get props => [error];
}
