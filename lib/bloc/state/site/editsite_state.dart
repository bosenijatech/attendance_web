import 'package:equatable/equatable.dart';

abstract class EditSiteState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EditSiteInitial extends EditSiteState {}

class EditSiteLoading extends EditSiteState {}

class EditSiteSuccess extends EditSiteState {
  final String message;
  EditSiteSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class EditSiteFailure extends EditSiteState {
  final String error;
  EditSiteFailure(this.error);
  @override
  List<Object?> get props => [error];
}
