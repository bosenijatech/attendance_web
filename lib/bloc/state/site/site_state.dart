
import '../../../model/site/getallsitemodel.dart';


abstract class SiteState {}

class SiteInitial extends SiteState {}

class SiteLoading extends SiteState {}

class SiteLoaded extends SiteState {
  final List<Sitelist> site;
 SiteLoaded(this.site);
}

class SiteError extends SiteState {
  final String message;
  SiteError(this.message);
}
