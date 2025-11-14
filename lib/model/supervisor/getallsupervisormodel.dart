// import 'dart:convert';

// GetallsupervisorsModel getallsupervisorsModelFromJson(String str) =>
//     GetallsupervisorsModel.fromJson(json.decode(str));

// String getallsupervisorsModelToJson(GetallsupervisorsModel data) =>
//     json.encode(data.toJson());

// class GetallsupervisorsModel {
//   bool status;
//   String message;
//   List<Supervisorlist> data;

//   GetallsupervisorsModel({
//     required this.status,
//     required this.message,
//     required this.data,
//   });

//   factory GetallsupervisorsModel.fromJson(Map<String, dynamic> json) =>
//       GetallsupervisorsModel(
//         status: json["status"],
//         message: json["message"],
//         data: List<Supervisorlist>.from(
//             json["data"].map((x) => Supervisorlist.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "message": message,
//         "data": List<dynamic>.from(data.map((x) => x.toJson())),
//       };
// }

// class Supervisorlist {
//   String? id; // numeric DB ID as string
//   String? supervisorid; // S001, S007
//   String? supervisorname;
//   String? type;
//   String? status;
//   int? v;

//   Supervisorlist({
//     this.id,
//     this.supervisorid,
//     this.supervisorname,
//     this.type,
//     this.status,
//     this.v,
//   });

//   factory Supervisorlist.fromJson(Map<String, dynamic> json) => Supervisorlist(
//         id: json["id"]?.toString(), // ✅ changed from "_id" → "id"
//         supervisorid: json["supervisorid"]?.toString(),
//         supervisorname: json["supervisorname"]?.toString(),
//         type: json["type"]?.toString(),
//         status: json["status"]?.toString(),
//         v: json["__v"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id, // ✅ match backend
//         "supervisorid": supervisorid,
//         "supervisorname": supervisorname,
//         "type": type,
//         "status": status,
//         "__v": v,
//       };
// }



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
    String? password;

    String? username;
    String? type;
    String? status;

    Supervisorlist({
         this.id,
         this.supervisorid,
         this.supervisorname,
         this.username,
         this.type,
         this.status,
         this.password,
    });

    factory Supervisorlist.fromJson(Map<String, dynamic> json) => Supervisorlist(
        id: json["id"],
        supervisorid: json["supervisorid"],
        supervisorname: json["supervisorname"],
        username: json["username"],
        password: json["password"],
        type: json["type"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "supervisorid": supervisorid,
        "supervisorname": supervisorname,
        "username": username,
        "password": password,
        "type": type,
        "status": status,
    };
}
