// To parse this JSON data, do
//
//     final getallsupervisorsModel = getallsupervisorsModelFromJson(jsonString);

import 'dart:convert';

GetallsupervisorsModel getallsupervisorsModelFromJson(String str) => GetallsupervisorsModel.fromJson(json.decode(str));

String getallsupervisorsModelToJson(GetallsupervisorsModel data) => json.encode(data.toJson());

class GetallsupervisorsModel {
    bool status;
    String message;
    List<Supervisorlist> data;

    GetallsupervisorsModel({
        required this.status,
        required this.message,
        required this.data,
    });

    factory GetallsupervisorsModel.fromJson(Map<String, dynamic> json) => GetallsupervisorsModel(
        status: json["status"],
        message: json["message"],
        data: List<Supervisorlist>.from(json["data"].map((x) => Supervisorlist.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Supervisorlist {
  String? id;
  String? supervisorid;
  String? supervisorname;
  String? type;
  String? status;
  int? v;

  Supervisorlist({
    this.id,
    this.supervisorid,
    this.supervisorname,
    this.type,
    this.status,
    this.v,
  });

  factory Supervisorlist.fromJson(Map<String, dynamic> json) => Supervisorlist(
        id: json["_id"],
        supervisorid: json["supervisorid"],
        supervisorname: json["supervisorname"],
        type: json["type"],
        status: json["status"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "supervisorid": supervisorid,
        "supervisorname": supervisorname,
        "type": type,
        "status": status,
        "__v": v,
      };

  
}