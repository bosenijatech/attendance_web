import 'package:equatable/equatable.dart';

abstract class AddSiteEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateSiteEvent extends AddSiteEvent {
 final String id; // numeric DB ID as string
  final String siteId;
  final String siteName;
  final String siteAddress;
  final String siteCity;


  final String status;
  CreateSiteEvent({
    required this.id,
    required this.siteId,
    required this.siteName,
    required this.siteAddress,
    required this.siteCity,

    required this.status,
  });

  @override
  List<Object?> get props => [id, siteId, siteName,siteAddress,siteCity, status];
}

