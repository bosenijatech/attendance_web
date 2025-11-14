import 'package:equatable/equatable.dart';

abstract class DeleteSiteEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitDeleteSite extends DeleteSiteEvent {
  final String id; // Site's DB ID (as string)

  SubmitDeleteSite({required this.id});

  @override
  List<Object?> get props => [id];
}
