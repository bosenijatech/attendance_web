

import '../../../model/site/getallsitemodel.dart';


abstract class SiteEvent {}

class FetchSiteEvent extends SiteEvent {}

class AddSiteToListEvent extends SiteEvent {
  final Sitelist site;
  AddSiteToListEvent(this.site);
}
