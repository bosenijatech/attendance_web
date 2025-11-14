


import 'dart:convert';
import 'getallsupervisormodel.dart'; // import your Supervisorlist model

AddsupervisorscreenModel addsupervisorscreenModelFromJson(String str) =>
    AddsupervisorscreenModel.fromJson(json.decode(str));

String addsupervisorscreenModelToJson(AddsupervisorscreenModel data) =>
    json.encode(data.toJson());

class AddsupervisorscreenModel {
  bool? status;
  String? message;
  Supervisorlist? data; // ✅ Newly added supervisor

  AddsupervisorscreenModel({this.status, this.message, this.data});

  factory AddsupervisorscreenModel.fromJson(Map<String, dynamic> json) =>
      AddsupervisorscreenModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] != null
            ? Supervisorlist.fromJson(json["data"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}
