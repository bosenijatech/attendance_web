import 'package:equatable/equatable.dart';

abstract class DeleteEmployeeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitDeleteEmployee extends DeleteEmployeeEvent {
  final String id; // Employee's DB ID (as string)

  SubmitDeleteEmployee({required this.id});

  @override
  List<Object?> get props => [id];
}
