

import '../../../model/projectmaster/getallprojectmodel.dart';



abstract class ProjectEvent {}

class FetchProjectEvent extends ProjectEvent {}

class AddProjectToListEvent extends ProjectEvent {
  final Projectlist project;
  AddProjectToListEvent(this.project);
}
