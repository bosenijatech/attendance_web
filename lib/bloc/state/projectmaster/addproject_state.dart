import 'package:equatable/equatable.dart';

abstract class AddProjectState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddProjectInitial extends AddProjectState {}
class AddProjectLoading extends AddProjectState {}
class AddProjectSuccess extends AddProjectState {
  final dynamic model;
  AddProjectSuccess(this.model);
}
class AddProjectFailure extends AddProjectState {
  final String error;
  AddProjectFailure(this.error);
}

