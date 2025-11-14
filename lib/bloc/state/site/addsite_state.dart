import 'package:equatable/equatable.dart';

abstract class AddSiteState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddSiteInitial extends AddSiteState {}
class AddSiteLoading extends AddSiteState {}
class AddSiteSuccess extends AddSiteState {
  final dynamic model;
  AddSiteSuccess(this.model);
}
class AddSiteFailure extends AddSiteState {
  final String error;
  AddSiteFailure(this.error);
}

