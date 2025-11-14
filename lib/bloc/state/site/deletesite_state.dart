import 'package:equatable/equatable.dart';

abstract class DeleteSiteState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DeleteSiteInitial extends DeleteSiteState {}

class DeleteSiteLoading extends DeleteSiteState {}

class DeleteSiteSuccess extends DeleteSiteState {
  final String message;
  DeleteSiteSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class DeleteSiteFailure extends DeleteSiteState {
  final String error;
  DeleteSiteFailure(this.error);

  @override
  List<Object?> get props => [error];
}
