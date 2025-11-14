import 'package:equatable/equatable.dart';

abstract class AddSupervisorState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddSupervisorInitial extends AddSupervisorState {}
class AddSupervisorLoading extends AddSupervisorState {}
class AddSupervisorSuccess extends AddSupervisorState {
  final dynamic model;
  AddSupervisorSuccess(this.model);
}
class AddSupervisorFailure extends AddSupervisorState {
  final String error;
  AddSupervisorFailure(this.error);
}

