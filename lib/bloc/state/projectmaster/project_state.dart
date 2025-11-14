


import '../../../model/projectmaster/getallprojectmodel.dart';

abstract class ProjectState {}

class ProjectInitial extends ProjectState {}

class ProjectLoading extends ProjectState {}

class ProjectLoaded extends ProjectState {
  final List<Projectlist> project;
 ProjectLoaded(this.project);
}

class ProjectError extends ProjectState {
  final String message;
  ProjectError(this.message);
}
