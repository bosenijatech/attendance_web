


// To parse this JSON data, do
//
//     final addsupervisorsModel = addsupervisorsModelFromJson(jsonString);

import 'dart:convert';

AddsupervisorsModel addsupervisorsModelFromJson(String str) => AddsupervisorsModel.fromJson(json.decode(str));

String addsupervisorsModelToJson(AddsupervisorsModel data) => json.encode(data.toJson());
class AddsupervisorsModel {
  bool status;
  String message;
  AddSupervisor? data; // nullable because sometimes data might be null

  AddsupervisorsModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory AddsupervisorsModel.fromJson(Map<String, dynamic> json) => AddsupervisorsModel(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] != null ? AddSupervisor.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class AddSupervisor {
  String supervisorid;
  String supervisorname;
  String type;
  String status;
  String id;
  int v;

  AddSupervisor({
    required this.supervisorid,
    required this.supervisorname,
    required this.type,
    required this.status,
    required this.id,
    required this.v,
  });

  factory AddSupervisor.fromJson(Map<String, dynamic> json) => AddSupervisor(
        supervisorid: json["supervisorid"] ?? "", // default empty string
        supervisorname: json["supervisorname"] ?? "",
        type: json["type"] ?? "",
        status: json["status"] ?? "",
        id: json["_id"] ?? "",
        v: json["__v"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "supervisorid": supervisorid,
        "supervisorname": supervisorname,
        "type": type,
        "status": status,
        "_id": id,
        "__v": v,
      };
}