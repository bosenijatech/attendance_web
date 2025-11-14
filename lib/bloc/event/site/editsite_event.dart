import 'package:equatable/equatable.dart';

abstract class EditSiteEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitEditSite extends EditSiteEvent {
  final String id; // numeric DB ID as string
  final String siteId;
  final String siteName;
  final String siteAddress;
  final String siteCity;

  
  final String status;

  SubmitEditSite({
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
